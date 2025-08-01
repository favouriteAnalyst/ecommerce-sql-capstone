--DATA CLEANING
--CHECK FOR NULLS
-- Check NULLs in customers table
SELECT 'customers.customer_id' AS ColumnName, SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS NullCount FROM customers
UNION ALL
SELECT 'customers.customer_unique_id', SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) FROM customers
UNION ALL
SELECT 'customers.customer_zip_code_prefix', SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) FROM customers
UNION ALL
SELECT 'customers.customer_city', SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) FROM customers
UNION ALL
SELECT 'customers.customer_state', SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) FROM customers

-- Check NULLs in order_items table
SELECT 'order_items.order_id', SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) FROM order_items
UNION ALL
SELECT 'order_items.order_item_id', SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) FROM order_items
UNION ALL
SELECT 'order_items.product_id', SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) FROM order_items
UNION ALL
SELECT 'order_items.seller_id', SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) FROM order_items
UNION ALL
SELECT 'order_items.shipping_limit_date', SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) FROM order_items
UNION ALL
SELECT 'order_items.price', SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) FROM order_items
UNION ALL
SELECT 'order_items.freight_value', SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) FROM order_items



-- Check NULLs in order_reviews table
SELECT 'order_reviews.review_id', SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) FROM order_reviews
UNION ALL
SELECT 'order_reviews.order_id', SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) FROM order_reviews
UNION ALL
SELECT 'order_reviews.review_score', SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) FROM order_reviews
UNION ALL
SELECT 'order_reviews.review_comment_title', SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) FROM order_reviews
UNION ALL
SELECT 'order_reviews.review_comment_message', SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) FROM order_reviews
UNION ALL
SELECT 'order_reviews.review_creation_date', SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) FROM order_reviews
UNION ALL
SELECT 'order_reviews.review_answer_timestamp', SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) FROM order_reviews

-- Check NULLs in orders table
SELECT 'orders.order_id', SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) FROM orders
UNION ALL
SELECT 'orders.customer_id', SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) FROM orders
UNION ALL
SELECT 'orders.order_status', SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) FROM orders
UNION ALL
SELECT 'orders.order_purchase_timestamp', SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) FROM orders
UNION ALL
SELECT 'orders.order_approved_at', SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) FROM orders
UNION ALL
SELECT 'orders.order_delivered_carrier_date', SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) FROM orders
UNION ALL
SELECT 'orders.order_delivered_customer_date', SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) FROM orders
UNION ALL
SELECT 'orders.order_estimated_delivery_date', SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) FROM orders

select * from orders

-- Check NULLs in products table
SELECT 'products.product_id', SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_category_name', SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_name_lenght', SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_description_lenght', SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_photos_qty', SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_weight_g', SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_length_cm', SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_height_cm', SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) FROM products
UNION ALL
SELECT 'products.product_width_cm', SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) FROM products



--CHECKING FOR DUPLICATES TABLE BY TABLE
SELECT customer_id, COUNT(*) AS Count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id, COUNT(*) AS Count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT order_id, order_item_id, COUNT(*) AS Count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT review_id, COUNT(*) AS Count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

--to check for identitical rows
SELECT *
FROM order_reviews_clean
WHERE review_id = '59294cb7699ef93d259c880d02b00ec1';


--backing up original table for precaution reasons
SELECT * 
INTO order_reviews_backup 
FROM order_reviews;

--removing duplicates
WITH ranked_reviews AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY review_id ORDER BY order_id) AS rn
    FROM order_reviews
)
SELECT *
INTO order_reviews_clean                       
FROM ranked_reviews
WHERE rn = 1;

SELECT * from order_reviews_clean

--translating the product category name column from portuguise to english
  SELECT 
    p.product_id,
    p.product_category_name,
    t.column2 AS translated_category,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM 
    products p
LEFT JOIN (
    SELECT *
    FROM product_category_name_translation
    WHERE column1 <> 'product_category_name'
) t
ON p.product_category_name = t.column1;


-- Add a new column for English translation
ALTER TABLE products
ADD product_category_name_english VARCHAR(100);

-- Populate English category names by joining with translation table
UPDATE p
SET p.product_category_name_english = t.column2
FROM products p
LEFT JOIN (
    SELECT *
    FROM product_category_name_translation
    WHERE column1 <> 'product_category_name'
) t
ON p.product_category_name = t.column1;

-- Create a new table with English name as second column
CREATE TABLE products_new (                                           
    product_id VARCHAR(50),
    product_category_name_english VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g FLOAT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- Insert data from old table into new one
INSERT INTO products_new
SELECT 
    product_id,
    product_category_name_english,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM products;

--adjusting for accurate datatype
ALTER TABLE order_reviews_clean
ALTER COLUMN review_score FLOAT;

--adjusting for accurate datatype
ALTER TABLE order_payments
ALTER COLUMN payment_installments INT;  


																		--join tables to form main table

SELECT 
    -- Order details
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    -- Customer details
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,

    -- Order item and pricing details
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value,

    -- Product metadata
    p.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,

    -- Customer review score
    r.review_score

-- Store result into a new table for persistent analysis
INTO joined_orders_dataset

FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
LEFT JOIN products_new p 
    ON oi.product_id = p.product_id
LEFT JOIN order_reviews_clean r 
    ON o.order_id = r.order_id;

