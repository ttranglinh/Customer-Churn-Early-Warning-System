# Data Dictionary

## Source
KKBox Churn Prediction Challenge (Kaggle)

## Note
KKBox does not provide a formal data dictionary.
This document is derived from Kaggle dataset descriptions and empirical inspection of the raw data.
Raw tables preserve source truth and intentionally contain unvalidated values.

## raw.members

**Grain**
One row per user registration record.
Multiple rows per msno may exist.

**Columns**
| Column | Raw Type | Description |	Observations / Notes |
|-------|-------------|-----------------|--------------|
| msno | string	| User identifier |	Stable across all datasets |
| city | int |	City code |	No reference or lookup table provided; small values from 1 to 22 |
| bd | integer | User age | Extreme values from negative to positive (-7,168 to 2,016) |
| gender | text | Gender | 'female'/'male'/null |
| registered_via | int | Registration channel | Encoded categorical |
| registration_init_time | integer (YYYYMMDD) |	Registration date | Stored as integer, requires parsing |

## raw.transactions

**Grain**
One row per transaction record.
msno may have multiple transaction_date.

**Columns**
| Column | Raw Type | Description |	Observations / Notes |
|-------|-------------|-----------------|--------------|
| msno | string	| User identifier |	Stable across all datasets |
| payment_method_id | int |	Payment method code |	No reference or lookup table provided; small values from 2 to 40 |
| payment_plan_days | integer | Subscription duration | Ranging from 0 to 450 |
| plan_list_price | int | List price of plan | Ranging from 0 to 2,000 (in New Taiwan Dollar (NTD)) |
| actual_amount_paid | int | Amount paid | Ranging similarly to list price (in New Taiwan Dollar (NTD)) |
| is_auto_renew | integer |	Auto renew subscription | Binary values (0/1)  |
| transaction_date | integer |	Transaction date | Need parsing format %Y%m%d |
| membership_expire_date | integer | Expiration date | Need parsing format %Y%m%d |
| is_cancel | integer | Whether or not the user canceled the membership in this transaction | Binary values (0/1) |

## raw.user_logs

**Grain**
One row per user login record.
msno may have multiple log in date.

**Columns**
| Column | Raw Type | Description | Observations / Notes |
|------|---------|------------|----------------------|
| msno | string | User identifier | Very high cardinality |
| date | integer (YYYYMMDD) | Activity date | Requires date parsing |
| num_25 | integer | Plays ≥25% and <50% | Count metric |
| num_50 | integer | Plays ≥50% and <75% | Count metric |
| num_75 | integer | Plays ≥75% and <98.5% | Count metric |
| num_985 | integer | Plays ≥98.5% | Count metric |
| num_100 | integer | Completed plays | Count metric |
| num_unq | integer | Unique songs played | Per day |
| total_secs | numeric | Total listening time | Seconds, fractional |

## raw.train (Churn Labels)

**Grain**  
One row per user churn label.

**Columns**

| Column | Raw Type | Description | Observations / Notes |
|------|---------|------------|----------------------|
| msno | string | User identifier | Join key to all tables |
| is_churn | integer (0/1) | Churn indicator | Target variable |

## Interpretation Boundary

- `raw` tables preserve source truth  
- No primary keys, foreign keys, or constraints are enforced  
- No business logic is applied  
- Invalid and missing values are expected  

Semantic interpretation, type casting, deduplication, and normalization are handled in the **staging layer**

## Design Rationale

This data dictionary exists to:

- Establish a shared understanding of raw fields  
- Separate observation from interpretation  
- Make downstream transformations explicit and auditable  
- Support reproducible analytics and modeling  

Documenting assumptions is intentional and part of the pipeline design.