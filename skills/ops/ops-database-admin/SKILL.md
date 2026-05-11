---
name: ops-database-admin
description: Database administration: setup, backup, monitoring, user management, migration
tags: [database, admin, postgresql, mysql, dba]
---

# Database Administration

Database administration patterns for PostgreSQL, MySQL, and common SQL databases.

## General Admin Tasks

### User & Permission Management

```sql
-- PostgreSQL
CREATE USER app_user WITH PASSWORD 'secure_pass';
GRANT CONNECT ON DATABASE mydb TO app_user;
GRANT USAGE ON SCHEMA public TO app_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO app_user;

-- MySQL
CREATE USER 'app_user'@'%' IDENTIFIED BY 'secure_pass';
GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'app_user'@'%';
```

### Backup & Restore

```bash
# PostgreSQL
pg_dump -Fc -h localhost -U admin mydb > mydb.dump       # custom format
pg_dump -Fp -h localhost -U admin mydb > mydb.sql         # plain SQL
pg_restore -d mydb mydb.dump

# MySQL
mysqldump -h localhost -u root -p mydb > mydb.sql
mysql -h localhost -u root -p mydb < mydb.sql
```

### Monitoring Queries

```sql
-- Long running queries (PostgreSQL)
SELECT pid, now() - pg_stat_activity.query_start AS duration,
       query, state
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY duration DESC;

-- Connection count
SELECT state, count(*) FROM pg_stat_activity GROUP BY state;

-- Table size
SELECT relname, pg_size_pretty(pg_total_relation_size(relid))
FROM pg_catalog.pg_statio_user_tables;
```

### Logging

```bash
# PostgreSQL logs
tail -f /var/log/postgresql/postgresql-*.log

# Slow query log (PostgreSQL)
# Edit postgresql.conf:
# log_min_duration_statement = 1000  # ms
```

## Maintenance

```sql
-- PostgreSQL: VACUUM & ANALYZE
VACUUM (VERBOSE, ANALYZE) my_table;
REINDEX TABLE my_table;
ANALYZE;

-- MySQL: Table optimization
OPTIMIZE TABLE my_table;
```

## Docker Quick Start

```bash
# PostgreSQL
docker run -d --name pg \
  -e POSTGRES_PASSWORD=secret \
  -e POSTGRES_DB=mydb \
  -p 5432:5432 \
  postgres:16

# MySQL
docker run -d --name mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=mydb \
  -p 3306:3306 \
  mysql:8
```

## Red Flags

- Backups not tested regularly (restore once a month)
- No connection pooling for high-traffic apps
- Grants on `*.*` or `ALL` without need
- No monitoring on long-running queries
- Tables without proper indexes on foreign keys
