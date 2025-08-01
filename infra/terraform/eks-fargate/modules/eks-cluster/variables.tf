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

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the cluster"
  type        = list(string)
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
}

variable "cluster_endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
}

variable "cluster_endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks that can access the public API server endpoint"
  type        = list(string)
}

variable "fargate_profiles" {
  description = "Map of Fargate profile definitions"
  type = map(object({
    namespace_patterns = list(string)
    labels             = map(string)
    subnet_ids         = list(string)
  }))
}
