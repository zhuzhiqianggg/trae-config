---
name: ops-monitoring
description: Set up observability for applications and infrastructure with metrics, logs, traces, and alerts. Use when deploying monitoring stacks, configuring Prometheus/Grafana, setting up log aggregation, creating alert rules, or debugging production issues.
tags: [monitoring, observability, prometheus, grafana, loki, alerting, sre]
---

# Monitoring

Complete observability setup guide — metrics, logs, traces, and alerts.

## Complexity Levels

| Level | Tools | Setup Time | Best For |
|-------|-------|------------|----------|
| Minimal | UptimeRobot, Healthchecks.io | 15 min | Side projects, MVPs |
| Standard | Uptime Kuma, Sentry, basic Grafana | 1-2 hours | Small teams, startups |
| Professional | Prometheus, Grafana, Loki, Alertmanager | 1-2 days | Production systems |
| Enterprise | Datadog, New Relic, or full OSS stack | Ongoing | Large-scale operations |

## The Three Pillars

| Pillar | Question | Tools |
|--------|----------|-------|
| Metrics | "How is the system performing?" | Prometheus, Grafana, Datadog |
| Logs | "What happened?" | Loki, ELK, CloudWatch |
| Traces | "Why is this request slow?" | Jaeger, Tempo, Sentry |

## What to Monitor

### Applications (RED Method)
- **Rate** — requests per second
- **Errors** — error rate by endpoint
- **Duration** — latency (p50, p95, p99)

### Infrastructure (USE Method)
- **Utilization** — CPU, memory, disk usage
- **Saturation** — queue depth, load average
- **Errors** — hardware/system errors

## Prometheus Configuration

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['localhost:9100']

  - job_name: 'app'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: "true"
```

### Recording Rules
```yaml
groups:
  - name: app_rates
    rules:
      - record: job:http_requests_total:rate5m
        expr: sum(rate(http_requests_total[5m])) by (job)
      - record: job:error_ratio:rate5m
        expr: sum(rate(http_requests_total{status=~"5.."}[5m])) by (job) / sum(rate(http_requests_total[5m])) by (job)
```

### Alerting Rules
```yaml
groups:
  - name: app_alerts
    rules:
      - alert: HighErrorRate
        expr: |
          sum(rate(http_requests_total{status=~"5.."}[5m]))
          / sum(rate(http_requests_total[5m])) > 0.05
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Error rate > 5% on {{ $labels.job }}"

      - alert: HighLatency
        expr: |
          histogram_quantile(0.99,
            sum(rate(http_request_duration_seconds_bucket[5m])) by (le, job)
          ) > 1.0
        for: 10m
```

## Grafana Dashboards

- **One dashboard per service** — not one for everything
- **RED metrics row** at top: rate, errors, duration
- **USE metrics row**: CPU, memory, disk, network
- **Logs panel** for correlation

### Dashboard Variables
```
name: service
type: query
query: label_values(up, service)
multi: true
includeAll: true
```

## Log Aggregation

### Loki (simple)
```
docker run -d --name=loki -p 3100:3100 grafana/loki
```

### ELK (complex queries)
- Filebeat / Fluentd for shipping
- Elasticsearch for storage
- Kibana for visualization

### Structured Logging
```json
// GOOD — searchable
{"level":"error","service":"checkout","trace_id":"abc123","duration_ms":2500,"error":"timeout"}
```

## Alerting Principles

| Do | Don't |
|----|-------|
| Alert on symptoms (user impact) | Alert on causes (CPU high) |
| Include runbook link | Require investigation to understand |
| Set appropriate severity | Make everything P1 |
| Require action | Alert on "interesting" metrics |

Alert fatigue kills monitoring. If alerts are ignored, you have no monitoring.

## Cost Comparison

| Solution | Monthly (small) | Monthly (medium) |
|----------|----------------|------------------|
| UptimeRobot | Free | $7 |
| Uptime Kuma | $5 (VPS) | $5 (VPS) |
| Sentry | Free / $26 | $80 |
| Grafana Cloud | Free tier | $50+ |
| Datadog | $15/host | $23/host + features |
| Self-hosted stack | $10-20 (VPS) | $50-100 (VPS) |

## Common Mistakes

- Starting with Prometheus/Grafana when Uptime Kuma would suffice
- No alerting (dashboards nobody watches)
- Too many alerts (alert fatigue → ignored)
- Missing runbooks (alert fires, nobody knows what to do)
- Not monitoring from outside (only internal checks)
- Storing logs forever (cost explodes)

## Verification

- [ ] All services emit RED metrics (rate, errors, duration)
- [ ] Logging is structured JSON with trace_id
- [ ] p99 latency tracked per endpoint
- [ ] Alerts have runbooks linked
- [ ] SLO dashboards exist for each service
- [ ] On-call has access to metrics + logs + traces in one place
- [ ] Alert volume < 5 per day per team (no alert fatigue)
