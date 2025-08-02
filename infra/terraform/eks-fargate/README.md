# EKS Fargate Terraform Module

This module provisions an AWS EKS cluster running entirely on Fargate profiles.

## Prerequisites

This stack assumes that the S3 bucket and DynamoDB table for the Terraform remote state backend have already been created. The `backend.tf` file is configured to use them, but they are not managed by this stack.

## Usage

This is a root module designed to be deployed directly.

```hcl
# See terraform.tfvars.example for a full list of variables
module "eks_fargate" {
  source = "./"

  environment = "dev"
  aws_region  = "us-east-1"
  # ... other variables
}
```

## Cost Considerations

- The module defaults to a cost-optimized setup, including a single NAT gateway.
- Fargate provides pay-per-pod pricing, avoiding idle node costs.
- All created resources are tagged with `Project` and `Environment` for cost tracking.
