CREATE OR REPLACE VIEW v_sales_vs_budget AS
WITH sales AS (
    SELECT
        DATE_TRUNC('month', f.date_key) AS budget_month,
        s.store_key,
        p.category,
        SUM(f.line_total) AS actual_revenue,
        SUM(f.quantity) AS actual_units
    FROM fact_sales f
    JOIN dim_store s ON f.store_key = s.store_key
    JOIN dim_product p ON f.product_key = p.product_key
    GROUP BY 1, 2, 3
)
SELECT
    b.budget_month_key,
    b.store_key,
    b.category,
    COALESCE(s.actual_revenue, 0) AS actual_revenue,
    b.target_revenue,
    COALESCE(s.actual_revenue, 0) - b.target_revenue AS revenue_variance,
    COALESCE(s.actual_units, 0) AS actual_units,
    b.target_units
FROM fact_budget b
LEFT JOIN sales s
       ON b.budget_month_key = s.budget_month
      AND b.store_key = s.store_key
      AND b.category = s.category;
