-- Step1: Append all monthly sales tables

CREATE OR REPLACE TABLE `rfm1100.sales.sales_2025` AS
SELECT *
FROM `rfm1100.sales.2025*`
WHERE _TABLE_SUFFIX BETWEEN '01' AND '12';

-- Step2: Calculate recency, frequency, monetary, r, f, m ranks
-- Combine views with CTEs

CREATE OR REPLACE VIEW `rfm1100.sales.rfm_metrics` AS
WITH current_date_cte AS (
  SELECT DATE('2026-03-28') AS analysis_date 
),
rfm AS (
  SELECT 
    CustomerID,
    MAX(OrderDate) AS last_order_date,
    DATE_DIFF((SELECT analysis_date FROM current_date_cte), MAX(OrderDate), DAY) AS recency,
    COUNT(*) AS frequency,
    SUM(OrderValue) AS monetary
  FROM `rfm1100.sales.sales_2025`
  GROUP BY CustomerID
)
SELECT
  *,
  RANK() OVER(ORDER BY recency ASC) AS r_rank,     
  RANK() OVER(ORDER BY frequency DESC) AS f_rank,  
  RANK() OVER(ORDER BY monetary DESC) AS m_rank    
FROM rfm;


-- Step 3: Assign deciles (10=best, 1=worst)
CREATE OR REPLACE VIEW `rfm1100.sales.rfm_scores`
AS
SELECT
  *,
  NTILE(10) OVER(order by r_rank DESC) as r_score,
  NTILE(10) OVER(order by f_rank DESC) as f_score,
  NTILE(10) OVER(order by m_rank DESC) as m_score
FROM `rfm1100.sales.rfm_metrics`;

-- Step 4: total score
CREATE OR REPLACE VIEW `rfm1100.sales.rfm_total_scores`
AS
SELECT
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  (r_score + f_score + m_score) AS rfm_total_score
FROM `rfm1100.sales.rfm_scores`
order by rfm_total_score desc;

-- Step 5: BI ready rfm segment table
CREATE OR REPLACE TABLE `rfm1100.sales.rfm_segments_final`
AS
SELECT
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  rfm_total_score,
  CASE
    WHEN rfm_total_score >= 28 THEN 'Champions'
    WHEN rfm_total_score >= 24 THEN 'Loyal VIPs'
    WHEN rfm_total_score >= 20 THEN 'Potential Loyalists'
    WHEN rfm_total_score >= 16 THEN 'Promising'
    WHEN rfm_total_score >= 12 THEN 'Engaged'
    WHEN rfm_total_score >= 8 THEN 'Requires Attention'
    WHEN rfm_total_score >= 4 THEN 'At Risk'
    ELSE 'Lost/Inactive'
  END AS rfm_segment
FROM `rfm1100.sales.rfm_total_scores`
order by rfm_total_score desc;

