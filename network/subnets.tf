# Define the subnets
# resource "aws_subnet" "public_subnet" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "10.0.1.0/24"
#   tags = {
#     Name = "public_subnet"
#   }
# }

# resource "aws_subnet" "private_subnet" {
#   vpc_id            = aws_vpc.my_vpc.id
#   cidr_block        = "10.0.2.0/24"
#   tags = {
#     Name = "private_subnet"
#   }
# }

resource "aws_subnet" "subnets-AZ1" {
for_each = { for subnet in var.subnets_details-AZ1 : subnet.name => subnet }
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_subnet" "subnets-AZ2" {
for_each = { for subnet in var.subnets_details-AZ2 : subnet.name => subnet }
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "${each.value.name}"
  }
}