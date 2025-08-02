# AWS region
aws_region = "eu-west-1"

# Environment name
environment = "dev"

# Project name
project_name = "team-notes-dev"

# VPC CIDR block
vpc_cidr = "10.10.0.0/16"

# Enable EKS cluster autoscaler
enable_cluster_autoscaler = false
# Private subnet CIDR blocks
private_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]

# Public subnet CIDR blocks
public_subnet_cidrs  = ["10.10.101.0/24", "10.10.102.0/24"]