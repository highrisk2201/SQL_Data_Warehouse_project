-- Creating tables
IF OBJECT_ID('Bronze.crm_cust_info') IS NOT NULL
	DROP TABLE Bronze.crm_cust_info
CREATE TABLE Bronze.crm_cust_info(
	cst_id INT,
	cst_key VARCHAR(50),
	cst_firstname VARCHAR(50),
	cst_lastname VARCHAR(50),
	cst_marital_status VARCHAR(50),
	cst_gndr VARCHAR(50),
	cst_create_date DATE
);
IF OBJECT_ID('Bronze.crm_prd_info') IS NOT NULL
	DROP TABLE Bronze.crm_prd_info
CREATE TABLE Bronze.crm_prd_info(
	prd_id INT,
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE
);
IF OBJECT_ID('Bronze.crm_slaes_details') IS NOT NULL
	DROP TABLE Bronze.crm_slaes_details
CREATE TABLE Bronze.crm_sales_details(
	sls_ord_num VARCHAR(50),
	sls_prd_key VARCHAR(50),
	sls_cust_id	INT,
	sls_order_dt INT,	
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,	
	sls_price INT
);
IF OBJECT_ID('Bronze.erp_CUST_AZ12') IS NOT NULL
	DROP TABLE Bronze.erp_CUST_AZ12
CREATE TABLE Bronze.erp_CUST_AZ12(
	CID	VARCHAR(50),
	BDATE DATE,
	GEN VARCHAR(50)
);
IF OBJECT_ID('Bronze.erp_LOC_A101') IS NOT NULL
	DROP TABLE Bronze.erp_LOC_A101
CREATE TABLE Bronze.erp_LOC_A101(
	CID	VARCHAR(50),
	CNTRY VARCHAR(50)
);
IF OBJECT_ID('Bronze.erp_PX_CAT_G1V2') IS NOT NULL
	DROP TABLE Bronze.erp_PX_CAT_G1V2
CREATE TABLE Bronze.erp_PX_CAT_G1V2(
	ID VARCHAR(50),
	CAT	VARCHAR(50),
	SUBCAT VARCHAR(50),	
	MAINTENANCE VARCHAR(50)
);
