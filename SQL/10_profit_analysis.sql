-- Query to understand about some of the columns in the dataco_cleaned table, including order details, sales, and profit per order
SELECT
    order_id,
    customer_id,
    order_item_product_price,
    order_item_discount,
    order_item_quantity,
    order_item_total,
    benefit_per_order,
    sales,
    sales_per_customer
FROM dataco_cleaned
LIMIT 100;

-- Query to analyze profit by calculating total sales, total profit, and average profit per order from the dataco_cleaned table
SELECT 
    COUNT(*) as total_rows,
    COUNT(benefit_per_order) FILTER (WHERE benefit_per_order < 0) as total_loss_orders,
    MIN(benefit_per_order) as lowest_profit,
    MAX(benefit_per_order) as highest_profit,
    AVG(benefit_per_order) as average_profit,
    COUNT(*) - COUNT(order_zipcode) as null_values 
FROM dataco_cleaned;

-- Query to analyze profit by calculating total sales and total profit from the dataco_cleaned table
SELECT
    count(*) AS total_orders,
    SUM(sales) AS total_gross_sales,
    SUM(sales_per_customer) AS total_net_sales,
    SUM(benefit_per_order) AS total_profit
FROM dataco_cleaned
LIMIT 100;

-- Query to analyze profit by market, calculating total sales, total profit, and profit margin percentage
SELECT 
    market,
    SUM(sales) AS total_sales,
    SUM(benefit_per_order) AS total_profit,
    ROUND((SUM(benefit_per_order) / NULLIF(SUM(sales), 0)) * 100, 2) AS profit_margin_pct,
    COUNT(order_id) AS total_orders
FROM dataco_cleaned
GROUP BY market
ORDER BY profit_margin_pct DESC;

-- Query to analyze profit by product category, calculating total sales, total profit, and profit margin percentage
SELECT 
    category_name,
    SUM(sales_per_customer) AS total_sales,
    SUM(benefit_per_order) AS total_profit,
    ROUND((SUM(benefit_per_order) / NULLIF(SUM(sales_per_customer), 0)) * 100, 2) AS margin_pct
FROM dataco_cleaned
GROUP BY category_name
ORDER BY total_profit DESC;

-- Analyze the impact of discounts on profit by making a bucket and calculating total sales, total profit, and profit margin percentage for each discount bucket
SELECT
    CASE
        WHEN order_item_discount_rate = 0 THEN 'No Discount'
        WHEN order_item_discount <= 0.1 THEN 'Low Discount (0-10%)'
        WHEN order_item_discount <= 0.3 THEN 'Medium Discount (10-30%)'
        ELSE 'High Discount (>30%)'
    END AS discount_tier,
    COUNT(*) AS total_orders,
    SUM(sales_per_customer) AS total_sales,
    SUM(benefit_per_order) AS total_profit,
    ROUND(AVG(benefit_per_order), 2) AS avg_profit_per_order,
    ROUND(AVG(sales_per_customer), 2) AS avg_sales_per_customer
FROM dataco_cleaned
GROUP BY discount_tier
ORDER BY avg_profit_per_order DESC;

-- Trend analysis of profit over time by calculating total sales, total profit, and profit margin percentage for each month
SELECT
    DATE_TRUNC('month', order_date) as order_month,
    SUM(sales_per_customer) AS total_sales,
    SUM(benefit_per_order) AS total_profit,
    ROUND((SUM(benefit_per_order) / NULLIF(SUM(sales_per_customer), 0)) * 100, 2) AS profit_margin_pct
FROM dataco_cleaned
GROUP BY order_month
ORDER BY order_month;

-- Analyze top 10 product with lowest profit by calculating total sales, total profit, and profit margin percentage for each product
SELECT
    product_name,
    category_name,
    COUNT(*) as total_orders,
    SUM(benefit_per_order) AS total_profit,
    SUM(sales_per_customer) AS total_sales,
    ROUND((SUM(benefit_per_order) / NULLIF(SUM(sales_per_customer), 0)) * 100, 2) AS profit_margin_pct
FROM dataco_cleaned
GROUP BY product_name, category_name
ORDER BY total_profit ASC
LIMIT 10;

-- Cleaned Profit Analysis Query by order status, calculating total orders, total sales, and total profit for each order status
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(sales_per_customer) AS total_sales,
    SUM(benefit_per_order) AS total_profit
FROM dataco_cleaned
GROUP BY order_status
ORDER BY total_profit DESC;

-- Analyze profit by Order Status as Buckets, calculating total orders, total sales, and total profit for each order status bucket
SELECT
    CASE
        WHEN order_status IN ('COMPLETE', 'CLOSED') THEN 'Full Profit'
        WHEN order_status IN ('PROCESSING', 'PENDING', 'PENDING_PAYMENT', 'ON_HOLD', 'PAYMENT_REVIEW') THEN 'Potential Profit'
        ELSE 'Lost/Risky'
    END AS profit_realization_status,
    COUNT(*) AS total_orders,
    SUM(sales_per_customer) AS total_sales,
    SUM(benefit_per_order) AS total_profit
FROM dataco_cleaned
GROUP BY profit_realization_status
ORDER BY total_profit DESC;

-- Analyze Cost vs Sales Ratio by Calculating total sales, total profit, and cost to sales ratio
SELECT
    SUM(sales_per_customer) AS total_sales,
    SUM(benefit_per_order) AS total_profit,
    ROUND((SUM(sales_per_customer) - SUM(benefit_per_order)) / NULLIF(SUM(sales_per_customer), 0), 2) AS cost_to_sales_ratio
FROM dataco_cleaned;

-- Analyze Customer Segmentation by Profitability by calculating total sales, total profit, and average profit per customer for each customer segment
WITH customer_profitability AS (
    SELECT
        customer_id,
        SUM(sales_per_customer) AS total_sales,
        SUM(benefit_per_order) AS total_profit,
        AVG(benefit_per_order) AS avg_profit_per_order
    FROM dataco_cleaned
    GROUP BY customer_id
), customer_segments AS (
    SELECT
        customer_id,
        total_profit,
        NTILE(4) OVER (ORDER BY total_profit DESC) AS profitability_quartile
    FROM customer_profitability
)
-- Percentage of Total Company Profit by Customer Segment, calculating total profit and percentage of total profit for each customer segment
SELECT
    profitability_quartile,
    SUM(total_profit) AS segment_total_profit,
    ROUND((SUM(total_profit) / NULLIF((SELECT SUM(total_profit) FROM customer_profitability), 0)) * 100, 2) AS pct_of_total_profit
FROM customer_segments
GROUP BY profitability_quartile
ORDER BY profitability_quartile;