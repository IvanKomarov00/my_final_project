Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## Final Project Overview

This repository delivers an end‑to‑end analytics engineering solution on the Brazilian E‑commerce dataset using BigQuery and dbt.


### Disclosure: generated with AI based on Final Project Task description
### Project Breakdown

1. **Data Ingestion (Part 1)**  
   Loaded raw CSV files from Kaggle into BigQuery as `fp_*_dataset` tables.

2. **Source Definitions (Part 2)**  
   Declared sources in `fp_sources.yml`, complete with column descriptions and built‑in schema tests.

3. **Staging Models (Part 3)**  
   Built `stg_*` models to clean data, handle nulls, and compute derived columns (e.g., `delivery_time_days`, `is_shipped`).

4. **Integrated Table (Part 4)**  
   Created `fp_sales_full`, a denormalized, partitioned, and clustered table combining orders, items, and payments.

5. **Analytical Marts (Part 5)**  
   Implemented three analytical models—`fp_order_performance`, `fp_customer_behavior`, and `fp_payment_analysis`—for order trends, customer segmentation, and payment method analysis.

6. **Testing & Documentation (Part 6)**  
   - **Custom Data Tests:** (e.g., ensuring `fp_sales_full` is populated and revenue is positive)  
   - **Persisted Docs:** All model and source descriptions are pushed to BigQuery via `persist_docs`.  
   - **Documentation Site:** Generated with `dbt docs generate`.

### Ussage

1. **Build everything:**  
   ```bash
   dbt run