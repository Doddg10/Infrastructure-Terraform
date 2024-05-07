module "network"{
    source= "./network"
    vpc_cidr = var.vpc_cidr
    region = var.region
    subnets_details-AZ1= var.subnets_details-AZ1
    subnets_details-AZ2= var.subnets_details-AZ2
}