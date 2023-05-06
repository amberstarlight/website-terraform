data "aws_caller_identity" "current" {}

data "aws_route53_zone" "this" {
  name         = var.base_domain
  private_zone = false
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}

locals {
  account_id = data.aws_caller_identity.current.account_id
}
