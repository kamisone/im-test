resource "aws_route53_record" "cloudfront_alias" {
  zone_id = var.hosted_zone_id
  name    = var.environment == "prod"? "impactes-mobile.fr": "dev.impactes-mobile.fr"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}