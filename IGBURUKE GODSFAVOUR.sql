use ecommerce;

-- 1. Total Sales by Employee: 
-- Write a query to calculate the total sales (in dollars) made by each employee, considering the quantity and unit price of products sold.
SELECT E.LastName, E.FirstName,
SUM( UnitPrice * Quantity * 1- OD.Discount) AS Total_Sales
FROM employees AS E
INNER JOIN  orders AS O
ON E.EmployeeID = O.EmployeeID
INNER JOIN orderdetails AS OD
ON OD.OrderID = O.OrderID
GROUP BY E.LastName, E.FirstName
ORDER BY Total_Sales DESC;

-- 2.Top 5 Customers by Sales:
-- Identify the top 5 customers who have generated the most revenue. Show the customer’s name and the total amount they’ve spent.
SELECT C.CustomerName , 
ROUND(SUM( UnitPrice * Quantity * 1 - OD.Discount) ,2) AS Total_Spent
FROM customers AS C
INNER JOIN  orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN orderdetails AS OD
ON OD.OrderID = O.OrderID
GROUP BY C.CustomerName
ORDER BY Total_Spent DESC
Limit 5;

-- 3. Monthly Sales Trend:
-- Write a query to display the total sales amount for each month in the year 1997.
SELECT month(O.OrderDate) AS MONTHS,
SUM( OD.UnitPrice * OD.Quantity * 1- OD.Discount) AS TotalSales
FROM orders AS O
INNER JOIN orderdetails AS OD
ON O.OrderID = OD.OrderID
WHERE year(O.OrderDate) = 1997
GROUP BY month(O.OrderDate)
ORDER BY month(O.OrderDate) ASC;

-- 4. Order Fulfilment Time:
-- Calculate the average time (in days) taken to fulfil an order for each employee. Assuming shipping takes 3 or 5 days respectively depending on if the item was ordered in 1996 or 1997.
SELECT E.EmployeeID,
    CONCAT(E.FirstName, ' ', E.LastName) AS Employee_Name,
    ROUND(AVG(
        CASE 
            WHEN YEAR(O.OrderDate) = 1996 THEN 3
            WHEN YEAR(O.OrderDate) = 1997 THEN 5
            ELSE 0 
        END
    ), 2) AS Avg_Fulfilment_Days
FROM Employees E
JOIN Orders O 
ON E.EmployeeID = O.EmployeeID
WHERE YEAR(O.OrderDate) IN (1996, 1997)
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY Avg_Fulfilment_Days DESC;


-- 5.Products by Category with No Sales:
-- List the customers operating in London and total sales for each. 
SELECT C.CustomerName, CITY,
sum(OD.UnitPrice * OD.Quantity) AS TotalSales
FROM customers as C 
LEFT JOIN orders AS o
ON C.CustomerID = O.CustomerID
LEFT JOIN orderdetails AS OD
ON O.OrderID = OD.OrderID
WHERE CITY = 'LONDON'
GROUP BY C.CustomerName, C.CITY
ORDER BY TotalSales DESC;

-- 6. Customers with Multiple Orders on the Same Date:
-- Write a query to find customers who have placed more than one order on the same date.
SELECT C.CustomerName,C.CustomerID, O.OrderDate, Count(*) AS CustomerOrders
FROM customers C
INNER JOIN orders O
ON C.CustomerID = O.CustomerID
GROUP BY CustomerName,OrderDate,CustomerID
HAVING COUNT(*) > 1
ORDER BY CustomerOrders desc;

-- 7.Average Discount per Product:
-- Calculate the average discount given per product across all orders. Round to 2 decimal places.
SELECT P.ProductName, 
ROUND(AVG(OD.Discount), 2) AS AverageDiscount
FROM products as P
INNER JOIN orderdetails as OD
ON P.ProductID = OD.ProductID
GROUP BY ProductName
ORDER BY AverageDiscount DESC;

--  8.Products Ordered by Each Customer:
-- For each customer, list the products they have ordered along with the total quantity of each product ordered.
SELECT C.CustomerID, C.CustomerName,P.ProductName,
SUM(OD.Quantity) AS TOTAL_QUANTITY
From customers AS C
INNER JOIN orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN orderdetails AS OD
ON O.OrderID = OD.OrderID
INNER JOIN products AS P
ON OD.ProductID = P.ProductID
GROUP BY 1,2,3
ORDER BY TOTAL_QUANTITY DESC;

-- 9.Employee Sales Ranking:
-- Rank employees based on their total sales. Show the employeename, total sales, and their rank.
WITH EmployeeSales AS (
	SELECT E.EmployeeID, E.LastName, E.FirstName,
	ROUND(SUM(OD.Quantity * OD.UnitPrice *(1- OD.Discount)), 2) AS Total_Sales
	FROM employees AS E
	INNER JOIN orders AS O
	ON E.EmployeeID = O.EmployeeID
	INNER JOIN orderdetails  AS OD
	ON  O.OrderID = OD.OrderID
	GROUP BY E.EmployeeID, E.FirstName, E.LastName
)
SELECT EmployeeID,CONCAT(LastName," ",FirstName) AS Employee_Name,Total_Sales,
RANK () OVER(ORDER BY Total_Sales DESC) AS Employee_Rank
From EmployeeSales;

--  10. Sales by Country and Category:
-- Write a query to display the total sales amount for each product category, grouped by country.
SELECT CA.CategoryName, 
SUM( OD.Quantity* OD.UnitPrice * (1- OD.Discount)) AS Total_Sales,
C.Country
From customers AS C
INNER JOIN orders AS O
ON C.CustomerID = O.CustomerID
INNER JOIN orderdetails AS OD
ON O.OrderID = OD.OrderID
INNER JOIN products AS P
ON OD.ProductID = P.ProductID
INNER JOIN categories AS CA
ON P.CategoryID = CA.CategoryID
GROUP BY 1,3
ORDER BY 2 DESC;


--  11 .Year-over-Year Sales Growth:
-- Calculate the percentage growth in sales from one year to the next for each product.
WITH ProductYearSales AS (
	SELECT P.ProductID, P.ProductName,
	YEAR(O.OrderDate) AS SalesYear,
		ROUND(SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)), 2) AS TotalSales
	FROM OrderDetails OD
	JOIN Orders O
    ON O.OrderID = OD.OrderID
	JOIN Products P 
	ON P.ProductID = OD.ProductID
	GROUP BY P.ProductID, P.ProductName, YEAR(O.OrderDate)
),
SalesWithGrowth AS (
    SELECT ProductID, ProductName, SalesYear, TotalSales,
	LAG(TotalSales) OVER (PARTITION BY ProductID ORDER BY SalesYear) AS PreviousYearSales
    FROM ProductYearSales
)
SELECT ProductID, ProductName, SalesYear, TotalSales, PreviousYearSales,
    ROUND(
        CASE 
            WHEN PreviousYearSales IS NULL THEN NULL
            WHEN PreviousYearSales = 0 THEN NULL
            ELSE ((TotalSales - PreviousYearSales) / PreviousYearSales) * 100
        END, 2
    ) AS YoY_Growth_Percent
FROM SalesWithGrowth
ORDER BY ProductID, SalesYear;

-- 12. Order Quantity Percentile:
-- Calculate the percentile rank of each order based on the total quantity of products in the order. 
WITH TOTAL_QUANTITY AS (	
    SELECT OD.OrderID,
	SUM(Quantity) AS Total_Quantity
	FROM orderdetails AS OD
	INNER JOIN orders AS O
	ON OD.OrderID = O.OrderID
    GROUP BY OrderID
)
	SELECT *,
    ROUND(PERCENT_RANK() OVER(ORDER BY Total_Quantity DESC)) AS Percentile_Rank
    FROM TOTAL_QUANTITY
    ORDER BY Percentile_Rank DESC;
    
-- 13. Products Never Reordered:
-- Identify products that have been sold but have never been reordered (ordered only once). 
SELECT P.ProductID, P.ProductName, COUNT(OD.OrderID) AS No_ofOrder
FROM Products P
INNER JOIN orderdetails OD
ON OD.ProductID = P.ProductID
GROUP BY 1,2
HAVING  No_ofOrder = 1;


-- 14. Most Valuable Product by Revenue:
-- Write a query to find the product that has generated the most revenue in each category.
WITH TOTAL_REVENUE AS (
	SELECT P.ProductName,  C.CategoryName,
	ROUND(SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)), 2) AS Total_Revenue
	FROM categories AS C
	INNER JOIN products AS P 
	ON C.CategoryID = P.CategoryID
	INNER JOIN orderdetails AS OD
	ON OD.ProductID = P.ProductID
	GROUP BY P.ProductName, C.CategoryName	
),	
 ProductsRank AS (
    SELECT *,
	RANK() OVER(PARTITION BY CategoryName ORDER BY Total_Revenue DESC) AS Revenue_Rank
    FROM TOTAL_REVENUE
)
 SELECT *
 FROM ProductsRank
 WHERE Revenue_Rank = 1
 ORDER BY Total_Revenue DESC;

-- 15. Complex Order Details:
-- Identify orders where the total price of all items exceeds $100 and contains at least one product with a discount of 5% or more.

WITH OrderTotals AS (
    SELECT 
        OD.OrderID,
        SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalOrderAmount,
        MAX(OD.Discount) AS MaxDiscount
    FROM OrderDetails OD
    GROUP BY OD.OrderID
)
SELECT O.OrderID, C.CustomerName, E.FirstName, E.LastName,
    ROUND(TotalOrderAmount, 2) AS Total_Price,
    ROUND(MaxDiscount * 100, 2) AS Max_Discount_Percent
FROM OrderTotals OT
JOIN Orders O 
ON O.OrderID = OT.OrderID
JOIN Customers C 
ON C.CustomerID = O.CustomerID
JOIN Employees E
ON E.EmployeeID = O.EmployeeID
WHERE OT.TotalOrderAmount > 100
AND OT.MaxDiscount >= 0.05
ORDER BY TotalOrderAmount DESC;








