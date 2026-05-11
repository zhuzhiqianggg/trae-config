---
name: ops-kubernetes-devops
description: Production-ready Kubernetes manifest generation — Deployments, StatefulSets, CronJobs, Services, Ingresses, ConfigMaps, Secrets, PVCs with security contexts and health checks. Use when deploying containers to K8s, configuring networking, managing configs, setting up storage, or troubleshooting cluster resources.
tags: [kubernetes, k8s, manifest, deployment, helm, ingress, devops]
---

# Kubernetes DevOps

Production-ready Kubernetes manifest generation with security contexts, health checks, and resource management.

## Workload Selection

| Type | Resource | When |
|------|----------|------|
| Stateless | Deployment | Web servers, APIs, microservices |
| Stateful | StatefulSet | Databases, message queues, caches |
| One-off | Job | Migrations, data imports |
| Scheduled | CronJob | Backups, reports, cleanup |
| Per-node | DaemonSet | Log collectors, monitoring agents |

## Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  namespace: production
  labels:
    app.kubernetes.io/name: my-app
    app.kubernetes.io/version: "1.0.0"
spec:
  replicas: 3
  selector:
    matchLabels:
      app.kubernetes.io/name: my-app
  template:
    metadata:
      labels:
        app.kubernetes.io/name: my-app
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: my-app
          image: registry.example.com/my-app:1.0.0
          ports:
            - containerPort: 8080
              name: http
          resources:
            requests:
              cpu: 250m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 512Mi
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop: [ALL]
          livenessProbe:
            httpGet:
              path: /health
              port: http
            initialDelaySeconds: 30
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /ready
              port: http
            initialDelaySeconds: 5
            periodSeconds: 5
          env:
            - name: LOG_LEVEL
              valueFrom:
                configMapKeyRef:
                  name: my-app-config
                  key: LOG_LEVEL
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: my-app-secret
                  key: DATABASE_PASSWORD
```

## Services

| Type | Scope | Use Case |
|------|-------|----------|
| ClusterIP | Cluster-internal | Inter-service communication |
| NodePort | External via node IP | Dev/testing, on-prem |
| LoadBalancer | External via cloud LB | Production external access |
| ExternalName | DNS alias | Mapping to external services |

## Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/rate-limit: "100"
spec:
  ingressClassName: nginx
  tls:
    - hosts: [app.example.com]
      secretName: app-tls
  rules:
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app
                port:
                  number: 80
```

## ConfigMap & Secret

```yaml
# ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-app-config
data:
  LOG_LEVEL: info
  APP_MODE: production

# Secret (never commit plaintext — use Sealed Secrets / External Secrets / Vault)
apiVersion: v1
kind: Secret
type: Opaque
stringData:
  DATABASE_PASSWORD: "changeme"
```

## Persistent Storage

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-app-data
spec:
  accessModes: [ReadWriteOnce]
  storageClassName: gp3
  resources:
    requests:
      storage: 10Gi
```

## Helm Chart Structure

```
chart/
├── Chart.yaml              # metadata + dependencies
├── values.yaml             # defaults
├── templates/
│   ├── _helpers.tpl        # template functions
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── configmap.yaml
│   ├── hpa.yaml
│   └── tests/
│       └── test-connection.yaml
```

## Security Checklist

| Check | Status |
|-------|--------|
| `runAsNonRoot: true` | Required |
| `allowPrivilegeEscalation: false` | Required |
| `readOnlyRootFilesystem: true` | Recommended |
| `capabilities.drop: [ALL]` | Required |
| `seccompProfile: RuntimeDefault` | Recommended |
| Specific image tags (never `:latest`) | Required |
| Resource requests and limits set | Required |

## Anti-Patterns

| Anti-Pattern | Why | Do Instead |
|-------------|-----|------------|
| `:latest` image tag | Non-reproducible | Pin exact version |
| Skip resource limits | Pods starve the node | Always set requests + limits |
| Run as root | Container escape = full host access | `runAsNonRoot: true` |
| Plaintext Secrets | Credentials in Git forever | Sealed Secrets / Vault |
| Skip health checks | Can't detect unhealthy pods | Liveness + readiness probes |
| Single replica | Zero availability during updates | `replicas: 3` minimum for HA |

## Troubleshooting

| Problem | Diagnosis | Fix |
|---------|-----------|-----|
| Pod stuck Pending | `kubectl describe pod` — check events | Fix resources, PVC binding |
| ImagePullBackOff | Wrong image or missing pull secret | Verify image, add imagePullSecrets |
| CrashLoopBackOff | `kubectl logs --previous` | Check app startup |
| OOMKilled | Memory limit too low | Increase `limits.memory` |
| Service not reachable | `kubectl get endpoints` | Fix selector match |

## Verification

- [ ] `kubectl apply --dry-run=server` passes
- [ ] `kube-score` or `kube-linter` clean
- [ ] All images have pinned versions
- [ ] Security context set at pod + container level
- [ ] Liveness + readiness probes configured
- [ ] Resource requests and limits set on all containers
- [ ] Secrets use External Secrets / Sealed Secrets (not plaintext)
