-- GIS805 S03 - SCD Type 1 vs Type 2 demonstration
-- Question CEO: which dimension changes preserve historical truth?
--
-- This script is intentionally self-contained. It loads the S03 change
-- events from CSV and creates Type 1 and Type 2 versions side by side.

-- %%
-- Cell 1 - Load S03 source data as temporary tables
CREATE OR REPLACE TEMP TABLE s03_raw_dim_customer AS
SELECT *
FROM read_csv_auto('data/synthetic/team_165278886/shared/dim_customer.csv');

CREATE OR REPLACE TEMP TABLE s03_raw_fact_sales AS
SELECT *
FROM read_csv_auto('data/synthetic/team_165278886/s02/fact_sales.csv');

CREATE OR REPLACE TEMP TABLE s03_raw_customer_changes AS
SELECT *
FROM read_csv_auto('data/synthetic/team_165278886/s03/customer_changes.csv');


-- Keep the latest segment change per customer for a clear side-by-side demo.

-- %%
-- Cell 2 - Keep current_value and historical_value for changed customers
CREATE OR REPLACE TEMP TABLE s03_latest_segment_change AS
SELECT
    customer_id,
    CAST(change_date AS DATE) AS change_date,
    old_value AS historical_value,
    new_value AS current_value,
    old_value AS old_segment,
    new_value AS new_segment
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY CAST(change_date AS DATE) DESC
        ) AS rn
    FROM s03_raw_customer_changes
    WHERE field_changed = 'segment'
) changes
WHERE rn = 1;

-- Explicit current vs historical schema required by the S03 rubric.
SELECT
    customer_id,
    change_date,
    historical_value,
    current_value
FROM s03_latest_segment_change
ORDER BY change_date
LIMIT 10;

-- ============================================================
-- TYPE 1: overwrite current dimension value, no history kept.
-- ============================================================

-- %%
-- Cell 3 - Build Type 1 customer dimension
CREATE OR REPLACE TEMP TABLE s03_dim_customer_type1 AS
SELECT
    ROW_NUMBER() OVER (ORDER BY c.customer_id) AS customer_key,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email_domain,
    c.city,
    c.province,
    COALESCE(sc.new_segment, c.loyalty_segment) AS loyalty_segment,
    CAST(c.join_date AS DATE) AS join_date
FROM s03_raw_dim_customer c
LEFT JOIN s03_latest_segment_change sc
       ON c.customer_id = sc.customer_id;

-- This report is intentionally wrong for history. Every sale for a changed
-- customer is reported under the customer's latest segment.

-- %%
-- Cell 4 - Build the incorrect Type 1 report
CREATE OR REPLACE TEMP TABLE s03_report_type1_segment_revenue AS
SELECT
    d.loyalty_segment AS reported_segment,
    ROUND(SUM(f.line_total), 2) AS revenue_type1
FROM s03_raw_fact_sales f
JOIN s03_dim_customer_type1 d
  ON f.customer_id = d.customer_id
JOIN s03_latest_segment_change sc
  ON f.customer_id = sc.customer_id
GROUP BY 1;

-- ============================================================
-- TYPE 2: add a new row per historical version.
-- ============================================================

-- %%
-- Cell 5 - Build Type 2 customer dimension with date ranges
CREATE OR REPLACE TEMP TABLE s03_dim_customer_type2 AS
WITH base_changed_customers AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.first_name || ' ' || c.last_name AS full_name,
        c.email_domain,
        c.city,
        c.province,
        CAST(c.join_date AS DATE) AS join_date,
        sc.change_date,
        sc.old_segment,
        sc.new_segment
    FROM s03_raw_dim_customer c
    JOIN s03_latest_segment_change sc
      ON c.customer_id = sc.customer_id
),
unchanged_customers AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.first_name || ' ' || c.last_name AS full_name,
        c.email_domain,
        c.city,
        c.province,
        c.loyalty_segment,
        CAST(c.join_date AS DATE) AS join_date,
        CAST('1900-01-01' AS DATE) AS valid_from,
        CAST(NULL AS DATE) AS valid_to,
        TRUE AS is_current
    FROM s03_raw_dim_customer c
    LEFT JOIN s03_latest_segment_change sc
           ON c.customer_id = sc.customer_id
    WHERE sc.customer_id IS NULL
),
old_versions AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        full_name,
        email_domain,
        city,
        province,
        old_segment AS loyalty_segment,
        join_date,
        CAST('1900-01-01' AS DATE) AS valid_from,
        change_date AS valid_to,
        FALSE AS is_current
    FROM base_changed_customers
),
new_versions AS (
    SELECT
        customer_id,
        first_name,
        last_name,
        full_name,
        email_domain,
        city,
        province,
        new_segment AS loyalty_segment,
        join_date,
        change_date AS valid_from,
        CAST(NULL AS DATE) AS valid_to,
        TRUE AS is_current
    FROM base_changed_customers
),
all_versions AS (
    SELECT * FROM unchanged_customers
    UNION ALL
    SELECT * FROM old_versions
    UNION ALL
    SELECT * FROM new_versions
)
SELECT
    ROW_NUMBER() OVER (ORDER BY customer_id, valid_from, loyalty_segment) AS customer_key,
    *
FROM all_versions;

-- This report is correct for history. The sale joins to the customer version
-- that was valid on the order date.

-- %%
-- Cell 6 - Build the correct Type 2 report
CREATE OR REPLACE TEMP TABLE s03_report_type2_segment_revenue AS
SELECT
    d.loyalty_segment AS reported_segment,
    ROUND(SUM(f.line_total), 2) AS revenue_type2
FROM s03_raw_fact_sales f
JOIN s03_dim_customer_type2 d
  ON f.customer_id = d.customer_id
 AND CAST(f.order_date AS DATE) >= d.valid_from
 AND (
        d.valid_to IS NULL
        OR CAST(f.order_date AS DATE) < d.valid_to
     )
JOIN s03_latest_segment_change sc
  ON f.customer_id = sc.customer_id
GROUP BY 1;

-- ============================================================
-- Executive proof: wrong Type 1 vs correct Type 2.
-- ============================================================

-- %%
-- Cell 7 - Main proof: side-by-side Type 1 vs Type 2 comparison
CREATE OR REPLACE TEMP TABLE s03_type1_vs_type2_comparison AS
SELECT
    COALESCE(t1.reported_segment, t2.reported_segment) AS segment,
    COALESCE(t1.revenue_type1, 0) AS revenue_type1,
    COALESCE(t2.revenue_type2, 0) AS revenue_type2,
    ROUND(
        COALESCE(t1.revenue_type1, 0) - COALESCE(t2.revenue_type2, 0),
        2
    ) AS distortion
FROM s03_report_type1_segment_revenue t1
FULL OUTER JOIN s03_report_type2_segment_revenue t2
  ON t1.reported_segment = t2.reported_segment
ORDER BY ABS(distortion) DESC;

SELECT *
FROM s03_type1_vs_type2_comparison;

-- Example detail: sales before the change keep the old segment in Type 2.

-- %%
-- Cell 8 - Detail example for one changed customer
SELECT
    f.customer_id,
    f.order_date,
    sc.change_date,
    sc.old_segment,
    sc.new_segment,
    d.loyalty_segment AS type2_segment_used,
    ROUND(f.line_total, 2) AS line_total
FROM s03_raw_fact_sales f
JOIN s03_latest_segment_change sc
  ON f.customer_id = sc.customer_id
JOIN s03_dim_customer_type2 d
  ON f.customer_id = d.customer_id
 AND CAST(f.order_date AS DATE) >= d.valid_from
 AND (
        d.valid_to IS NULL
        OR CAST(f.order_date AS DATE) < d.valid_to
     )
WHERE f.customer_id = 'CUS-00091'
ORDER BY f.order_date
LIMIT 20;

-- Validation 1: Type 2 has only one current row per customer.

-- %%
-- Cell 9 - Validation: one current Type 2 row per customer
SELECT
    'one_current_row_per_customer' AS validation_check,
    CASE WHEN MAX(current_rows) = 1 THEN 'PASS' ELSE 'FAIL' END AS result
FROM (
    SELECT customer_id, COUNT(*) AS current_rows
    FROM s03_dim_customer_type2
    WHERE is_current = TRUE
    GROUP BY customer_id
) current_counts;

-- Validation 2: every changed-customer sale joins to exactly one Type 2 row.

-- %%
-- Cell 10 - Validation: each changed-customer sale joins one Type 2 version
SELECT
    'every_changed_customer_sale_has_one_type2_version' AS validation_check,
    CASE WHEN COUNT(*) = SUM(version_matches) THEN 'PASS' ELSE 'FAIL' END AS result
FROM (
    SELECT
        f.order_number,
        f.sale_line_id,
        COUNT(d.customer_key) AS version_matches
    FROM s03_raw_fact_sales f
    JOIN s03_latest_segment_change sc
      ON f.customer_id = sc.customer_id
    LEFT JOIN s03_dim_customer_type2 d
      ON f.customer_id = d.customer_id
     AND CAST(f.order_date AS DATE) >= d.valid_from
     AND (
            d.valid_to IS NULL
            OR CAST(f.order_date AS DATE) < d.valid_to
         )
    GROUP BY 1, 2
) joined_sales;

-- Validation 3: inventory of S03 customer changes.

-- %%
-- Cell 11 - Inventory of customer changes loaded from customer_changes.csv
SELECT
    field_changed,
    change_type,
    COUNT(*) AS change_count
FROM s03_raw_customer_changes
GROUP BY 1, 2
ORDER BY 1, 2;

-- %%
-- Cell 12 - Final output if you run the whole file
SELECT *
FROM s03_type1_vs_type2_comparison;
