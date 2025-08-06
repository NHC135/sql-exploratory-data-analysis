--Find the Total Sales
SELECT 
SUM(sales_amount) AS total_sales
FROM gold.fact_sales

--Find how many items are sold
SELECT 
SUM(quantity) AS items_sold
FROM gold.fact_sales

--Find the average selling price
SELECT 
AVG(price) AS avg_sell_price
FROM gold.fact_sales

--Find the Total number of orders
SELECT 
COUNT(order_number) AS total_orders
FROM gold.fact_sales

SELECT 
COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales

--Find the Total number of products
SELECT 
COUNT(product_key) AS total_number_products
FROM gold.dim_products

--Find the Total number of customers
SELECT
COUNT(customer_id) AS total_number_customers
FROM gold.dim_customers

--Find the Total number of customers that has placed an order
SELECT
COUNT(DISTINCT customer_key) AS total_of_customers_with_orders
FROM gold.fact_sales


--Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales 

UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales 

UNION ALL
SELECT 'Average Sell Price', AVG(price) AS avg_sell_price FROM gold.fact_sales

UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales

UNION ALL
SELECT 'Total number of products', COUNT(product_key) AS total_number_products
FROM gold.dim_products

UNION ALL
SELECT 'Total Number Customers', COUNT(customer_id) AS total_number_customers
FROM gold.dim_customers

UNION ALL
SELECT 'Total Customers With Orders', COUNT(DISTINCT customer_key) AS total_of_customers_with_orders
FROM gold.fact_sales
