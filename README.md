## KKBox Customer Churn Early-Warning System

## Goal
To build a reproducible data pipeline for weekly churn early-warning system that answers: “Which users should we proactively intervene with this week?”.

## Project structure
- `sql/` PostgreSQL schema and table DDL, reset scripts
- `ingestion/` Python ingestion scripts (validate then COPY)
- `docs/` design notes and documentation

## How to run
See 'docs/'