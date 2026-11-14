create database ris2;
use ris2;

CREATE TABLE sales_practice2 (Row_ID INT PRIMARY KEY,Order_ID VARCHAR(30),Order_Date DATE,Ship_Date DATE,Ship_Mode VARCHAR(30),Customer_ID VARCHAR(20),Customer_Name VARCHAR(100),Segment VARCHAR(30),Country VARCHAR(50),City VARCHAR(60),State VARCHAR(60),Postal_Code VARCHAR(10),Region VARCHAR(30),Product_ID VARCHAR(20),Category VARCHAR(40),Sub_Category VARCHAR(40),Product_Name VARCHAR(120),Quantity INT,Sales DECIMAL(12,2),Discount DECIMAL(4,2),Profit DECIMAL(12,2));
select*from sales_practice2;
select count(*) from sales_practice2;

-- DATA UNDERSTANDING

describe sales_practice2;
select*from sales_practice2 limit 20;
select count(*) as total_rows from sales_practice2;

-- PHASE-2 DATA CLEANING / CHEKS
-- 2.1 Date range
select min(Order_Date) as first_order, max(Order_Date) as last_order
from sales_practice2;

-- 2.2 NULL check table
select
sum(Order_id is null) as null_order_id,
sum(Order_date is null) as null_order_date,
sum(Ship_Date is null) as null_ship_date,
sum(Sales is null) as null_Sales,
sum(Profit is null) as null_Profit
from sales_practice2;

-- 2.3 CHECK MISSING VALUES

SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 ELSE 0 END) AS Missing_Order_ID,
    SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS Missing_Customer,
    SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS Missing_Order_Date,
    SUM(CASE WHEN Product_Name IS NULL THEN 1 ELSE 0 END) AS Missing_Product,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Missing_Sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Missing_Profit
FROM sales_practice2;

-- 2.4 DUPLICATE ROWS_ID

select ROW_ID,count(*) as cnt
from sales_practice2
group by ROW_ID
Having count(*)>1;

-- PHASE-3 BASIC SQL ANALYSIS

SELECT SUM(Sales) AS Total_Sales
FROM sales_practice2;

SELECT SUM(Profit) AS Total_Profit
FROM sales_practice2;

SELECT COUNT(DISTINCT Order_ID) AS Total_Orders
FROM sales_practice2;

SELECT COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM sales_practice2;

SELECT AVG(Sales) AS Average_Sales
FROM sales_practice2;

SELECT SUM(Quantity) AS Total_Quantity
FROM sales_practice2;

SELECT
    MIN(Sales) AS Minimum_Sales,
    MAX(Sales) AS Maximum_Sales
FROM sales_practice2;

SELECT
    Category,
    SUM(Sales) AS Total_Sales
FROM sales_practice2
GROUP BY Category
ORDER BY Total_Sales DESC;

SELECT
    Category,
    SUM(Profit) AS Total_Profit
FROM sales_practice2
GROUP BY Category
ORDER BY Total_Profit DESC;

SELECT
    Region,
    SUM(Sales) AS Total_Sales
FROM sales_practice2
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT
    State,
    SUM(Sales) AS Total_Sales
FROM sales_practice2
GROUP BY State
ORDER BY Total_Sales DESC;

SELECT
    Segment,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM sales_practice2
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- PHASE-4 INTERMEDIATE SQL ANALYSIS

SELECT
    Product_Name,
    SUM(Sales) AS Total_Sales
FROM sales_practice2
GROUP BY Product_Name
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT
    Product_Name,
    SUM(Sales) AS Total_Sales
FROM sales_practice2
GROUP BY Product_Name
ORDER BY Total_Sales ASC
LIMIT 10;

SELECT
    Product_Name,
    SUM(Profit) AS Total_Profit
FROM sales_practice2
GROUP BY Product_Name
ORDER BY Total_Profit DESC
LIMIT 10;

SELECT
    YEAR(Order_Date) AS Sales_Year,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM sales_practice2
GROUP BY YEAR(Order_Date)
ORDER BY Sales_Year;

SELECT
    Category,
    AVG(Discount) AS Average_Discount
FROM sales_practice2
GROUP BY Category;

SELECT *
FROM sales_practice2
WHERE Sales > 1000
ORDER BY Sales DESC;

SELECT
    Ship_Mode,
    COUNT(*) AS Total_Orders,
    SUM(Sales) AS Total_Sales
FROM sales_practice2
GROUP BY Ship_Mode
ORDER BY Total_Orders DESC;


    
-- Phase 5 – Advanced SQL Analysis

SELECT
    Product_Name,
    SUM(Sales) AS Total_Sales,

    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS Sales_Rank

FROM sales_practice2
GROUP BY Product_Name;


SELECT
    Category,
    Product_Name,
    Total_Sales,

    RANK() OVER (
        PARTITION BY Category
        ORDER BY Total_Sales DESC
    ) AS Product_Rank

FROM (
    SELECT
        Category,
        Product_Name,
        SUM(Sales) AS Total_Sales
    FROM sales_practice2
    GROUP BY Category, Product_Name
) AS Product_Summary;

WITH State_Sales AS (

    SELECT
        State,
        SUM(Sales) AS Total_Sales
    FROM sales_practice2
    GROUP BY State

)

SELECT *
FROM State_Sales
ORDER BY Total_Sales DESC;


WITH Monthly_Sales AS (

    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS Sales_Month,
        SUM(Sales) AS Total_Sales
    FROM sales_practice2
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')

)

SELECT
    Sales_Month,
    Total_Sales,

    SUM(Total_Sales) OVER (
        ORDER BY Sales_Month
    ) AS Running_Sales

FROM Monthly_Sales;

SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.10 THEN 'Low Discount'
        WHEN Discount <= 0.20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS Discount_Group,

    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit) AS Average_Profit

FROM sales_practice2
GROUP BY Discount_Group
ORDER BY Total_Sales DESC;


select region, 
sum(Profit) as Total_Profit
from sales_practice2
group by region 
order by Total_Profit;