# S02 - Star Schema Board Brief

## Recommendation

Use a star schema centered on `fact_sales` to make the CEO question repeatable every month and quarter.

## Grain

One row in `fact_sales` represents one sold order line, identified by `order_number` and `sale_line_id`.

This grain is fine enough to answer the current question and future variants by product, store, date, customer and channel. It also avoids locking the model into a summary level that would hide product or regional changes.

## Star schema

Fact:
- `fact_sales`

Dimensions:
- `dim_date`
- `dim_product`
- `dim_store`
- `dim_customer`
- `dim_channel`

The core CEO analysis uses three dimensions:
- category from `dim_product`
- region from `dim_store`
- quarter from `dim_date`

The revenue measure comes from `fact_sales.line_total`.

## Evidence

The SQL proof is in `sql/analysis/s02-first-answer.sql`. It returns category-region pairs where 2025 Q4 revenue is lower than the previous quarter.

Top declines found:

| Category | Region | Revenue T4 | Revenue T3 | Change | Change % | Units change | Orders change |
|---|---:|---:|---:|---:|---:|---:|---:|
| Automotive | Ontario | 3266.55 | 6879.84 | -3613.29 | -52.52% | -24 | -6 |
| Automotive | Quebec | 5276.78 | 7066.78 | -1790.00 | -25.33% | -12 | -3 |
| Automotive | Alberta | 579.82 | 2361.64 | -1781.82 | -75.45% | -12 | -4 |
| Grocery | Ontario | 3903.57 | 5619.46 | -1715.89 | -30.53% | -20 | -6 |
| Pet Supplies | Outaouais | 3300.58 | 4262.35 | -961.77 | -22.56% | -5 | 0 |
| Sports & Outdoors | BC | 554.02 | 1505.37 | -951.35 | -63.20% | -14 | -3 |

## Executive interpretation

The model shows that the most urgent decline is `Automotive` in Ontario, followed by `Automotive` in Quebec and Alberta. The drops are accompanied by lower units and fewer orders, which suggests a demand or regional commercial issue more than a pure pricing issue.

The model answers where and when the decline happens. Explaining why will require later facts such as returns, budget, inventory or promotions.
