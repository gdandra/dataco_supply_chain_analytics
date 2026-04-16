CREATE TABLE dataco_cleaned (
    -- Identitas & Kategori
    type VARCHAR(50),
    days_for_shipping_real INTEGER,
    days_for_shipment_scheduled INTEGER,
    benefit_per_order NUMERIC(15,2),
    sales_per_customer NUMERIC(15,2),
    delivery_status VARCHAR(50),
    late_delivery_risk INTEGER,
    category_id INTEGER,
    category_name VARCHAR(100),
    
    -- Data Pelanggan
    customer_city VARCHAR(100),
    customer_country VARCHAR(100),
    customer_email VARCHAR(100),
    customer_fname VARCHAR(100),
    customer_id INTEGER,
    customer_lname VARCHAR(100),
    customer_segment VARCHAR(50),
    customer_state VARCHAR(50),
    customer_street VARCHAR(255),
    customer_zipcode VARCHAR(20), 
    
    -- Departemen & Geografi
    department_id INTEGER,
    department_name VARCHAR(100),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    market VARCHAR(50),
    
    -- Order Detail
    order_city VARCHAR(100),
    order_country VARCHAR(100),
    order_customer_id INTEGER,
    order_date TIMESTAMP, 
    order_id INTEGER,
    order_item_cardprod_id INTEGER,
    order_item_discount NUMERIC(15,2),
    order_item_discount_rate NUMERIC(5,4),
    order_item_id INTEGER,
    order_item_product_price NUMERIC(15,2),
    order_item_profit_ratio NUMERIC(5,2),
    order_item_quantity INTEGER,
    sales NUMERIC(15,2),
    order_item_total NUMERIC(15,2),
    order_profit_per_order NUMERIC(15,2),
    order_region VARCHAR(100),
    order_state VARCHAR(100),
    order_status VARCHAR(50),
    order_zipcode VARCHAR(20),
    
    -- Produk
    product_card_id INTEGER,
    product_category_id INTEGER,
    product_description TEXT,
    product_image VARCHAR(255),
    product_name VARCHAR(255),
    product_price NUMERIC(15,2),
    product_status INTEGER,
    shipping_date TIMESTAMP,
    shipping_mode VARCHAR(50)
);
