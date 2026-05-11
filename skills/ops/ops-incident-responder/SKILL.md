---
name: ops-incident-responder
description: Incident response: severity levels, runbooks, communication, post-mortem patterns
tags: [incident, response, on-call, sre, reliability]
---

# Incident Responder

Systematic incident response process for production outages.

## Incident Severity Levels

| Level | Definition | Response Time | Example |
|-------|-----------|---------------|---------|
| SEV1 | Service down or data loss | < 15 min | All users can't access app |
| SEV2 | Major feature degraded | < 1 hour | Payment processing failing |
| SEV3 | Minor issue, no user impact | < 1 business day | Non-critical UI bug |
| SEV4 | Cosmetic / informational | Next sprint | Typo in docs |

## Response Flow

```
Detect → Triage → Mitigate → Resolve → Post-mortem
```

### 1. Detect
- Monitoring alert fires
- User reports issue
- Automated health check fails

### 2. Triage (5 min)

```bash
# Check status
kubectl get pods -o wide | grep -i crash
kubectl top pods
kubectl logs --tail=50 -l app=myapp

# Check metrics
# - Error rate spike?
# - Latency increase?
# - Resource exhaustion?

# Check recent changes
git log --oneline -10
kubectl rollout history deployment/myapp
```

### 3. Mitigate (stop the bleeding)
- **Rollback** if a recent deployment caused it: `kubectl rollout undo`
- **Scale up** if traffic-related: `kubectl scale deployment --replicas=10`
- **Restart** if unknown: `kubectl rollout restart`
- **Feature flag off** if the feature is toggled

### 4. Resolve
- Apply permanent fix
- Verify monitoring shows recovery
- Confirm with stakeholders

### 5. Post-mortem

```
Summary: 1-2 sentence description of the incident
Timeline:
  - 14:02 Alert fired: error rate > 5%
  - 14:05 Engineer paged, acknowledged
  - 14:10 Root cause identified: config change in PR #1234
  - 14:12 Rollback initiated
  - 14:15 Error rate returned to baseline
  - 14:20 Incident resolved

Root Cause: [technical explanation]
Impact: [users affected, duration, data loss if any]
Action Items:
  - [ ] Add test coverage for the config edge case
  - [ ] Improve monitoring to catch this faster
  - [ ] Document fix in runbook
```

## Communication Template

```
[INCIDENT] SEV{1|2}: {Service} - {brief description}
Status: Investigating / Mitigating / Resolved
Impact: {what's affected and how many users}
Started: {time}
Current: {what we know and what we're doing}
Next update: {time}
```

## Runbook Structure

```
# Service: MyApp — High Error Rate

## Symptoms
- Alert: error_rate > 5% for 5 minutes
- Users report 500 errors on /api/checkout

## Checks
1. kubectl get pods -o wide | grep myapp
2. kubectl logs -l app=myapp —tail=100 | grep ERROR
3. kubectl rollout history deployment/myapp

## Actions
1. Rollback: kubectl rollout undo deployment/myapp
2. Scale: kubectl scale deployment/myapp --replicas=5

## Escalation
- Primary: @alice
- Secondary: @bob
```

## On-Call Best Practices

- Always acknowledge the alert first
- Don't debug alone — ask for backup after 15 min for SEV1
- Communicate in the incident channel every 15-30 min
- Record timeline as you go (not after)
- Get sleep/food during long incidents — rotate if needed
