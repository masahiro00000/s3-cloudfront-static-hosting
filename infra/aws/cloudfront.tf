###############################################################################
# CloudFront distribution                                                      #
###############################################################################

locals {
  cf_price_class = "PriceClass_All"
}

# CloudFront Function to add index.html to the path
# resource "aws_cloudfront_function" "add-index-function" {
#   name    = "add-index-function"
#   runtime = "cloudfront-js-1.0"
#   comment = "Add index.html to the path"
#   publish = true
#   code    = file("${path.module}/assets/cloudfront_function/addIndexFunction.js")
# }

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  comment             = "Static site for ${var.domain_name}"
  aliases             = [var.domain_name]
  default_root_object = "index.html"
  price_class         = local.cf_price_class

  # Logging
  logging_config {
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    include_cookies = false
    prefix          = "cloudfront/"
  }

  origin {
    domain_name = aws_s3_bucket.content.bucket_regional_domain_name
    origin_id   = "s3-content-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-content-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]

    # CloudFront Function association
    # function_association {
    #   event_type   = "viewer-request"
    #   function_arn = aws_cloudfront_function.add-index-function.arn
    # }

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.this.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  depends_on = [
    aws_acm_certificate.this,
    aws_s3_bucket_policy.content
  ]
}
