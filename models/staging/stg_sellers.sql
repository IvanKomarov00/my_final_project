-- models/staging/stg_sellers.sql

with raw_sellers as (
    select
        seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state
    from {{ source('i_komarov', 'fp_sellers_dataset') }}
)

select *
from raw_sellers