provider "aws" {
  region              = var.aws_region
  profile             = var.terraform_profile
  allowed_account_ids = [var.aws_account_id]

  default_tags {
    tags = {
      Terraform   = "True"
      Environment = "Production"
    }
  }
}