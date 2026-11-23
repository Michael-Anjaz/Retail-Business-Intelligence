
-- 1. Total Revenue
SELECT
    SUM(grand_total) AS total_revenue
FROM transactions
WHERE transaction_status = 'Completed';

-- 2. Total Transactions
SELECT
    COUNT(*) AS total_transactions
FROM transactions
WHERE transaction_status = 'Completed';

-- 3. Average Order Value
SELECT
    ROUND(AVG(grand_total), 2) AS average_order_value
FROM transactions
WHERE transaction_status = 'Completed';

-- 4. Sales by Branch
SELECT
    b.branch_name,
    SUM(t.grand_total) AS total_revenue
FROM transactions t
JOIN branches b ON t.branch_id = b.branch_id
WHERE t.transaction_status = 'Completed'
GROUP BY b.branch_name
ORDER BY total_revenue DESC;

-- 5. Sales by Category
SELECT
    c.category_name,
    SUM(ti.line_total) AS total_revenue
FROM transaction_items ti
JOIN products p ON ti.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN transactions t ON ti.transaction_id = t.transaction_id
WHERE t.transaction_status = 'Completed'
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- 6. Monthly Sales
SELECT
    DATE_TRUNC('month', transaction_datetime)::DATE AS month,
    SUM(grand_total) AS total_revenue
FROM transactions
WHERE transaction_status = 'Completed'
GROUP BY month
ORDER BY month;

-- 7. Payment Method
SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(grand_total) AS total_revenue
FROM transactions
WHERE transaction_status = 'Completed'
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- 8. Customer Rating
SELECT
    ROUND(AVG(rating), 2) AS average_rating,
    COUNT(*) AS total_reviews
FROM customer_reviews;
