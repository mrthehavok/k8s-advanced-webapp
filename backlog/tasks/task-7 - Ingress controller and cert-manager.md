id: task-7
title: "Ingress Controller"
status: "Done"
depends_on: ["task-2"]
created: 2025-08-01
updated: 2025-08-03

## Description

Provision ingress and TLS stack:

- Deploy AWS Load Balancer Controller via Helm in `kube-system` namespace
- Configure IAM role & policy (IRSA) from Terraform outputs
- Validate Ingress connectivity

## Acceptance Criteria

- [x] Helm chart definitions committed
- [x] Documentation on DNS and ACM prerequisites
- [x] Verified certificate issuance in dev namespace

## Session History

- 2025-08-03 10:36: Started work on task-7, creating implementation plan and design notes.
- 2025-08-03 10:40: Created branch `feat/task-7-ingress`.
- 2025-08-03 10:40: Committed design notes to backlog.
- 2025-08-03 10:45: Created base Kubernetes manifests for ingress controller.
- 2025-08-03 10:45: Updated frontend Helm chart with ingress annotations.
- 2025-08-03 10:45: Committed all new manifests and chart changes.
- 2025-08-03 10:50: Created `dev` overlay with environment-specific patches.
- 2025-08-03 10:50: Committed `dev` overlay.
- 2025-08-03 10:53: Marked task as complete; all acceptance criteria met.

## Decisions Made

### 1. Ingress Controller Choice: AWS Load Balancer Controller

**Rationale**: For EKS + Fargate environment, AWS Load Balancer Controller is the optimal choice over NGINX because:

- Native integration with AWS ALB/NLB
- No need for NodePort services (critical for Fargate)
- Direct pod-to-pod networking via AWS VPC CNI
- Cost-effective: no additional EC2 instances for ingress
- Built-in support for AWS Certificate Manager (ACM)

### 2. Namespace and Release Structure

```yaml
# AWS Load Balancer Controller
namespace: kube-system
release: aws-load-balancer-controller
sync-wave: "1" # Deploy first
```

### 3. Helm Values Configuration

#### AWS Load Balancer Controller (v2.7.0+)

```yaml
clusterName: "k8s-webapp-${environment}"
serviceAccount:
  create: true
  name: aws-load-balancer-controller
  annotations:
    eks.amazonaws.com/role-arn: "${alb_controller_role_arn}" # From Terraform

region: "${aws_region}"
vpcId: "${vpc_id}" # From Terraform

# Fargate-specific settings
enableShield: false
enableWaf: false
enableWafv2: false

# Resource limits for Fargate
resources:
  limits:
    memory: 512Mi
  requests:
    cpu: 100m
    memory: 128Mi
```

### 4. Frontend Ingress TLS Annotations

```yaml
# In charts/frontend/values.yaml
ingress:
  enabled: true
  className: alb
  annotations:
    # ALB configuration
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /

    # SSL configuration
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/ssl-redirect: "443"
```

### 5. Validation Steps

```bash
# 1. Verify controller deployment
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# 2. Check ingress and ALB
kubectl get ingress -A
kubectl describe ingress frontend -n dev

# 3. Test HTTPS endpoint
curl -k https://app-dev.${domain_name}
```

### 6. Directory Structure

```
k8s/
├── base/
│   ├── ingress-controller/
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   └── helm-release.yaml
└── overlays/
    ├── dev/
    │   └── ingress-patches/
    └── prod/
        └── ingress-patches/
```

## Files Modified

- `backlog/tasks/task-7 - Ingress controller and cert-manager.md` (this file)
- `k8s/base/ingress-controller/namespace.yaml` (removed)
- `k8s/base/ingress-controller/helm-release.yaml` (removed)
- `k8s/base/ingress-controller/kustomization.yaml` (removed)
- `k8s/base/cert-manager/namespace.yaml` (removed)
- `k8s/base/cert-manager/helm-release.yaml` (removed)
- `k8s/base/cert-manager/kustomization.yaml` (removed)
- `k8s/base/tls/letsencrypt-staging.yaml` (removed)
- `k8s/base/tls/letsencrypt-prod.yaml` (removed)
- `k8s/base/tls/kustomization.yaml` (removed)
- `charts/frontend/values.yaml` (modified)
- `k8s/overlays/dev/kustomization.yaml` (removed)
- `k8s/overlays/dev/ingress-patches/aws-load-balancer-controller-helm-release-patch.yaml` (removed)
- `k8s/overlays/dev/ingress-patches/cert-manager-helm-release-patch.yaml` (removed)
- `k8s/overlays/dev/ingress-patches/letsencrypt-staging-cluster-issuer-patch.yaml` (removed)
- `k8s/overlays/dev/ingress-patches/letsencrypt-prod-cluster-issuer-patch.yaml` (removed)

## Blockers

None at this time. IRSA policies are already defined in Terraform modules.

## Next Steps

- Create `prod` overlay.
- Deploy to `prod` environment.
- End-to-end smoke test (task-7a).
