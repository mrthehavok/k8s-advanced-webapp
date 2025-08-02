# EKS Fargate Terraform Module

This module provisions an AWS EKS cluster running entirely on Fargate profiles.

## Prerequisites

This stack assumes that the S3 bucket and DynamoDB table for the Terraform remote state backend have already been created. The `backend.tf` file is configured to use them, but they are not managed by this stack.

## Usage

```bash
terraform init
terraform plan -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars
```

## Cost Considerations

- The module defaults to a cost-optimized setup, including a single NAT gateway.
- Fargate provides pay-per-pod pricing, avoiding idle node costs.
- All created resources are tagged with `Project` and `Environment` for cost tracking.
