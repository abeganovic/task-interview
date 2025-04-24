output "generated_secret_arn" {
  value       = aws_secretsmanager_secret.generate_secret.arn
  description = "ARN of the generate secret with key name"
}