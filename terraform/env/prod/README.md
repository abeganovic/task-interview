<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0, != 5.71.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app-prod-alb"></a> [app-prod-alb](#module\_app-prod-alb) | terraform-aws-modules/alb/aws | ~> 9.0 |
| <a name="module_app-prod-ecr"></a> [app-prod-ecr](#module\_app-prod-ecr) | terraform-aws-modules/ecr/aws | 1.6.0 |
| <a name="module_app-prod-ecs"></a> [app-prod-ecs](#module\_app-prod-ecs) | terraform-aws-modules/ecs/aws | 5.8.0 |
| <a name="module_app-prod-ecs_service"></a> [app-prod-ecs\_service](#module\_app-prod-ecs\_service) | terraform-aws-modules/ecs/aws//modules/service | 5.8.0 |
| <a name="module_generate_application_api_key"></a> [generate\_application\_api\_key](#module\_generate\_application\_api\_key) | ../../modules/secrets-manager | n/a |
| <a name="module_generate_application_password"></a> [generate\_application\_password](#module\_generate\_application\_password) | ../../modules/secrets-manager | n/a |
| <a name="module_generate_application_user_name"></a> [generate\_application\_user\_name](#module\_generate\_application\_user\_name) | ../../modules/secrets-manager | n/a |
| <a name="module_vpc-app-prod-eu"></a> [vpc-app-prod-eu](#module\_vpc-app-prod-eu) | terraform-aws-modules/vpc/aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_prod_image"></a> [app\_prod\_image](#input\_app\_prod\_image) | n/a | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | n/a | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | n/a | yes |
| <a name="input_terraform_profile"></a> [terraform\_profile](#input\_terraform\_profile) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->