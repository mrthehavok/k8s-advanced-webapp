# AWS region
aws_region = "eu-west-1"

# Environment name
environment = "prod"

# Project name
project_name = "team-notes"

# VPC CIDR block
vpc_cidr = "10.20.0.0/16"

# Enable EKS cluster autoscaler
enable_cluster_autoscaler = true
# Private subnet CIDR blocks
private_subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24"]

# Public subnet CIDR blocks
public_subnet_cidrs = ["10.20.101.0/24", "10.20.102.0/24"]