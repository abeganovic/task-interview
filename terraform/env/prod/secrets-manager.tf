module "generate_application_user_name" {
  source             = "../../modules/secrets-manager"
  secret_name        = "application_user_name"
  secret_description = "Application Username"
}

module "generate_application_password" {
  source             = "../../modules/secrets-manager"
  secret_name        = "application_password_new"
  secret_description = "Application Password"
}

module "generate_application_api_key" {
  source             = "../../modules/secrets-manager"
  secret_name        = "api_key"
  secret_description = "API KEY"
}