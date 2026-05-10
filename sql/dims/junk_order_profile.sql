CREATE OR REPLACE TABLE junk_order_profile AS
SELECT
    ROW_NUMBER() OVER (
        ORDER BY
            is_gift_wrapped,
            is_express_shipping,
            is_loyalty_redeemed,
            is_promo_applied,
            is_employee_purchase,
            is_online_pickup,
            is_fragile,
            is_oversized
    ) AS order_profile_key,
    CAST(is_gift_wrapped AS BOOLEAN) AS is_gift_wrapped,
    CAST(is_express_shipping AS BOOLEAN) AS is_express_shipping,
    CAST(is_loyalty_redeemed AS BOOLEAN) AS is_loyalty_redeemed,
    CAST(is_promo_applied AS BOOLEAN) AS is_promo_applied,
    CAST(is_employee_purchase AS BOOLEAN) AS is_employee_purchase,
    CAST(is_online_pickup AS BOOLEAN) AS is_online_pickup,
    CAST(is_fragile AS BOOLEAN) AS is_fragile,
    CAST(is_oversized AS BOOLEAN) AS is_oversized
FROM (
    SELECT DISTINCT
        is_gift_wrapped,
        is_express_shipping,
        is_loyalty_redeemed,
        is_promo_applied,
        is_employee_purchase,
        is_online_pickup,
        is_fragile,
        is_oversized
    FROM raw_orders
) profiles;
