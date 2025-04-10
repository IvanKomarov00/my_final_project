-- models/staging/stg_order_payments.sql

with raw_order_payments as (
    select
        order_id,
        payment_sequential,
        payment_type,
        payment_installments,
        payment_value
    from {{ source('i_komarov', 'fp_order_payments_dataset') }}
)

select *
from raw_order_payments