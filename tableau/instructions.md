# 📌 Connecting Tableau Desktop to PostgreSQL & Creating a Sales by Country Visualization

This guide provides step-by-step instructions to **connect Tableau to PostgreSQL**, ensure tables are present, set up table relationships, and create a **Sales by Country** visualization.

---

## 🚀 Step 1: Connect Tableau Desktop to PostgreSQL

1. **Open Tableau Desktop**.
2. **Go to "Connect" (Left Panel)** → Select **PostgreSQL** under **"To a Server"**.
3. **Enter Connection Details**:
   - **Server**: `localhost` (if PostgreSQL is running locally) or your database server name.
   - **Port**: `5432` (default PostgreSQL port).
   - **Database**: `data_warehouse` (replace with your database name).
   - **Username**: `postgres` (or your PostgreSQL user).
   - **Password**: Enter your PostgreSQL password.
4. **(Optional) Enable SSL**: Check **"Require SSL"** if your database requires secure connections.
5. **Click "Sign In"**.

✅ **You are now connected to PostgreSQL in Tableau!**

---

## 🔎 Step 2: Ensure Tables Are Present in PostgreSQL

1. **Once connected**, select your database (`data_warehouse`).
2. **Check for tables in the left panel** under the **"Tables"** section.
3. Ensure key tables like:
   - `gold.dim_customers`
   - `gold.dim_products`
   - `gold.fact_sales`
4. **If tables are missing**, verify:
   - The PostgreSQL database has the tables:
     ```sql
     SELECT * FROM pg_tables WHERE schemaname = 'gold';
     ```
   - The `gold` schema and views exist in PostgreSQL.

✅ **Your PostgreSQL tables should now be visible in Tableau.**

---

## 📌 Step 3: Define Table Relationships in Tableau

1. **Drag `fact_sales` into the workspace** (this is your main fact table).
2. **Drag `dim_customers` into the workspace**.
   - Tableau should automatically detect **`fact_sales.sls_cust_id = dim_customers.customer_id`**.
   - If not, click **"Add Relationship"** and manually define the **customer relationship**.
3. **Drag `dim_products` into the workspace**.
   - Define the relationship **`fact_sales.sls_prd_key = dim_products.product_number`**.
4. Ensure relationships **use "Inner" or "Left Join" logic**, depending on your data needs.

✅ **You have successfully created relationships between fact and dimension tables!**

---

## 📊 Step 4: Create a Simple Sales by Country Visualization

1. **Go to "Sheet 1"**.
2. **Drag `country` from `dim_customers` to the "Rows" shelf**.
3. **Drag `sales_amount` from `fact_sales` to the "Columns" shelf**.
4. **Change the chart type**:
   - Click **"Show Me" (top-right panel)**.
   - Select **Bubble Chart** or **Horizontal Bars**.
5. **Customize the Chart**:
   - Drag **`sales_amount` to "Size"** to adjust bubble sizes.
   - Drag **`country` to "Color"** to differentiate countries.
   - Add **labels** by dragging `sales_amount` to "Label".
6. **Format the visualization**:
   - Right-click **"Sales Amount"** → Choose **"Format"**.
   - Adjust currency settings if necessary.

✅ **Your Sales by Country visualization is now complete! 🎉**

---

## 🎯 Final Takeaways

✔ **Tableau is successfully connected to PostgreSQL**.  
✔ **Tables are present and relationships are correctly established**.  
✔ **You created a clear, insightful visualization of sales by country**.

🚀 **Now you can build more advanced analytics in Tableau with your PostgreSQL data!**  
Let me know if you need further refinements! 😊
