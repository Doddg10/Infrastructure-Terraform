output subnets-AZ1{
 value = aws_subnet.subnets-AZ1
 description = "description"
}

output subnets-AZ2{
 value = aws_subnet.subnets-AZ2
 description = "description"
}

output vpc_id{
    value = aws_vpc.my_vpc.id
    description = "description"
}

output vpc_cidr{
    value = aws_vpc.my_vpc.cidr_block
}