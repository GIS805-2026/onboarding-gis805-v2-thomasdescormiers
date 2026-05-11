# Schema v1 - NexaMart Sales

## CEO question

"Quelles categories declinent dans quelles regions et pourquoi?"

For S02, the repeatable analytical version is: what is revenue by product category, region and quarter, and which declines should be investigated first?

## Grain statement

One row in `fact_sales` represents one sold order line, identified by the combination of `order_number` and `sale_line_id`.

This grain is the design contract for the first NexaMart star. Measures such as `quantity`, `line_total` and `gross_amount` are additive at this level and can be rolled up safely by product, store, date, customer or channel.

## Business process

The modeled business process is customer sales. Each row records one product sold as part of a customer order.

## Fact table

`fact_sales` is the center of the star.

Keys:
- `date_key`
- `product_key`
- `store_key`
- `customer_key`
- `channel_key`

Degenerate dimension:
- `order_number`
- `sale_line_id`

Measures:
- `quantity`
- `unit_price`
- `discount_pct`
- `net_price`
- `line_total`
- `gross_amount`

## Dimensions

`dim_date` supports analysis by year, quarter, month, week and day.

`dim_product` supports analysis by category, subcategory, brand and product.

`dim_store` supports analysis by region, province, city and store type.

`dim_customer` supports analysis by customer identity, geography and loyalty segment.

`dim_channel` supports analysis by channel name and channel type.

## Conformed dimensions

`dim_date`, `dim_product` and `dim_store` are conformed dimensions for the NexaMart model. They can be reused later with returns, budgets, inventory and promotion facts. This makes drill-across possible because multiple facts can be summarized using the same date, product and store definitions.

## Validation query

The proof query is stored in `sql/analysis/s02-first-answer.sql`. It aggregates `fact_sales.line_total` by `dim_product.category`, `dim_store.region` and `dim_date.quarter`, then compares 2025 Q4 with the previous quarter.

## Diagram

The Mermaid source is stored in `diagrams/schema-v1.mmd`.
