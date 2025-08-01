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
      labels             = {}
      subnet_ids         = [] # Will use private subnets
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
    "cert-manager" = {
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
    policy_arns          = list(string)
  }))
  default = {
    "alb-controller" = {
      namespace            = "kube-system"
      service_account_name = "aws-load-balancer-controller"
      policy_arns          = [] # Will be created by module
    }
    "cert-manager" = {
      namespace            = "cert-manager"
      service_account_name = "cert-manager"
      policy_arns          = []
    }
    "external-dns" = {
      namespace            = "kube-system"
      service_account_name = "external-dns"
      policy_arns          = []
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
