
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  } 
}

module "tf-state" {
  source              = "./modules/tf-state"
  bucket_name         = local.state_bucket_name
  dynamodb_table_name = local.state_dynamodb_table_name
}