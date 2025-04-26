variable "secret_name" {
  type        = string
  description = "The name of the secret to create"
}

variable "secret_description" {
  type        = string
  description = "The description of the secret to create"
}

variable "recovery_window_in_days" {
  type        = number
  description = "The number of days to recover the secret"
  default     = 30
}