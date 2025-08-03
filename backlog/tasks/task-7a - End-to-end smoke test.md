id: task-7a
title: "End-to-end smoke test"
status: "To Do"
created: 2025-08-03
updated: 2025-08-03

## Description

After Helm charts for the backend (task-6) and frontend (task-7) are packaged, deploy them to the dev EKS Fargate cluster and verify that the complete application works.

## Acceptance Criteria

- [ ] Backend and frontend charts installed via `helm upgrade --install` (dev namespace)
- [ ] Pods reach **Ready** state; services obtain ClusterIP
- [ ] Ingress resolves with valid TLS cert (CLUSTER_ISSUER from previous tasks)
- [ ] `curl https://<domain>/api/health` returns `{"status":"ok"}`
- [ ] Frontend URL shows notes list and CRUD operations work end-to-end
- [ ] CI job outputs deployment logs and marks pipeline green on success

## Session History

<!-- Update as work progresses -->

## Decisions Made

<!-- Document key implementation decisions -->

## Files Modified

<!-- Track all file changes -->

## Blockers

<!-- Document any blockers encountered -->

## Next Steps

<!-- Maintain continuity between sessions -->
