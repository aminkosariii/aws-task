resource "aws_eip" "turkey_external_ip" {
  vpc = true
  tags = {
    Name = "turkey_external_nat_ip"
  }
}

resource "aws_nat_gateway" "turkeyngw" {
    count         = 1
    allocation_id = element(aws_eip.turkey_external_ip[*].id, count.index)
    subnet_id     = element(aws_subnet.public_turkeysubnet[*].id, count.index)
    tags = {
        Name = "turkeyngw"
    }
  depends_on = [aws_internet_gateway.turkeyigw]
}