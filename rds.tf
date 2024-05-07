resource "aws_security_group" "rds_security_group" {
  name        = "rds_access"
  description = "Security group for RDS access"
  vpc_id      = module.network.vpc_id  

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow connections from anywhere, consider restricting to specific IP ranges
  }

  tags = {
    Name = "rds_security_group"
  }
}

# RDS DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_gp" {
  name       = "db-subnet-gp"
  subnet_ids = [
    module.network.subnets-AZ1["private_subnet1"].id 
   ,module.network.subnets-AZ2["private_subnet2"].id
  ] 
}

# RDS DB Instance
resource "aws_db_instance" "rdsdb" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = var.db_username  
  password             = var.db_password 
  db_subnet_group_name = aws_db_subnet_group.db_subnet_gp.name 
  vpc_security_group_ids = [aws_security_group.rds_security_group.id]
  skip_final_snapshot  = true
}
