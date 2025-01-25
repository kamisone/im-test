variable "vpc_tag_name" {
  description = "The name of the tag used to identify the VPC."
  type = string
}



variable "load_balancer_security_group_name" {
    description = "The name of the security group assigned to the load balancer"
    type = string
}

variable "ecs_security_group_name" {
    description = "The name of the security group assigned to ECS"
    type = string
}


variable "rds_security_group_name" {
    description = "The name of the security group associated with the RDS instance"
    type = string
}

variable "igw_tag_name" {
    description = "The name of the tag used to identify the Internet Gateway (IGW)."
    type = string
}