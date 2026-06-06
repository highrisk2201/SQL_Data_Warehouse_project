CREATE VIEW Gold.dim_customer AS
SELECT
	ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.CNTRY AS Country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr -- Master source for gender info
	ELSE COALESCE(ca.GEN,'Unknown') END AS Gender,
	ca.BDATE AS Birthdate,
	ci.cst_create_date AS create_date
FROM Silver.crm_cust_info AS ci
LEFT JOIN Silver.erp_CUST_AZ12 AS ca
ON ci.cst_key = ca.CID
LEFT JOIN Silver.erp_LOC_A101 AS la
ON ci.cst_key = la.CID
