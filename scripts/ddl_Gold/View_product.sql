CREATE VIEW Gold.dim_product AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS Product_key,
	pn.prd_id AS Product_id,
	pn.prd_key AS Product_number,
	pn.prd_nm AS Product_name,
	pn.cat_id AS Category_id,
	pa.CAT AS Category,
	pa.SUBCAT AS Subcategory,
	pa.MAINTENANCE AS Maintenance,
	pn.prd_cost AS Cost,
	pn.prd_line AS Product_line,
	pn.prd_start_dt AS Start_dt
FROM Silver.crm_prd_info AS pn
LEFT JOIN Silver.erp_PX_CAT_G1V2 AS pa
ON pn.cat_id = pa.ID
WHERE pn.prd_end_dt IS NULL -- filter out historical data for a product(removing end date from select as it is null always)
