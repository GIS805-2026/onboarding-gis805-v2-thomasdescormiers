CREATE OR REPLACE VIEW v_sales_by_region_month AS
SELECT
    d.year,
    d.month,
    s.region,
    SUM(f.line_total) AS revenue,
    SUM(f.quantity) AS units_sold,
    COUNT(DISTINCT f.order_number) AS orders
FROM fact_sales f
JOIN dim_date d ON f.date_key = d.date_key
JOIN dim_store s ON f.store_key = s.store_key
GROUP BY d.year, d.month, s.region;
