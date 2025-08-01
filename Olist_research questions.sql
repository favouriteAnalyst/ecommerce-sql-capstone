--Q1: What is the average delivery time by state?
SELECT 
    customer_state,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    COUNT(DISTINCT order_id) AS total_orders
FROM joined_orders_dataset

GROUP BY customer_state
ORDER BY avg_delivery_days DESC;


-- Q2. What is the count of each order status?
SELECT 
    order_status,
    COUNT(*) AS total_orders
FROM joined_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

--Q3: Which product categories generate the highest revenue?
SELECT 
    product_category_name_english,
    ROUND(SUM(price), 2) AS total_revenue,
    COUNT(product_id) AS items_sold
FROM joined_orders_dataset
GROUP BY product_category_name_english
ORDER BY total_revenue DESC;

--Q4: What is the average freight value by category?
SELECT 
    product_category_name_english,
    ROUND(AVG(freight_value), 2) AS avg_freight
FROM joined_orders_dataset
GROUP BY product_category_name_english
ORDER BY avg_freight DESC;

--Q5: What is the average review score per product category?
SELECT 
    product_category_name_english,
    ROUND(AVG(review_score), 0) AS avg_review_score,
    COUNT(review_score) AS review_count
FROM joined_orders_dataset
WHERE review_score IS NOT NULL
GROUP BY product_category_name_english
ORDER BY avg_review_score ASC;

--Do delivery delays affect review scores?
SELECT 
    review_score,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    COUNT(*) AS review_count
FROM joined_orders_dataset
WHERE review_score IS NOT NULL AND delivery_days IS NOT NULL
GROUP BY review_score
ORDER BY review_score;
