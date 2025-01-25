variable "environment" {
  description = "Environment (dev or prod)"
  type = string
  validation {
    condition = contains(["dev", "prod"], var.environment)
    error_message = "The environment must be either 'dev' or 'prod'."
  }
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}



variable "task_family_name" {
  description = "ECS Task Family"
  type        = string
}


variable "task_name" {
  description = "ECS Task Name"
  type        = string
}


variable "ecr_repo_url" {
  description = "ECR Repo URL"
  type        = string

}

variable "container_port" {
  description = "Container Port"
  type        = number
}


variable "ecs_task_exection_role_name" {
  description = "ECS Task Execution Role Name"
  type        = string
}


variable "application_load_balancer_name" {
  description = "Application LoadBalancer Name"
  type        = string
}

variable "target_group_name" {
  description = "Target Group Name"
  type        = string
}


variable "ecs_service_name" {
  description = "ECS Service Name"
  type        = string
}

variable "cloudwatch_group_name" {
  description = "CloudWatch group name"
  type        = string
}

variable "cloudwatch_task_access_iam_role_policy_name" {
  description = "The name of the IAM policy that grants ECS tasks access to CloudWatch"
  type        = string
}



variable "aws_vpc_id" {
  type        = string
  description = "AWS vpc id"
}


variable "subnet_ids" {
  type = list(string)
}



variable "ecs_security_group_id" {
  type = string

}

variable "alb_security_group_id" {
  type = string

}


variable "db_address" {
  description = "The database host address"
  type = string
}

variable "igw_id" {
  description = "The internet gateway id"
  type = string
}

variable "secret_manager_arn" {
  description = "The ARN of the secret used to retrieve sensitive environment variables for ECS tasks."
  type = string
}

variable "ecs_secrets_manager_policy_name" {
  type = string
}
variable "ecr_access_policy_name" {
  type = string
}


