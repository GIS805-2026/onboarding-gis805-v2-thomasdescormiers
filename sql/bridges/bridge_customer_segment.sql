CREATE OR REPLACE TABLE bridge_customer_segment AS
SELECT
    b.bridge_id,
    c.customer_key,
    b.customer_id,
    b.segment,
    CAST(b.weight AS DECIMAL(8, 4)) AS weight,
    CAST(b.effective_date AS DATE) AS effective_date,
    CAST(b.is_primary AS BOOLEAN) AS is_primary
FROM raw_bridge_customer_segment b
LEFT JOIN dim_customer c
       ON b.customer_id = c.customer_id
      AND c.is_current = TRUE
WHERE c.customer_key IS NOT NULL;
