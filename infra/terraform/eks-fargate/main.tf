locals {
  cluster_name = "${var.project_name}-${var.environment}"
}

# Data source to get the existing EKS cluster (if it exists)
data "aws_eks_cluster" "cluster" {
  name = local.cluster_name

  depends_on = [module.eks_cluster]
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name

  depends_on = [module.eks_cluster]
}

# Kubernetes provider configuration depends on EKS cluster outputs
# This ensures the provider is configured only after the cluster exists
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_availability_zones" "available" {
  state = "available"
}

# AIDEV-TODO: Replace with actual module sources once implemented
module "networking" {
  source = "./modules/networking"

  vpc_cidr             = var.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway
  project_name         = var.project_name
  environment          = var.environment
  tags                 = var.tags
}

module "eks_cluster" {
  source = "./modules/eks-cluster"

  project_name                         = var.project_name
  environment                          = var.environment
  tags                                 = var.tags
  vpc_id                               = module.networking.vpc_id
  private_subnet_ids                   = module.networking.private_subnet_ids
  cluster_version                      = var.cluster_version
  cluster_endpoint_private_access      = var.cluster_endpoint_private_access
  cluster_endpoint_public_access       = var.cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  fargate_profiles                     = var.fargate_profiles
}

module "irsa" {
  source = "./modules/irsa"

  enable_irsa       = var.enable_irsa
  irsa_configs      = var.irsa_configs
  oidc_provider_arn = module.eks_cluster.oidc_provider_arn
  oidc_provider_url = module.eks_cluster.cluster_oidc_issuer_url
  project_name      = var.project_name
  environment       = var.environment
  tags              = var.tags
}


