CREATE VIEW Gold.fact_sales AS
SELECT
	sd.sls_ord_num AS Order_number,
	pr.Product_key,
	cu.customer_id,
	sd.sls_order_dt AS Order_date,
	sd.sls_ship_dt AS Shipping_date,
	sd.sls_due_dt AS Due_date,
	sd.sls_sales AS _Sales_amount,
	sd.sls_quantity AS Quantity,
	sd.sls_price AS Price
FROM Silver.crm_sales_details AS sd
LEFT JOIN Gold.dim_customer AS cu
ON sd.sls_cust_id = cu.customer_id
LEFT JOIN Gold.dim_product AS pr
ON sd.sls_prd_key = pr.Product_number
