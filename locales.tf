locals {
  region  = "eu-west-3"

  environment = var.environment

  state_bucket_name         = "impactes-mobile-state-33493fig3gil-${var.environment}"
  state_dynamodb_table_name = "impactes-mobile-state-33493fig3gil-${var.environment}"

  assets_bucket_name = "impactes-mobile-assets-33493fig3gil-${var.environment}"


  ecr_repo_name = "impactes-mobile-ecr-repo-${var.environment}"
  ecs_secrets_manager_policy_name = "ecs-secrets-manager-policy-${var.environment}"
  ecr_access_policy_name = "ecr-access-policy-${var.environment}"

  cluster_name = "impactes-mobile-cluster-${var.environment}"

  task_family_name            = "impactes-mobile-task-family-${var.environment}"
  container_port              = 1337
  task_name                   = "impactes-mobile-task-${var.environment}"
  ecs_task_exection_role_name = "impactes-mobile-task-execution-role-${var.environment}"


  application_load_balancer_name = "impactes-mobile-lb-${var.environment}"
  target_group_name              = "impactes-mobile-tg-${var.environment}"
  ecs_service_name               = "impactes-mobile-ecs-service-${var.environment}"

  cloudwatch_group_name = "/ecs/impactes-mobile-${var.environment}"
  cloudwatch_task_access_iam_role_policy_name = "cloudwatch-task-access-${var.environment}"

  route53_hosted_zone_id = data.aws_route53_zone.impactes-mobile_zone.zone_id

  rds_instance_identifier = "impactes-mobile-${var.environment}"
  rds_subnet_name = "impactes-mobile-${var.environment}"
  custom_rds_parameter_group_name = "impactes-mobile-custom-rds-parameter-group-${var.environment}"

  secret_manager_arn =  "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-${var.environment == "prod" ? "prod-jnJG2C": "dev-r510fn"}"

  vpc_tag_name = "impactes-mobile-${var.environment}"
  load_balancer_security_group_name = "impactes-mobile-lb-security-group-${var.environment}"
  ecs_security_group_name = "impactes-mobile-ecs-security-group-${var.environment}"
  rds_security_group_name = "impactes-mobile-rds-security-group-${var.environment}"
  igw_tag_name = "impactes-mobile-${var.environment}"

  assets_bucket_environment_tag = var.environment
  assets_bucket_iam_user_name = "impactes-mobile-assets-bucket-iam-user-${var.environment}"
  assets_bucket_iam_user_policy_name = "impactes-mobile-assets-bucket-iam-user-policy-${var.environment}"

}
