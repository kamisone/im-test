locals {
  region  = "eu-west-3"

  environment = "dev"

  state_bucket_name         = "impactes-mobile-state-33493fig3gil-dev"
  state_dynamodb_table_name = "impactes-mobile-state-33493fig3gil-dev"

  assets_bucket_name = "impactes-mobile-assets-33493fig3gil-dev"


  ecr_repo_name = "impactes-mobile-ecr-repo-dev"

  cluster_name = "impactes-mobile-cluster-dev"

  task_family_name            = "impactes-mobile-task-family-dev"
  container_port              = 1337
  task_name                   = "impactes-mobile-task-dev"
  ecs_task_exection_role_name = "impactes-mobile-task-execution-role-dev"


  application_load_balancer_name = "impactes-mobile-lb-dev"
  target_group_name              = "impactes-mobile-tg-dev"
  ecs_service_name               = "impactes-mobile-ecs-service-dev"

  cloudwatch_group_name = "/ecs/impactes-mobile-dev"
  cloudwatch_task_access_iam_role_policy_name = "cloudwatch-task-access-dev"

  route53_hosted_zone_id = data.aws_route53_zone.impactes-mobile_zone.zone_id

  rds_instance_identifier = "impactes-mobile-dev"
  rds_subnet_name = "impactes-mobile-dev"
  custom_rds_parameter_group_name = "impactes-mobile-custom-rds-parameter-group-dev"

  secret_manager_arn = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn"

  vpc_tag_name = "impactes-mobile-dev"
  load_balancer_security_group_name = "impactes-mobile-lb-security-group-dev"
  ecs_security_group_name = "impactes-mobile-ecs-security-group-dev"
  rds_security_group_name = "impactes-mobile-rds-security-group-dev"
  igw_tag_name = "impactes-mobile-dev"

  assets_bucket_environment_tag = "Developement"
  assets_bucket_iam_user_name = "impactes-mobile-assets-bucket-iam-user-dev"
  assets_bucket_iam_user_policy_name = "impactes-mobile-assets-bucket-iam-user-policy-dev"

}
