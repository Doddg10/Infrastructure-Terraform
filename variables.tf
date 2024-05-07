variable vpc_cidr {
  type        = string
  description = "description"
}

variable machine_type {
  type        = string
  description = "description"
}

variable region {
  type        = string
  description = "description"
}

variable subnets_details-AZ1 {
  type        = list(object({
    name=string,
    cidr=string,
    type=string

  }))

  description = "description"
}

variable subnets_details-AZ2 {
  type        = list(object({
    name=string,
    cidr=string,
    type=string

  }))

  description = "description"
}

variable "db_username" {
  description = "Username for the RDS database"
}

variable "db_password" {
  description = "Password for the RDS database"
}