# Repository Structure

This document outlines the directory structure and purpose of each component in the k8s-advanced-webapp repository.

## Directory Layout

```
k8s-advanced-webapp/
├── services/                  # Application source code
│   ├── backend/              # FastAPI backend service
│   │   ├── src/             # Python source files
│   │   ├── tests/           # Unit and integration tests
│   │   ├── Dockerfile       # Container image definition
│   │   ├── requirements.txt # Python dependencies
│   │   └── README.md        # Service documentation
│   │
│   └── frontend/            # React frontend application
│       ├── src/             # React source files
│       ├── public/          # Static assets
│       ├── tests/           # Frontend tests
│       ├── Dockerfile       # Container image definition
│       ├── package.json     # Node dependencies
│       └── README.md        # Service documentation
│
├── charts/                   # Helm charts
│   ├── backend/             # Backend service chart
│   │   ├── templates/       # Kubernetes manifests
│   │   ├── values.yaml      # Default configuration
│   │   └── Chart.yaml       # Chart metadata
│   │
│   ├── frontend/            # Frontend service chart
│   │   ├── templates/       # Kubernetes manifests
│   │   ├── values.yaml      # Default configuration
│   │   └── Chart.yaml       # Chart metadata
│   │
│   └── umbrella/            # Umbrella chart for full stack
│       ├── Chart.yaml       # Dependencies on sub-charts
│       ├── values.yaml      # Override values
│       └── values/          # Environment-specific values
│           ├── dev.yaml
│           ├── staging.yaml
│           └── prod.yaml
│
├── infra/                    # Infrastructure as Code
│   ├── terraform/           # Terraform modules
│   │   ├── modules/         # Reusable modules
│   │   │   ├── eks/        # EKS cluster module
│   │   │   ├── networking/ # VPC and subnets
│   │   │   └── iam/        # IAM roles and policies
│   │   │
│   │   ├── environments/    # Environment configurations
│   │   │   ├── dev/
│   │   │   ├── staging/
│   │   │   └── prod/
│   │   │
│   │   └── backend.tf       # Terraform state backend
│   │
│   └── scripts/             # Helper scripts
│       ├── setup-cluster.sh
│       └── destroy-cluster.sh
│
├── gitops/                   # Argo CD GitOps definitions
│   ├── bootstrap/           # Initial Argo CD setup
│   │   ├── argocd/         # Argo CD installation
│   │   └── app-of-apps.yaml # Root application
│   │
│   ├── apps/                # Application definitions
│   │   ├── backend.yaml     # Backend app manifest
│   │   ├── frontend.yaml    # Frontend app manifest
│   │   └── monitoring.yaml  # Monitoring stack
│   │
│   └── overlays/            # Kustomize overlays
│       ├── dev/
│       ├── staging/
│       └── prod/
│
├── monitoring/               # Observability configurations
│   ├── prometheus/          # Prometheus configuration
│   │   ├── rules/          # Alert rules
│   │   └── values.yaml     # Helm values override
│   │
│   ├── grafana/            # Grafana dashboards
│   │   ├── dashboards/     # JSON dashboard definitions
│   │   └── datasources/    # Data source configs
│   │
│   └── alerts/             # AlertManager configuration
│       ├── routes.yaml     # Alert routing rules
│       └── templates/      # Notification templates
│
├── docs/                     # Documentation
│   ├── architecture.md      # System architecture
│   ├── repo-structure.md    # This document
│   ├── deployment.md        # Deployment guide
│   ├── development.md       # Developer guide
│   ├── troubleshooting.md   # Common issues
│   └── runbooks/           # Operational runbooks
│       ├── incident-response.md
│       └── backup-restore.md
│
├── .github/                  # GitHub specific files
│   ├── workflows/           # GitHub Actions
│   │   ├── ci-backend.yaml  # Backend CI pipeline
│   │   ├── ci-frontend.yaml # Frontend CI pipeline
│   │   ├── cd-deploy.yaml   # Deployment pipeline
│   │   └── security-scan.yaml # Security scanning
│   │
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── ISSUE_TEMPLATE/
│   └── CODEOWNERS
│
├── backlog/                  # Task management
│   ├── tasks/               # Task files
│   └── config.yml           # Backlog configuration
│
├── tests/                    # End-to-end tests
│   ├── e2e/                 # E2E test suites
│   ├── load/                # Load testing scripts
│   └── smoke/               # Smoke tests
│
├── scripts/                  # Utility scripts
│   ├── local-dev.sh         # Local development setup
│   ├── port-forward.sh      # Port forwarding helper
│   └── clean-resources.sh   # Resource cleanup
│
├── .gitignore               # Git ignore rules
├── README.md                # Project overview
├── Makefile                 # Common tasks
└── AGENTS.md                # AI agent guidelines

```

## Directory Purposes

### `/services`

Contains the application source code for all microservices. Each service has its own subdirectory with:

- Source code in the appropriate language
- Tests colocated with the code
- Dockerfile for containerization
- Dependency management files
- Service-specific documentation

### `/charts`

Helm charts for Kubernetes deployments:

- Individual charts for each service
- Umbrella chart for deploying the full stack
- Environment-specific value files
- Reusable chart templates

### `/infra`

Infrastructure as Code (IaC) definitions:

- **Terraform modules**: Reusable infrastructure components
- **Environment configs**: Separate state per environment
- **Scripts**: Automation for common infrastructure tasks

### `/gitops`

Argo CD application definitions and configurations:

- **Bootstrap**: Initial cluster setup with Argo CD
- **Apps**: Application manifests for GitOps
- **Overlays**: Kustomize patches for environments

### `/monitoring`

Observability stack configurations:

- **Prometheus**: Metrics collection and alerting rules
- **Grafana**: Visualization dashboards
- **Alerts**: AlertManager routing and templates

### `/docs`

Comprehensive documentation:

- Architecture and design documents
- Deployment and operational guides
- Development guidelines
- Troubleshooting resources
- Runbooks for incident response

### `/.github`

GitHub-specific configurations:

- **Workflows**: CI/CD pipeline definitions
- **Templates**: Issue and PR templates
- **CODEOWNERS**: Code review assignments

### `/backlog`

Task management system:

- Task files in markdown format
- Configuration for task workflow
- Historical task records

### `/tests`

Testing beyond unit tests:

- **E2E**: End-to-end integration tests
- **Load**: Performance testing scripts
- **Smoke**: Quick validation tests

### `/scripts`

Developer productivity scripts:

- Local development environment setup
- Kubernetes debugging helpers
- Resource cleanup utilities

## File Naming Conventions

1. **Lowercase with hyphens**: `my-service-name.yaml`
2. **Environment prefix**: `dev-values.yaml`, `prod-config.yaml`
3. **Descriptive names**: Avoid abbreviations when possible
4. **Consistent extensions**: `.yaml` for YAML, `.md` for Markdown

## Best Practices

### Code Organization

- Keep related code together
- Separate concerns clearly
- Use consistent structure across services

### Configuration Management

- Use Helm for templating
- Environment-specific values in separate files
- Secrets never in plain text

### Documentation

- README.md in each major directory
- Keep docs close to code
- Update docs with code changes

### Version Control

- Feature branches for development
- Protected main branch
- Meaningful commit messages
- Tag releases semantically

### Security

- No secrets in repository
- Use `.gitignore` properly
- Regular dependency updates
- Security scanning in CI

## Repository Evolution

This structure is designed to support:

1. **Scalability**: Easy to add new services
2. **Maintainability**: Clear separation of concerns
3. **Collaboration**: Well-organized for teams
4. **Automation**: CI/CD friendly layout
5. **Flexibility**: Adaptable to changing needs

As the project grows, new directories may be added or existing ones restructured. Any significant changes should be documented and communicated to the team.
