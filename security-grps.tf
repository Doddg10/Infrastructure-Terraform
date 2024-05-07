# Create Security Group allowing SSH from 0.0.0.0/0
resource "aws_security_group" "ssh_from_anywhere" {
  name        = "ssh_from_anywhere"
  description = "Allow SSH from anywhere"
   vpc_id     = module.network.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
    tags = {
    Name = "ssh_public"
  }
}

# Create Security Group allowing SSH and Port 3000 from VPC CIDR only
resource "aws_security_group" "ssh_and_port_3000_from_vpc_cidr" {
  name        = "ssh_and_port_3000_from_vpc_cidr"
  description = "Allow SSH and Port 3000 from VPC CIDR"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.network.vpc_cidr]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [module.network.vpc_cidr]
  }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
    tags = {
    Name = "ssh_private"
  }
}
