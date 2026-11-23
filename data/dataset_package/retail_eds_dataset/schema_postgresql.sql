CREATE TABLE categories (
  category_id VARCHAR(10) PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE suppliers (
  supplier_id VARCHAR(10) PRIMARY KEY,
  supplier_name VARCHAR(150) NOT NULL,
  supplier_city VARCHAR(100)
);
CREATE TABLE branches (
  branch_id VARCHAR(10) PRIMARY KEY,
  branch_name VARCHAR(150) NOT NULL,
  city VARCHAR(100) NOT NULL,
  region VARCHAR(50)
);
CREATE TABLE customers (
  customer_id VARCHAR(10) PRIMARY KEY,
  customer_name VARCHAR(150) NOT NULL,
  gender VARCHAR(20),
  birth_year INT CHECK (birth_year BETWEEN 1900 AND 2026),
  city VARCHAR(100),
  registration_date DATE,
  membership_tier VARCHAR(20)
);
CREATE TABLE products (
  product_id VARCHAR(10) PRIMARY KEY,
  product_name VARCHAR(150) NOT NULL,
  category_id VARCHAR(10) NOT NULL REFERENCES categories(category_id),
  supplier_id VARCHAR(10) NOT NULL REFERENCES suppliers(supplier_id),
  unit_cost NUMERIC(14,2) CHECK (unit_cost >= 0),
  list_price NUMERIC(14,2) CHECK (list_price >= 0),
  is_active BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE transactions (
  transaction_id VARCHAR(12) PRIMARY KEY,
  transaction_datetime TIMESTAMP NOT NULL,
  branch_id VARCHAR(10) NOT NULL REFERENCES branches(branch_id),
  customer_id VARCHAR(10) NOT NULL REFERENCES customers(customer_id),
  payment_method VARCHAR(30),
  sales_channel VARCHAR(20),
  transaction_status VARCHAR(20) NOT NULL,
  subtotal NUMERIC(14,2) NOT NULL CHECK (subtotal >= 0),
  discount_total NUMERIC(14,2) NOT NULL CHECK (discount_total >= 0),
  grand_total NUMERIC(14,2) NOT NULL CHECK (grand_total >= 0)
);
CREATE TABLE transaction_items (
  transaction_item_id VARCHAR(20) PRIMARY KEY,
  transaction_id VARCHAR(12) NOT NULL REFERENCES transactions(transaction_id),
  product_id VARCHAR(10) NOT NULL REFERENCES products(product_id),
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price NUMERIC(14,2) NOT NULL CHECK (unit_price >= 0),
  discount_amount NUMERIC(14,2) NOT NULL CHECK (discount_amount >= 0),
  line_total NUMERIC(14,2) NOT NULL CHECK (line_total >= 0)
);
CREATE TABLE customer_reviews (
  review_id VARCHAR(12) PRIMARY KEY,
  transaction_id VARCHAR(12) NOT NULL REFERENCES transactions(transaction_id),
  customer_id VARCHAR(10) NOT NULL REFERENCES customers(customer_id),
  product_id VARCHAR(10) NOT NULL REFERENCES products(product_id),
  review_datetime TIMESTAMP NOT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  review_text TEXT NOT NULL,
  sentiment_label VARCHAR(20)
);
CREATE INDEX idx_transactions_datetime ON transactions(transaction_datetime);
CREATE INDEX idx_transactions_branch ON transactions(branch_id);
CREATE INDEX idx_items_product ON transaction_items(product_id);
CREATE INDEX idx_reviews_rating ON customer_reviews(rating);
