# PostgreSQL-Data-Warehouse-Project

## Requirements for this Project

### Building the Data Warehouse 

### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleaning and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.
- **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---
## Data Architecture

Medallion Architecture is a modern data engineering design pattern used primarily in lakehouse environments, such as those built on Databricks, Delta Lake, or cloud-based data lakes. It follows a layered approach to data organization, improving data quality, governance, and efficiency by structuring data into different tiers: Bronze, Silver, and Gold.

1. **The Bronze Layer** is the raw data ingestion layer, where data is collected in its native format from various sources, such as APIs, IoT devices, databases, or logs. This layer ensures data immutability, allowing analysts to trace the original source.
2. **The Silver Layer** focuses on data cleansing, transformation, and enrichment, eliminating duplicates, handling missing values, and applying schema validation. This layer prepares data for analytical processing.
3. **The Gold Layer** contains highly refined, business-ready data that is aggregated, structured, and optimized for consumption in reports, dashboards, or machine learning models.

By implementing the Medallion Architecture, organizations can enhance data quality, lineage tracking, and query performance while maintaining flexibility. This approach also supports incremental data processing, where updates are seamlessly integrated into the pipeline, making it ideal for real-time analytics and AI-driven insights.
