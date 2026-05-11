---
name: ops-database-optimizer
description: Database performance optimization: indexing, query tuning, schema design, connection pooling
tags: [database, performance, optimization, postgresql, mysql, sql]
---

# Database Optimizer

Systematic approach to database performance optimization.

## Process

```
Identify slow query → EXPLAIN → Index/rewrite → Test → Repeat
```

## Query Analysis

```sql
-- PostgreSQL: EXPLAIN plans
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) SELECT * FROM orders WHERE user_id = 42;
EXPLAIN (ANALYZE, TIMING) SELECT ...

-- Key signals:
--   Seq Scan on large tables (missing index)
--   Nested Loop with many rows
--   Sort/Materialize on large datasets
--   "Rows Removed by Filter" high vs actual rows

-- MySQL:
EXPLAIN FORMAT=JSON SELECT * FROM orders WHERE user_id = 42;
```

## Indexing Strategy

```sql
-- B-tree: default, equality + range queries
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Composite: column order matters (equality first, then range)
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at);

-- Partial: for filtered queries
CREATE INDEX idx_orders_active ON orders(user_id) WHERE status = 'active';

-- Covering: include extra columns to avoid table access
CREATE INDEX idx_orders_user_covering ON orders(user_id) INCLUDE (total, status);

-- BRIN: for large append-only tables (much smaller index)
CREATE INDEX idx_logs_created ON logs USING BRIN(created_at);

-- GIN: for JSONB / full-text search
CREATE INDEX idx_users_prefs ON users USING GIN(preferences);
```

### Index Rules

- Index WHERE and JOIN columns first
- Composite index: most selective column first
- Avoid over-indexing on write-heavy tables
- Drop unused indexes (check `pg_stat_user_indexes`)
- Monitor index size vs table size

## Query Rewriting

```sql
-- BAD: Function on indexed column
SELECT * FROM orders WHERE EXTRACT(YEAR FROM created_at) = 2024;
-- GOOD: Range query
SELECT * FROM orders WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';

-- BAD: Implicit type conversion
SELECT * FROM users WHERE phone = 13800138000;
-- GOOD: Match column type
SELECT * FROM users WHERE phone = '13800138000';

-- BAD: SELECT * with JOINs
SELECT * FROM orders JOIN users ON orders.user_id = users.id;
-- GOOD: Only needed columns
SELECT orders.id, orders.total, users.name FROM orders ...
```

## Configuration Tuning

```ini
# postgresql.conf — start with https://pgtune.leopard.in.ua
shared_buffers = '4GB'              # 25% of RAM
effective_cache_size = '12GB'       # 75% of RAM
work_mem = '64MB'                   # per-operation sort memory
maintenance_work_mem = '1GB'        # VACUUM, CREATE INDEX
random_page_cost = 1.1              # SSD: 1.1, HDD: 4.0
```

## Connection Pooling

```bash
# PgBouncer config example
[databases]
mydb = host=127.0.0.1 port=5432 dbname=mydb

[pgbouncer]
pool_mode = transaction          # or session/statement
max_client_conn = 200
default_pool_size = 20           # match CPU cores * 2-4
```

## Common Problems

| Issue | Likely Cause | Fix |
|-------|-------------|-----|
| Slow SELECT by primary key | Connection pool exhaustion | Increase pool size |
| Slow COUNT(*) on large table | Sequential scan | Use approximate count or index-only scan |
| Sudden query slowdown | Stale statistics | `ANALYZE` |
| High CPU on standby | Query cancellation | Tune `max_standby_streaming_delay` |
| Bloat on UPDATE-heavy table | Autovacuum not keeping up | Tune autovacuum settings |

## Verification

- [ ] `EXPLAIN (ANALYZE)` shows index scans for critical queries
- [ ] No sequential scans on tables > 100K rows in hot paths
- [ ] Connection pool hit ratio > 99%
- [ ] Query time within SLA (p95 < 100ms for OLTP)
- [ ] `pg_stat_activity` shows no long-running queries stuck
