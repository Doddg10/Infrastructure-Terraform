# Define the VPC
resource "aws_vpc" "my_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "terraform"
  }
}