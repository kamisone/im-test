locals {
  region  = "eu-west-3"

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

  route53_hosted_zone_id = data.aws_route53_zone.impactes-mobile_zone.zone_id
}
