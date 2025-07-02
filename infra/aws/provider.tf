locals {
  project_prefix = "s3-cloudfront-static-hosting"
}

provider "aws" {
  region = var.region
}

# CloudFront / ACM 用 us-east-1 プロバイダー
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
