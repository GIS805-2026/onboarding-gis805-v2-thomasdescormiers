-- S04 - Market basket analysis.
-- Question: which products are bought together in the same NexaMart order?
-- Grain read: one row in raw_order_lines = one product line in an order.

WITH basket_pairs AS (
    SELECT
        LEAST(l1.product_id, l2.product_id) AS product_a_id,
        GREATEST(l1.product_id, l2.product_id) AS product_b_id,
        COUNT(DISTINCT l1.order_number) AS orders_together,
        SUM(CAST(l1.line_total AS DECIMAL(12, 2)) + CAST(l2.line_total AS DECIMAL(12, 2))) AS pair_line_total
    FROM raw_order_lines l1
    JOIN raw_order_lines l2
        ON l1.order_number = l2.order_number
       AND l1.product_id < l2.product_id
    GROUP BY
        LEAST(l1.product_id, l2.product_id),
        GREATEST(l1.product_id, l2.product_id)
)
SELECT
    p.product_a_id,
    pa.product_name AS product_a_name,
    pa.category AS product_a_category,
    p.product_b_id,
    pb.product_name AS product_b_name,
    pb.category AS product_b_category,
    p.orders_together,
    CAST(p.pair_line_total AS DECIMAL(12, 2)) AS pair_line_total
FROM basket_pairs p
JOIN dim_product pa
    ON p.product_a_id = pa.product_id
JOIN dim_product pb
    ON p.product_b_id = pb.product_id
ORDER BY
    p.orders_together DESC,
    p.pair_line_total DESC,
    p.product_a_id,
    p.product_b_id
LIMIT 20;
