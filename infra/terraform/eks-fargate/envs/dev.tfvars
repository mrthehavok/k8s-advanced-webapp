# AWS region
aws_region = "eu-west-1"

# Environment name
environment = "dev"

# Project name
project_name = "team-notes-dev"

# VPC CIDR block
vpc_cidr = "10.10.0.0/16"

# Private subnet CIDR blocks
private_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]

# Public subnet CIDR blocks
public_subnet_cidrs = ["10.10.101.0/24", "10.10.102.0/24"]

# AWS Auth Users - IAM users to add to the aws-auth ConfigMap
aws_auth_users = [
  {
    userarn  = "arn:aws:iam::347913851454:user/idmitriev"
    username = "idmitriev"
    groups   = ["system:masters"]
  }
]

# Fargate profiles
fargate_profiles = {
default = {
  namespace_patterns = ["default", "kube-system", "flux-system"]
  labels             = {}
  subnet_ids         = []
}
  dev = {
    namespace_patterns = ["dev"]
    labels             = {}
    subnet_ids         = []
  }
  monitoring = {
    namespace_patterns = ["monitoring"]
    labels             = {}
    subnet_ids         = []
  }
  cert-manager = {
    namespace_patterns = ["cert-manager"]
    labels             = {}
    subnet_ids         = []
  }
  argocd = {
    namespace_patterns = ["argocd"]
    labels             = {}
    subnet_ids         = []
  }
}

# IRSA configurations - empty to preserve existing resources
irsa_configs = {
  alb-controller = {
    namespace            = "kube-system"
    service_account_name = "aws-load-balancer-controller"
    policy_json_path     = "modules/irsa/policies/alb-controller.json"
  }
  cert-manager = {
    namespace            = "cert-manager"
    service_account_name = "cert-manager"
    policy_json_path     = "modules/irsa/policies/cert-manager.json"
  }
}

# Disable IRSA since resources already exist
enable_irsa = true

# Keep cluster version as default
cluster_version = "1.31"