------------------------------------------------------------
-- SWIGGY DATA ANALYST PROJECT - FULL SQL SCRIPT

---CREATE DATABASE SWIGGY; 

USE SWIGGY;



------------------------------------------------------------
-- 1. DATA CLEANING & VALIDATION
------------------------------------------------------------


SELECT COUNT(*) FROM food
SELECT COUNT(*) FROM menu
SELECT COUNT(*) FROM orders
SELECT COUNT(*) FROM orders_Type
SELECT COUNT(*) FROM restaurant
SELECT COUNT(*) FROM users


SELECT user_id, COUNT(*) AS cnt
FROM  users
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT id, name, city, rating, rating_count
FROM   restaurant
WHERE city IS NULL OR rating IS NULL OR rating < 0 OR rating > 5;

SELECT m.menu_id, m.r_id, m.f_id
FROM  menu m
LEFT JOIN   restaurant r ON m.r_id = r.id
LEFT JOIN  food f ON m.f_id = f.f_id
WHERE r.id IS NULL OR f.f_id IS NULL;

SELECT order_date, user_id, r_id
FROM  orders
WHERE user_id IS NULL OR r_id IS NULL;

SELECT * FROM  orders WHERE sales_amount IS NULL OR sales_amount <= 0;



------------------------------------------------------------
-- 2. CORE EDA METRICS
------------------------------------------------------------
SELECT
    COUNT(*) AS total_transactions,
    SUM(sales_qty) AS total_items_sold,
    SUM(sales_amount) AS total_revenue,
    SUM(sales_amount) * 1.0 / COUNT(*) AS avg_order_value,
    COUNT(DISTINCT user_id) AS distinct_customers
FROM  orders;

SELECT r.id, r.name, r.city, SUM(o.sales_amount) AS revenue, COUNT(*) AS orders
FROM  orders o
JOIN   restaurant r ON o.r_id = r.id
GROUP BY r.id, r.name, r.city
ORDER BY revenue DESC;

SELECT
    DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1) AS month_start,
    COUNT(*) AS orders,
    SUM(sales_amount) AS revenue,
    SUM(sales_qty) AS items_sold
FROM  orders
WHERE order_date >= DATEADD(MONTH, -24, GETDATE())
GROUP BY DATEFROMPARTS(YEAR(order_date), MONTH(order_date), 1)
ORDER BY month_start;

SELECT f.f_id, f.item, f.veg_or_non_veg,
       COUNT(o.order_id) AS order_count,
       SUM(o.sales_qty) AS total_qty,
       SUM(o.sales_amount) AS revenue_estimate
FROM  orders o
JOIN  menu m ON m.r_id = o.r_id
JOIN  food f ON f.f_id = m.f_id
GROUP BY f.f_id, f.item, f.veg_or_non_veg
ORDER BY total_qty DESC;

SELECT f.veg_or_non_veg,
       SUM(CAST(o.sales_qty AS BIGINT)) AS total_qty,
       SUM(CAST(o.sales_amount AS BIGINT)) AS revenue
FROM  orders o
JOIN  menu m ON m.r_id = o.r_id
JOIN  food f ON f.f_id = m.f_id
GROUP BY f.veg_or_non_veg;


------------------------------------------------------------
-- 3. CUSTOMER & RETENTION ANALYSIS
------------------------------------------------------------

WITH user_agg AS (
    SELECT
        user_id,
        MAX(order_date) AS last_order_date,
        COUNT(*) AS frequency,
        SUM(sales_amount) AS monetary
    FROM  orders
    GROUP BY user_id
)
SELECT
    user_id,
    DATEDIFF(DAY, last_order_date, GETDATE()) AS recency_days,
    frequency,
    monetary
FROM user_agg
ORDER BY monetary DESC;

WITH first_order AS (
    SELECT user_id, MIN(order_date) AS first_order_date
    FROM  orders
    GROUP BY user_id
),
order_months AS (
    SELECT
        o.user_id,
        DATEFROMPARTS(YEAR(o.order_date), MONTH(o.order_date), 1) AS order_month
    FROM  orders o
)
SELECT
    DATEFROMPARTS(YEAR(f.first_order_date), MONTH(f.first_order_date), 1) AS cohort_month,
    om.order_month,
    COUNT(DISTINCT om.user_id) AS active_users
FROM first_order f
JOIN order_months om ON f.user_id = om.user_id
GROUP BY DATEFROMPARTS(YEAR(f.first_order_date), MONTH(f.first_order_date), 1),
         om.order_month
ORDER BY cohort_month, order_month;

WITH u AS (
    SELECT user_id, COUNT(*) AS orders_count
    FROM  orders
    GROUP BY user_id
)
SELECT
    SUM(CASE WHEN orders_count >= 2 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS repeat_rate,
    AVG(orders_count) AS avg_orders_per_customer
FROM u;



------------------------------------------------------------
-- 4. STATISTICAL TESTING PREP (T-TEST COMPARISON)
------------------------------------------------------------


WITH ord_item AS (
    SELECT o.order_id, o.sales_amount, m.menu_id, f.veg_or_non_veg
    FROM  orders o
    JOIN  menu m ON m.r_id = o.r_id
    JOIN  food f ON f.f_id = m.f_id
)
SELECT veg_or_non_veg,
       COUNT(*) AS n,
       AVG(CAST(sales_amount AS BIGINT)) AS mean_amt,
       STDEV(CAST(sales_amount AS BIGINT)) AS sd_amt,
       VAR(CAST(sales_amount AS BIGINT)) AS var_amt
INTO #group_stats
FROM ord_item
GROUP BY veg_or_non_veg;

DECLARE @n1 FLOAT = (SELECT n FROM #group_stats WHERE veg_or_non_veg = 'Veg');
DECLARE @n2 FLOAT = (SELECT n FROM #group_stats WHERE veg_or_non_veg = 'Non-Veg');
DECLARE @mean1 FLOAT = (SELECT mean_amt FROM #group_stats WHERE veg_or_non_veg = 'Veg');
DECLARE @mean2 FLOAT = (SELECT mean_amt FROM #group_stats WHERE veg_or_non_veg = 'Non-Veg');
DECLARE @var1 FLOAT = (SELECT var_amt FROM #group_stats WHERE veg_or_non_veg = 'Veg');
DECLARE @var2 FLOAT = (SELECT var_amt FROM #group_stats WHERE veg_or_non_veg = 'Non-Veg');

DECLARE @t_stat FLOAT = (@mean1 - @mean2) / SQRT( (@var1/@n1) + (@var2/@n2) );
SELECT @t_stat AS t_statistic;

DECLARE @num FLOAT = ( (@var1/@n1) + (@var2/@n2) ) * ( (@var1/@n1) + (@var2/@n2) );
DECLARE @den FLOAT = ( (@var1*@var1) / ( (@n1*@n1)*(@n1-1) ) ) + ( (@var2*@var2) / ( (@n2*@n2)*(@n2-1) ) );
SELECT CASE WHEN @den = 0 THEN NULL ELSE @num/@den END AS welch_df;

DROP TABLE IF EXISTS #group_stats;



------------------------------------------------------------
-- 5. ADVANCED ANALYTICS: CLTV, RFM, ANOMALY
------------------------------------------------------------


WITH user_metrics AS (
    SELECT
        user_id,
        MIN(order_date) AS first_order,
        MAX(order_date) AS last_order,
        COUNT(*) AS orders_count,
        SUM(sales_amount) AS total_spend
    FROM  orders
    GROUP BY user_id
)
SELECT
    user_id,
    DATEDIFF(DAY, first_order, last_order) AS active_days,
    orders_count,
    total_spend,
    total_spend * 1.0 / NULLIF(orders_count,0) AS avg_order_value,
    total_spend * 1.0 / NULLIF(DATEDIFF(DAY, first_order, GETDATE()),1) AS spend_per_day
FROM user_metrics
ORDER BY total_spend DESC;

WITH rfm AS (
    SELECT u.user_id,
           DATEDIFF(DAY, MAX(o.order_date), GETDATE()) AS recency,
           COUNT(o.order_id) AS frequency,
           SUM(o.sales_amount) AS monetary
    FROM  users u
    LEFT JOIN  orders o ON u.user_id = o.user_id
    GROUP BY u.user_id
)
SELECT *,
       NTILE(5) OVER (ORDER BY recency ASC) AS recency_quintile,
       NTILE(5) OVER (ORDER BY frequency DESC) AS frequency_quintile,
       NTILE(5) OVER (ORDER BY monetary DESC) AS monetary_quintile
INTO  user_rfm
FROM rfm;

WITH daily AS (
    SELECT CAST(order_date AS DATE) AS day,
           SUM(sales_amount) AS revenue
    FROM  orders
    GROUP BY CAST(order_date AS DATE)
),
stats AS (
    SELECT AVG(revenue) AS mean_rev, STDEV(revenue) AS sd_rev FROM daily
)
SELECT d.day, d.revenue,
       (d.revenue - s.mean_rev) / NULLIF(s.sd_rev,0) AS z_score
FROM daily d CROSS JOIN stats s
ORDER BY ABS((d.revenue - s.mean_rev) / NULLIF(s.sd_rev,0)) DESC;



