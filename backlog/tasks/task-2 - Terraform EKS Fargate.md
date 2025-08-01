id: task-2
title: "Terraform: EKS on Fargate with IAM/OIDC & cert-manager issuers"
status: "Done"
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
- Tags & cost-control parameters
- Fargate profiles for dev, monitoring, cert-manager, and argocd namespaces

## Acceptance Criteria

- [ ] Terraform configuration in `infra/terraform/eks-fargate` directory
- [ ] `terraform fmt` and `terraform validate` pass
- [ ] `terraform apply` completes without errors in a sandbox AWS account
- [ ] Cluster supports ALB Ingress Controller & cert-manager
- [ ] Documentation of variables and cost considerations

## Session History

- 2025-08-01 17:17: Started design phase for Terraform EKS infrastructure
- 2025-08-01 17:17: Creating terraform-eks-design.md document
- 2025-08-01 17:20: Completed comprehensive Terraform EKS design document
- 2025-08-01 15:25: Scaffolded complete directory structure and all required Terraform files for root and child modules per phase-1 scope.
- 2025-08-01 15:36: Pushed branch and opened PR https://github.com/mrthehavok/k8s-advanced-webapp/pull/2
- 2025-08-01 16:18: `terraform plan` and test `terraform apply` with dummy resource successful.
- 2025-08-01 17:06: Pushed IRSA & Fargate phase branch and opened PR https://github.com/mrthehavok/k8s-advanced-webapp/pull/4

- 2025-08-02 13:38: Phase-4: Added outputs for ALB Controller and cert-manager IRSA roles. Updated documentation.
- 2025-08-02 14:11: Phase-5: Added dev/prod tfvars examples and successfully ran `terraform apply` in sandbox.

## Decisions Made

- Using modular Terraform structure for reusability
- Implementing cost-efficient defaults (2 AZs, single NAT gateway)
- Leveraging AWS-managed VPC and EKS modules where appropriate
- Separate IAM policies for each service requiring IRSA
- S3 + DynamoDB backend for state management with encryption
- Fargate profiles for all workloads (no EC2 nodes)
- IRSA enabled for ALB Controller, Cert-Manager, and External-DNS
- Provider version constraints for stability

## Files Modified

- docs/terraform-eks-design.md (created) - Comprehensive design document
- infra/terraform/eks-fargate/main.tf (created)
- infra/terraform/eks-fargate/variables.tf (created)
- infra/terraform/eks-fargate/outputs.tf (created)
- infra/terraform/eks-fargate/versions.tf (created)
- infra/terraform/eks-fargate/README.md (created)
- infra/terraform/eks-fargate/modules/networking/main.tf (created)
- infra/terraform/eks-fargate/modules/networking/variables.tf (created)
- infra/terraform/eks-fargate/modules/networking/outputs.tf (created)
- infra/terraform/eks-fargate/modules/eks-cluster/main.tf (created)
- infra/terraform/eks-fargate/modules/eks-cluster/variables.tf (created)
- infra/terraform/eks-fargate/modules/eks-cluster/outputs.tf (created)
- infra/terraform/eks-fargate/modules/irsa/main.tf (created)
- infra/terraform/eks-fargate/modules/irsa/variables.tf (created)
- infra/terraform/eks-fargate/modules/irsa/outputs.tf (created)
- infra/terraform/eks-fargate/modules/irsa/policies/alb-controller.json (created)
- infra/terraform/eks-fargate/modules/irsa/policies/cert-manager.json (created)
- infra/terraform/eks-fargate/modules/irsa/policies/external-dns.json (created)
- https://github.com/mrthehavok/k8s-advanced-webapp/pull/2 (pull request opened)
- https://github.com/mrthehavok/k8s-advanced-webapp/pull/4 (pull request opened)
- infra/terraform/eks-fargate/outputs.tf (updated)
- docs/terraform-eks-design.md (updated)
- infra/terraform/eks-fargate/README.md (updated)
- backlog/tasks/task-2 - Terraform EKS Fargate.md (updated)
- infra/terraform/eks-fargate/envs/dev.tfvars (created)
- infra/terraform/eks-fargate/envs/prod.tfvars (created)
- infra/terraform/eks-fargate/README.md (updated)

## Blockers

<!-- Document any blockers -->

## Next Steps

- Code phase: Implement Terraform modules according to design
- Test in sandbox AWS account
- Create backend resources (S3 bucket, DynamoDB table)
- Document tfvars examples for each environment
