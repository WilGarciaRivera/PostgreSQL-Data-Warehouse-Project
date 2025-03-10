/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.

To create a new database using pgAdmin 4, follow these steps:

Step 1: Open pgAdmin 4
	1.	Launch pgAdmin 4.
	2.	Connect to your PostgreSQL server by clicking on it in the left “Browser” panel.

Step 2: Create a New Database
	1.	In the left panel, right-click on Databases.
	2.	Select “Create” → “Database…” from the dropdown menu.
	3.	In the “General” tab:
	•	Enter a name for your database in the Database Name field.
	•	Select the Owner (default is “postgres” unless you have created another user).

Step 3: Configure Database Settings (Optional)
	•	Click on the “Definition” tab if you want to set:
	•	Encoding (default: UTF-8).
	•	Collation and Character Type (default is fine for most cases).
	•	Template (use template1 if unsure).
	•	Click on the “Security” tab to configure privileges.

Step 4: Save and Verify
	1.	Click “Save”.
	2.	Your new database should now appear under Databases in the left panel.
	3.	Click on the new database and open the Query Tool to run SQL commands.
*/

-- Database: data_warehouse

-- DROP DATABASE IF EXISTS data_warehouse; 
DROP DATABASE IF EXISTS data_warehouse; 

-- Create the 'data_warehouse' database
CREATE DATABASE data_warehouse
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- Once the data_warehouse is selected then

Create SCHEMA bronze;
Create SCHEMA silver;
Create SCHEMA gold;
