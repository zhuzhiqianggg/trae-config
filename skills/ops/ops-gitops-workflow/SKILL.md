---
name: ops-gitops-workflow
description: GitOps workflow with ArgoCD/Flux: declarative infrastructure, sync strategies, PR-driven operations
tags: [gitops, argocd, flux, kubernetes, declarative]
---

# GitOps Workflow

GitOps patterns using ArgoCD and Flux for declarative Kubernetes operations.

## Principles

1. **Declarative**: entire system described in Git
2. **Versioned**: every change is a commit
3. **Automated**: operator syncs desired state to cluster
4. **Auditable**: full history of all changes

## Repository Structure

```
infra/
├── base/                        # shared base configs
│   ├── kustomization.yaml
│   ├── deployment.yaml
│   └── service.yaml
├── overlays/
│   ├── staging/
│   │   ├── kustomization.yaml
│   │   └── patch.yaml
│   └── production/
│       ├── kustomization.yaml
│       ├── patch.yaml
│       └── sealed-secrets.yaml
└── apps/
    ├── myapp/
    │   └── application.yaml     # ArgoCD Application CR
    └── monitoring/
        └── application.yaml
```

## ArgoCD Configuration

```yaml
# application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
spec:
  destination:
    namespace: myapp
    server: https://kubernetes.default.svc
  project: default
  source:
    repoURL: https://github.com/org/infra.git
    path: overlays/production
    targetRevision: main
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - PruneLast=true
```

## PR-Driven Operations

### Standard Workflow

```
1. Fork/clone the Git repo
2. Make changes (update image tag, config, etc.)
3. Create PR with changes
4. CI validates (kubeconform, kustomize build, dry-run)
5. Review and merge
6. ArgoCD/Flux detects drift → syncs cluster
7. Verify sync status
```

### Hotfix

```
1. Create branch from current production tag
2. Apply fix
3. PR with expedited review
4. Merge → ArgoCD syncs
5. Cherry-pick back to main
```

## Sync Strategies

| Strategy | When to Use | Risk |
|----------|------------|------|
| Auto-sync + prune | Standard deployments | Fast, but auto-deletes removed resources |
| Manual sync | Breaking changes | Controlled rollout, requires manual approve |
| Automated with prune last | Critical infra | Safe — prunes only after successful deploy |
| Disabled auto-sync | Secrets, CRDs | Max control, no auto updates |

## Sealed Secrets

```bash
# Encrypt secret for Git
kubeseal --format=yaml < secret.yaml > sealed-secret.yaml

# Only the Sealed Secrets controller can decrypt it
```

## Rollback

```bash
# ArgoCD
argocd app rollback myapp <commit-sha>

# Or revert the Git commit — ArgoCD auto-syncs
git revert HEAD
git push origin main
```

## Verification

- [ ] `kustomize build` or `helm template` validates clean
- [ ] Diff checked before sync (`argocd app diff`)
- [ ] Secrets are sealed (not plaintext in repo)
- [ ] Sync policy matches deployment risk
- [ ] Rollback tested in staging
- [ ] Health checks pass after sync
