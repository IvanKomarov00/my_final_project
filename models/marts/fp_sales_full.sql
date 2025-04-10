/*
  Model: fp_sales_full

  This table brings together everything you need for order‑level analysis in one place:
  - Order details and handy metrics like delivery_time_days and is_shipped
  - A list of items per order, stored as an ARRAY of STRUCTs (order_item_id, product_id, category, category_en)
  - All payment information per order, also as an ARRAY of STRUCTs, plus a total_paid field

  We partition by order_purchase_date to speed up time‑based queries,
  and cluster by customer_id and order_status so filtering by customer or status is faster.

  Why we built it this way:
  - ARRAY_AGG + STRUCT lets us keep one‑to‑many data (items and payments) neatly packed into a single row.
  - We pushed type conversions and null handling into stg_orders so this model can focus on joining and aggregating data.
*/

{{  
  config(
    materialized = 'table',
    partition_by = { "field": "order_purchase_date", "data_type": "date" },
    cluster_by = ["customer_id", "order_status"]
  ) 
}}

with 
-- 1. Base orders (with staging)
orders as (
  select
    order_id,
    customer_id,
    order_status,
    cast(order_purchase_ts as date) as order_purchase_date,
    order_purchase_ts,
    order_approved_ts,
    order_delivered_carrier_ts,
    order_delivered_customer_ts,
    order_estimated_delivery_ts,
    delivery_time_days,
    is_shipped
  from {{ ref('stg_orders') }}
),

-- 2. Order items + product + category translation
items as (
  select
    oi.order_id,
    array_agg(struct(
      oi.order_item_id,
      oi.product_id,
      p.product_category_name,
      pct.product_category_name_english
    )) as items
  from {{ ref('stg_order_items') }} as oi
  left join {{ ref('stg_products') }} as p
    using (product_id)
  left join {{ ref('stg_product_category_name_translation') }} as pct
    on p.product_category_name = pct.product_category_name
  group by oi.order_id
),

-- 3. Payments aggregated
payments as (
  select
    op.order_id,
    array_agg(struct(
      op.payment_sequential,
      op.payment_type,
      op.payment_installments,
      op.payment_value
    )) as payments,
    sum(op.payment_value) as total_paid
  from {{ ref('stg_order_payments') }} as op
  group by op.order_id
)

select
  o.*,
  i.items,
  p.payments,
  p.total_paid
from orders as o
left join items as i using (order_id)
left join payments as p using (order_id)