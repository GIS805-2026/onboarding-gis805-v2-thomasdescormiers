-- GRAIN : une ligne = un budget mensuel par categorie et magasin.
CREATE OR REPLACE TABLE fact_budget AS
SELECT
    b.budget_id,
    d.date_key AS budget_month_key,
    s.store_key,
    b.category,
    b.store_id,
    CAST(b.target_revenue AS DECIMAL(12, 2)) AS target_revenue,
    CAST(b.target_units AS INTEGER) AS target_units
FROM raw_fact_budget b
LEFT JOIN dim_date d
       ON CAST(b.budget_month AS DATE) = d.date_key
LEFT JOIN dim_store s
       ON b.store_id = s.store_id;
