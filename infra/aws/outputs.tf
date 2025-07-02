###############################################################################
# Outputs                                                                     #
###############################################################################

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "content_bucket_name" {
  description = "Name of the S3 bucket hosting static content"
  value       = aws_s3_bucket.content.id
}

output "logs_bucket_name" {
  description = "Name of the S3 bucket storing access logs"
  value       = aws_s3_bucket.logs.id
}

output "acm_certificate_arn" {
  description = "ARN of the ACM certificate for the custom domain"
  value       = aws_acm_certificate.this.arn
}
