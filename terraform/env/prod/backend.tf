terraform {
  backend "s3" {
    bucket         = "terraform-state-eu-central-1-412306529917"
    key            = "app-prod.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}