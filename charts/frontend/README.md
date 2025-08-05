# Frontend Helm Chart

This chart deploys the React frontend SPA.

## Values

| Key                                          | Type   | Default                                                                              | Description                                              |
| -------------------------------------------- | ------ | ------------------------------------------------------------------------------------ | -------------------------------------------------------- |
| `affinity`                                   | object | `{}`                                                                                 | Affinity for pod assignment                              |
| `autoscaling.enabled`                        | bool   | `true`                                                                               | Enable Horizontal Pod Autoscaler                         |
| `autoscaling.maxReplicas`                    | int    | `5`                                                                                  | Maximum number of replicas                               |
| `autoscaling.minReplicas`                    | int    | `2`                                                                                  | Minimum number of replicas                               |
| `autoscaling.targetCPUUtilizationPercentage` | int    | `60`                                                                                 | Target CPU utilization for scaling                       |
| `config.data`                                | object | `{}`                                                                                 | Data for the ConfigMap                                   |
| `config.enabled`                             | bool   | `false`                                                                              | Enable a ConfigMap for runtime environment variables     |
| `extraEnv`                                   | list   | `[]`                                                                                 | Extra environment variables to inject into the container |
| `image.pullPolicy`                           | string | `"IfNotPresent"`                                                                     | Image pull policy                                        |
| `image.repository`                           | string | `"frontend"`                                                                         | Image repository                                         |
| `image.tag`                                  | string | `"latest"`                                                                           | Image tag                                                |
| `ingress.annotations`                        | object | `{}`                                                                                 | Ingress annotations                                      |
| `ingress.className`                          | string | `"alb"`                                                                              | Ingress class name                                       |
| `ingress.enabled`                            | bool   | `true`                                                                               | Enable Ingress                                           |
| `ingress.hosts`                              | list   | `[{"host":"team-notes.example.com","paths":[{"path":"/","pathType":"Prefix"}]}]`     | Ingress host configuration                               |
| `ingress.tls`                                | list   | `[{"hosts":["team-notes.example.com"],"secretName":"frontend-tls"}]`                 | Ingress TLS configuration                                |
| `livenessProbe`                              | object | `{"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":10,"periodSeconds":30}` | Liveness probe configuration                             |
| `nodeSelector`                               | object | `{}`                                                                                 | Node labels for pod assignment                           |
| `readinessProbe`                             | object | `{"httpGet":{"path":"/","port":"http"},"initialDelaySeconds":5,"periodSeconds":10}`  | Readiness probe configuration                            |
| `replicaCount`                               | int    | `1`                                                                                  | Number of replicas if HPA is disabled                    |
| `resources.limits.cpu`                       | string | `"300m"`                                                                             | CPU limit                                                |
| `resources.limits.memory`                    | string | `"256Mi"`                                                                            | Memory limit                                             |
| `resources.requests.cpu`                     | string | `"100m"`                                                                             | CPU request                                              |
| `resources.requests.memory`                  | string | `"128Mi"`                                                                            | Memory request                                           |
| `service.port`                               | int    | `80`                                                                                 | Service port                                             |
| `service.targetPort`                         | int    | `80`                                                                                 | Service target port                                      |
| `service.type`                               | string | `"ClusterIP"`                                                                        | Service type                                             |
| `serviceAccount.create`                      | bool   | `true`                                                                               | Create a service account                                 |
| `serviceAccount.name`                        | string | `""`                                                                                 | Name of the service account to use                       |
| `tolerations`                                | list   | `[]`                                                                                 | Tolerations for pod assignment                           |
