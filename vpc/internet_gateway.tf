resource "aws_internet_gateway" "turkeyigw" {
  vpc_id = aws_vpc.turkeyvpc.id
  tags = {
    Name = "turkey-igw"
  }
}
