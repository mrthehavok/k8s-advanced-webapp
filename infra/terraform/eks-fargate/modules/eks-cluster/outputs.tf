# AIDEV-TODO: Replace with actual resource outputs.
output "cluster_id" {
  description = "EKS cluster ID"
  value       = "eks-placeholder"
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = "arn:aws:eks:us-east-1:123456789012:cluster/eks-placeholder"
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = "https://placeholder.eks.amazonaws.com"
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = "sg-placeholder"
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for cluster"
  value       = "placeholder"
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = "https://oidc.eks.us-east-1.amazonaws.com/id/placeholder"
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/placeholder"
}
