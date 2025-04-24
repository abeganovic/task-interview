module "vpc-app-prod-eu" {
  source = "terraform-aws-modules/vpc/aws"

  name = "app-vpc-prod-eu"
  cidr = "10.10.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.10.1.0/24", "10.10.3.0/24"]
  public_subnets  = ["10.10.2.0/24", "10.10.4.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  public_subnet_tags = {
    "Type" = "public"
  }

  private_subnet_tags = {
    "Type" = "private"
  }
}