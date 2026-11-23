
-- ==========================================
-- RETAIL BUSINESS INTELLIGENCE
-- STAGING DATA QUALITY SIMULATION
-- ==========================================

CREATE SCHEMA IF NOT EXISTS staging;

DROP TABLE IF EXISTS staging.customers;
DROP TABLE IF EXISTS staging.customer_reviews;
DROP TABLE IF EXISTS staging.transactions;

-- 1. Salin data customers
CREATE TABLE staging.customers AS
SELECT customer_id, customer_name
FROM customers;

-- 2. Salin data customer reviews
CREATE TABLE staging.customer_reviews AS
SELECT review_id, rating
FROM customer_reviews;

-- 3. Salin data transactions
-- Tanggal diubah menjadi TEXT agar bisa
-- menampung format tanggal yang salah.
CREATE TABLE staging.transactions AS
SELECT
    transaction_id,
    transaction_datetime::TEXT AS transaction_datetime
FROM transactions;

-- ==========================================
-- INJECT CONTROLLED DATA QUALITY ISSUES
-- ==========================================

-- A. Duplikasi customer ID
INSERT INTO staging.customers
SELECT customer_id, customer_name
FROM staging.customers
ORDER BY customer_id
LIMIT 1;

-- B. Nilai customer_name kosong
UPDATE staging.customers
SET customer_name = NULL
WHERE customer_id = (
    SELECT MIN(customer_id)
    FROM staging.customers
);

-- C. Rating di luar rentang valid
UPDATE staging.customer_reviews
SET rating = 6
WHERE review_id = (
    SELECT MIN(review_id)
    FROM staging.customer_reviews
);

-- D. Format tanggal tidak valid
UPDATE staging.transactions
SET transaction_datetime = 'tanggal-rusak'
WHERE transaction_id = (
    SELECT MIN(transaction_id)
    FROM staging.transactions
);

-- ==========================================
-- VERIFY INJECTED ISSUES
-- ==========================================

-- Cek duplikasi
SELECT
    COUNT(*) - COUNT(DISTINCT customer_id)
    AS duplicate_customer_ids
FROM staging.customers;

-- Cek nilai kosong
SELECT
    COUNT(*) FILTER (
        WHERE customer_name IS NULL
    ) AS missing_customer_names
FROM staging.customers;

-- Cek rating tidak valid
SELECT
    COUNT(*) AS invalid_ratings
FROM staging.customer_reviews
WHERE rating NOT BETWEEN 1 AND 5
   OR rating IS NULL;

-- Cek format tanggal tidak valid
SELECT
    COUNT(*) AS invalid_dates
FROM staging.transactions
WHERE transaction_datetime !~
    '^[0-9]{4}-[0-9]{2}-[0-9]{2}';
