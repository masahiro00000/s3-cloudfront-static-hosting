###############################################################################
# Terraform backend configuration                                             #
#                                                                             #
# 初回デプロイ手順:                                                            #
#   1. この backend.tf を一時的にコメントアウト、ローカル状態で init+apply      #
#      (backend_setup.tf により tfstate バケット等を作成)                      #
#   2. backend.tf のコメントを解除し、以下設定を有効化                          #
#   3. terraform init -migrate-state でステートを S3 に移行                    #
###############################################################################

# terraform {
#   backend "s3" {
#     # バケット名は backend_setup.tf で作成される local.tfstate_bucket_name に合わせる
#     bucket = "terraform-state-s3-cloudfront-static-hosting"
#     key    = "aws/terraform.tfstate"
#     region = "ap-northeast-1"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
