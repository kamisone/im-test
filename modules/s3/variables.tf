variable "assets_bucket_name" {
  type        = string
  description = "App assets (images, videos...) bucket"
}

variable "assets_bucket_environment_tag" {
  description = "The tag used to specify the environment for the assets S3 bucket"
  type = string
}

variable "assets_bucket_iam_user_name" {
  description = "The IAM username with access to the assets S3 bucket"
  type = string
}

variable "assets_bucket_iam_user_policy_name" {
  description = "The name of the IAM policy granting access to the assets S3 bucket"
  type = string
}