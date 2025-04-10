{{ config(materialized='table') }}

with first_orders as (
  select
    customer_id,
    min(order_purchase_date) as first_order_date
  from {{ ref('fp_sales_full') }}
  group by customer_id
),

orders as (
  select
    customer_id,
    order_id,
    order_purchase_date,
    total_paid
  from {{ ref('fp_sales_full') }}
),

annotated as (
  select
    o.customer_id,
    o.order_id,
    o.order_purchase_date,
    o.total_paid,
    f.first_order_date,
    case 
      when o.order_purchase_date = f.first_order_date then 'new'
      else 'returning'
    end as customer_type
  from orders o
  join first_orders f
    on o.customer_id = f.customer_id
)

select
  customer_id,
  customer_type,
  count(order_id)           as total_orders,
  sum(total_paid)           as lifetime_value,
  avg(total_paid)           as avg_order_value,
  date_diff(current_date(), min(first_order_date), day) as days_since_first_order
from annotated
group by customer_id, customer_type