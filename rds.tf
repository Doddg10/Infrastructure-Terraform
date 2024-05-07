# RDS DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_gp" {
  name       = "db-subnet-gp"
  subnet_ids = [
    module.network.subnets-AZ1["private_subnet1"].id 
   ,module.network.subnets-AZ2["private_subnet2"].id
  ] 
}

# RDS DB Instance
resource "aws_db_instance" "my_db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name              = "my-db"
  username             = var.db_username  adm
  password             = var.db_password 
  db_subnet_group_name = aws_db_subnet_group.db_subnet_gp.name 
  skip_final_snapshot  = true
}

