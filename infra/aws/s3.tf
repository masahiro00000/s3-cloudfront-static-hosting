###############################################################################
# S3 buckets                                                                   #
###############################################################################

# Content bucket (private, accessed only via CloudFront)
resource "aws_s3_bucket" "content" {
  bucket = "${local.project_prefix}-website"

  # force_destroy = true

  tags = {
    Name = "static-content"
  }
}

resource "aws_s3_bucket_versioning" "content" {
  bucket = aws_s3_bucket.content.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Public access block for content bucket
resource "aws_s3_bucket_public_access_block" "content" {
  bucket = aws_s3_bucket.content.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Access-log bucket
resource "aws_s3_bucket" "logs" {
  bucket = "${local.project_prefix}-logs"

  lifecycle {
    prevent_destroy = true
  }

  # force_destroy = true

  tags = {
    Name = "access-logs"
  }
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# 追加で、CloudFront からの書き込みを許可するポリシー
resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontLogs"
        Effect    = "Allow"
        Principal = { Service = "logging.s3.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.logs.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Origin Access Identity for CloudFront -> S3
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for ${aws_s3_bucket.content.id}"
}

# Grant read permissions to OAI
data "aws_iam_policy_document" "content_bucket_policy" {
  statement {
    sid     = "AllowCloudFrontRead"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
    resources = ["${aws_s3_bucket.content.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "content" {
  bucket = aws_s3_bucket.content.id
  policy = data.aws_iam_policy_document.content_bucket_policy.json
}
