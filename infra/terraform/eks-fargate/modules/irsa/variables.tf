variable "enable_irsa" {
  description = "Enable IAM Roles for Service Accounts"
  type        = bool
}

variable "irsa_configs" {
  description = "IRSA configurations for various services"
  type = map(object({
    namespace            = string
    service_account_name = string
    policy_json_path     = string
  }))
}

variable "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  type        = string
}

variable "oidc_provider_url" {
  description = "The URL of the OIDC Provider"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
}
