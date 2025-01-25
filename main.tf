terraform {
  required_version = "~> 1.3"


  backend "s3" {
    // parameters are in backend.(dev/prod).hcl files
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  } 
}





module "ecrRepo" {
  source = "./modules/ecr"

  ecr_repo_name = local.ecr_repo_name
}


module "rdsPostgres" {
  source     = "./modules/db"
  subnet_ids = module.networking.subnet_ids

  rds_security_group_id = module.networking.rds_security_group_id

  instance_username = var.rds_instance_username
  instance_password = var.rds_instance_password

  instance_identifier = local.rds_instance_identifier

  rds_subnet_name = local.rds_subnet_name

  custom_rds_parameter_group_name = local.custom_rds_parameter_group_name

}

module "ecsCluster" {
  source = "./modules/ecs"

  environment = local.environment

  cluster_name = local.cluster_name

  task_family_name            = local.task_family_name
  container_port              = local.container_port
  task_name                   = local.task_name
  ecs_task_exection_role_name = local.ecs_task_exection_role_name

  secret_manager_arn = local.secret_manager_arn


  application_load_balancer_name = local.application_load_balancer_name
  target_group_name              = local.target_group_name
  ecs_service_name               = local.ecs_service_name
  

  db_address = module.rdsPostgres.db_address

  ecs_secrets_manager_policy_name = local.ecs_secrets_manager_policy_name
  ecr_access_policy_name = local.ecr_access_policy_name



  cloudwatch_group_name = local.cloudwatch_group_name
  cloudwatch_task_access_iam_role_policy_name = local.cloudwatch_task_access_iam_role_policy_name
  aws_vpc_id            = module.networking.aws_vpc_id
  subnet_ids            = module.networking.subnet_ids
  ecr_repo_url          = module.ecrRepo.repository_url
  ecs_security_group_id = module.networking.ecs_security_group_id
  alb_security_group_id = module.networking.alb_security_group_id
  
  igw_id = module.networking.igw_id

}

module "networking" {
  source = "./modules/networking"

  vpc_tag_name = local.vpc_tag_name

  load_balancer_security_group_name = local.load_balancer_security_group_name

  ecs_security_group_name = local.ecs_security_group_name

  rds_security_group_name = local.rds_security_group_name

  igw_tag_name = local.igw_tag_name

}





module "s3Bucket" {
  source             = "./modules/s3"
  assets_bucket_name = local.assets_bucket_name

  assets_bucket_environment_tag = local.assets_bucket_environment_tag

  assets_bucket_iam_user_name = local.assets_bucket_iam_user_name

  assets_bucket_iam_user_policy_name = local.assets_bucket_iam_user_policy_name
}


module "cloudfront" {
  source = "./modules/cloudfront"

  environment = local.environment

  load_balancer_dns_name = module.ecsCluster.load_balancer_dns_name
  load_balancer_name  = module.ecsCluster.load_balancer_name

}

module "route53" {
  source = "./modules/route53"

  environment = local.environment

  hosted_zone_id = local.route53_hosted_zone_id
  cloudfront_domain_name = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
}