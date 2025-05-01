
locals {
  app_ecr_name = "app-prod"
}

module "app-prod-ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.4.0"

  repository_name                 = local.app_ecr_name
  create_lifecycle_policy         = false
  repository_image_tag_mutability = "MUTABLE"
}
