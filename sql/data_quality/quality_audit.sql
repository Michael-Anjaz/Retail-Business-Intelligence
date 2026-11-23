SELECT 'customers' AS tabel,
       COUNT(*) FILTER (
           WHERE customer_id IS NULL
              OR customer_name IS NULL
              OR city IS NULL
       ) AS incomplete_records
FROM customers

UNION ALL

SELECT 'products',
       COUNT(*) FILTER (
           WHERE product_id IS NULL
              OR product_name IS NULL
              OR category_id IS NULL
              OR supplier_id IS NULL
       )
FROM products

UNION ALL

SELECT 'transactions',
       COUNT(*) FILTER (
           WHERE transaction_id IS NULL
              OR transaction_datetime IS NULL
              OR branch_id IS NULL
              OR transaction_status IS NULL
       )
FROM transactions

UNION ALL

SELECT 'transaction_items',
       COUNT(*) FILTER (
           WHERE transaction_item_id IS NULL
              OR transaction_id IS NULL
              OR product_id IS NULL
       )
FROM transaction_items;

-- 2. UNIQUENESS
-- Memeriksa duplikasi primary key

SELECT 'customers' AS tabel,
       COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_ids
FROM customers

UNION ALL

SELECT 'products',
       COUNT(*) - COUNT(DISTINCT product_id)
FROM products

UNION ALL

SELECT 'transactions',
       COUNT(*) - COUNT(DISTINCT transaction_id)
FROM transactions

UNION ALL

SELECT 'transaction_items',
       COUNT(*) - COUNT(DISTINCT transaction_item_id)
FROM transaction_items

UNION ALL

SELECT 'customer_reviews',
       COUNT(*) - COUNT(DISTINCT review_id)
FROM customer_reviews;

-- 3. VALIDITY
-- Memeriksa nilai yang tidak sesuai aturan

SELECT COUNT(*) AS invalid_ratings
FROM customer_reviews
WHERE rating NOT BETWEEN 1 AND 5
   OR rating IS NULL;

SELECT COUNT(*) AS invalid_quantities
FROM transaction_items
WHERE quantity <= 0
   OR quantity IS NULL;

SELECT COUNT(*) AS invalid_prices
FROM transaction_items
WHERE unit_price < 0
   OR discount_amount < 0
   OR line_total < 0;

SELECT COUNT(*) AS invalid_transaction_amounts
FROM transactions
WHERE subtotal < 0
   OR discount_total < 0
   OR grand_total < 0;

-- 4. CONSISTENCY
-- Memeriksa hubungan antartabel

SELECT COUNT(*) AS invalid_customer_relations
FROM transactions t
LEFT JOIN customers c
    ON t.customer_id = c.customer_id
WHERE t.customer_id IS NOT NULL
  AND c.customer_id IS NULL;

SELECT COUNT(*) AS invalid_branch_relations
FROM transactions t
LEFT JOIN branches b
    ON t.branch_id = b.branch_id
WHERE b.branch_id IS NULL;

SELECT COUNT(*) AS invalid_category_relations
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;

SELECT COUNT(*) AS invalid_supplier_relations
FROM products p
LEFT JOIN suppliers s
    ON p.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;

SELECT COUNT(*) AS invalid_product_relations
FROM transaction_items ti
LEFT JOIN products p
    ON ti.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS invalid_transaction_relations
FROM transaction_items ti
LEFT JOIN transactions t
    ON ti.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;
