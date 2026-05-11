---
name: ops-devops-automation-pack
description: Complete DevOps automation toolkit for Docker, Kubernetes, CI/CD, monitoring, and backup. Use when setting up deployment pipelines, automating infrastructure, configuring CI/CD workflows, or establishing backup strategies.
tags: [devops, automation, ci-cd, docker, kubernetes, deployment]
---

# DevOps Automation Pack

Complete DevOps automation toolkit for modern deployments.

## Docker Automation

### Multi-Stage Build Optimization
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

### Docker Compose Templates

```yaml
# Node.js + PostgreSQL
services:
  app:
    build: .
    ports: ["3000:3000"]
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      db:
        condition: service_healthy
  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
volumes:
  pgdata:
```

## Kubernetes Deployment

### Helm Chart Structure
```
chart/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── hpa.yaml
```

### Auto-Scaling
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  maxReplicas: 20
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

## CI/CD Pipelines

### GitHub Actions
```yaml
name: CI/CD
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t app:${{ github.sha }} .
      - run: docker push ghcr.io/org/app:${{ github.sha }}
      - run: kubectl set image deployment/app app=ghcr.io/org/app:${{ github.sha }}
```

### GitLab CI
```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
```

## Backup & Recovery

### Database Backups
```bash
# PostgreSQL
pg_dump -Fc mydb > /backups/mydb-$(date +%Y%m%d).dump

# MySQL
mysqldump mydb > /backups/mydb-$(date +%Y%m%d).sql

# Rotate backups — keep 30 days
find /backups -name "*.dump" -mtime +30 -delete
```

### Kubernetes Volume Snapshots
```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: myapp-snapshot-20240101
spec:
  volumeSnapshotClassName: csi-aws-vsc
  source:
    persistentVolumeClaimName: myapp-data
```

## Verification

- [ ] Docker builds are reproducible (pinned base image versions)
- [ ] CI/CD runs lint → test → build → deploy stages
- [ ] Kubernetes manifests have resource limits + health checks
- [ ] Backups automated and tested monthly
- [ ] Monitoring alerts configured for deployment failures
- [ ] Rollback procedure documented and tested
