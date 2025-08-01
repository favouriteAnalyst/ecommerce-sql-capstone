                                                                   --EXPOLRATORY DATA ANALYSIS


                                                                       --CUSTOMER INSIGHTS

-- Count of unique customers in the dataset
SELECT COUNT(DISTINCT customer_id) AS total_customers 
FROM joined_orders_dataset;                                                                                 

-- Count of customers grouped by their state of residence
SELECT 
    customer_state, 
    COUNT(*) AS customer_count
FROM joined_orders_dataset
GROUP BY customer_state
ORDER BY customer_count DESC;


                                                                          -- ORDER INSIGHTS

-- Total number of orders placed
SELECT COUNT(order_id) AS total_orders 
FROM joined_orders_dataset;

-- Count of orders by their current status (delivered, shipped, etc.)
SELECT 
    order_status, 
    COUNT(*) AS count
FROM joined_orders_dataset
GROUP BY order_status;

-- Number of orders placed per month to analyze trends over time
SELECT 
    FORMAT(order_purchase_timestamp, 'yyyy-MM') AS order_month,
    COUNT(*) AS order_count
FROM joined_orders_dataset
GROUP BY FORMAT(order_purchase_timestamp, 'yyyy-MM')
ORDER BY order_count desc

--cumulative monthly orders 
SELECT 
    FORMAT(order_purchase_timestamp, 'MM') AS order_month,
    COUNT(*) AS order_count
FROM joined_orders_dataset
GROUP BY FORMAT(order_purchase_timestamp, 'MM')
ORDER BY order_count desc

                                                                    --SALES INSIGHT

-- Total revenue generated from product sales (excluding freight)
SELECT SUM(price) AS total_revenue 
FROM joined_orders_dataset

-- Average order value across all orders
SELECT AVG(total) AS average_order_value
FROM (
    SELECT 
        order_id, 
        SUM(price) AS total
   FROM joined_orders_dataset
    GROUP BY order_id) AS order_totals;

-- Top 10 product categories by total sales revenue
SELECT TOP 10
    product_category_name_english AS category,
    SUM(price) AS category_revenue
FROM joined_orders_dataset
WHERE product_category_name_english IS NOT NULL
GROUP BY product_category_name_english
ORDER BY category_revenue DESC;



                                                               --SHOPPING INSIGHTS
-- Average number of days between order and delivery
SELECT 
    AVG(DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date)) AS avg_delivery_days
FROM joined_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL;

-- Compare average product price vs average freight cost
SELECT 
    AVG(price) AS avg_product_price,
    AVG(freight_value) AS avg_freight_cost
FROM joined_orders_dataset


                                                              --REVIEW INSIGHTS
-- Average review score across all orders
SELECT 
    AVG(review_score) AS avg_review_score 
FROM joined_orders_dataset

-- Distribution of review scores (1 to 5)
SELECT 
    review_score, 
    COUNT(*) AS review_count
FROM joined_orders_dataset
GROUP BY review_score
ORDER BY review_score;

																	 


