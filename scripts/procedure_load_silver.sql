-- After running the query to save the procedure run this (EXEC Silver.load_silver) to execute the procedure
CREATE OR ALTER PROCEDURE Silver.load_silver AS
BEGIN
    PRINT 'TRUNCATING TABLE Silver.crm_cust_info'
    TRUNCATE TABLE Silver.crm_cust_info;
    PRINT 'INSERTING DATA INTO Silver.crm_cust_info'
    INSERT INTO Silver.crm_cust_info(
        [cst_id], [cst_key], [cst_firstname], [cst_lastname], 
        [cst_marital_status], [cst_gndr], [cst_create_date]
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname),
        TRIM(cst_lastname),
        CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
             WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
             ELSE 'Unknown' END,
        CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
             WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
             ELSE 'Unknown' END,
        cst_create_date
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag
        FROM Bronze.crm_cust_info
        WHERE cst_id IS NOT NULL -- <--- Filter it here BEFORE the heavy lifting!
    ) t
    WHERE flag = 1;
    PRINT'--------------------------------------------------'
    PRINT'TRUNCATING TABLE Silver.crm_prd_info'
    TRUNCATE TABLE [Silver].[crm_prd_info];
    PRINT'INSERTING INTO Silver.crm_prd_info'
    INSERT INTO [Silver].[crm_prd_info](
          [prd_id],
          [Cat_id],
          [prd_key],
          [prd_nm],
          [prd_cost],
          [prd_line],
          [prd_start_dt],
          [prd_end_dt]
    )
    SELECT
          [prd_id],
          REPLACE(SUBSTRING([prd_key],1,5),'-','_') AS Cat_id,
          SUBSTRING([prd_key],7,LEN(prd_key)) As prd_key,
          [prd_nm],
          COALESCE([prd_cost],0) AS prd_cost,
          CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
               WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
               WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
               WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
               ELSE 'Unknown' END AS prd_line,
          CAST([prd_start_dt] AS DATE),
          CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
    FROM [Datawarehouse].[Bronze].[crm_prd_info]
    PRINT'---------------------------------------------------------'
    PRINT'TRUNCATING TABLE Silver.crm_sales_details'
    TRUNCATE TABLE Silver.crm_sales_details;
    PRINT'INSERTING INTO Silver.crm_sales_details'
    INSERT INTO Silver.crm_sales_details(
	    sls_ord_num,
	    sls_prd_key,
	    sls_cust_id,
	    sls_order_dt, 	
	    sls_ship_dt,
	    sls_due_dt, 
	    sls_sales, 
	    sls_quantity, 	
	    sls_price 
	
    )
    SELECT
          sls_ord_num,
          sls_prd_key,
          sls_cust_id,
          CASE WHEN sls_order_dt <=0 OR LEN(sls_order_dt) !=8 THEN NULL
          ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) END AS sls_order_dt,
          CASE WHEN sls_ship_dt <=0 OR LEN(sls_ship_dt) !=8 THEN NULL
          ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) END AS sls_ship_dt,
          CASE WHEN sls_due_dt <=0 OR LEN(sls_due_dt) !=8 THEN NULL
          ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) END AS sls_due_dt,
          CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales!=sls_quantity*ABS(sls_price)
          THEN sls_quantity*ABS(sls_price)
          ELSE sls_sales END AS sls_sales,
          sls_quantity,
          CASE WHEN sls_price IS NULL OR sls_price <=0 THEN sls_sales/NULLIF(sls_quantity,0)
          ELSE sls_price END AS sls_price
    FROM [Datawarehouse].[Bronze].[crm_sales_details]
    PRINT'------------------------------------------------------------'
    PRINT'TUNCATING TABLE Silver.erp_CUST_AZ12'
    TRUNCATE TABLE Silver.erp_CUST_AZ12;
    PRINT'INSERTING INTO Silver.erp_CUST_AZ12'
    INSERT INTO Silver.erp_CUST_AZ12(CID,BDATE,GEN)
    SELECT
	    CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID,4,LEN(CID))
	    ELSE CID END AS CID,
	    CASE WHEN BDATE > GETDATE() THEN NULL
	    ELSE BDATE END AS BDATE,
	    CASE WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'Male'
	    WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'Female'
	    ELSE 'Unknown' END AS GEN
    FROM Bronze.erp_CUST_AZ12
    PRINT'-------------------------------------------------------------'
    PRINT'TRUNCATING TABLE Silver.erp_LOC_A101'
    TRUNCATE TABLE Silver.erp_LOC_A101;
    PRINT'INSERTING INTO Silver.erp_LOC_A101'
    INSERT INTO Silver.erp_LOC_A101 (CID,CNTRY)
    SELECT
	    REPLACE(CID,'-','') AS CID,
	    CASE WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
	    WHEN TRIM(CNTRY) IN ('US','USA') THEN 'United States'
	    WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'Unknown'
	    ELSE TRIM(CNTRY) END AS CNTRY
    FROM Bronze.erp_LOC_A101
    PRINT '----------------------------------------------------------'
    PRINT'TRUNCATING TABLE Silver.erp_PX_CAT_G1V2'
    TRUNCATE TABLE Silver.erp_PX_CAT_G1V2;
    PRINT'INSERTING INTO Silver.erp_PX_CAT_G1V2'
    INSERT INTO Silver.erp_PX_CAT_G1V2(ID,CAT,SUBCAT,MAINTENANCE)
    SELECT
	    TRIM(ID) AS ID,
	    TRIM(CAT) AS CAT,
	    TRIM(SUBCAT) AS SUBCAT,
	    TRIM(MAINTENANCE) AS MAINTENANCE
    FROM Bronze.erp_PX_CAT_G1V2
END
