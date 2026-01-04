create table staging.stg_members as
with cleaned as (
	select
		msno,
		city::smallint as city,
		case 
			when bd between 1 and 99 then bd 
			else null
		end as age,
		case 
			when gender = 'female' then 'female'
			when gender = 'male' then 'male'
			else null
		end as gender,
		registered_via::smallint as registered_channel,
		to_date(registration_init_time::text, 'YYYYMMDD') as registration_init_date
	from raw.members
)
,
dedup as (
	select 
		*,
		row_number() over (partition by msno order by registration_init_date desc) as dup_count
	from cleaned
)
select 
	msno,
	city,
	age, 
	gender,
	registered_channel,
	registration_init_date
from dedup
where dup_count = 1;