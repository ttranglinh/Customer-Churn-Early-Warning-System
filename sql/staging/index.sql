-- Light indexing 

create index if not exists idx_stg_members_msno on staging.stg_members (msno);
create index if not exists idx_stg_transactions_msno_date on staging.stg_transactions (msno, transaction_date);
create index if not exists idx_stg_user_logs_msno_date on staging.stg_user_logs (msno, log_date);
create index if not exists idx_stg_churn_labels_msno on staging.stg_churn_labels (msno);
