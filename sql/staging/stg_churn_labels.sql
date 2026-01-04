create table staging.stg_churn_labels as 
with raw as (
	select
		msno,
		case 
			when is_churn = 1 then true
			when is_churn = 0 then false
			else null
		end as is_churn
	from raw.train
)
,
dedup as (
	select 
		*,
		row_number() over (partition by msno) as dup_count
	from raw
)
select 
	msno,
	is_churn
from dedup
where dup_count = 1;