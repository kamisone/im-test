
variable "hosted_zone_id" {
    type = string
}


variable "cloudfront_domain_name" {
    type = string
}

variable "cloudfront_hosted_zone_id" {
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