
-- ==========================================
-- PRODUCTION VS STAGING DATA QUALITY
-- ==========================================

SELECT
    'Duplicate Customer ID' AS quality_check,
    (
        SELECT COUNT(*) - COUNT(DISTINCT customer_id)
        FROM customers
    ) AS production_issues,
    (
        SELECT COUNT(*) - COUNT(DISTINCT customer_id)
        FROM staging.customers
    ) AS staging_issues

UNION ALL

SELECT
    'Missing Customer Name',
    (
        SELECT COUNT(*)
        FROM customers
        WHERE customer_name IS NULL
    ),
    (
        SELECT COUNT(*)
        FROM staging.customers
        WHERE customer_name IS NULL
    )

UNION ALL

SELECT
    'Invalid Rating',
    (
        SELECT COUNT(*)
        FROM customer_reviews
        WHERE rating NOT BETWEEN 1 AND 5
           OR rating IS NULL
    ),
    (
        SELECT COUNT(*)
        FROM staging.customer_reviews
        WHERE rating NOT BETWEEN 1 AND 5
           OR rating IS NULL
    )

UNION ALL

SELECT
    'Invalid Date',
    0,
    (
        SELECT COUNT(*)
        FROM staging.transactions
        WHERE transaction_datetime !~
            '^[0-9]{4}-[0-9]{2}-[0-9]{2}'
    );
