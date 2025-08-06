--which 5 products generate the highest revenue? 
--SIMPLE
SELECT TOP 5
p.product_name,						--can change to 'p.subcategory'
SUM(fs.sales_amount) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products p
ON p.product_key = fs.product_key
GROUP BY p.product_name				--can change to 'p.subcategory'
ORDER BY total_sales DESC

--COMPLEX
SELECT
*
FROM (
	SELECT 
	p.product_name,						--can change to 'p.subcategory'
	SUM(fs.sales_amount) AS total_sales,
	RANK() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_products p
	ON p.product_key = fs.product_key
	GROUP BY p.product_name)t			--can change to 'p.subcategory
WHERE rank_products <= 5




--What are the 5 worst performing products in terms of sales? 
SELECT TOP 5
p.product_name,
SUM(fs.sales_amount) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products p
ON p.product_key = fs.product_key
GROUP BY p.product_name
ORDER BY total_sales ASC

--Find the top 10 customers who have generated the highest revenue and 3 customers with the fewest orders placed 
SELECT TOP 10
c.customer_key,
c.first_name,
c.last_name,
SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c
ON c.customer_key = fs.customer_key
GROUP BY 
c.first_name,
c.last_name,
c.customer_key
ORDER BY total_revenue DESC

--Find the 3 customers with the fewest orders placed
SELECT TOP 3
c.customer_key, 
c.first_name,
c.last_name,
COUNT(DISTINCT order_number) as total_orders
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers c
ON c.customer_key = fs.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders ASC



