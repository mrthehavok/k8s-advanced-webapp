provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_id]
  }
}

locals {
  cluster_name = "${var.project_name}-${var.environment}"
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
