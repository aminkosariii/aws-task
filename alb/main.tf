resource "aws_lb" "turkey" {
  name               = "turkey-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [var.public_subnet.id]

  listener {
    port     = 80
    protocol = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.turkey.arn
    }
  }

  tags = {
    Name = "turkey-alb"
  }
}
resource "aws_lb_target_group" "turkey" {
  name_prefix     = "turkey"
  port            = 80
  protocol        = "HTTP"
  target_type     = "instance"
  vpc_id          = var.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_launch_configuration" "turkey" {
  name_prefix = "turkey-lc"
  image_id    = "AMI_ID"
  instance_type = "t2.micro"
  security_groups = [var.security_groups.private.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
}

resource "aws_autoscaling_group" "turkey" {
  name_prefix = "turkey-asg"
  launch_configuration = aws_launch_configuration.turkey.name
  target_group_arns = [aws_lb_target_group.turkey.arn]
  vpc_zone_identifier = [aws_subnet.private.id]
  min_size = 2
  max_size = 4
  health_check_type = "EC2"
  health_check_grace_period = 300
  metrics_granularity = "1Minute"
  tag {
    key = "Name"
    value = "turkey-asg"
    propagate_at_launch = true
  }
  termination_policies = ["OldestInstance"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "turkey" {
  name = "turkey.com"
  type = "A"
  alias {
    name = aws_lb.turkey.dns_name
    zone_id = aws_lb.turkey.zone_id
    evaluate_target_health = true
  }
}
