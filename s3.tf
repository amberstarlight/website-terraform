module "bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v3.14.1"
  bucket = "website-${local.account_id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.bucket.s3_bucket_arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
  }
}

module "logs" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket.git?ref=v3.14.1"

  bucket = "logs-${local.account_id}"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}
