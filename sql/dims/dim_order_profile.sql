-- S04 - Junk dimension for operational order flags.
-- Grain: one row = one observed combination of the 8 order flags.
-- Facts such as order_count stay outside this dimension.
CREATE OR REPLACE TABLE dim_order_profile AS
WITH distinct_profiles AS (
    SELECT DISTINCT
        CAST(is_gift_wrapped AS BOOLEAN) AS is_gift_wrapped,
        CAST(is_express_shipping AS BOOLEAN) AS is_express_shipping,
        CAST(is_loyalty_redeemed AS BOOLEAN) AS is_loyalty_redeemed,
        CAST(is_promo_applied AS BOOLEAN) AS is_promo_applied,
        CAST(is_employee_purchase AS BOOLEAN) AS is_employee_purchase,
        CAST(is_online_pickup AS BOOLEAN) AS is_online_pickup,
        CAST(is_fragile AS BOOLEAN) AS is_fragile,
        CAST(is_oversized AS BOOLEAN) AS is_oversized
    FROM raw_orders
),
named_profiles AS (
    SELECT
        *,
        CAST(is_gift_wrapped AS INTEGER)
        + CAST(is_express_shipping AS INTEGER)
        + CAST(is_loyalty_redeemed AS INTEGER)
        + CAST(is_promo_applied AS INTEGER)
        + CAST(is_employee_purchase AS INTEGER)
        + CAST(is_online_pickup AS INTEGER)
        + CAST(is_fragile AS INTEGER)
        + CAST(is_oversized AS INTEGER) AS active_flag_count,
        CASE
            WHEN active_flag_count = 0 THEN 'Standard'
            WHEN is_employee_purchase THEN 'Employee order'
            WHEN is_express_shipping AND (is_fragile OR is_oversized)
                THEN 'Priority special handling'
            WHEN is_online_pickup THEN 'Online pickup'
            WHEN is_promo_applied OR is_loyalty_redeemed THEN 'Incentive order'
            WHEN is_gift_wrapped THEN 'Gift order'
            WHEN is_fragile OR is_oversized THEN 'Special handling'
            ELSE 'Operational flags'
        END AS profile_family,
        CASE
            WHEN active_flag_count = 0 THEN 'Standard order'
            ELSE CONCAT_WS(
                ' + ',
                CASE WHEN is_gift_wrapped THEN 'gift' END,
                CASE WHEN is_express_shipping THEN 'express' END,
                CASE WHEN is_loyalty_redeemed THEN 'loyalty' END,
                CASE WHEN is_promo_applied THEN 'promo' END,
                CASE WHEN is_employee_purchase THEN 'employee' END,
                CASE WHEN is_online_pickup THEN 'pickup' END,
                CASE WHEN is_fragile THEN 'fragile' END,
                CASE WHEN is_oversized THEN 'oversized' END
            )
        END AS profile_name
    FROM distinct_profiles
)
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
    profile_name,
    profile_family,
    active_flag_count,
    is_gift_wrapped,
    is_express_shipping,
    is_loyalty_redeemed,
    is_promo_applied,
    is_employee_purchase,
    is_online_pickup,
    is_fragile,
    is_oversized
FROM named_profiles;
