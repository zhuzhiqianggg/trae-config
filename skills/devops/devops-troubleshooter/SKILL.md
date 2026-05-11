---
name: devops-troubleshooter
description: DevOps troubleshooting: CI/CD failures, infrastructure issues, deployment problems
tags: [devops, troubleshooting, ci-cd, infrastructure, debugging]
---

# DevOps Troubleshooter

Systematic approach to diagnosing DevOps pipeline and infrastructure failures.

## CI/CD Pipeline Issues

### Pipeline Fails

```bash
# 1. Check logs
# GitHub Actions: navigate to Actions tab → failed run → step logs
# GitLab CI: pipeline → job → logs

# 2. Check for common issues
# - Cache corruption: clear cache and retry
# - Vercel/Netlify: check build limits
# - Docker build: check layer cache, free disk space
# - Test flakiness: rerun failed tests

# 3. Debug locally
docker compose up -d          # replicate environment
act -j job-name               # run GitHub Actions locally
```

### Build Failures

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| "Out of memory" during build | Node/Build memory limit | Set `NODE_OPTIONS="--max-old-space-size=4096"` |
| "Disk quota exceeded" | Docker layer cache too large | `docker builder prune` or set up cleanup |
| "Connection refused" | Service dependency not ready | Add `wait-for-it` or health check |
| Test timeout | Test relies on external service | Mock the service or increase timeout |

### Infrastructure Problems

```bash
# Docker issues
docker ps -a                     # all containers
docker logs <container> --tail 100
docker stats                     # live resource usage
docker system df                 # disk usage
docker system prune -f           # cleanup

# Kubernetes debugging
kubectl get pods -o wide
kubectl describe pod <pod>
kubectl logs -f <pod>
kubectl exec -it <pod> -- sh
kubectl get events --sort-by='.lastTimestamp'

# Port issues
ss -tlnp                         # listening ports
lsof -i :8080                    # what's on port 8080
```

### Deployment Failures

```bash
# Application crash loop
kubectl logs --previous <pod>    # last crash logs
journalctl -u myapp -n 100       # systemd service logs

# Database migration issues
kubectl exec <pod> -- rails db:status
kubectl exec <pod> -- rails db:migrate:status
```

## Networking Issues

```bash
# DNS resolution
dig +short service.consul
nslookup api.example.com

# Connectivity
curl -v http://service:8080/health
nc -zv service 8080

# TLS/SSL
openssl s_client -connect host:443 -servername host
```

## Red Flags

| Claim | Reality |
|-------|---------|
| "It works on my machine" | Environment mismatch. Use containers. |
| "Just merge, CI passes" | CI ≠ production. Check staging first. |
| "We'll fix it in the next deployment" | Rollback or hotfix instead. |
| "I didn't change anything" | Check git diff — something changed. |
| "The config was wrong all along" | Was it? Check when it changed. |
