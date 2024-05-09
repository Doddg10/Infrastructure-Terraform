# Define the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "terraform"
  }
}

###################### Subnets ##########################
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


###############################  Route Tables ###########################################

resource "aws_route_table" "route_tables" {
  count  = 2
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = count.index == 0 ? aws_internet_gateway.my_igw.id : aws_nat_gateway.lab1-nat.id
  }
}

# Attach Public/Private Route Table to Subnets

resource "aws_route_table_association" "public_subnet_association_az1" {
  subnet_id      = aws_subnet.subnets-AZ1["public_subnet1"].id
  route_table_id = aws_route_table.route_tables[0].id
}

resource "aws_route_table_association" "private_subnet_association_az1" {
  subnet_id      = aws_subnet.subnets-AZ1["private_subnet1"].id
  route_table_id = aws_route_table.route_tables[1].id
}

resource "aws_route_table_association" "public_subnet_association_az2" {
  subnet_id      = aws_subnet.subnets-AZ2["public_subnet2"].id
  route_table_id = aws_route_table.route_tables[0].id
}

resource "aws_route_table_association" "private_subnet_association_az2" {
  subnet_id      = aws_subnet.subnets-AZ2["private_subnet2"].id
  route_table_id = aws_route_table.route_tables[1].id
}
########################################  gateways ###########################################3
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
subnet_id     = aws_subnet.subnets-AZ1["public_subnet1"].id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.my_igw]
}

##########################################################
# Update the route in the route table to route internet-bound traffic through the NAT gateway
resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.route_tables[1].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lab1-nat.id
}
