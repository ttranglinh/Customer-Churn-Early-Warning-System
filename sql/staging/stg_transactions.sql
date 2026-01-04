create table staging.stg_transactions as
with cleaned as (
	select 
		msno,
		payment_method_id::smallint as payment_method_id,
		payment_plan_days::smallint as payment_plan_days,
		plan_list_price::smallint as plan_list_price,
		actual_amount_paid::smallint as actual_amount_paid,
		case 
			when is_auto_renew = 1 then true
			when is_auto_renew = 0 then false
			else null
		end as is_auto_renew,
		to_date(transaction_date::text, 'YYYYMMDD') as transaction_date,
		to_date(membership_expire_date::text, 'YYYYMMDD') as membership_expire_date,
		case 
			when is_cancel = 1 then true
			when is_cancel = 0 then false
			else null
		end as is_cancel
	from raw.transactions 
)
,
dedup as (
	select 
		*,
		row_number() over (partition by msno, payment_method_id, payment_plan_days, plan_list_price, actual_amount_paid, is_auto_renew, transaction_date, membership_expire_date, is_cancel) as dup_count
	from cleaned
)
select 
	msno,
	payment_method_id,
	payment_plan_days,
	plan_list_price,
	actual_amount_paid,
	is_auto_renew,
	transaction_date,
	membership_expire_date,
	is_cancel
from dedup
where dup_count = 1;