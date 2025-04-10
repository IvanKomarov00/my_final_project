-- tests/fp_total_revenue_positive.sql

select
  case
    when sum(total_paid) > 0 then 0
    else 1
  end as failure_count
from {{ ref('fp_sales_full') }}