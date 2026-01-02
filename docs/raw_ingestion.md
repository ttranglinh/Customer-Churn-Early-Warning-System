# Raw Ingestion (KKBox)

## Purpose
The `raw` schema preserves source data exactly as received. No business logic.

## Design choices
Raw tables intentionally avoid primary keys, foreign keys, type casting, and constraints to preserve source truth.

## Tables
- raw.members (members_v3.csv)
- raw.transactions (transactions_v2.csv)
- raw.user_logs (user_logs_v2.csv)
- raw.train (train_v2.csv)

## Ingestion strategy
Two phases:
1. Validate mode: small chunk inserts to validate schema, measure memory, observe failures.
2. Copy mode: PostgreSQL COPY for full ingestion once trusted.

## Reset policy
Raw tables are truncated explicitly via SQL prior to COPY mode to avoid accidental destructive operations inside scripts.

## Verification
Row counts are checked after ingestion:
```sql
SELECT COUNT(*) FROM raw.members;
SELECT COUNT(*) FROM raw.transactions;
SELECT COUNT(*) FROM raw.user_logs;
SELECT COUNT(*) FROM raw.train;

## Add SQL scripts for reproducibility
Create these in `sql/`:

- `sql/00_schemas.sql`
- `sql/01_raw_tables.sql`
- `sql/02_reset_raw.sql`