resource "aws_route_table" "turkeypublicrt" {
  vpc_id  = aws_vpc.turkeyvpc.id
  tags = {
    Name = "turkey_public_rt"
  }
}
resource "aws_route" "public_internet_gateway_ipv6" {
  route_table_id              = aws_route_table.turkeypublicrt.id
  destination_cidr_block      = "0.0.0.0/0"
  gateway_id                  = aws_internet_gateway.turkeyigw.id
}
resource "aws_route_table_association" "rt_public_subnet" {
  count           = length(var.public_subnets_cidr) 
  subnet_id       = element(aws_subnet.public_turkeysubnet[*].id, count.index)
  route_table_id  = aws_route_table.turkeypublicrt.id
}

resource "aws_route_table" "turkeyprivatert" {
  vpc_id    = aws_vpc.turkeyvpc.id
  tags = {
    Name = "turkey_private_rt"
  }
}
resource "aws_route" "private_natgateway_ipv6" {
  route_table_id              = aws_route_table.turkeyprivatert.id
  destination_cidr_block      = "0.0.0.0/0"
  nat_gateway_id              = aws_nat_gateway.turkeyngw[0].id
}
resource "aws_route_table_association" "rt_associate_private" {
  count           = length(var.private_subnets_cidr) 
  subnet_id       = element(aws_subnet.private_turkeysubnet[*].id, count.index)
  route_table_id  = aws_route_table.turkeyprivatert.id
}