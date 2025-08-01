id: task-11
title: "Cost-control defaults: Fargate profiles, resources, guidelines"
status: "To Do"
created: 2025-08-01
updated: 2025-08-01

## Description

Define and document cost-efficient settings across the stack:

- Fargate profile selectors to schedule only required namespaces
- Spot Fargate (if supported) or Savings Plan guidance
- Default resource requests/limits for all workloads
- Idle load balancer timeout and scale-to-zero discussion
- Grafana cost dashboard link & AWS Cost Explorer pointers
- README section summarising monthly cost estimates

## Acceptance Criteria

- [ ] `docs/cost-control.md` explaining all measures
- [ ] Default resources in Helm charts match guidelines
- [ ] Terraform variables expose cost toggles (e.g., spot enabled)
- [ ] Review by stakeholder confirms clarity & practicality

## Session History

## Decisions Made

## Files Modified

## Blockers

## Next Steps

- Draft cost-control doc
- Align chart values & Terraform vars
