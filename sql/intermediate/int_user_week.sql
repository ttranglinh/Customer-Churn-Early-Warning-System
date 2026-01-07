create schema if not exists intermediate;

create table intermediate.int_user_week (
	msno text not null,
	week_id int not null,
	snapshot_date date not null,
	primary key (msno, week_id)
);


with first_date_tbl as (
	select 
		msno,
		min(transaction_date)::date as first_date
	from staging.stg_transactions
	group by msno
	order by msno
)
,
temp_tbl as (
	select 
		msno, 
		min(first_date) as first_seen_date
	from first_date_tbl
	group by msno
)
insert into intermediate.int_user_week (msno, week_id, snapshot_date)
select 
	t.msno,
	d.week_id,
	d.snapshot_date
from temp_tbl t
join dim.dim_week d on d.snapshot_date >= t.first_seen_date; -- check week after the first_seen_date for that user

--- Validate the spine
	-- Check duplicates
select msno, week_id, count(*)
from intermediate.int_user_week 
group by msno, week_id
having count(*) > 1;

	-- Row growth sanity
select 
	week_id, 
	count(*) as users
from intermediate.int_user_week 
group by week_id 
order by week_id;