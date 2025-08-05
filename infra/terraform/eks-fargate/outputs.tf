# Cluster Outputs
output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks_cluster.cluster_id
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks_cluster.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_cluster.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks_cluster.cluster_security_group_id
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data for cluster"
  value       = module.eks_cluster.cluster_certificate_authority_data
  sensitive   = true
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster OIDC Issuer"
  value       = module.eks_cluster.cluster_oidc_issuer_url
}

# Networking Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.networking.public_subnet_ids
}

# IRSA Outputs
output "irsa_role_arns" {
  description = "Map of IRSA role ARNs"
  value       = module.irsa.role_arns
}

output "alb_controller_service_account" {
  description = "IRSA service account details for the AWS Load Balancer Controller"
  value = {
    namespace = "kube-system"
    name      = "aws-load-balancer-controller"
    role_arn  = lookup(module.irsa.role_arns, "alb-controller", null)
  }
}

# Fargate Profile Outputs
output "fargate_profile_names" {
  description = "List of Fargate profile names created for the cluster"
  value       = module.eks_cluster.fargate_profile_names
}

# Kubeconfig
output "kubeconfig_command" {
  description = "AWS CLI command to update kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${local.cluster_name}"
}
