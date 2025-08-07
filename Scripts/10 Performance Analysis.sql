--Analyze the yearly performance of products by comparing each 
--product's sales to both its average sales performance and the previous year's sales
WITH yearly_product_sales AS (
SELECT 
SUM(f.sales_amount) AS current_sales,
p.product_name,
YEAR(f.order_date) AS yearly_date 
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p 
ON p.product_key = f.product_key
GROUP BY p.product_name, YEAR(f.order_date)
) 

SELECT 
yearly_date, 
product_name, 
current_sales, 
AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS sales_diff,
CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
	 WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg' 
END avg_change,
--year over year analysis
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_date) AS py_sales,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_date) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_date) > 0 THEN 'Above Avg'
	 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY yearly_date) < 0 THEN 'Below Avg'
	 ELSE 'No Change' 
END
FROM yearly_product_sales
 