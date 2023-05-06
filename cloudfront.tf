resource "aws_cloudfront_origin_access_identity" "this" {
  comment = local.s3_origin_id
}

locals {
  s3_origin_id = "Website S3"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = module.bucket.s3_bucket_bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  aliases             = [var.base_domain]
  comment             = "Website CDN"
  default_root_object = "index.html"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = local.s3_origin_id
    cache_policy_id        = data.aws_cloudfront_cache_policy.caching_optimized.id
    viewer_protocol_policy = "redirect-to-https"

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.directory_index_rewrite.arn
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.acm.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  depends_on = [
    module.acm.acm_certificate_arn
  ]
}

resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.base_domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_cloudfront_function" "directory_index_rewrite" {
  name    = "directory_index_rewrite"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("${path.module}/function.js")
}
