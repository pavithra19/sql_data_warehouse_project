use DataWarehouse;

TRUNCATE TABLE bronze.crm_customer_info;
BULK INSERT bronze.crm_customer_info
From '/var/opt/mssql/data/SQL DWH datasets/source_crm/cust_info.csv'
With (
    Firstrow = 2,
    Fieldterminator = ',',
    Tablock
);

TRUNCATE TABLE bronze.crm_product_info;
BULK INSERT bronze.crm_product_info
From '/var/opt/mssql/data/SQL DWH datasets/source_crm/prd_info.csv'
With (
    Firstrow = 2,
    Fieldterminator = ',',
    Tablock
);

TRUNCATE TABLE bronze.crm_sales_info;
BULK INSERT bronze.crm_sales_info
From '/var/opt/mssql/data/SQL DWH datasets/source_crm/sales_details.csv'
With (
    Firstrow = 2,
    Fieldterminator = ',',
    Tablock
);