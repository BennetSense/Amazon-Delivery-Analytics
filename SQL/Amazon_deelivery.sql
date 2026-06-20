==================================================
AMAZON DELIVERY SQL ANALYSIS
==================================================

Contents

1. Traffic Analysis
2. Weather Analysis
3. Vehicle Analysis
4. Category Analysis
5. Area Analysis
6. Order Hour Analysis
7. Day of Week Analysis
8. Window Functions
9. Ranking Functions
10. CASE WHEN Analysis
11. Subqueries
12. Common Table Expressions (CTE)
13. JOIN Analysis
14. Business Conclusions

==================================================



--1)Which traffic condition has the greatest impact on delivery time?

SELECT
    TRAFFIC,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME), 2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY TRAFFIC
ORDER BY AVG_DELIVERY_TIME DESC;

-- Insight:


Heavy traffic (Jam) leads to the longest average delivery time.


Deliveries under Low traffic conditions are approximately 46 minutes faster than under Jam conditions.

Most deliveries occur during Low and Medium traffic periods.

-- Recommendation:


Increase courier availability during heavy traffic periods.

Optimize delivery routes using traffic-aware navigation.

Inform customers about potential delays during peak congestion.

-- Business Impact:


Reducing the impact of heavy traffic can improve delivery efficiency, increase customer satisfaction, and lower operational delays.
-------------------------------------------------------
--2)How do different weather conditions affect delivery performance?

sELECT
    WEATHER,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME), 2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY WEATHER
ORDER BY AVG_DELIVERY_TIME DESC;

-- Insight:


Cloudy and Fog conditions are associated with the longest delivery times.

Sunny weather provides the fastest delivery performance.

Weather significantly affects operational efficiency.

-- Recommendation:


Allocate additional couriers during adverse weather conditions.

Incorporate weather forecasts into delivery planning.

Inform customers about expected delays during poor weather.

-- Business Impact:


Weather-aware planning can improve delivery reliability and reduce customer complaints.


-------------------------------------------------------
--3)Which delivery vehicle performs most efficiently?

SELECT
    VEHICLE,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME), 2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY VEHICLE
ORDER BY AVG_DELIVERY_TIME DESC;

-- Insight:


Motorcycles account for the majority of deliveries but also show the highest average delivery time.

Scooters and vans demonstrate similar delivery performance.

Vehicle type alone does not fully explain delivery efficiency.

-- Recommendation:


Analyze route assignments by vehicle type.

Match vehicle types to delivery distance and order characteristics.

Monitor motorcycle workload to identify operational bottlenecks.

-- Business Impact:


Optimizing vehicle allocation can improve fleet utilization and reduce average delivery times.


-------------------------------------------------------
--4)Does product category influence delivery time?

SELECT
    CATEGORY,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME), 2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY CATEGORY
ORDER BY AVG_DELIVERY_TIME DESC;

-- Insight:


Average delivery time is relatively consistent across all product categories.

No category demonstrates a substantial delivery delay.

Product category has a limited impact on delivery performance.

-- Recommendation:


Do not prioritize optimization efforts based on product category.

Focus operational improvements on traffic, weather, and delivery distance instead.

-- Business Impact:


Concentrating on high-impact operational factors will provide greater improvements than category-specific optimization.


-------------------------------------------------------
--5)Which delivery areas experience the longest delivery times?

SELECT
    AREA,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME), 2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY AREA
ORDER BY AVG_DELIVERY_TIME DESC;

-- Insight:


Semi-Urban areas show the highest average delivery time.

However, the sample size for Semi-Urban deliveries is very small (152 orders).

Metropolitan areas generate the highest delivery volume.

-- Recommendation:


Investigate Semi-Urban operations before making strategic decisions.

Prioritize optimization efforts within Metropolitan areas due to their large order volume.

-- Business Impact:


Improving delivery efficiency in Metropolitan areas can have the greatest overall operational impact.

-------------------------------------------------------
--6)At what time of day does delivery performance decline?

SELECT
    ORDER_HOUR,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME), 2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY ORDER_HOUR
ORDER BY ORDER_HOUR;

-- Insight


Morning deliveries (08:00–10:00) are completed the fastest.

Delivery time increases significantly after 11:00.

Evening hours combine the highest order volume with longer delivery times.

-- Recommendation


Increase courier capacity during evening peak hours.

Use demand forecasting to balance courier workload throughout the day.

-- Business Impact


Optimizing staffing during peak hours can reduce delays and improve delivery throughput.


-------------------------------------------------------
--7)Does delivery performance vary across different days of the week?

SELECT
    DAY_OF_WEEK,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME), 2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY DAY_OF_WEEK
ORDER BY AVG_DELIVERY_TIME DESC

-- Insight


Wednesday records the highest average delivery time.

Thursday achieves the fastest delivery performance.

Order volume remains relatively stable throughout the week.

-- Recommendation


Investigate operational conditions on Wednesdays.

Compare staffing levels and traffic patterns between Wednesday and Thursday.

--🚀 Business Impact


Understanding weekly delivery patterns can improve workforce planning and operational efficiency.


-------------------------------------------------------
--8.1)Which deliveries took the longest within each delivery area?


SELECT *
FROM (
    SELECT
        AREA,
        ORDER_ID,
        DELIVERY_TIME,
        TRAFFIC,
        WEATHER,
        VEHICLE,
        ROW_NUMBER() OVER (
            PARTITION BY AREA
            ORDER BY DELIVERY_TIME DESC
        ) AS RN
    FROM AMAZON_DELIVERY
)
WHERE RN <= 5
ORDER BY AREA, RN;

-- Insight


Each delivery area has its own ranking of the longest deliveries.

Semi-Urban deliveries dominate the highest delivery times.

This query identifies extreme cases within each area instead of comparing all deliveries together.

-- Recommendation


Investigate the top delayed deliveries in each area.

Identify common factors such as traffic, weather, or route complexity.

Prioritize operational improvements for recurring delay patterns.
-- Business Impact


Identifying the longest deliveries within each region helps operations teams target specific bottlenecks instead of applying general solutions.
-------------------------------------------------------
--8.2)How much does each delivery differ from the overall average delivery time?

SELECT
    ORDER_ID,
    DELIVERY_TIME,
    ROUND(AVG(DELIVERY_TIME) OVER (),2) AS GLOBAL_AVG,
    ROUND(
        DELIVERY_TIME -
        AVG(DELIVERY_TIME) OVER (),2
    ) AS DIFFERENCE
FROM AMAZON_DELIVERY
FETCH FIRST 15 ROWS ONLY;

-- Insight


Positive values indicate deliveries slower than average.

Negative values indicate deliveries faster than average.

This allows every delivery to be evaluated against the overall operational benchmark.

-- Recommendation


Focus investigation on deliveries with the largest positive differences.

Analyze operational factors causing unusually slow deliveries.

-- Business Impact


Benchmarking individual deliveries against the global average enables faster identification of inefficient operations.
-------------------------------------------------------
--8.3)Which deliveries experienced the highest delivery times?

SELECT
    ORDER_ID,
    DELIVERY_TIME,
    DENSE_RANK() OVER (
        ORDER BY DELIVERY_TIME DESC
    ) AS DELIVERY_RANK
FROM AMAZON_DELIVERY
FETCH FIRST 20 ROWS ONLY;

-- Insight


Deliveries with identical delivery times receive the same rank.

DENSE_RANK() avoids gaps in ranking.

Ranking highlights the most delayed deliveries across the dataset.

-- Recommendation


Review the highest-ranked delayed deliveries.

Identify common operational issues affecting these orders.

-- Business Impact


Ranking delayed deliveries helps prioritize operational investigations and continuous performance improvement.
-------------------------------------------------------
--8.4)How does the cumulative number of orders grow throughout the day?

SELECT
    ORDER_HOUR,
    COUNT(*) AS ORDER_COUNT,
    SUM(COUNT(*)) OVER (
        ORDER BY ORDER_HOUR
    ) AS CUMULATIVE_ORDERS
FROM AMAZON_DELIVERY
GROUP BY ORDER_HOUR
ORDER BY ORDER_HOUR;

-- Insight


The cumulative total increases steadily throughout the day.

Peak ordering periods become easier to identify.

This analysis supports workload planning.

-- Recommendation


Allocate couriers based on cumulative demand growth.

Schedule staff according to peak order accumulation.

-- Business Impact


Understanding cumulative demand helps improve workforce planning and resource allocation.
-------------------------------------------------------
--9)How can deliveries be classified based on delivery time performance?

SELECT
    CASE
        WHEN DELIVERY_TIME < 100 THEN 'Fast'
        WHEN DELIVERY_TIME BETWEEN 100 AND 150 THEN 'Normal'
        ELSE 'Delayed'
    END AS DELIVERY_STATUS,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME),2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY
    CASE
        WHEN DELIVERY_TIME < 100 THEN 'Fast'
        WHEN DELIVERY_TIME BETWEEN 100 AND 150 THEN 'Normal'
        ELSE 'Delayed'
    END
ORDER BY AVG_DELIVERY_TIME DESC;

--Insight: 


Around 40% of deliveries fall into the Delayed category.

Most deliveries are classified as Normal.

Fast deliveries have an average delivery time of only 67.69 minutes, while delayed deliveries average 189.66 minutes.

-- Recommendation: 


Monitor the percentage of delayed deliveries as a key operational KPI.

Improve route planning and courier allocation to shift more deliveries into the Fast and Normal categories.

--Business Impact


Reducing delayed deliveries can significantly improve customer satisfaction while lowering operational costs.
-------------------------------------------------------
--10)Which high-volume categories have the longest average delivery time?

SELECT
    CATEGORY,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME),2) AS AVG_DELIVERY_TIME
FROM AMAZON_DELIVERY
GROUP BY CATEGORY
HAVING COUNT(*) > 2700
ORDER BY AVG_DELIVERY_TIME DESC;

--Insight: 


Among high-volume product categories, Skincare has the highest average delivery time (132.06 min).

Order volumes are relatively similar across these categories, suggesting that delivery delays are not caused by demand alone.

--Recommendation: 


Investigate logistics for the worst-performing categories.

Optimize inventory placement or warehouse allocation for categories with consistently higher delivery times.

--Business Impact


Improving delivery efficiency for high-volume categories can positively affect thousands of customer orders.
-------------------------------------------------------

--11)Which traffic conditions perform worse than the overall average delivery time?

WITH TrafficStats AS (
    SELECT
        TRAFFIC,
        COUNT(*) AS ORDER_COUNT,
        ROUND(AVG(DELIVERY_TIME),2) AS AVG_DELIVERY_TIME
    FROM AMAZON_DELIVERY
    GROUP BY TRAFFIC
),
OverallStats AS (
    SELECT
        ROUND(AVG(DELIVERY_TIME),2) AS OVERALL_AVG
    FROM AMAZON_DELIVERY
)
SELECT
    t.TRAFFIC,
    t.ORDER_COUNT,
    t.AVG_DELIVERY_TIME,
    o.OVERALL_AVG,
    ROUND(t.AVG_DELIVERY_TIME - o.OVERALL_AVG,2) AS DIFFERENCE
FROM TrafficStats t
CROSS JOIN OverallStats o
WHERE t.AVG_DELIVERY_TIME > o.OVERALL_AVG
ORDER BY DIFFERENCE DESC;

--Insight: 


The overall average delivery time is 124.94 minutes.

Jam traffic exceeds the overall average by 22.85 minutes.

High traffic exceeds it by 4.45 minutes.

Medium traffic exceeds it by only 1.92 minutes.

--Recommendation: 


Prioritize traffic-aware routing during Jam periods.

Schedule more couriers during peak congestion hours.

--Business Impact


Reducing delays in Jam traffic can provide the largest improvement in overall delivery performance.
-------------------------------------------------------
--12)Which delivery areas have the longest deliveries ranked from worst to best?

SELECT
    AREA,
    ORDER_ID,
    DELIVERY_TIME,
    RANK() OVER (
        PARTITION BY AREA
        ORDER BY DELIVERY_TIME DESC
    ) AS DELIVERY_RANK
FROM AMAZON_DELIVERY
FETCH FIRST 20 ROWS ONLY;

-- Insight


Multiple deliveries reached the maximum delivery time of 270 minutes.

Metropolitan area contains several deliveries sharing the highest delay.

The RANK() function assigns the same rank to deliveries with identical delivery times.

-- Recommendation


Investigate why multiple deliveries in the Metropolitan area reached the maximum delivery duration.

Focus operational improvements on areas with repeated extreme delays.

-- Business Impact

Identifying the most delayed deliveries helps prioritize operational improvements and reduce severe delivery delays.
-------------------------------------------------------

--13)Which deliveries share the same ranking without leaving gaps between positions?

SELECT
    AREA,
    ORDER_ID,
    DELIVERY_TIME,
    DENSE_RANK() OVER (
        PARTITION BY AREA
        ORDER BY DELIVERY_TIME DESC
    ) AS DELIVERY_RANK
FROM AMAZON_DELIVERY
FETCH FIRST 20 ROWS ONLY;

-- Insight


DENSE_RANK() assigns the same rank to deliveries with identical delivery times without skipping the next rank.

This approach creates a continuous ranking sequence, making it easier to compare delivery performance within each area.

In the Metropolitan area, multiple deliveries share the maximum delivery time of 270 minutes, all receiving rank 1.

-- Recommendation


Use DENSE_RANK() when building operational dashboards or business reports where continuous rankings are easier to interpret.

Identify groups of deliveries with identical performance to investigate common operational issues.

Monitor top-ranked delayed deliveries to prioritize process improvements.
-- Business Impact


Using DENSE_RANK() provides clearer and more intuitive rankings for business users, improving reporting quality and helping operations teams quickly identify the most critical delivery delays.
-------------------------------------------------------
--14)How does average delivery time change throughout the day?

SELECT
    ORDER_HOUR,
    COUNT(*) AS ORDER_COUNT,
    ROUND(AVG(DELIVERY_TIME),2) AS AVG_DELIVERY_TIME,
    LAG(ROUND(AVG(DELIVERY_TIME),2)) OVER (ORDER BY ORDER_HOUR) AS PREVIOUS_HOUR_AVG,
    ROUND(
        ROUND(AVG(DELIVERY_TIME),2) -
        LAG(ROUND(AVG(DELIVERY_TIME),2)) OVER (ORDER BY ORDER_HOUR),
        2
    ) AS CHANGE_FROM_PREVIOUS_HOUR
FROM AMAZON_DELIVERY
GROUP BY ORDER_HOUR
ORDER BY ORDER_HOUR;

-- Insight


The query highlights hourly changes in delivery performance and identifies time periods where delivery time increases or decreases.

-- Recommendation


Adjust courier scheduling during hours with increasing delivery times to reduce future delays.

-- Business Impact


Understanding hourly performance enables better workforce planning and improves delivery efficiency.
-------------------------------------------------------

-- 15) Which deliveries belong to the worst-performing 20% based on delivery time?

SELECT *
FROM (
    SELECT
        ORDER_ID,
        DELIVERY_TIME,
        TRAFFIC,
        WEATHER,
        VEHICLE,
        AREA,
        NTILE(5) OVER (
            ORDER BY DELIVERY_TIME DESC
        ) AS DELIVERY_GROUP
    FROM AMAZON_DELIVERY
)
WHERE DELIVERY_GROUP = 1
FETCH FIRST 20 ROWS ONLY;

-- Insight

The query isolates the most delayed deliveries, making it easier to identify common characteristics among the worst-performing orders.

-- Recommendation

Perform root-cause analysis on the worst delivery group to identify operational bottlenecks.

-- Business Impact

Focusing on the slowest deliveries provides the greatest opportunity to improve overall service quality.
-------------------------------------------------------

-- 16)What are the overall delivery performance KPIs?

SELECT
    COUNT(*) AS TOTAL_ORDERS,
    ROUND(AVG(DELIVERY_TIME),2) AS AVG_DELIVERY_TIME,
    MIN(DELIVERY_TIME) AS MIN_DELIVERY_TIME,
    MAX(DELIVERY_TIME) AS MAX_DELIVERY_TIME,
    ROUND(AVG(DISTANCE_KM),2) AS AVG_DISTANCE_KM
FROM AMAZON_DELIVERY;

-- Insight

The query provides a high-level overview of operational performance, including delivery volume, delivery time, and travel distance.

-- Recommendation

Use these KPIs as baseline metrics for operational dashboards and continuous performance monitoring.

-- Business Impact

Tracking these core KPIs helps management measure operational efficiency and evaluate future improvements.
