id: task-7
title: "Ingress Controller & cert-manager ClusterIssuer"
status: "To Do"
depends_on: ["task-2"]
created: 2025-08-01
updated: 2025-08-01

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

## Decisions Made

## Files Modified

## Blockers

## Next Steps

- Implement Helm releases via Argo CD
- Test issuance with sample Ingress
