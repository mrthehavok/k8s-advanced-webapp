id: task-8
title: "Monitoring: kube-prometheus-stack & custom dashboards"
status: "To Do"
created: 2025-08-01
updated: 2025-08-01

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

## Decisions Made

## Files Modified

## Blockers

## Next Steps

- Install stack via Argo CD
- Import dashboards
