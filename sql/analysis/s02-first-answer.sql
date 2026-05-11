-- S02 - First SQL answer
-- CEO question: which product categories decline in which regions, by quarter?
-- Grain used: one row in fact_sales = one sold order line
--             identified by order_number + sale_line_id.

WITH quarterly_sales AS (
    SELECT
        p.category,
        s.region,
        d.year,
        d.quarter,
        SUM(f.line_total) AS revenue,
        SUM(f.quantity) AS units_sold,
        COUNT(DISTINCT f.order_number) AS orders
    FROM fact_sales f
    JOIN dim_product p ON f.product_key = p.product_key
    JOIN dim_store s ON f.store_key = s.store_key
    JOIN dim_date d ON f.date_key = d.date_key
    GROUP BY
        p.category,
        s.region,
        d.year,
        d.quarter
),
compared AS (
    SELECT
        category,
        region,
        year,
        quarter,
        revenue AS revenue_t4,
        LAG(revenue) OVER (
            PARTITION BY category, region
            ORDER BY year, quarter
        ) AS revenue_t3,
        units_sold AS units_t4,
        LAG(units_sold) OVER (
            PARTITION BY category, region
            ORDER BY year, quarter
        ) AS units_t3,
        orders AS orders_t4,
        LAG(orders) OVER (
            PARTITION BY category, region
            ORDER BY year, quarter
        ) AS orders_t3
    FROM quarterly_sales
)
SELECT
    category,
    region,
    CAST(revenue_t4 AS DECIMAL(12, 2)) AS revenue_t4,
    CAST(revenue_t3 AS DECIMAL(12, 2)) AS revenue_t3,
    CAST(revenue_t4 - revenue_t3 AS DECIMAL(12, 2)) AS revenue_change,
    CAST((revenue_t4 - revenue_t3) / NULLIF(revenue_t3, 0) AS DECIMAL(8, 4)) AS revenue_change_pct,
    CAST(units_t4 - units_t3 AS INTEGER) AS units_change,
    CAST(orders_t4 - orders_t3 AS INTEGER) AS orders_change
FROM compared
WHERE year = 2025
  AND quarter = 4
  AND revenue_t4 < revenue_t3
ORDER BY revenue_change ASC;
