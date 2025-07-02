variable "region" {
  description = "AWS region for primary resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "domain_name" {
  description = "FQDN that CloudFront will serve (e.g., www.example.com)"
  type        = string
  default     = "dummy.com"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID corresponding to the domain"
  type        = string
  default     = "DUMMYIDXXXXXXXXXXXXXX"
}
