## fp_sales_full

**Description**  
A single, denormalized table at the order level, combining metadata, items, and payments.

**Fields**  
| Field                       | Type                | Description                                                                 |
|-----------------------------|---------------------|-----------------------------------------------------------------------------|
| order_id                    | STRING              | Unique order identifier.                                                    |
| customer_id                 | STRING              | Identifier for the customer placing the order.                              |
| order_status                | STRING              | Current status of the order.                                                |
| order_purchase_date         | DATE                | Date of order placement (partition key).                                     |
| order_purchase_ts           | TIMESTAMP           | Exact timestamp when the order was placed.                                  |
| order_approved_ts           | TIMESTAMP           | Timestamp when the order was approved.                                      |
| order_delivered_carrier_ts  | TIMESTAMP           | When the carrier dispatched the order.                                      |
| order_delivered_customer_ts | TIMESTAMP           | When the order was delivered to the customer.                               |
| order_estimated_delivery_ts | TIMESTAMP           | Estimated delivery timestamp.                                               |
| delivery_time_days          | INT                 | Days between purchase and customer delivery.                                |
| is_shipped                  | BOOLEAN             | True if status in ('shipped','delivered'), else False.                      |
| items                       | ARRAY<STRUCT>       | List of order items with fields: order_item_id, product_id, category, category_en. |
| payments                    | ARRAY<STRUCT>       | List of payments with fields: payment_sequential, payment_type, payment_installments, payment_value. |
| total_paid                  | NUMERIC             | Sum of all payment_value for the order.                                     |

**Partitioning & Clustering**  
- Partitioned by `order_purchase_date` to optimize date-range queries.  
- Clustered by `customer_id`, `order_status` to speed up filtering by customer or status.