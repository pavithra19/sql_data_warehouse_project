/*
===============================================================================
Stored Procedure: Loading data in Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data since this is Full Load.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
Create OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT ('===========================');
        PRINT ('Loading Bronze layer');
        PRINT ('===========================');

        PRINT ('---------------------------');
        PRINT ('Loading CRM Tables');
        PRINT ('---------------------------');

        SET @start_time = GETDATE();
        PRINT ('>> Truncating table: bronze.crm_cust_info');
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT ('>> Inserting into table: bronze.crm_cust_info');
        BULK INSERT bronze.crm_cust_info
        From '/var/opt/mssql/data/SQL DWH datasets/source_crm/cust_info.csv'
        With (
            Firstrow = 2,
            Fieldterminator = ',',
            Tablock
        );
        SET @end_time = GETDATE();

        PRINT ('Load Duration for bronze.crm_cust_info:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds');
        PRINT ('>> ---------------------------');

        SET @start_time = GETDATE();
        PRINT ('>> Truncating table: bronze.crm_prd_info');
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT ('>> Inserting into table: bronze.crm_prd_info');
        BULK INSERT bronze.crm_prd_info
        From '/var/opt/mssql/data/SQL DWH datasets/source_crm/prd_info.csv'
        With (
            Firstrow = 2,
            Fieldterminator = ',',
            Tablock
        );
        SET @end_time = GETDATE();

        PRINT ('Load Duration for bronze.crm_prd_info:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds');
        PRINT ('>> ---------------------------');

        SET @start_time = GETDATE();
        PRINT ('>> Truncating table: bronze.crm_sales_details');
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT ('>> Inserting into table: bronze.crm_sales_details');
        BULK INSERT bronze.crm_sales_details
        From '/var/opt/mssql/data/SQL DWH datasets/source_crm/sales_details.csv'
        With (
            Firstrow = 2,
            Fieldterminator = ',',
            Tablock
        );
        SET @end_time = GETDATE();

        PRINT ('Load Duration for bronze.crm_sales_details:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds');

        PRINT ('---------------------------');
        PRINT ('Loading ERP Tables');
        PRINT ('---------------------------');

        SET @start_time = GETDATE();
        PRINT ('>> Truncating table: bronze.erp_cust_az12');
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT ('>> Inserting into table: bronze.erp_cust_az12');
        BULK INSERT bronze.erp_cust_az12
        From '/var/opt/mssql/data/SQL DWH datasets/source_erp/CUST_AZ12.csv'
        With (
            Firstrow = 2,
            Fieldterminator = ',',
            Tablock
        );
        SET @end_time = GETDATE();

        PRINT ('Load Duration for bronze.erp_cust_az12:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds');
        PRINT ('>> ---------------------------');

        SET @start_time = GETDATE();
        PRINT ('>> Truncating table: bronze.erp_loc_a101');
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT ('>> Inserting into table: bronze.erp_loc_a101');
        BULK INSERT bronze.erp_loc_a101
        From '/var/opt/mssql/data/SQL DWH datasets/source_erp/LOC_A101.csv'
        With (
            Firstrow = 2,
            Fieldterminator = ',',
            Tablock
        );
        SET @end_time = GETDATE();

        PRINT ('Load Duration for bronze.erp_loc_a101:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds');
        PRINT ('>> ---------------------------');

        SET @start_time = GETDATE();
        PRINT ('>> Truncating table: bronze.erp_px_cat_g1v2');
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT ('>> Inserting into table: bronze.erp_px_cat_g1v2');
        BULK INSERT bronze.erp_px_cat_g1v2
        From '/var/opt/mssql/data/SQL DWH datasets/source_erp/PX_CAT_G1V2.csv'
        With (
            Firstrow = 2,
            Fieldterminator = ',',
            Tablock
        );
        SET @end_time = GETDATE();

        PRINT ('Load Duration for bronze.erp_px_cat_g1v2:' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds');
        SET @batch_end_time = GETDATE();

        PRINT ('===========================');
        PRINT ('Data Ingestion in Bronze layer is successful, total time taken:' + 
        CAST (DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds');
        PRINT ('===========================');
        
    END TRY

    BEGIN CATCH

        PRINT ('=======================');
        PRINT ('ERROR WHILE LOADING DATA IN BRONZE LAYER');
        PRINT ('ERROR MESSAE:' + ERROR_MESSAGE());
        PRINT ('ERROR NUMBER:' + CAST (ERROR_NUMBER() AS NVARCHAR));
        PRINT ('ERROR STATE:' + CAST (ERROR_STATE() AS NVARCHAR));
        PRINT ('=======================');

    END CATCH
END