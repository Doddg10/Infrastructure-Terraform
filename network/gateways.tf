# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Elastic IP for NAT 
resource "aws_eip" "my-eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.my_igw]
}

# NAT
resource "aws_nat_gateway" "lab1-nat" {
  allocation_id = aws_eip.my-eip.id
#   subnet_id     = aws_subnet.public_subnet.id
subnet_id     = aws_subnet.subnets-AZ1["public_subnet1"].id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.my_igw]
}


