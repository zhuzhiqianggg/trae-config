---
name: ops-postgres-best-practices
description: PostgreSQL best practices: schema design, indexing, migration, configuration, backup
tags: [postgresql, database, sql, dba, backend]
---

# PostgreSQL Best Practices

Production PostgreSQL configuration and usage patterns.

## Connection Management

```ini
# postgresql.conf
max_connections = 100               # depends on RAM, 100-500 typical
shared_buffers = '4GB'              # 25% of RAM
work_mem = '64MB'                   # per-operation sort memory
maintenance_work_mem = '1GB'        # for VACUUM, indexes
effective_cache_size = '12GB'       # 75% of RAM
wal_buffers = '16MB'
random_page_cost = 1.1              # 1.1 for SSD, 4.0 for HDD
effective_io_concurrency = 200      # SSD can handle high concurrency
```

## Schema Design

```sql
-- Use UUIDs for distributed systems
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Prefer TIMESTAMPTZ over TIMESTAMP
-- Use TEXT instead of VARCHAR(n) unless you need length enforcement
-- Use NUMERIC for money, not FLOAT

-- Index foreign keys
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Partial indexes for common filters
CREATE INDEX idx_orders_active ON orders(status) WHERE status = 'pending';

-- Covering indexes
CREATE INDEX idx_users_email_covering ON users(email) INCLUDE (name, avatar_url);
```

## Migrations

```sql
-- Principles:
-- 1. Always backward-compatible
-- 2. Add columns as NULLABLE or with DEFAULT
-- 3. Never remove a column in the same deploy that stops using it

-- SAFE: add nullable column
ALTER TABLE users ADD COLUMN phone TEXT;

-- SAFE: add column with default
ALTER TABLE orders ADD COLUMN currency TEXT NOT NULL DEFAULT 'USD';

-- RISKY: rename column (needs two-phase deploy)
-- Phase 1: add new column, dual-write
-- Phase 2: backfill, switch reads
-- Phase 3: drop old column

-- DANGEROUS: add NOT NULL without default on large table
-- ALTER TABLE users ALTER COLUMN phone SET NOT NULL; -- locks table!
```

## Backup & Recovery

```bash
# pg_dump (logical backup)
pg_dump -Fc -h localhost -U admin mydb > /backups/mydb-$(date +%Y%m%d).dump

# pg_dumpall (cluster-wide)
pg_dumpall -h localhost -U postgres > /backups/full-$(date +%Y%m%d).sql

# Restore
pg_restore -d mydb --jobs=4 /backups/mydb-20240101.dump

# Point-in-Time Recovery (PITR)
# Requires continuous WAL archiving:
archive_mode = on
archive_command = 'cp %p /wal/%f'
```

## Performance Monitoring

```sql
-- Slow queries
SELECT query, calls, total_exec_time / calls AS avg_time,
       rows, shared_blks_hit, shared_blks_read
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 20;

-- Table bloat
SELECT schemaname, tablename,
       pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename))
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema');

-- Unused indexes
SELECT schemaname, tablename, indexname, idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0;
```

## Common Pitfalls

| Issue | Fix |
|-------|-----|
| No connection pooling | Add PgBouncer or application-level pool |
| Missing `EXPLAIN (ANALYZE, BUFFERS)` | Always analyze before optimizing |
| Sequential scans on large tables | Add appropriate indexes |
| Autovacuum not keeping up | Tune autovacuum settings |
| NOT NULL added on live table | Use CHECK (column IS NOT NULL) NO INHERIT first |
| SELECT * in production | Always specify columns |
| No PITR capability | Enable WAL archiving |

## Verification

- [ ] `pg_stat_activity` shows no idle-in-transaction queries
- [ ] `pg_stat_statements` top queries are index-backed
- [ ] Autovacuum running regularly (`pg_stat_user_tables`)
- [ ] Backups tested within the last month
- [ ] `shared_buffers` ≤ 25% of system RAM
- [ ] WAL archiving enabled for production
