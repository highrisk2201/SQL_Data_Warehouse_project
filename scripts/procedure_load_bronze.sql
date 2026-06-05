-- Fisrt run the procedure and the run this command (EXEC Bronze.load_tables) to execute the stored procedure
-- Change the file paths according to your workspace
-- Inserting Data into the respective tables
CREATE OR ALTER PROCEDURE Bronze.load_tables AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME
		-- Table-1
		SET @start_time = GETDATE()
		TRUNCATE TABLE Bronze.crm_cust_info -- to fill the after making it empty
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\Users\hp\OneDrive\Desktop\SQL\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- TO LOCK THE WHOLE TABLE
		);
		PRINT 'TABLE-1 LOADED';
		SET @end_time = GETDATE()
		PRINT 'TIME TAKEN:' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'SECONDS';
		-- Table-2
		SET @start_time = GETDATE()
		TRUNCATE TABLE Bronze.crm_prd_info
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\Users\hp\OneDrive\Desktop\SQL\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- TO LOCK THE WHOLE TABLE
		);
		PRINT 'TABLE-2 LOADED';
		SET @end_time = GETDATE()
		PRINT 'TIME TAKEN:' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'SECONDS';
		-- table-3
		SET @start_time = GETDATE()
		TRUNCATE TABLE Bronze.crm_sales_details
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\Users\hp\OneDrive\Desktop\SQL\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- TO LOCK THE WHOLE TABLE
		);
		PRINT 'TABLE-3 LOADED';
		SET @end_time = GETDATE()
		PRINT 'TIME TAKEN:' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'SECONDS';
		-- table-4
		SET @start_time = GETDATE()
		TRUNCATE TABLE Bronze.erp_CUST_AZ12
		BULK INSERT Bronze.erp_CUST_AZ12
		FROM 'C:\Users\hp\OneDrive\Desktop\SQL\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- TO LOCK THE WHOLE TABLE
		);
		PRINT 'TABLE-4 LOADED';
		SET @end_time = GETDATE()
		PRINT 'TIME TAKEN:' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'SECONDS';
		-- table-5
		SET @start_time = GETDATE()
		TRUNCATE TABLE Bronze.erp_LOC_A101
		BULK INSERT Bronze.erp_LOC_A101
		FROM 'C:\Users\hp\OneDrive\Desktop\SQL\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- TO LOCK THE WHOLE TABLE
		);
		PRINT 'TABLE-5 LOADED';
		SET @end_time = GETDATE()
		PRINT 'TIME TAKEN:' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'SECONDS';
		-- table-6
		SET @start_time = GETDATE()
		TRUNCATE TABLE Bronze.erp_PX_CAT_G1V2
		BULK INSERT Bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\hp\OneDrive\Desktop\SQL\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK -- TO LOCK THE WHOLE TABLE
		);
		PRINT 'TABLE-6 LOADED';
		SET @end_time = GETDATE()
		PRINT 'TIME TAKEN:' + CAST(DATEDIFF(second,@start_time,@end_time) AS VARCHAR) + 'SECONDS';
	END TRY
	BEGIN CATCH
		PRINT 'ERROR OCCURED DURING LOADIND'
		PRINT 'ERROR MESSAGE: '+ ERROR_MESSAGE()
		PRINT 'ERROR NUMBER: '+ CAST(ERROR_NUMBER() AS VARCHAR)
		PRINT 'ERROR STATE:' + CAST(ERROR_STATE() AS VARCHAR)
	END CATCH
END;
