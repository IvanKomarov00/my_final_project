-- models/staging/stg_customers.sql

with raw_customers as (
    select
        customer_id,
        customer_unique_id,
        -- Replace NULL values in city and state with 'Unknown'
        coalesce(customer_city, 'Unknown') as customer_city,
        coalesce(customer_state, 'Unknown') as customer_state,
        customer_zip_code_prefix
    from {{ source('i_komarov', 'fp_customers_dataset') }}
)

select *
from raw_customers