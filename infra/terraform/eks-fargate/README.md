# EKS Fargate Terraform Module

This module provisions an AWS EKS cluster running entirely on Fargate profiles.

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
