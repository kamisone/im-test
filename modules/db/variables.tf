
variable "subnet_ids" {
  type = list(string)
}

variable "rds_security_group_id" {
  type = string
}

variable "instance_username" {
  type = string
}

variable "instance_password" {
  type = string
}

variable "instance_identifier" {
  type = string
}

variable "rds_subnet_name" {
  type = string
}

variable "custom_rds_parameter_group_name" {
  type = string
  
}