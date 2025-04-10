{{ config(materialized='table') }}

with exploded as (
  select
    order_purchase_date,
    payment.payment_type           as payment_type,
    payment.payment_installments   as installments,
    total_paid
  from {{ ref('fp_sales_full') }},
  unnest(payments) as payment
),

monthly as (
  select
    date_trunc(order_purchase_date, month) as period_month,
    payment_type,
    count(*)                                as payment_count,
    avg(installments)                       as avg_installments,
    sum(total_paid)                         as revenue_by_method
  from exploded
  group by 1,2
)

select * from monthly