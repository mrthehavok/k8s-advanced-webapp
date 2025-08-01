id: task-2
title: "Terraform: EKS on Fargate with IAM/OIDC & cert-manager issuers"
status: "To Do"
created: 2025-08-01
updated: 2025-08-01

## Description

Provision AWS infrastructure necessary for the “Team Notes” stack using Terraform:

- EKS cluster running on Fargate profiles
- Public & private subnets via VPC module (cost-efficient defaults)
- IAM roles for service accounts (IRSA) to allow cert-manager & external-DNS access
- OIDC provider association for the cluster
- ALB Ingress Controller (AWS Load Balancer Controller) IAM policies
- Output kubeconfig and cluster details
- Cert-manager ClusterIssuer for Let’s Encrypt (staging + prod)
- Tags & cost-control parameters (spot where applicable)

## Acceptance Criteria

- [ ] Terraform configuration in `infra/terraform/eks-fargate` directory
- [ ] `terraform fmt` and `terraform validate` pass
- [ ] Plan applies without errors in a sandbox AWS account
- [ ] Cluster supports ALB Ingress Controller & cert-manager
- [ ] Documentation of variables and cost considerations

## Session History

<!-- Update as work progresses -->

## Decisions Made

<!-- Document key decisions -->

## Files Modified

<!-- Track all file changes -->

## Blockers

<!-- Document any blockers -->

## Next Steps

- Develop Terraform modules and variables
- Add README with usage instructions
