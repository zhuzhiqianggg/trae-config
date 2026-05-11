---
name: ops-github-actions-templates
description: GitHub Actions workflow templates for CI/CD, testing, deployment with best practices
tags: [github-actions, ci-cd, automation, devops]
---

# GitHub Actions Templates

Reusable CI/CD workflow patterns for GitHub Actions.

## Basic Structure

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm test
```

## Common Workflows

### Node.js / TypeScript

```yaml
name: Node.js CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18, 20]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck
      - run: npm test -- --coverage
      - uses: codecov/codecov-action@v3
```

### Docker Build & Push

```yaml
jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: ${{ github.ref == 'refs/heads/main' }}
          tags: ghcr.io/${{ github.repository }}:latest
```

### Deploy to Vercel

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'
```

### Deployment to Kubernetes

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: azure/k8s-set-context@v3
        with:
          kubeconfig: ${{ secrets.KUBE_CONFIG }}
      - run: kubectl set image deployment/my-app app=ghcr.io/myorg/app:${{ github.sha }}
```

## Caching

```yaml
- uses: actions/cache@v3
  with:
    path: ~/.npm
    key: npm-${{ hashFiles('package-lock.json') }}
    restore-keys: npm-
```

## Conditional Steps

```yaml
- run: echo "Deploying to production"
  if: github.ref == 'refs/heads/main'

- run: echo "Deploying to staging"
  if: github.ref == 'refs/heads/develop'

- run: echo "Skipping deploy"
  if: github.event_name == 'pull_request'
```

## Matrix Builds

```yaml
strategy:
  matrix:
    os: [ubuntu-latest, macos-latest]
    node: [18, 20]
    include:
      - os: ubuntu-latest
        node: 20
        coverage: true
```

## Secrets & Environments

```yaml
jobs:
  deploy:
    environment: production
    steps:
      - run: deploy.sh
        env:
          API_KEY: ${{ secrets.API_KEY }}
```

## Verification

- [ ] Secrets not logged or leaked in output
- [ ] Cache keys properly hash the correct lock file
- [ ] Matrix builds have appropriate `fail-fast` settings
- [ ] Concurrency groups set for cancel-in-progress
- [ ] Timeout defined: `timeout-minutes: 10`
- [ ] OIDC used instead of long-lived secrets where possible
