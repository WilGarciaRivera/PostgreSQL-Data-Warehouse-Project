/*
===============================================================================
DDL Script: Create silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================

The DO $$ construct in PostgreSQL is used to execute anonymous procedural blocks, 
typically written in PL/pgSQL. This allows you to run procedural logic, like conditional 
statements (IF), loops, and exception handling, without creating a stored procedure or function.

Why Use DO $$?
	1.	To execute procedural code dynamically without defining a function.
	2.	To check if a table exists before dropping it, mimicking SQL Server’s OBJECT_ID check.
	3.	To use control structures like IF, LOOP, and EXCEPTION handling.

Metadata column wgr_create_date TIMESTAMP DEFAULT NOW()
Extra column added by data engineers that do not originate from source data. 
The function is to
- create_date: The record's load timestamp.
- update_date: The record's last update timestamp.
- source_system: The origin system of the record.
- file_location: The file source of the record.
The naming covention for that column is the initials of the engineer and the name of the column., 

*/

DO $$ 
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'silver' AND tablename = 'crm_cust_info') THEN
        EXECUTE 'DROP TABLE silver.crm_cust_info CASCADE';
    END IF;
END $$;

CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
	wgr_create_date TIMESTAMP DEFAULT NOW()
);

DO $$ 
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'silver' AND tablename = 'crm_sales_details') THEN
        EXECUTE 'DROP TABLE silver.crm_sales_details CASCADE';
    END IF;
END $$;

CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt VARCHAR(50),
    sls_ship_dt VARCHAR(50),
    sls_due_dt VARCHAR(50),
    sls_sales INT,
    sls_quantity INT,
    sls_price INT,
	wgr_create_date TIMESTAMP DEFAULT NOW()
);

DO $$ 
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'silver' AND tablename = 'crm_prd_info') THEN
        EXECUTE 'DROP TABLE silver.crm_prd_info CASCADE';
    END IF;
END $$;

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    cat_id VARCHAT(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    wgr_create_date TIMESTAMP DEFAULT NOW()
);

DO $$ 
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'silver' AND tablename = 'erp_loc_a101') THEN
        EXECUTE 'DROP TABLE silver.erp_loc_a101 CASCADE';
    END IF;
END $$;

CREATE TABLE silver.erp_loc_a101 (
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

DO $$ 
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'silver' AND tablename = 'erp_cust_az12') THEN
        EXECUTE 'DROP TABLE silver.erp_cust_az12 CASCADE';
    END IF;
END $$;

CREATE TABLE silver.erp_cust_az12 (
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50)
);

DO $$ 
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'silver' AND tablename = 'erp_px_cat_g1v2') THEN
        EXECUTE 'DROP TABLE silver.erp_px_cat_g1v2 CASCADE';
    END IF;
END $$;

CREATE TABLE silver.erp_px_cat_g1v2 (
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);
