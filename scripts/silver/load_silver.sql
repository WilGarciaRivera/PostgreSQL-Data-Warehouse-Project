DROP PROCEDURE IF EXISTS silver.load_silver;

CREATE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE 
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP := clock_timestamp();
    batch_end_time TIMESTAMP;
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Silver Layer';
    RAISE NOTICE '================================================';

    -- Capture batch start time
    batch_start_time := clock_timestamp();

    -- Load CRM Customer Info
    RAISE NOTICE '>> Truncating Table: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;
    start_time := clock_timestamp();
    RAISE NOTICE '>> Inserting Data Into: silver.crm_cust_info';
    INSERT INTO silver.crm_cust_info (
        cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date
    )
    SELECT
        cst_id, cst_key, TRIM(cst_firstname), TRIM(cst_lastname),
        CASE 
            WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END,
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END,
        cst_create_date
    FROM (
        SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze.crm_cust_info WHERE cst_id IS NOT NULL
    ) t WHERE flag_last = 1;
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration for silver.crm_cust_info: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- Load CRM Product Info
    RAISE NOTICE '>> Truncating Table: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;
    start_time := clock_timestamp();
    RAISE NOTICE '>> Inserting Data Into: silver.crm_prd_info';
    INSERT INTO silver.crm_prd_info (
        prd_id, prd_key, cat_id, prd_nm, prd_cost, prd_line, prd_start_dt, prd_end_dt
    )
    SELECT
        prd_id, SUBSTRING(prd_key FROM 7 FOR LENGTH(prd_key)),  
        REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_'),  
        prd_nm, COALESCE(prd_cost, 0),
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END,
        CAST(prd_start_dt AS DATE),
        CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day' AS DATE)
    FROM bronze.crm_prd_info;
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration for silver.crm_prd_info: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- Load CRM Sales Details
    RAISE NOTICE '>> Truncating Table: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;
    start_time := clock_timestamp();
    RAISE NOTICE '>> Inserting Data Into: silver.crm_sales_details';
    INSERT INTO silver.crm_sales_details (
        sls_ord_num, sls_prd_key, sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity, sls_price
    )
    SELECT 
        sls_ord_num, sls_prd_key,
        CASE 
            WHEN sls_cust_id IS NULL THEN NULL
            WHEN TRIM(sls_cust_id::TEXT) ~ '^[0-9]+$' THEN sls_cust_id 
            ELSE NULL 
        END,
        sls_order_dt::DATE, sls_ship_dt::DATE, sls_due_dt::DATE,    
        COALESCE(sls_sales, sls_quantity * ABS(sls_price)),
        sls_quantity,
        COALESCE(sls_price, sls_sales / NULLIF(sls_quantity, 0))
    FROM bronze.crm_sales_details;
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration for silver.crm_sales_details: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- Load ERP Customer Data
    RAISE NOTICE '>> Truncating Table: silver.erp_cust_az12';
    TRUNCATE TABLE silver.erp_cust_az12;
    start_time := clock_timestamp();
    RAISE NOTICE '>> Inserting Data Into: silver.erp_cust_az12';
    INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
    SELECT
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) ELSE cid END,
        CASE WHEN bdate > CURRENT_DATE THEN NULL ELSE bdate END,
        CASE 
            WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
            WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
            ELSE 'n/a'
        END
    FROM bronze.erp_cust_az12;
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration for silver.erp_cust_az12: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- Load ERP Location Data
    RAISE NOTICE '>> Truncating Table: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;
    start_time := clock_timestamp();
    RAISE NOTICE '>> Inserting Data Into: silver.erp_loc_a101';
    INSERT INTO silver.erp_loc_a101 (cid, cntry)
    SELECT
        REPLACE(cid, '-', ''),
        CASE 
            WHEN TRIM(cntry) = 'DE' THEN 'Germany'
            WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END
    FROM bronze.erp_loc_a101;
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration for silver.erp_loc_a101: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- Load ERP Product Category Data
    RAISE NOTICE '>> Truncating Table: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    start_time := clock_timestamp();
    RAISE NOTICE '>> Inserting Data Into: silver.erp_px_cat_g1v2';
    INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
    SELECT id, cat, subcat, maintenance FROM bronze.erp_px_cat_g1v2;
    end_time := clock_timestamp();
    RAISE NOTICE '>> Load Duration for silver.erp_px_cat_g1v2: % seconds', EXTRACT(EPOCH FROM (end_time - start_time));

    -- Capture total batch duration
    batch_end_time := clock_timestamp();
    RAISE NOTICE '==========================================';
    RAISE NOTICE 'Loading Silver Layer Completed';
    RAISE NOTICE 'Total Load Duration: % seconds', EXTRACT(EPOCH FROM (batch_end_time - batch_start_time));
    RAISE NOTICE '==========================================';
END $$;

-- Call Procedure
CALL silver.load_silver();
