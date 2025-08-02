id: task-1
title: "Draft architecture and repo layout"
status: "Done"
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
- 2025-08-01 15:06 UTC: Started work on architecture and repository structure documentation.
- 2025-08-01 15:08 UTC: Created architecture.md with high-level component diagram and explanations.
- 2025-08-01 15:09 UTC: Created repo-structure.md with comprehensive directory layout and purposes.

## Decisions Made

- **Architecture Pattern**: Adopted microservices architecture with separate frontend (React SPA) and backend (FastAPI) services for better scalability and independent deployment.
- **GitOps Approach**: Chose Argo CD with App-of-Apps pattern for declarative continuous deployment, enabling better auditability and rollback capabilities.
- **Namespace Strategy**: Separated concerns into distinct namespaces (dev, monitoring, cert-manager, argocd) for better resource isolation and RBAC.
- **Observability Stack**: Selected kube-prometheus-stack (Prometheus + Grafana) for comprehensive metrics collection and visualization.
- **Cost Optimization**: Designed for AWS Fargate to eliminate node management overhead and enable precise resource allocation per pod.
- **Security**: Implemented TLS termination at ALB with cert-manager for automated certificate management using Let's Encrypt.
- **Repository Structure**: Organized code into logical directories (services/, charts/, infra/, gitops/) following GitOps best practices.

## Files Modified

- docs/architecture.md (created) - High-level architecture documentation with Mermaid diagram
- docs/repo-structure.md (created) - Repository structure and directory purposes documentation

## Blockers

<!-- Document any blockers encountered -->

## Next Steps

- Complete architecture diagrams
- Document repo structure
