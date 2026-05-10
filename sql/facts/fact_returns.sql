-- GRAIN : une ligne = un retour client.
CREATE OR REPLACE TABLE fact_returns AS
SELECT
    r.return_id,
    r.original_sale_line_id,
    d.date_key AS return_date_key,
    p.product_key,
    s.store_key,
    r.product_id,
    r.store_id,
    CAST(r.return_quantity AS INTEGER) AS return_quantity,
    CAST(r.refund_amount AS DECIMAL(12, 2)) AS refund_amount,
    r.return_reason
FROM raw_fact_returns r
LEFT JOIN dim_date d
       ON CAST(r.return_date AS DATE) = d.date_key
LEFT JOIN dim_product p
       ON r.product_id = p.product_id
LEFT JOIN dim_store s
       ON r.store_id = s.store_id;
