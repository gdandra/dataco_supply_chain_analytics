-- Create view for profit analysis
CREATE OR REPLACE VIEW v_profit_analysis AS
WITH customer_profitability AS(
    SELECT
        customer_id,
        SUM(sales_per_customer) AS total_sales,
        SUM(benefit_per_order) AS total_profit,
        ROUND((SUM(benefit_per_order) / NULLIF(SUM(sales_per_customer), 0)) * 100, 2) AS profit_margin_pct
    FROM dataco_cleaned
    GROUP BY customer_id
), customer_segments AS (
    SELECT
        customer_id,
        total_profit,
        NTILE(4) OVER (ORDER BY total_profit DESC) AS profit_quartile
    FROM customer_profitability
)
SELECT
    t.order_id,
    t.order_date::TIMESTAMP AS order_date,
    t.market,
    t.order_zipcode,
    t.category_name,
    t.product_name,
    t.customer_id,
    t.customer_segment,
    t.sales_per_customer AS net_sales,
    t.benefit_per_order AS profit,
    (t.sales_per_customer - t.benefit_per_order) AS total_cost,

    CASE
        WHEN order_item_discount_rate = 0 THEN 'No Discount'
        WHEN order_item_discount_rate <= 0.1 THEN 'Low Discount (0-10%)'
        WHEN order_item_discount_rate <= 0.15 THEN 'Medium Discount (10-15%)'
        ELSE 'High Discount (>15%)'
    END AS discount_tier,

    CASE
        WHEN order_status IN ('COMPLETE', 'CLOSED') THEN 'Full Profit'
        WHEN order_status IN ('PROCESSING', 'PENDING', 'PENDING_PAYMENT', 'ON_HOLD', 'PAYMENT_REVIEW') THEN 'Potential Profit'
        ELSE 'Lost/Risky'
    END AS profit_realization_status,

    s.profit_quartile AS customer_profit_tier,
    t.order_country,
    t.order_item_discount_rate
FROM dataco_cleaned t
JOIN customer_segments s ON t.customer_id = s.customer_id;
