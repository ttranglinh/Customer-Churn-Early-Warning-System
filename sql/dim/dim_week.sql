create schema if not exists dim;

create table dim.dim_week (
	week_id int primary key,
	week_start_date date not null,
	week_end_date date not null,
	snapshot_date date not null,
	iso_year int not null,
	iso_week int not null
	);

with calendar_days as (
	select
		d::date as calendar_date
	from generate_series(
		DATE '2015-01-01',
		DATE '2017-12-31',
		interval '1 day'
		) as g(d)
),
weeks as (
	select 
		date_trunc('week', calendar_date)::date as week_start_date
	from calendar_days
	group by date_trunc('week', calendar_date)::date
)
insert into dim.dim_week (
	week_id,
	week_start_date,
	week_end_date,
	snapshot_date,
	iso_year,
	iso_week
)
select 
	(extract(ISOYEAR from week_start_date) * 100 + extract(week from week_start_date))::int as week_id,
	week_start_date,
	(week_start_date + interval '6 days')::date as week_end_date,
	(week_start_date + interval '6 days')::date as snapshot_date,
	extract(isoyear from week_start_date)::int as iso_year,
	extract(week from week_start_date)::int as iso_week
from weeks
order by week_start_date;

--- Check validity
	-- One row per week:
select count(*) = count(distinct week_id)
from dim.dim_week;

	-- Snapshot date consistency:
select *
from dim.dim_week
where snapshot_date <> week_end_date;