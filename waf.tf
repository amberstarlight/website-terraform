resource "aws_wafv2_web_acl" "this" {
  provider = aws.us_east_1

  name  = "website-waf"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    action {
      block {
        custom_response {
          response_code = 402
        }
      }
    }

    name     = "OpenAI"
    priority = 1

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.openai_ranges.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockedRequests"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "BlockedRequests"
    sampled_requests_enabled   = true
  }
}

# Potentially could change.
# https://openai.com/gptbot-ranges.txt
resource "aws_wafv2_ip_set" "openai_ranges" {
  name               = "gptbot"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses = [
    "20.15.240.64/28",
    "20.15.240.80/28",
    "20.15.240.96/28",
    "20.15.240.176/28",
    "20.15.241.0/28",
    "20.15.242.128/28",
    "20.15.242.144/28",
    "20.15.242.192/28",
    "40.83.2.64/28",
  ]
}
