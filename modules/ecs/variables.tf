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

