{{ config(materialized='table') }}

with base as (
  select
    order_id,
    order_purchase_date,
    total_paid,
    order_status
  from {{ ref('fp_sales_full') }}
),

daily as (
  select
    order_purchase_date             as period_date,
    'daily'                         as period,
    order_status,
    count(order_id)                 as orders_count,
    sum(total_paid)                 as revenue
  from base
  group by
    order_purchase_date,
    order_status
),

monthly as (
  select
    date_trunc(order_purchase_date, month) as period_date,
    'monthly'                             as period,
    order_status,
    count(order_id)                       as orders_count,
    sum(total_paid)                       as revenue
  from base
  group by
    date_trunc(order_purchase_date, month),
    order_status
)

select * from daily
union all
select * from monthly