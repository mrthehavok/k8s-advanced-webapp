# Frontend Helm Chart Design

## Overview

This document outlines the design for the frontend Helm chart that will package the React SPA for deployment on Kubernetes with ALB Ingress, TLS termination, and autoscaling capabilities.

## Chart Structure

```
charts/frontend/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Default values
├── .helmignore            # Files to ignore during packaging
├── templates/
│   ├── _helpers.tpl       # Helper templates
│   ├── deployment.yaml    # Frontend deployment
│   ├── service.yaml       # ClusterIP service
│   ├── ingress.yaml       # ALB Ingress with TLS
│   ├── hpa.yaml           # Horizontal Pod Autoscaler (conditional)
│   ├── configmap.yaml     # Runtime configuration (optional)
│   └── NOTES.txt          # Post-installation notes
├── tests/
│   └── values-lint.yaml   # Test values for linting
├── values-dev.yaml        # Development environment values
├── values-prod.yaml       # Production environment values
└── README.md              # Chart documentation
```

## Key Design Decisions

### 1. Container Configuration

- **Base Image**: nginx:1.25-alpine serving static React build
- **Port**: 80 (nginx default)
- **Health Checks**: Both liveness and readiness probes on `/`

### 2. Resource Management

- **Requests**: 100m CPU, 128Mi Memory
- **Limits**: 300m CPU, 256Mi Memory
- **HPA**: 2-5 replicas, 60% CPU target (conditional)

### 3. Ingress Configuration

- **Type**: AWS ALB via annotations
- **Host**: Configurable (default: team-notes.example.com)

### 4. ConfigMap Strategy

- Optional ConfigMap for runtime environment variables
- Mounted as volume to inject config at startup
- Supports dynamic backend API endpoint configuration

## Values Structure

```yaml
# Image configuration
image:
  repository: frontend
  tag: latest
  pullPolicy: IfNotPresent

# Service configuration
service:
  type: ClusterIP
  port: 80
  targetPort: 80

# Ingress configuration
ingress:
  enabled: true
  className: alb
  annotations: {}
  hosts:
    - host: team-notes.example.com
      paths:
        - path: /
          pathType: Prefix

# HPA configuration
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 5
  targetCPUUtilizationPercentage: 60

# Resource configuration
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 300m
    memory: 256Mi

# Config for runtime environment
config:
  enabled: false
  data:
    {}
    # API_ENDPOINT: https://api.example.com

# Probes
livenessProbe:
  httpGet:
    path: /
    port: http
  initialDelaySeconds: 10
  periodSeconds: 30

readinessProbe:
  httpGet:
    path: /
    port: http
  initialDelaySeconds: 5
  periodSeconds: 10

# Additional configurations
nodeSelector: {}
tolerations: []
affinity: {}
extraEnv: []
```

## Template Patterns

### 1. Conditional HPA

```yaml
{{- if .Values.autoscaling.enabled }}
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
...
{{- end }}
```

### 2. Flexible Annotations

```yaml
annotations: { { - toYaml .Values.ingress.annotations | nindent 4 } }
```

### 3. ConfigMap Volume Mount

```yaml
{{- if .Values.config.enabled }}
volumeMounts:
  - name: config
    mountPath: /usr/share/nginx/html/config
volumes:
  - name: config
    configMap:
      name: {{ include "frontend.fullname" . }}
{{- end }}
```

## CI/CD Integration

### GitHub Actions Workflow Addition

```yaml
- name: Lint frontend Helm chart
  run: |
    helm lint charts/frontend
    helm lint charts/frontend -f charts/frontend/values-dev.yaml
    helm lint charts/frontend -f charts/frontend/values-prod.yaml
```

## Security Considerations

2. **Network Policies**: Consider adding NetworkPolicy templates
3. **Pod Security Standards**: Run as non-root nginx user
4. **Image Scanning**: Integrate with CI/CD pipeline

## Testing Strategy

1. **Helm Lint**: Validate chart syntax and structure
2. **Template Rendering**: Test with different values files
3. **Dry Run**: `helm install --dry-run` validation
4. **Integration**: Deploy to test cluster before production

## Migration Notes

- Ensure backend URL is configurable via ConfigMap or environment variable
- Consider CORS settings for backend API calls
- Plan for zero-downtime deployments with proper readiness checks
