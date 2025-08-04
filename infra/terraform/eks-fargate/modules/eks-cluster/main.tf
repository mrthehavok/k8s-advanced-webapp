# AIDEV-NOTE: Using the official AWS EKS module for cluster creation.
# See https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.0"

  name               = "${var.project_name}-${var.environment}"
  kubernetes_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  endpoint_private_access = var.cluster_endpoint_private_access
  endpoint_public_access  = var.cluster_endpoint_public_access


  # Fargate Profiles
  fargate_profiles = {
    for k, v in var.fargate_profiles : k => {
      selectors = [
        for pattern in v.namespace_patterns : {
          namespace = pattern
        }
      ]
      subnet_ids = length(v.subnet_ids) > 0 ? v.subnet_ids : null
      tags       = v.labels
    }
  }

  tags = merge(
    {
      "Name" = "${var.project_name}-${var.environment}"
    },
    var.tags,
  )
}

