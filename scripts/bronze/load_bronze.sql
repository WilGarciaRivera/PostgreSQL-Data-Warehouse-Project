/*
===============================================================================
Stored Procedure: Load CSV Data into Bronze Tables (with TRUNCATE)
===============================================================================
Script Purpose:
    This stored procedure automates the process of loading raw CSV data 
    into the 'bronze' schema. It first truncates the target table 
    before loading new data using the COPY command.

===============================================================================

How It Works:
    - The procedure takes three parameters:
        1. table_name (TEXT)  → The target table in the 'bronze' schema.
        2. file_path (TEXT)    → Full file path of the CSV to be loaded.
        3. delimiter (CHAR)    → The delimiter used in the CSV (default is ',').
    
    - The EXECUTE format() function dynamically constructs and runs:
        1. **TRUNCATE TABLE bronze.table_name** → Clears existing records.
        2. **COPY FROM CSV** → Loads new data into the truncated table.

===============================================================================

Why Use This Procedure?
    1. **Ensures Fresh Data**: Clears old records before every load.
    2. **Avoids Duplicate Entries**: Prevents duplicate ingestion of records.
    3. **Automated & Reusable**: Works for all Bronze tables with a single call.
    4. **Scalable**: Can be used in scheduled jobs for periodic refreshes.

===============================================================================
===============================================================================
Stored Procedure: Load CSV Data into Bronze Tables (with Logging & Error Handling)
===============================================================================
Script Purpose:
    - Automates loading CSV files into the 'bronze' schema.
    - Truncates the target table before inserting new data.
    - Logs execution details (start time, end time, duration).
    - Handles errors and logs failures.

===============================================================================

*/

CREATE OR REPLACE PROCEDURE bronze.load_csv_data(
    table_name TEXT,
    file_path TEXT,
    delimiter CHAR DEFAULT ','
)
LANGUAGE plpgsql
AS $$
DECLARE 
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP := clock_timestamp();
    batch_end_time TIMESTAMP;
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';
    
    RAISE NOTICE '------------------------------------------------';
    RAISE NOTICE 'Processing Table: %', table_name;
    RAISE NOTICE '------------------------------------------------';

    -- Capture Start Time
    start_time := clock_timestamp();

    -- Truncate the target table before loading new data
    RAISE NOTICE '>> Truncating Table: %', table_name;
    EXECUTE format('TRUNCATE TABLE bronze.%I', table_name);

    -- Load the CSV data into the truncated table
    RAISE NOTICE '>> Inserting Data Into: %', table_name;
    EXECUTE format(
        'COPY bronze.%I FROM %L WITH (FORMAT csv, HEADER, DELIMITER %L)',
        table_name, file_path, delimiter
    );

    -- Capture End Time
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration for %: % seconds', table_name, EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> -----------------------------------';

    -- Capture batch end time
    batch_end_time := clock_timestamp();
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Bronze Layer is Completed';
    RAISE NOTICE '   - Total Load Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '==========================================';

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '==========================================';
        RAISE NOTICE 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        RAISE NOTICE 'Error Message: %', SQLERRM;
        RAISE NOTICE '==========================================';
END $$;

CALL bronze.load_csv_data('crm_sales_details', '/Users/wilfredogarcia/Desktop/Data Warehouse project/CRM/sales_details.csv');
CALL bronze.load_csv_data('crm_cust_info', '/Users/wilfredogarcia/Desktop/Data Warehouse project/CRM/cust_info.csv');
CALL bronze.load_csv_data('crm_prd_info', '/Users/wilfredogarcia/Desktop/Data Warehouse project/CRM/prd_info.csv');
CALL bronze.load_csv_data('erp_cust_az12', '/Users/wilfredogarcia/Desktop/Data Warehouse project/ERP/CUST_AZ12.csv');
CALL bronze.load_csv_data('erp_loc_a101', '/Users/wilfredogarcia/Desktop/Data Warehouse project/ERP/LOC_A101.csv');
CALL bronze.load_csv_data('erp_px_cat_g1v2', '/Users/wilfredogarcia/Desktop/Data Warehouse project/ERP/PX_CAT_G1V2.csv');
