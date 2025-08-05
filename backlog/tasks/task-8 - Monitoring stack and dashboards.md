id: task-8
title: "Monitoring: kube-prometheus-stack & custom dashboards"
status: "In Progress"
created: 2025-08-01
updated: 2025-08-05

## Description

Install and configure observability stack:

- Deploy kube-prometheus-stack via Helm into `monitoring` namespace
- Configure Prometheus scrape for frontend and backend pods via ServiceMonitors
- Create Grafana dashboard JSON for:
  - Pod CPU & memory usage
  - HTTP request count / rate (frontend & backend)
  - Pod restarts
- Add PrometheusRules:
  - High CPU usage > 80 % for 5 m
  - ≥3 restarts within 10 m
- Expose Grafana via ALB Ingress with TLS

## Acceptance Criteria

- [ ] Helm release manifests in `infra/helm/kube-prometheus-stack`
- [ ] ServiceMonitor YAMLs for backend & frontend
- [ ] Dashboard JSON checked into `monitoring/dashboards/`
- [ ] PrometheusRule YAMLs with listed alerts
- [ ] Grafana accessible via HTTPS

## Session History

- 2025-08-05T15:49:52Z: Branch feat/task-8-monitoring-stack created.
- 2025-08-05T15:49:52Z: Initial scaffold (monitoring.yaml, values.yaml, placeholders) committed.

## Decisions Made

- Use kube-prometheus-stack via Argo CD; sandbox values stub committed.

## Files Modified

- gitops/apps/monitoring.yaml (created)
- monitoring/kube-prometheus-stack/values.yaml (created)
- monitoring/service-monitors/\*.yaml (placeholders)
- monitoring/alerts/app-alerts.yaml
- monitoring/dashboards/README.md

## Blockers

## Next Steps

- Fill values.yaml with real config
- Implement ServiceMonitors/dashboards/alerts
- Add Grafana ingress
- Deploy & verify in Argo CD
