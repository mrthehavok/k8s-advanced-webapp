id: task-7
title: "Ingress Controller & cert-manager ClusterIssuer"
status: "In Progress"
depends_on: ["task-2"]
created: 2025-08-01
updated: 2025-08-03

## Description

Provision ingress and TLS stack:

- Deploy AWS Load Balancer Controller via Helm in `kube-system` namespace
- Configure IAM role & policy (IRSA) from Terraform outputs
- Install cert-manager via Helm in dedicated `cert-manager` namespace
- Create ClusterIssuer resources for Let's Encrypt (staging & prod) using Route53 DNS-01 or HTTP-01 with ALB
- Validate certificate issuance with test Ingress

## Acceptance Criteria

- [ ] Helm chart definitions committed
- [ ] ClusterIssuer YAML manifests in `k8s/base/tls/`
- [ ] Documentation on DNS and ACM prerequisites
- [ ] Verified certificate issuance in dev namespace

## Session History

- 2025-08-03 10:36: Started work on task-7, creating implementation plan and design notes
- 2025-08-03 10:36: Branch creation planned: feat/task-7-ingress

## Decisions Made

### 1. Ingress Controller Choice: AWS Load Balancer Controller

**Rationale**: For EKS + Fargate environment, AWS Load Balancer Controller is the optimal choice over NGINX because:

- Native integration with AWS ALB/NLB
- No need for NodePort services (critical for Fargate)
- Direct pod-to-pod networking via AWS VPC CNI
- Cost-effective: no additional EC2 instances for ingress
- Built-in support for AWS Certificate Manager (ACM) as alternative to cert-manager

### 2. TLS Strategy: cert-manager with Let's Encrypt

**Primary approach**: cert-manager with DNS-01 challenge via Route53

- DNS-01 allows wildcard certificates
- No need for HTTP endpoints during validation
- IRSA policy already includes Route53 permissions (confirmed in cert-manager.json)

**Alternative**: AWS Certificate Manager (ACM) for simpler setup if wildcard not needed

### 3. Namespace and Release Structure

```yaml
# AWS Load Balancer Controller
namespace: kube-system
release: aws-load-balancer-controller
sync-wave: "1"  # Deploy first

# cert-manager
namespace: cert-manager
release: cert-manager
sync-wave: "2"  # Deploy after ALB controller

# ClusterIssuers
namespace: cert-manager  # ClusterIssuers are cluster-scoped but managed here
sync-wave: "3"  # Deploy after cert-manager is ready
```

### 4. Helm Values Configuration

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

#### cert-manager (v1.14.0+)

```yaml
installCRDs: true # Manage CRDs via Helm

serviceAccount:
  create: true
  name: cert-manager
  annotations:
    eks.amazonaws.com/role-arn: "${cert_manager_role_arn}" # From Terraform

# Fargate compatibility
securityContext:
  fsGroup: 1001

# DNS-01 solver configuration
extraArgs:
  - --dns01-recursive-nameservers-only
  - --dns01-recursive-nameservers=8.8.8.8:53,1.1.1.1:53

resources:
  limits:
    memory: 256Mi
  requests:
    cpu: 50m
    memory: 128Mi

webhook:
  resources:
    limits:
      memory: 128Mi
    requests:
      cpu: 10m
      memory: 64Mi

cainjector:
  resources:
    limits:
      memory: 256Mi
    requests:
      cpu: 50m
      memory: 128Mi
```

### 5. ClusterIssuer Configurations

#### Let's Encrypt Staging (for testing)

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    email: devops@example.com # Will be parameterized
    privateKeySecretRef:
      name: letsencrypt-staging-key
    solvers:
      - dns01:
          route53:
            region: ${aws_region}
            # Uses IRSA, no credentials needed
```

#### Let's Encrypt Production

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: devops@example.com # Will be parameterized
    privateKeySecretRef:
      name: letsencrypt-prod-key
    solvers:
      - dns01:
          route53:
            region: ${aws_region}
```

### 6. Frontend Ingress TLS Annotations

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

    # cert-manager integration
    cert-manager.io/cluster-issuer: letsencrypt-prod
    cert-manager.io/acme-challenge-type: dns01

    # SSL configuration
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/ssl-redirect: "443"

  tls:
    - secretName: frontend-tls-certificate
      hosts:
        - "app.${domain_name}"
```

### 7. Validation Steps

```bash
# 1. Verify controller deployment
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
kubectl logs -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# 2. Verify cert-manager
kubectl get pods -n cert-manager
kubectl get crds | grep cert-manager

# 3. Check ClusterIssuers
kubectl get clusterissuer
kubectl describe clusterissuer letsencrypt-staging

# 4. Deploy test ingress with staging issuer first
kubectl apply -f test-ingress-staging.yaml

# 5. Monitor certificate creation
kubectl get certificate -A
kubectl describe certificate frontend-tls-certificate -n dev

# 6. Check ingress and ALB
kubectl get ingress -A
kubectl describe ingress frontend -n dev

# 7. Test HTTPS endpoint (staging cert will show warning)
curl -k https://app-dev.${domain_name}

# 8. Switch to production issuer after successful staging test
```

### 8. Directory Structure

```
k8s/
├── base/
│   ├── ingress-controller/
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   └── helm-release.yaml
│   ├── cert-manager/
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   └── helm-release.yaml
│   └── tls/
│       ├── kustomization.yaml
│       ├── letsencrypt-staging.yaml
│       └── letsencrypt-prod.yaml
└── overlays/
    ├── dev/
    │   └── ingress-patches/
    └── prod/
        └── ingress-patches/
```

## Files Modified

- backlog/tasks/task-7 - Ingress controller and cert-manager.md (this file)

## Blockers

None at this time. IRSA policies are already defined in Terraform modules.

## Next Steps

- Create Helm release definitions for AWS Load Balancer Controller
- Create Helm release definitions for cert-manager
- Create ClusterIssuer manifests
- Create test ingress for validation
- Document DNS prerequisites and domain setup
- Test with staging issuer before production
