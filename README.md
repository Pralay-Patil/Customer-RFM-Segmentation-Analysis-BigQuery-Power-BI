Customer RFM Segmentation Analysis (BigQuery & Power BI)

📌 Project Overview
This project demonstrates a professional, end-to-end data engineering and analytics workflow. I transformed raw, fragmented sales data into a dynamic Customer Segmentation Dashboard using Google BigQuery for cloud data warehousing and Power BI for business intelligence.

The core of the analysis is the RFM Model, which categorizes customers based on:

  Recency: How recently a customer made a purchase.

  Frequency: How often they purchase.

  Monetary: How much they spend.

🛠️ Tech Stack
  Cloud Data Warehouse: Google BigQuery (SQL)

  Business Intelligence: Power BI

  Data Source: 12 Monthly Transactional CSVs (2025)

🚀 The Step-by-Step Workflow
  1. Data Ingestion & Consolidation
  Instead of manually merging files, I used SQL wildcards to append 12 individual monthly sales tables into a single source-of-truth table: sales_2025. This        ensures the pipeline is scalable for future data.

  2. Metric Calculation & Competitive Ranking
  I calculated the raw RFM values for 287 unique customers. To ensure mathematical fairness, I utilized the RANK() function.

  Why RANK()? In a real-world dataset, many customers share identical behaviors (e.g., the same number of orders). Using RANK() ensures that identical behaviors    receive the exact same rank, preventing arbitrary bias in the final segments.

  3. Statistical Decile Scoring
  Using the NTILE(10) window function, I divided the ranked customers into ten equal groups (deciles). This allows the business to see who the "Top 10%" are        versus the bottom tier, regardless of the raw dollar amount.

  4. Segmentation Logic
  I developed a CASE statement to aggregate the R, F, and M scores (ranging from 3 to 30) into 8 strategic marketing segments:

    Champions: The most loyal and high-spending customers.

    Loyal VIPs: Consistent customers with high frequency.

    Potential Loyalists: Recent spenders with good frequency.

    At Risk / Lost: Customers who haven't purchased in a long time.

  5. Power BI Visualization
  I connected Power BI directly to the BigQuery final table. By performing the heavy data transformation in the SQL layer, the Power BI report remains fast,        lightweight, and easy to refresh.

📊 Key Insights
Total Customers: 287

Top Segment: "Engaged" (59 customers) represents the core of the business.

Opportunity: 92 customers are in the "Promising" or "Potential Loyalist" categories, representing the best targets for upselling campaigns.

💡 Professional Takeaway
The "Modern Data Stack" approach used here (SQL + Cloud + BI) is designed for production environments. By decoupling the Data Transformation (SQL) from the Data Visualization (Power BI), the logic is traceable, auditable, and easily shared across a data team.
