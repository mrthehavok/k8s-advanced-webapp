id: task-1
title: "Draft architecture and repo layout"
status: "In Progress"
created: 2025-08-01
updated: 2025-08-01

## Description

Create a high-level architecture document and repository layout proposal covering:

- AWS EKS on Fargate base infrastructure
- Namespaces (dev, monitoring)
- GitOps flow with Argo CD App-of-Apps
- Helm chart hierarchy (frontend, backend, ingress, monitoring)
- TLS termination with cert-manager + ALB Ingress Controller
- Observability stack (kube-prometheus-stack) and alert rules
- CI/CD image build and chart release lifecycle
- Cost-control practices (Fargate sizing, limits)

## Acceptance Criteria

- [ ] `docs/architecture.md` with architecture diagram (Mermaid) and component explanations
- [ ] `docs/repo-structure.md` enumerating directories and purpose
- [ ] All decisions documented
- [ ] Reviewed and approved by stakeholders

## Session History

- 2025-08-01 14:55 UTC: Task created and assigned to Architect agent.

## Decisions Made

<!-- Document key decisions here -->

## Files Modified

<!-- Track all file changes -->

## Blockers

<!-- Document any blockers encountered -->

## Next Steps

- Complete architecture diagrams
- Document repo structure
