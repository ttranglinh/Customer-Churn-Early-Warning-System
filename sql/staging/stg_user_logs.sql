create table staging.stg_user_logs as 
with cleaned as (
	select
		msno,
		to_date(date::text, 'YYYYMMDD') as log_date,
		num_25::int as num_25,
		num_50::int as num_50,
		num_75::int as num_75,
		num_985::int as num_985,
		num_100::int as num_100,
		num_unq::int4 as num_unq,
		total_secs::numeric as total_secs
	from raw.user_logs
)
,
dedup as (
	select 
		*,
		row_number() over (partition by msno, log_date order by msno, log_date) as dup_count
	from cleaned
)
select 
	msno,
	log_date,
	num_25,
	num_50,
	num_75,
	num_985,
	num_100,
	num_unq,
	total_secs
from dedup
where dup_count = 1;