module "acm" {
  source = "github.com/terraform-aws-modules/terraform-aws-acm.git?ref=v4.3.2"

  providers = {
    aws = aws.us_east_1
  }

  domain_name               = var.base_domain
  zone_id                   = data.aws_route53_zone.this.zone_id
  wait_for_validation       = true
  subject_alternative_names = ["*.${var.base_domain}"]
}
