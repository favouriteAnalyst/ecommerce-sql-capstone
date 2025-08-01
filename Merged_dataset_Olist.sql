-- STEP 1: Join selected tables to create a unified dataset for analysis
-- Tables: orders, customers, order_items, products_new, order_reviews_clean

SELECT 
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,

    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,

    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value,

    p.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,

    r.review_score

INTO joined_orders_dataset
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products_new p ON oi.product_id = p.product_id
LEFT JOIN order_reviews_clean r ON o.order_id = r.order_id;

-- This creates a physical table named 'joined_orders_dataset' you can now use for all analysis



ALTER TABLE joined_orders_dataset
create delivery_days int;

UPDATE joined_orders_dataset
SET delivery_days = DATEDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)
WHERE order_delivered_customer_date IS NOT NULL;


alter table joined_orders_dataset
alter column delivery_days float

alter table joined_orders_dataset
alter column review_score float

DELETE FROM joined_orders_dataset
WHERE product_category_name_english IS NULL
   OR review_score IS NULL;

   select * from joined_orders_dataset









