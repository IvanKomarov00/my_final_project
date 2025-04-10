-- tests/fp_sales_full_not_empty.sql

select
  case
    when count(*) > 0 then 0
    else 1
  end as failure_count
from {{ ref('fp_sales_full') }}