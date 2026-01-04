-- Row counts before and after
select 'raw.members' as table_name, count(*) as row_counts
from raw.members
union all
select 'staging.stg_members' as table_name, count(*) as row_counts
from staging.stg_members
union all
select 'raw.transactions'  as table_name, count(*) as row_counts
from raw.transactions 
union all
select 'staging.stg_transactions'  as table_name, count(*) as row_counts
from staging.stg_transactions 
union all
select 'raw.user_logs'  as table_name, count(*) as row_counts
from raw.user_logs
union all 
select 'staging.stg_user_logs'  as table_name, count(*) as row_counts
from staging.stg_user_logs
union all
select 'raw.train'  as table_name, count(*) as row_counts
from raw.train
union all 
select 'staging.stg_churn_labels'  as table_name, count(*) as row_counts
from staging.stg_churn_labels;

	-- Duplicate check: No dups
select msno, count(*)
from staging.stg_members
group by msno
having count(*) > 1;

select msno, log_date, count(*)
from staging.stg_user_logs
group by msno, log_date
having count(*) > 1;

select msno, count(*)
from staging.stg_churn_labels
group by msno
having count(*) > 1;

	-- Date sanity check
select 
	min(registration_init_date) as min_registration_init_date,
	max(registration_init_date) as max_registration_init_date
from staging.stg_members;

select 
	min(transaction_date) as min_transaction_date,
	max(transaction_date) as max_transaction_date,
	min(membership_expire_date) as min_membership_expire_date,
	max(membership_expire_date) as max_membership_expire_date
from staging.stg_transactions;

select 
	min(log_date) as min_log_date,
	max(log_date) as max_log_date
from staging.stg_user_logs;

	-- Stable user identifier across tables (work for joins later)

select 'staging.stg_members' as table_name, count(distinct msno) as ui_counts
from staging.stg_members
union all
select 'staging.stg_transactions' as table_name, count(distinct msno) as ui_counts
from staging.stg_transactions 
union all
select 'staging.stg_user_logs' as table_name, count(distinct msno) as ui_counts
from staging.stg_user_logs
union all
select 'staging.stg_churn_labels' as table_name, count(distinct msno) as row_counts
from staging.stg_churn_labels
	-- Notes: stg_members is the largest -> normal sign
;
