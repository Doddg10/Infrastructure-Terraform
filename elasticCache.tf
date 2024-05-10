#Elasticache Subnet Group
resource "aws_elasticache_subnet_group" "elasticache_subnet_gp" {
  name       = "elasticache-subnet-gp"
  subnet_ids = [module.network.subnets-AZ1["private_subnet1"].id] 
}

# ElastiCache Cluster
resource "aws_elasticache_cluster" "elasticache_cluster" {
  cluster_id               = "elasticache-cluster"
  engine                   = "redis"
  node_type                = "cache.t2.micro"
  num_cache_nodes          = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.1"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet_gp.name
  security_group_ids    = [aws_security_group.redis_sg.id]

}
