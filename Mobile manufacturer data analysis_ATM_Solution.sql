--SQL Advance Case Study_Assignment2
        --DATABASE db.SQLCaseStudies

SELECT TOP 1 * FROM dbo.DIM_CUSTOMER
SELECT TOP 1 * FROM dbo.DIM_DATE
SELECT TOP 1 * FROM dbo.DIM_LOCATION
SELECT  * FROM dbo.DIM_MANUFACTURER
SELECT  * FROM dbo.DIM_MODEL
SELECT * FROM dbo.FACT_TRANSACTIONS

--Q1--BEGIN 

--1. List all the states in which we have customers who have bought cellphones 
--from 2005 till today. 
SELECT C.State FROM  FACT_TRANSACTIONS AS B
JOIN DIM_LOCATION AS C
ON B.IDLocation = C.IDLocation
WHERE  YEAR(B.Date) >= '2005'
GROUP BY C.State

--Q1--END

--Q2--BEGIN
--2. What state in the US is buying the most 'Samsung' cell phones? 

SELECT TOP 1 A.State
FROM DIM_LOCATION AS A
JOIN FACT_TRANSACTIONS AS B
ON A.IDLocation = B.IDLocation
JOIN DIM_MODEL AS C
ON B.IDModel = C.IDModel
JOIN DIM_MANUFACTURER AS D
ON C.IDManufacturer = D.IDManufacturer
WHERE D.Manufacturer_Name = 'Samsung' AND A.Country = 'US'
GROUP BY A.State
ORDER BY SUM(B.Quantity) DESC

--Q2--END

--Q3--BEGIN 
--3. Show the number of transactions for each model per zip code per state. 

SELECT B.IDModel,C.State ,C.ZipCode,
COUNT(*) AS NO_OF_TRANSACTION
FROM FACT_TRANSACTIONS AS A
INNER JOIN DIM_MODEL AS B
ON A.IDModel = B.IDModel 
INNER JOIN DIM_LOCATION AS C
ON A.IDLocation = C.IDLocation
GROUP BY C.State,C.ZipCode,B.IDModel

--Q3--END

--Q4--BEGIN
--4. Show the cheapest cellphone (Output should contain the price also)
SELECT TOP 1 Model_Name,B.Manufacturer_Name ,
MIN(UNIT_PRICE) AS Price
FROM DIM_MODEL AS A
INNER JOIN DIM_MANUFACTURER AS B
ON A.IDManufacturer = B.IDManufacturer
GROUP BY Model_Name,B.Manufacturer_Name 
ORDER BY MIN(UNIT_PRICE)


--Alternate way
SELECT B.Manufacturer_Name, A.Unit_price
FROM DIM_MODEL AS A
JOIN DIM_MANUFACTURER AS B
ON A.IDManufacturer = B.IDManufacturer
WHERE A.Unit_price IN(
					SELECT MIN(UNIT_PRICE) AS min_price FROM DIM_MODEL)

--Q4--END

--Q5--BEGIN
--5. Find out the average price for each model in the top5 manufacturers in 
--terms of sales quantity and order by average price.

WITH Top5Manufacturers AS
(
		SELECT TOP 5 B.IDManufacturer,B.Manufacturer_Name, SUM(C.Quantity) AS Sales_Qty, 
		AVG(C.TotalPrice) as Avg_ManufacturerPrice
		FROM DIM_MODEL AS A
		JOIN DIM_MANUFACTURER AS B
		ON A.IDManufacturer = B.IDManufacturer
		join FACT_TRANSACTIONS AS C
		 ON A.IDModel = C.IDModel
		group by B.IDManufacturer,B.Manufacturer_Name
		ORDER BY Sales_Qty DESC, Avg_ManufacturerPrice DESC),
AverageModelPrice AS(
		SELECT A.Model_Name, B.IDManufacturer, 
		AVG(C.TotalPrice) as AvgPrice
		FROM DIM_MODEL AS A
		JOIN DIM_MANUFACTURER AS B
		ON A.IDManufacturer = B.IDManufacturer
		join FACT_TRANSACTIONS AS C
		ON A.IDModel = C.IDModel 
		GROUP BY A.Model_Name, B.IDManufacturer)

SELECT MP.Model_Name,MP.AvgPrice FROM Top5Manufacturers AS MF 
JOIN AverageModelPrice as MP ON MF.IDManufacturer = MP.IDManufacturer

--Q5--END

--Q6--BEGIN
--6. List the names of the customers and the average amount spent in 2009, 
--where the average is higher than 500 

SELECT A.IDCustomer, A.Customer_Name,AVG(B.TotalPrice ) AS Avg_Amount
from DIM_CUSTOMER AS A
INNER JOIN FACT_TRANSACTIONS AS B
ON A.IDCustomer = B.IDCustomer
WHERE YEAR(B.DATE) = 2009
GROUP BY A.Customer_Name,A.IDCustomer
HAVING AVG(B.TotalPrice ) > 500


--Q6--END
	
--Q7--BEGIN  
--7. List if there is any model that was in the top 5 in terms of quantity, 
--simultaneously in 2008, 2009 and 2010	

Select T1.Model_Name  from
	   (select top 5 B.Model_Name,B.IDmodel ,SUM(A.Quantity) as TotQty from FACT_TRANSACTIONS as A
		inner join DIM_MODEL as B on A.IDModel = B.IDModel
		 where YEAR(A.[Date])=2008 
		 group by B.Model_Name,B.IDmodel
		 order by TotQty desc) as T1 inner join

		 (select top 5 B.Model_Name,B.IDmodel ,SUM(A.Quantity) as TotQty from FACT_TRANSACTIONS as A
		inner join DIM_MODEL as B on A.IDModel = B.IDModel
		 where YEAR(A.[Date])=2009 
		 group by B.Model_Name,B.IDmodel
		 order by TotQty desc) as T2 on T1.Model_Name=T2.Model_Name inner join

	    (select top 5 B.Model_Name,B.IDmodel ,SUM(A.Quantity) as TotQty from FACT_TRANSACTIONS as A
		inner join DIM_MODEL as B on A.IDModel = B.IDModel
		 where YEAR(A.[Date])=2010
		 group by B.Model_Name,B.IDmodel
		 order by TotQty desc)as T3 on T3.Model_Name=T2.Model_Name;

--Q7--END

--Q8--BEGIN
--8. Show the manufacturer with the 2nd top sales in the year of 2009 and the 
--manufacturer with the 2nd top sales in the year of 2010. 

SELECT * FROM 
(SELECT ROW_NUMBER() OVER(ORDER BY SUM(A.TotalPrice) DESC) AS Row_Count, 
C.Manufacturer_Name, YEAR(DATE) AS YEAR_ ,
SUM(A.TotalPrice) AS Total_sales FROM FACT_TRANSACTIONS AS A
INNER JOIN DIM_MODEL AS B
ON A.IDModel = B.IDModel
INNER JOIN DIM_MANUFACTURER AS C
ON B.IDManufacturer = C.IDManufacturer
where YEAR(A.[Date])=2009
group by C.Manufacturer_Name,YEAR(DATE) )
AS T1 WHERE Row_Count = 2
 
UNION ALL

SELECT * FROM 
(SELECT ROW_NUMBER() OVER(ORDER BY SUM(A.TotalPrice) DESC) AS Row_Count, C.Manufacturer_Name, YEAR(DATE) AS YEAR_ ,
SUM(A.TotalPrice) AS Total_sales FROM FACT_TRANSACTIONS AS A
INNER JOIN DIM_MODEL AS B
ON A.IDModel = B.IDModel
INNER JOIN DIM_MANUFACTURER AS C
ON B.IDManufacturer = C.IDManufacturer
where YEAR(A.[Date])=2010
group by C.Manufacturer_Name,YEAR(DATE) )
AS T1 WHERE Row_Count = 2

--Q8--END

--Q9--BEGIN
--9. Show the manufacturers that sold cellphones in 2010 but did not in 2009.

SELECT Manufacturer_Name FROM
(SELECT C.Manufacturer_Name,SUM(A.TotalPrice) AS Total_Amt 
FROM FACT_TRANSACTIONS AS A
INNER JOIN DIM_MODEL AS B
ON A.IDModel = B.IDModel
INNER JOIN DIM_MANUFACTURER AS C
ON B.IDManufacturer = C.IDManufacturer
WHERE YEAR(A.Date) in( 2010)
group by C.Manufacturer_Name, YEAR(A.Date) )AS T1

EXCEPT

SELECT Manufacturer_Name FROM
(SELECT C.Manufacturer_Name,SUM(A.TotalPrice) AS Total_Amt 
FROM FACT_TRANSACTIONS AS A
INNER JOIN DIM_MODEL AS B
ON A.IDModel = B.IDModel
INNER JOIN DIM_MANUFACTURER AS C
ON B.IDManufacturer = C.IDManufacturer
WHERE YEAR(A.Date) in( 2009)
group by C.Manufacturer_Name, YEAR(A.Date) ) AS T2

--Q9--END

--Q10--BEGIN
-- 10. Find top 100 customers and their average spend, average quantity by each 
--year. Also find the percentage of change in their spend

WITH TopCustomers AS (
    -- Selecting top 10 customers based on TotalPrice
    SELECT TOP 100 C.IDCustomer, C.Customer_Name
    FROM DIM_CUSTOMER AS C
    LEFT JOIN FACT_TRANSACTIONS AS F ON F.IDCustomer = C.IDCustomer
    GROUP BY C.IDCustomer, C.Customer_Name
    ORDER BY SUM(F.TotalPrice) DESC
),
CustomerYearlyData AS (
    -- Fetching yearly average spend and quantity for each customer
    SELECT 
        C.IDCustomer,
        C.Customer_Name,
        YEAR(F.Date) AS Year_,
        AVG(F.TotalPrice) AS Avg_Spend,
        AVG(F.Quantity) AS Avg_Qty,
        LAG(AVG(F.TotalPrice)) OVER (PARTITION BY C.IDCustomer ORDER BY YEAR(F.Date)) AS Prev_Year_Spend
    FROM TopCustomers AS C
    LEFT JOIN FACT_TRANSACTIONS AS F ON F.IDCustomer = C.IDCustomer
    GROUP BY C.IDCustomer, C.Customer_Name, YEAR(F.Date)
)
-- Main query to calculate year-on-year percentage change
SELECT 
    IDCustomer,
    Customer_Name,
    Year_,
    Avg_Spend,
    Avg_Qty,
    CASE 
        WHEN Prev_Year_Spend IS NOT NULL AND Prev_Year_Spend != 0
        THEN ((Avg_Spend - Prev_Year_Spend) / Prev_Year_Spend) * 100
        ELSE NULL 
    END AS 'YOY in Average Spend'
FROM CustomerYearlyData;

--Q10--END
