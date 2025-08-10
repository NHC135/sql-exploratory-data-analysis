/*
======================================================
Product Report
======================================================
Purpose: 
	-This report consolidates key product metrics and behaviors

Highlights: 
	1. Gathers essential fields such as product names, category, subcategory, and cost. 
	2. Segments products by revenue to identify High-performers, Mid-Range, or Low-Performers
	3. Aggregates product-level metrics: 
	- total orders
	- total sales 
	- total quantity sold
	- total customers (unique) 
	- lifespan (in months) 
	4. Calculates valuable KPIs: 
	- recency (months since last sale) 
	- average order revenue (AOR) 
	- average monthly revenue
*/ 
CREATE VIEW gold.report_products AS
/* 
=================================================================
Base Query: Retrieves core columns from fact_sales and dim_products
====================================================================
*/
WITH base_query AS ( 
SELECT 
	f.customer_key,
	f.order_number,
	f.sales_amount,
	f.quantity,	
	f.order_date,
	p.product_key,
	p.product_name,
	p.category,
	p.subcategory, 
	p.cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key)

, product_aggregations AS ( 
/* ===================================================
Product Aggregations: Summarizes key metrics at the product level 
======================================================*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	order_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	SUM(quantity) AS total_quanitity,
	SUM(sales_amount) AS total_sales,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query
	GROUP BY product_key,
	product_name,
	category,
	subcategory,
	cost,
	order_date)

/*=============================================
Final Query: Combines all product results into one output
===============================================*/
SELECT 
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_order_date,
	first_order_date,
	CASE WHEN total_sales > 50000 THEN 'High Performers'
		 WHEN total_sales >= 10000 THEN 'Mid-Range'
		 ELSE 'Low-Performers'
	END AS product_segments,
	total_sales,
	total_quanitity,
	total_orders,
	order_date,
	lifespan,
	DATEDIFF(MONTH,last_order_date, GETDATE()) AS recency,
	--Average Order Revenue (AOR)
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales / total_orders
	END AS avg_order_revenue,
	-- Average Monthly Revenue
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END AS avg_monthly_revenue
FROM product_aggregations
