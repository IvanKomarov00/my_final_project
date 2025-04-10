-- models/staging/stg_orders.sql

with raw_orders as (
    select
        order_id,
        customer_id,
        order_status,
        -- Convert timestamps to TIMESTAMP type if they are strings
        safe_cast(order_purchase_timestamp as timestamp) as order_purchase_ts,
        safe_cast(order_approved_at as timestamp) as order_approved_ts,
        safe_cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_ts,
        safe_cast(order_delivered_customer_date as timestamp) as order_delivered_customer_ts,
        safe_cast(order_estimated_delivery_date as timestamp) as order_estimated_delivery_ts
    from {{ source('i_komarov', 'fp_orders_dataset') }}
),

orders_clean as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_ts,
        order_approved_ts,
        order_delivered_carrier_ts,
        order_delivered_customer_ts,
        order_estimated_delivery_ts,
        -- Calculate derived column: delivery time in days
        date_diff(
            cast(order_delivered_customer_ts as date),
            cast(order_purchase_ts as date),
            day
        ) as delivery_time_days,
        -- Derived column: is_shipped flag based on order status
        case
            when order_status in ('delivered', 'shipped') then true
            else false
        end as is_shipped,
        -- Handle NULL values: if approved timestamp is null, replace with a placeholder date
        coalesce(order_approved_ts, timestamp('1970-01-01 00:00:00')) as order_approved_clean
    from raw_orders
)

select *
from orders_clean