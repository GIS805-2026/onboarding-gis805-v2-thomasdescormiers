-- GRAIN : une ligne = un snapshot quotidien de stock par produit et magasin.
CREATE OR REPLACE TABLE fact_daily_inventory AS
SELECT
    i.snapshot_id,
    d.date_key AS snapshot_date_key,
    p.product_key,
    s.store_key,
    i.product_id,
    i.store_id,
    CAST(i.quantity_on_hand AS INTEGER) AS quantity_on_hand,
    CAST(i.quantity_on_order AS INTEGER) AS quantity_on_order,
    CAST(i.days_of_supply AS DECIMAL(10, 2)) AS days_of_supply
FROM raw_fact_daily_inventory i
LEFT JOIN dim_date d
       ON CAST(i.snapshot_date AS DATE) = d.date_key
LEFT JOIN dim_product p
       ON i.product_id = p.product_id
LEFT JOIN dim_store s
       ON i.store_id = s.store_id;
