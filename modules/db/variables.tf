
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