

resource "aws_cloudfront_distribution" "cloudfront_distribution" {
  
  origin {
    domain_name = var.load_balancer_dns_name
    origin_id = var.load_balancer_name

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  comment = "CloudFront distribution for impactes ALB dev"

  default_cache_behavior {
    target_origin_id = var.load_balancer_name
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }

      headers = ["Authorization"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = local.impactes-mobile_fr_ssl_ca_arn
    ssl_support_method  = "sni-only"
  }

  aliases = var.environment == "prod" ? ["impactes-mobile.fr"] : ["dev.impactes-mobile.fr"]
}


output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cloudfront_distribution.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.cloudfront_distribution.hosted_zone_id
}
