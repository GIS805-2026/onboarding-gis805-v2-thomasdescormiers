-- GRAIN : une ligne = une commande suivie dans le pipeline de livraison.
CREATE OR REPLACE TABLE fact_order_pipeline AS
SELECT
    op.pipeline_id,
    op.order_id,
    order_d.date_key AS order_date_key,
    payment_d.date_key AS payment_date_key,
    pick_d.date_key AS pick_date_key,
    ship_d.date_key AS ship_date_key,
    delivery_d.date_key AS delivery_date_key,
    c.customer_key,
    p.product_key,
    s.store_key,
    op.customer_id,
    op.product_id,
    op.store_id,
    op.current_status,
    CAST(op.days_order_to_deliver AS INTEGER) AS days_order_to_deliver
FROM raw_fact_order_pipeline op
LEFT JOIN dim_date order_d
       ON CAST(op.order_date AS DATE) = order_d.date_key
LEFT JOIN dim_date payment_d
       ON CAST(op.payment_date AS DATE) = payment_d.date_key
LEFT JOIN dim_date pick_d
       ON CAST(op.pick_date AS DATE) = pick_d.date_key
LEFT JOIN dim_date ship_d
       ON CAST(op.ship_date AS DATE) = ship_d.date_key
LEFT JOIN dim_date delivery_d
       ON CAST(op.delivery_date AS DATE) = delivery_d.date_key
LEFT JOIN dim_customer c
       ON op.customer_id = c.customer_id
      AND c.is_current = TRUE
LEFT JOIN dim_product p
       ON op.product_id = p.product_id
LEFT JOIN dim_store s
       ON op.store_id = s.store_id;
