# Manual EKS Authentication Setup

## Overview

This document describes the manual process for configuring IAM user access to the EKS cluster when the automated Terraform approach encounters issues.

## Prerequisites

- AWS CLI configured with appropriate credentials
- kubectl installed
- Access to modify the EKS cluster

## Steps

### 1. Update kubeconfig

First, update your local kubeconfig to connect to the EKS cluster:

```bash
aws eks --region eu-west-1 update-kubeconfig --name team-notes-dev-dev
```

### 2. Edit the aws-auth ConfigMap

Edit the aws-auth ConfigMap in the kube-system namespace:

```bash
kubectl edit -n kube-system configmap/aws-auth
```

### 3. Add IAM User Mapping

Add the following under the `data` section of the ConfigMap:

```yaml
mapUsers: |
  - userarn: arn:aws:iam::347913851454:user/idmitriev
    username: idmitriev
    groups:
    - system:masters
```

### 4. Verify Access

Test that kubectl commands work properly:

```bash
kubectl get nodes
kubectl get pods --all-namespaces
```

## Notes

- The Terraform configuration includes an `auth.tf` file that manages the aws-auth ConfigMap automatically
- If the automated approach fails due to provider initialization issues, this manual process can be used as a workaround
- The manual changes will be overwritten if Terraform apply is run with the auth.tf configuration
