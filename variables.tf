variable "rds_instance_username" {
  type = string
}

variable "rds_instance_password" {
  type = string
}


variable "environment" {
  description = "Environment (dev or prod)"
  type = string
  validation {
    condition = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be either 'dev' or 'prod'."
  }
}
