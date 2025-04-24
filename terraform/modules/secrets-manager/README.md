# secrets-manager

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_secretsmanager_secret.generate_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | The number of days to recover the secret | `number` | `30` | no |
| <a name="input_secret_description"></a> [secret\_description](#input\_secret\_description) | The description of the secret to create | `string` | n/a | yes |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | The name of the secret to create | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_generated_secret_arn"></a> [generated\_secret\_arn](#output\_generated\_secret\_arn) | ARN of the generate secret with key name |
<!-- END_TF_DOCS -->
