# Terraform EKS Fargate Infrastructure Design

## 1. Overview

This document outlines the design for provisioning an AWS EKS cluster running entirely on Fargate profiles, including all supporting infrastructure required for the "Team Notes" application stack.

## 2. Directory Structure

```
infra/terraform/eks-fargate/
├── main.tf                    # Root module orchestration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── versions.tf                # Provider version constraints
├── backend.tf                 # Remote state configuration
├── data.tf                    # Data sources (AMIs, AZs, etc.)
├── locals.tf                  # Local computed values
│
├── modules/                   # Local modules
│   ├── networking/           # VPC, subnets, NAT gateway
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── eks-cluster/          # EKS cluster and OIDC
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── fargate.tf       # Fargate profiles
│   │   └── versions.tf
│   │
│   └── irsa/                 # IAM roles for service accounts
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── policies/         # Policy documents
│       │   └── external-dns.json
│       └── versions.tf
│
├── terraform.tfvars.example   # Example variable values
└── README.md                  # Module documentation
```

## 3. Variables Definition

### 3.1 Root Module Variables

```hcl
# General Configuration
variable "project_name" {
  description = "Name of the project, used for resource naming and tagging"
  type        = string
  default     = "team-notes"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Networking Variables
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones for subnets (leave empty for auto-selection)"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "single_nat_gateway" {
  description = "Use a single NAT Gateway for all private subnets (cost optimization)"
  type        = bool
  default     = true
}

# EKS Configuration
variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.30"
}

variable "cluster_endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Fargate Profiles
variable "fargate_profiles" {
  description = "Map of Fargate profile definitions"
  type = map(object({
    namespace_patterns = list(string)
    labels             = map(string)
    subnet_ids         = list(string)
  }))
  default = {
    default = {
      namespace_patterns = ["default", "kube-system"]
      labels            = {}
      subnet_ids        = [] # Will use private subnets
    }
    dev = {
      namespace_patterns = ["dev"]
      labels            = {}
      subnet_ids        = []
    }
    monitoring = {
      namespace_patterns = ["monitoring"]
      labels            = {}
      subnet_ids        = []
    }
    argocd = {
      namespace_patterns = ["argocd"]
      labels            = {}
      subnet_ids        = []
    }
  }
}

# IRSA Configuration
variable "enable_irsa" {
  description = "Enable IAM Roles for Service Accounts"
  type        = bool
  default     = true
}

variable "irsa_configs" {
  description = "IRSA configurations for various services"
  type = map(object({
    namespace            = string
    service_account_name = string
    policy_arns         = list(string)
  }))
  default = {
    external-dns = {
      namespace            = "kube-system"
      service_account_name = "external-dns"
      policy_arns         = []
    }
  }
}

# Cost Control
variable "enable_cost_allocation_tags" {
  description = "Enable cost allocation tags"
  type        = bool
  default     = true
}

variable "budget_alert_email" {
  description = "Email address for budget alerts"
  type        = string
  default     = ""
  sensitive   = true
}
```

## 4. Outputs Definition

```hcl
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

# Kubeconfig
output "kubeconfig_command" {
  description = "AWS CLI command to update kubeconfig"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks_cluster.cluster_id}"
}
```

## 5. Backend Configuration

### backend.tf

```hcl
terraform {
  backend "s3" {
    # These values should be provided via backend config file or CLI args
    # bucket         = "team-notes-terraform-state"
    # key            = "eks-fargate/terraform.tfstate"
    # region         = "us-east-1"
    # encrypt        = true
    # dynamodb_table = "team-notes-terraform-locks"
  }
}
```

### Backend initialization script

```bash
# scripts/init-backend.sh
#!/bin/bash
ENVIRONMENT=$1
AWS_REGION=${2:-us-east-1}

terraform init \
  -backend-config="bucket=team-notes-terraform-state-${ENVIRONMENT}" \
  -backend-config="key=eks-fargate/${ENVIRONMENT}/terraform.tfstate" \
  -backend-config="region=${AWS_REGION}" \
  -backend-config="encrypt=true" \
  -backend-config="dynamodb_table=team-notes-terraform-locks-${ENVIRONMENT}"
```

## 6. Provider Configuration

### versions.tf

```hcl
terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0, < 6.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.27.0, < 3.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Environment = var.environment
        Project     = var.project_name
        ManagedBy   = "terraform"
      },
      var.tags
    )
  }
}

provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_id]
  }
}
```

## 7. IAM Policies for IRSA

### 7.1 External-DNS Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["route53:ChangeResourceRecordSets"],
      "Resource": ["arn:aws:route53:::hostedzone/*"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResource"
      ],
      "Resource": ["*"]
    }
  ]
}
```

## 8. Integration Points

### 8.1 Downstream Dependencies

The following components will depend on outputs from this Terraform module:

1. **Helm Charts** (Task 5-6)

   - Will need: `cluster_endpoint`, `cluster_certificate_authority_data`
   - IRSA role ARNs for service account annotations

2. **Monitoring Stack** (Task 8)

   - Will need: Fargate profile for monitoring namespace
   - Security group rules for metrics collection

3. **Argo CD** (Task 9)
   - Will need: Fargate profile for argocd namespace
   - Cluster access configuration

### 8.2 Prerequisites

Before running this Terraform:

1. AWS account with appropriate permissions
2. S3 bucket and DynamoDB table for Terraform state
3. Route53 hosted zone (if using custom domain)
4. AWS CLI configured with credentials

## 9. Cost Control Recommendations

### 9.1 Default Cost-Optimized Settings

1. **Single NAT Gateway**: By default, use one NAT gateway instead of one per AZ

   - Saves ~$45/month per additional NAT gateway
   - Trade-off: No AZ redundancy for egress traffic

2. **Two Availability Zones**: Minimum required for EKS

   - Avoids unnecessary subnet and NAT costs
   - Still provides HA for the cluster

3. **Fargate Profiles**: Pay-per-pod pricing

   - No idle node costs
   - Automatic right-sizing
   - Consider spot for non-critical workloads

4. **Resource Tagging**: Enable cost allocation tags
   - Track costs by environment, service, and team
   - Set up AWS Cost Explorer filters

### 9.2 Cost Monitoring

```hcl
# Optional budget alert module
module "budget_alerts" {
  source = "./modules/budget"

  budget_limit      = 100 # USD per month
  alert_email       = var.budget_alert_email
  threshold_percent = 80
}
```

### 9.3 Recommendations by Environment

- **Dev**: Single NAT, minimal Fargate resources
- **Staging**: Single NAT, production-like configuration
- **Prod**: Consider multi-NAT for redundancy, reserved Fargate capacity

## 10. Implementation Roadmap

### Phase 1: Core Infrastructure

1. `versions.tf` - Provider requirements
2. `backend.tf` - State management
3. `variables.tf` - Input variables
4. `locals.tf` - Computed values
5. `data.tf` - Data sources

### Phase 2: Networking Module

1. `modules/networking/main.tf` - VPC, subnets, NAT
2. `modules/networking/variables.tf` - Module inputs
3. `modules/networking/outputs.tf` - Module outputs

### Phase 3: EKS Cluster Module

1. `modules/eks-cluster/main.tf` - Cluster resource
2. `modules/eks-cluster/fargate.tf` - Fargate profiles
3. `modules/eks-cluster/oidc.tf` - OIDC provider
4. `modules/eks-cluster/outputs.tf` - Cluster details

### Phase 4: IRSA Module

1. `modules/irsa/main.tf` - IAM roles and policies
2. `modules/irsa/policies/*.json` - Policy documents
3. `modules/irsa/outputs.tf` - Role ARNs

### Phase 5: Root Module Integration

1. `main.tf` - Module composition
2. `outputs.tf` - Consolidated outputs
3. `README.md` - Usage documentation
4. `terraform.tfvars.example` - Example configuration

### Phase 6: Validation & Testing

1. Format validation: `terraform fmt -recursive`
2. Configuration validation: `terraform validate`
3. Plan generation: `terraform plan`
4. Cost estimation via AWS Cost Explorer

## 11. Security Considerations

1. **API Endpoint Access**: Default allows public access, consider restricting
2. **IRSA**: Use fine-grained IAM policies, avoid wildcards
3. **Secrets**: Never store in Terraform state, use AWS Secrets Manager
4. **Network Isolation**: Private subnets for Fargate pods
5. **Security Groups**: Least-privilege ingress/egress rules

## 12. Maintenance & Updates

1. **EKS Version**: Plan quarterly updates
2. **Provider Versions**: Test updates in dev first
3. **Module Versioning**: Tag releases for stability
4. **State Management**: Regular backups, access controls
5. **Documentation**: Keep README and examples current
