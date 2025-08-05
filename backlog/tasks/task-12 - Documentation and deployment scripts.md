id: task-12
title: "Documentation: AWS deployment scripts & README with architecture diagrams"
status: "To Do"
created: 2025-08-01
updated: 2025-08-01

## Description

Produce comprehensive documentation and helper scripts covering:

- `README.md` at repo root with project overview, prerequisites, and quick-start
- Step-by-step guide to bootstrap Terraform, Argo CD, and GitOps flow
- Mermaid architecture and workflow diagrams (avoid quotes/parentheses in brackets)
- `scripts/` folder with helper shell scripts:
  - `deploy.sh` – one-shot bootstrap for fresh AWS account
  - `destroy.sh` – tear-down with safety prompts
  - `port-forward-grafana.sh` – local port forward for monitoring
- Troubleshooting section (common EKS, Argo CD issues)

## Acceptance Criteria

- [ ] `README.md` includes architecture diagram and setup instructions
- [ ] All helper scripts executable and shell-checked
- [ ] Diagrams render correctly in GitHub Markdown preview
- [ ] Documentation reviewed and approved by a newcomer tester

## Session History

## Decisions Made

## Files Modified

## Blockers

## Next Steps

- Draft README skeleton
- Create diagrams under `docs/img/`
- Author helper scripts
