# Staging

## Purpose
The `staging` schema converts `raw` source data into **structurally trustworthy data** that downstream transformations, features, and models can rely on without re-validating basic assumptions.

Staging is a **contract layer**, not a business logic layer.

## What staging guarantees
After data enters `staging`, downstream code may assume:
- Columns have correct and consistent data types
- Date fields are valid `Date` values (YYYYMMDD)
- Table grain is explicit and enforced
- Obvious duplicates are handled deterministically
- Allowed categorical values are enforced
- Row counts and key coverage are measurable and auditable

Staging does **not**:
- Apply business rules
- Aggregate metrics
- Engineer features
- Infer missing information

## Core objectives
Staging achieves schema alignment through:
- **Semantic alignment**
    Clear, consistent column naming
- **Data type alignment**
    Explicit casting to `DATE`, `BOOLEAN`, `INTEGER`, `NUMERIC`, `TEXT`
- **Structural alignment**
    Enforcing table grain and handling duplicates where required
- **Nullability control**
    Invalid or out-of-contract values are converted to `NULL`
- **Time standardisation**
    All date fields are converted from 'YYYYMMDD' integers to `DATE`

# Table grain contracts
These grain definitions are enforced in SQL and relied upon downstream.

- `stg_members` 
    One row per msno (user).
    If multiple records exist, the most recent registration record is retained.
- `stg_transactions`
    One row per unique subscription.
    Exact duplicate rows are removed; no transaction ID is invented.
- `stg_user_logs` 
    One row per 'msno' per 'log_date' per record.
    No aggregation is performed at this stage.
- `stg_churn_labels` 
    One row per 'msno'.
    Label values are cast to boolean.

## Data handling rules

### Duplicates
Duplicates are handled only when:
- They violate declared table grain
- A deterministic rule exists for resolution

Otherwise, duplicates are preserved.

### Categorical values
Categorical columns (e.g. 'gender') are restricted to allowed values.

### Integer values
Integer columns (e.g. age) are restricted within reasonable range.

### Dates
All date fields:
- Are parsed from `YYYYMMDD` integers
- Must fall within reasonable calendar ranges
- Are stored as 'DATE'

Invalid dates result in `NULL`.

## Data quality checks

Staging quality checks are implemented in:
- `staging_quality_check.sql`

These checks verify:
- Raw vs staging row count reconciliation
- No duplicate keys where uniqueness is guaranteed
- Valid date ranges
- Stable user identifier coverage across table

Staging is considered **successful** only if all checks pass.

## SQL assets
- `stg_members.sql`
- `stg_transactions.sql`
- `stg_user_logs.sql`
- `stg_churn_labels.sql`
- `staging_quality_check.sql`

Each SQL file enforces the contract defined in this document.

## Design principle

Raw data records **what exists**.
Staging defines **what downstream logic is allowed to assume**.

All staging transformations are explicit, deterministic and documented.