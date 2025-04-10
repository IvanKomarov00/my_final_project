-- models/staging/stg_product_category_name_translation.sql

with raw_category as (
    select
        product_category_name,
        product_category_name_english
    from {{ source('i_komarov', 'fp_product_category_name_translation') }}
)

select *
from raw_category