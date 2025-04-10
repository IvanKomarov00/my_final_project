-- models/staging/stg_order_items.sql

with raw_order_items as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        -- Convert shipping_limit_date to a TIMESTAMP
        safe_cast(shipping_limit_date as timestamp) as shipping_limit_date,
        price,
        freight_value
    from {{ source('i_komarov', 'fp_order_items_dataset') }}
)

select *
from raw_order_items