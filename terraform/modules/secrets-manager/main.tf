resource "aws_secretsmanager_secret" "generate_secret" {
  name                    = var.secret_name
  description             = var.secret_description
  recovery_window_in_days = var.recovery_window_in_days
  tags = {
    Name = "application_user"
  }
}