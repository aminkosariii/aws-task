resource "aws_elb" "turkey" {
  name               = "turkey-elb"
  security_groups    = [aws_security_group.turkey.id]
  subnets            = [aws_subnet.turkey.id]
  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
}


resource "aws_subnet" "turkey" {
  vpc_id      =  var.vpc_id
}

resource "aws_route53_zone" "turkey" {
  name = "turkey.com"
}

resource "aws_security_group" "turkey" {
  name_prefix = "turkey-sg"
  vpc_id      =  var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "turkey" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.turkey.id]
}