# Create Route Tables
resource "aws_route_table" "route_tables" {
  count=2
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = count.index == 0? aws_internet_gateway.my_igw.id:aws_nat_gateway.lab1-nat.id
  }
}

# Attach Public/Private Route Table to Subnets

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.subnets-AZ1["public_subnet1"].id
  route_table_id = aws_route_table.route_tables[0].id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.subnets-AZ1["private_subnet1"].id
  route_table_id = aws_route_table.route_tables[1].id
}
########################################################################
# #Create Public Route Table
# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.my_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.my_igw.id
#   }
# }

# # Create Private Route Table
# resource "aws_route_table" "private_route_table" {
#   vpc_id = aws_vpc.my_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.lab1-nat.id
#   }
# }

# # Attach Public/Private Route Table to Subnets

# resource "aws_route_table_association" "public_subnet_association" {
#   subnet_id      = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "private_subnet_association" {
#   subnet_id      = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.private_route_table.id
# }

##########################################################################
