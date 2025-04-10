-- models/staging/stg_products.sql

with raw_products as (
    select
        product_id,
        product_category_name,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    from {{ source('i_komarov', 'fp_products_dataset') }}
)

select *
from raw_products