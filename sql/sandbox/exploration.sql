-- ============================================================
-- Sandbox area for exploration
-- ============================================================
-- Use this file for ad-hoc queries and exploration.
-- Nothing here needs to be production-ready.
-- ============================================================

-- Example: Quick look at data distributions
-- SELECT * FROM raw_customers LIMIT 10;

-- Example: Check category distribution
-- SELECT category, COUNT(*) as cnt
-- FROM raw_products
-- GROUP BY category
-- ORDER BY cnt DESC;

-- Example: Monthly order trends
-- SELECT
--     DATE_TRUNC('month', CAST(order_date AS DATE)) as month,
--     COUNT(*) as order_count
-- FROM raw_orders
-- GROUP BY 1
-- ORDER BY 1;

-- Your exploration queries below:

-- Question CEO :
-- Quelles categories declinent dans quelles regions, et pourquoi ?
--
-- Methode :
-- 1. Calculer les ventes par categorie, region et trimestre.
-- 2. Comparer chaque trimestre avec le trimestre precedent.
-- 3. Ajouter des signaux explicatifs : variation des unites,
--    variation des commandes, remises, retours et ecart au budget.
-- 4. Afficher les plus fortes baisses du dernier trimestre disponible.

WITH sales_by_quarter AS (
    SELECT
        d.year,
        d.quarter,
        d.year * 10 + d.quarter AS period_id,
        p.category,
        s.region,
        SUM(f.line_total) AS revenue,
        SUM(f.quantity) AS units_sold,
        COUNT(DISTINCT f.order_number) AS orders,
        AVG(f.discount_pct) AS avg_discount_pct
    FROM fact_sales f
    JOIN dim_date d ON f.date_key = d.date_key
    JOIN dim_product p ON f.product_key = p.product_key
    JOIN dim_store s ON f.store_key = s.store_key
    GROUP BY
        d.year,
        d.quarter,
        d.year * 10 + d.quarter,
        p.category,
        s.region
),
sales_change AS (
    SELECT
        *,
        LAG(revenue) OVER (
            PARTITION BY category, region
            ORDER BY period_id
        ) AS previous_revenue,
        LAG(units_sold) OVER (
            PARTITION BY category, region
            ORDER BY period_id
        ) AS previous_units_sold,
        LAG(orders) OVER (
            PARTITION BY category, region
            ORDER BY period_id
        ) AS previous_orders
    FROM sales_by_quarter
),
returns_by_quarter AS (
    SELECT
        d.year,
        d.quarter,
        p.category,
        s.region,
        SUM(r.refund_amount) AS refunds,
        SUM(r.return_quantity) AS returned_units
    FROM fact_returns r
    JOIN dim_date d ON r.return_date_key = d.date_key
    JOIN dim_product p ON r.product_key = p.product_key
    JOIN dim_store s ON r.store_key = s.store_key
    GROUP BY
        d.year,
        d.quarter,
        p.category,
        s.region
),
budget_by_quarter AS (
    SELECT
        d.year,
        d.quarter,
        b.category,
        s.region,
        SUM(b.target_revenue) AS target_revenue
    FROM fact_budget b
    JOIN dim_date d ON b.budget_month_key = d.date_key
    JOIN dim_store s ON b.store_key = s.store_key
    GROUP BY
        d.year,
        d.quarter,
        b.category,
        s.region
)
SELECT
    sc.year,
    sc.quarter,
    sc.category,
    sc.region,
    ROUND(sc.revenue, 2) AS revenue,
    ROUND(sc.previous_revenue, 2) AS previous_revenue,
    ROUND(sc.revenue - sc.previous_revenue, 2) AS revenue_decline,
    ROUND(
        100 * (sc.revenue - sc.previous_revenue)
        / NULLIF(sc.previous_revenue, 0),
        1
    ) AS revenue_decline_pct,
    sc.units_sold - sc.previous_units_sold AS units_change,
    sc.orders - sc.previous_orders AS orders_change,
    ROUND(sc.avg_discount_pct * 100, 1) AS avg_discount_pct,
    ROUND(COALESCE(rq.refunds, 0), 2) AS refunds,
    COALESCE(rq.returned_units, 0) AS returned_units,
    ROUND(
        100 * COALESCE(rq.refunds, 0) / NULLIF(sc.revenue, 0),
        1
    ) AS refund_rate_pct,
    ROUND(bq.target_revenue, 2) AS target_revenue,
    ROUND(sc.revenue - bq.target_revenue, 2) AS variance_to_budget
FROM sales_change sc
LEFT JOIN returns_by_quarter rq
       ON sc.year = rq.year
      AND sc.quarter = rq.quarter
      AND sc.category = rq.category
      AND sc.region = rq.region
LEFT JOIN budget_by_quarter bq
       ON sc.year = bq.year
      AND sc.quarter = bq.quarter
      AND sc.category = bq.category
      AND sc.region = bq.region
WHERE sc.previous_revenue IS NOT NULL
  AND sc.revenue < sc.previous_revenue
  AND sc.year = 2025
  AND sc.quarter = 4
ORDER BY revenue_decline ASC
LIMIT 10;
