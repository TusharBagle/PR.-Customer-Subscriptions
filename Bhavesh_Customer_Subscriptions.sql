CREATE DATABASE Bhavesh_Customer_Subscriptions ;

USE Bhavesh_Customer_Subscriptions ;

SHOW TABLES ;


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SELECT
	*
FROM customersubscriptions ;


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 1. Total number of active vs churned customers (by SubscriptionType).

SELECT
    SubscriptionType,
    SUM(
		CASE WHEN IsChurned = 1 THEN 1 ELSE 0 END
        ) AS Churned_Customers ,
    SUM(
		CASE WHEN IsChurned = 0 THEN 1 ELSE 0 END
		) AS Active_Customers ,
    COUNT(*) AS Total_Customers
FROM customersubscriptions
GROUP BY SubscriptionType
ORDER BY SubscriptionType ;


-- OUTPUT

-- ┌───────────────────┬───────────────────┬──────────────────┬─────────────────┐
-- │ SubscriptionType  │ Churned_Customers │ Active_Customers │ Total_Customers │
-- ├───────────────────┼───────────────────┼──────────────────┼─────────────────┤
-- │ Monthly           │ 488               │ 514              │ 1002            │
-- │ Quarterly         │ 188               │ 432              │ 620             │
-- │ Yearly            │ 69                │ 309              │ 378             │
-- └───────────────────┴───────────────────┴──────────────────┴─────────────────┘


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--  2. Average FeedbackScore by SubscriptionType and Gender.

SELECT
    SubscriptionType ,
    Gender ,
    ROUND(
		AVG(FeedbackScore) , 2
        ) AS AvgFeedback_Score,
    COUNT(*) AS Customer_Count
FROM CustomerSubscriptions
GROUP BY SubscriptionType , Gender
ORDER BY SubscriptionType , Gender ;


-- OUTPUT

-- ┌───────────────────┬─────────┬───────────────────┬─────────────────┐
-- │ SubscriptionType  │ Gender  │ AvgFeedback_Score │ Customer_Count  │
-- ├───────────────────┼─────────┼───────────────────┼─────────────────┤
-- │ Monthly           │ Female  │ 5.38              │ 473             │
-- │ Monthly           │ Male    │ 5.29              │ 486             │
-- │ Monthly           │ Other   │ 5.30              │ 43              │
-- │ Quarterly         │ Female  │ 5.86              │ 317             │
-- │ Quarterly         │ Male    │ 5.98              │ 277             │
-- │ Quarterly         │ Other   │ 6.62              │ 26              │
-- │ Yearly            │ Female  │ 6.21              │ 184             │
-- │ Yearly            │ Male    │ 6.47              │ 176             │
-- │ Yearly            │ Other   │ 6.00              │ 18              │
-- └───────────────────┴─────────┴───────────────────┴─────────────────┘


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 3. List customers who attended < 5 sessions AND gave feedback < 5.

SELECT
    CustomerID ,
    Name ,
    SubscriptionType ,
    TotalSessions ,
    FeedbackScore ,
    IsChurned
FROM CustomerSubscriptions
WHERE TotalSessions < 5
  AND FeedbackScore < 5
ORDER BY TotalSessions ASC , 
			FeedbackScore ASC ;


-- OUTPUT

-- ┌───────────────────┬───────────────────┬──────────────────┬─────────────────┐
-- │ SubscriptionType  │ Churned_Customers │ Active_Customers │ Total_Customers │
-- ├───────────────────┼───────────────────┼──────────────────┼─────────────────┤
-- │ Monthly           │ 488               │ 514              │ 1002            │
-- │ Quarterly         │ 188               │ 432              │ 620             │
-- │ Yearly            │ 69                │ 309              │ 378             │
-- └───────────────────┴───────────────────┴──────────────────┴─────────────────┘


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            
-- 4. Identify customers who haven’t logged in for the past 60 days.

SELECT
    CustomerID ,
    Name ,
    SubscriptionType ,
    LastLoginDate ,
    CAST(
		JULIANDAY('2026-01-15') - JULIANDAY(LastLoginDate) AS ILU
        ) AS Days_Since_Last_Login,
    IsChurned
FROM CustomerSubscriptions
WHERE JULIANDAY('2026-01-15') - JULIANDAY(LastLoginDate) > 60
ORDER BY DaysSinceLastLogin DESC ;


-- OUTPUT

-- ┌───────────────────┬───────────────────┬──────────────────┬─────────────────┐
-- │ SubscriptionType  │ Churned_Customers │ Active_Customers │ Total_Customers │
-- ├───────────────────┼───────────────────┼──────────────────┼─────────────────┤
-- │ Monthly           │ 488               │ 514              │ 1002            │
-- │ Quarterly         │ 188               │ 432              │ 620             │
-- │ Yearly            │ 69                │ 309              │ 378             │
-- └───────────────────┴───────────────────┴──────────────────┴─────────────────┘


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            
-- 5. Churn rate by SubscriptionType. 

SELECT
    SubscriptionType ,
    COUNT(*) AS Total_Customers ,
    SUM(IsChurned) AS Churned_Customers ,
    ROUND(
        (SUM(IsChurned) * 100.0) / COUNT(*) ,
        2
    ) AS Churn_Rate_Percentage
FROM CustomerSubscriptions
GROUP BY SubscriptionType
ORDER BY Churn_Rate_Percentage DESC ;


-- OUTPUT

-- ┌───────────────────┬─────────────────┬───────────────────┬────────────────────────┐
-- │ SubscriptionType  │ Total_Customers │ Churned_Customers │ Churn_Rate_Percentage  │
-- ├───────────────────┼─────────────────┼───────────────────┼────────────────────────┤
-- │ Monthly           │ 1002            │ 488               │ 48.70                  │
-- │ Quarterly         │ 620             │ 188               │ 30.32                  │
-- │ Yearly            │ 378             │ 69                │ 18.25                  │
-- └───────────────────┴─────────────────┴───────────────────┴────────────────────────┘


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            
-- 6. List Top 10 customers with longest subscriptions (based on SubscriptionDate).

SELECT
    CustomerID ,
    Name ,
    SubscriptionType ,
    SubscriptionDate
FROM CustomerSubscriptions
ORDER BY SubscriptionDate ASC
LIMIT 10 ;


-- OUTPUT

-- ┌────────────┬───────────────────┬─────────────────┬──────────────────┐
-- │ CustomerID │ Name              │ SubscriptionType│ SubscriptionDate │
-- ├────────────┼───────────────────┼─────────────────┼──────────────────┤
-- │ CUST00906  │ Barbara Wilson    │ Yearly          │ 2023-01-01       │
-- │ CUST00910  │ Linda White       │ Yearly          │ 2023-01-02       │
-- │ CUST01241  │ Pooja Flores      │ Yearly          │ 2023-01-02       │
-- │ CUST01247  │ Kevin Johnson     │ Monthly         │ 2023-01-05       │
-- │ CUST01465  │ Donna Martin      │ Monthly         │ 2023-01-05       │
-- │ CUST00179  │ Kevin Roberts     │ Yearly          │ 2023-01-06       │
-- │ CUST01941  │ Christopher Nair  │ Monthly         │ 2023-01-07       │
-- │ CUST01583  │ Rahul Baker       │ Quarterly       │ 2023-01-08       │
-- │ CUST00051  │ Barbara Green     │ Monthly         │ 2023-01-08       │
-- │ CUST01145  │ Meera Nelson      │ Quarterly       │ 2023-01-09       │
-- └────────────┴───────────────────┴─────────────────┴──────────────────┘


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

            
-- 7. Age group-wise churn analysis (e.g., 18–25, 26–35, etc.).

SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END AS Age_Group,

    COUNT(*) AS Total_Customers,

    SUM(IsChurned) AS Churned_Customers,

    ROUND(
        (SUM(IsChurned) * 100.0) / COUNT(*),
        2
    ) AS Churn_Rate_Percentage

FROM CustomerSubscriptions

GROUP BY
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age BETWEEN 56 AND 65 THEN '56-65'
        ELSE '66+'
    END

ORDER BY
    MIN(Age) ;


-- OUTPUT

-- ┌───────────┬────────────────┬───────────────────┬────────────────────────┐
-- │ Age_Group │ Total_Customers│ Churned_Customers │ Churn_Rate_Percentage   │
-- ├───────────┼────────────────┼───────────────────┼────────────────────────┤
-- │ 66+       │ 158            │ 77                │ 48.73                  │
-- │ 18-25     │ 307            │ 138               │ 44.95                  │
-- │ 26-35     │ 669            │ 240               │ 35.87                  │
-- │ 36-45     │ 611            │ 213               │ 34.86                  │
-- │ 46-55     │ 209            │ 66                │ 31.58                  │
-- │ 56-65     │ 46             │ 11                │ 23.91                  │
-- └───────────┴────────────────┴───────────────────┴────────────────────────┘


-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------