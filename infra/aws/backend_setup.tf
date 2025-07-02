###############################################################################
# Terraform remote state backend resources (S3 + DynamoDB)                    #
###############################################################################

locals {
  tfstate_bucket_name = "terraform-state-${local.project_prefix}"
}

# S3 bucket for tfstate
resource "aws_s3_bucket" "tfstate" {
  bucket = local.tfstate_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  # force_destroy = true

  tags = {
    Name = "tfstate"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

