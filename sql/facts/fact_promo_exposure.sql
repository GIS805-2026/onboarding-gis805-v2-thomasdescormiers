-- GRAIN : une ligne = une exposition client a une campagne marketing.
CREATE OR REPLACE TABLE fact_promo_exposure AS
SELECT
    pe.exposure_id,
    d.date_key AS exposure_date_key,
    c.customer_key,
    ch.channel_key,
    pe.campaign_id,
    pe.customer_id,
    pe.channel_id,
    1 AS exposure_count
FROM raw_fact_promo_exposure pe
LEFT JOIN dim_date d
       ON CAST(pe.exposure_date AS DATE) = d.date_key
LEFT JOIN dim_customer c
       ON pe.customer_id = c.customer_id
      AND c.is_current = TRUE
LEFT JOIN dim_channel ch
       ON pe.channel_id = ch.channel_id;
