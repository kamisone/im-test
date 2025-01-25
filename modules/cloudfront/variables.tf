variable "load_balancer_dns_name" {
  type = string
}
variable "load_balancer_name" {
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