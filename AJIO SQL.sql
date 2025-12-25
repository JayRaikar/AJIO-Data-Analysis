--Sales/Revenue KPIs
--Total Revenue
SELECT SUM(p.Price * o.Qty * (1 - o.Discount / 100.0)) AS Total_Revenue
FROM [dbo].[orders] AS o
JOIN [dbo].[products] AS p
ON o.P_ID = p.P_ID

--Avg Order Value
SELECT SUM(p.Price * o.Qty * (1 - o.Discount / 100)) / COUNT(DISTINCT o.Or_ID) AS AvgOrderValue
FROM [dbo].[orders] AS o
JOIN [dbo].[products] AS p
ON o.P_ID = p.P_ID

--Sales by Company 
SELECT DISTINCT p.Company_Name, SUM(p.Price * o.Qty * (1 - o.Discount / 100.0)) AS Total_Revenue
FROM [dbo].[orders] AS o
JOIN [dbo].[products] AS p
ON o.P_ID = p.P_ID
GROUP BY p.Company_Name
ORDER BY Total_Revenue

--Coupon Usage Rate
SELECT Coupon, COUNT(*) AS Usage_Count
FROM [dbo].[orders]
GROUP BY Coupon
ORDER BY Usage_Count DESC;

--Sales State/city
SELECT DISTINCT c.State, c.City, SUM(p.Price * o.Qty * (1 - o.Discount / 100.0)) AS Total_Revenue
FROM [dbo].[orders] AS o
JOIN [dbo].[products] AS p ON o.P_ID = p.P_ID
JOIN [dbo].[customer] AS c ON o.C_ID = c.C_ID
GROUP BY c.State, c.City
ORDER BY Total_Revenue DESC

--Customers KPIs
--Total Customers
SELECT c.State, COUNT(C_ID) AS Total_Customers
FROM [dbo].[customer] AS c
GROUP BY c.State
ORDER BY Total_Customers DESC

--Returning Customers / Customer with more than 1 order by State
SELECT c.State ,o.C_ID, COUNT(*) AS Total_Orders
FROM [dbo].[orders] AS o
JOIN [dbo].[customer] AS c
ON o.C_ID = c.C_ID
GROUP BY o.C_ID, c.State
HAVING COUNT(*) > 1;

--Top customer by spend
SELECT c.C_ID, c.C_Name, c.State, c.City, ROUND(SUM(p.Price * o.Qty * (1 - o.Discount / 100.0)), 2) AS Total_Spend
FROM [dbo].[orders] AS o
JOIN [dbo].[products] as p ON o.P_ID = p.P_ID
JOIN [dbo].[customer] as c ON o.C_ID = c.C_ID
GROUP  BY c.City, c.State, c.C_Name, c.C_ID
ORDER BY Total_Spend

--Customer Demographics
SELECT c.State, c.Gender, 
CASE
    WHEN Age < 20 THEN 'Under 20'
    WHEN Age BETWEEN 20 AND 29 THEN '20-29'
    WHEN Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Age BETWEEN 40 AND 49 THEN '40-49'
    ELSE '50+'
	END AS Age, COUNT(*) AS Count
FROM [dbo].[customer] AS c
GROUP BY c.Gender, Age, C.State
ORDER BY c.Gender, Age

--Product Performance KPIs
--Top Selling Product
SELECT c.State, p.Category, SUM(o.Qty) AS Total_Quantity_Sold
FROM [dbo].[products] AS p
JOIN [dbo].[orders] AS o ON o.P_ID = p.P_ID
JOIN [dbo].[customer] AS c ON c.C_ID = o.C_ID
GROUP BY p.Category, c.State
ORDER BY Total_Quantity_Sold

--Average Product Rating
SELECT p.P_ID, p.P_Name, ROUND(AVG(r.Prod_Rating), 2) AS Avg_Rating
FROM [dbo].[ratings] AS r
JOIN [dbo].[orders] AS o ON r.Or_ID = o.Or_ID
JOIN [dbo].[products] AS p ON p.P_ID = o.P_ID
GROUP BY p.P_ID, p.P_Name

--Most Returned Products
SELECT p.P_Name, r.RT_ID, COUNT(*) AS Returned, r.Reason
FROM [dbo].[orders] AS o
JOIN [dbo].[returns] AS r ON o.Or_ID = r.Or_ID
JOIN [dbo].[products] AS p ON p.P_ID = o.P_ID
GROUP BY r.RT_ID, r.Reason, p.P_Name
ORDER BY Returned 

--Revenue by Product Category
SELECT p.Category, ROUND(SUM(p.Price * o.Qty * (1 - o.Discount / 100.0)), 2) AS Revenue
FROM [dbo].[orders] AS o
JOIN [dbo].[products] AS p ON p.P_ID = o.P_ID 
GROUP BY p.Category
ORDER BY Revenue

--Delivery KPIs
--Average Delivery rating
SELECT r.Or_ID, ROUND(AVG(r.Delivery_Service_Rating), 2) AS Delivery_Avg_Rating
FROM [dbo].[ratings] AS r
GROUP BY r.Or_ID

--Delivery Partner Performance
SELECT d.DP_ID, d.DP_name, o.Or_ID, AVG(DP_Ratings) AS Average_Ratings
FROM [dbo].[orders] AS o
JOIN [dbo].[delivery] AS d ON d.DP_ID = o.DP_ID
GROUP BY d.DP_ID,d.DP_name, o.Or_ID

--Delivery Issues
SELECT d.DP_name, o.Or_ID, c.C_Name, c.C_ID, r.Reason
FROM [dbo].[returns] AS r
JOIN [dbo].[orders] AS o ON o.Or_ID = r.Or_ID
LEFT JOIN [dbo].[delivery] AS d ON d.DP_ID = o.DP_ID
LEFT JOIN [dbo].[customer] AS c ON c.C_ID = o.C_ID
GROUP BY d.DP_name, r.Reason, o.Or_ID, c.C_Name, c.C_ID

--Return & Refund KPIs
--Return Rate
SELECT r.Reason, COUNT(*) AS Return_Rate, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[returns] ), 2) AS Return_Percent
FROM [dbo].[returns] AS r
GROUP BY r.Reason

--Refund Rate
SELECT r.Return_Refund, COUNT(*) AS Refund_Rate, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [dbo].[returns]), 2) AS Refund_Percent
FROM [dbo].[returns] AS r
GROUP BY r.Return_Refund

--Payment Method
SELECT t.Transaction_Mode, COUNT(*) AS Payment_Mode
FROM [dbo].[transaction] AS t
GROUP BY t.Transaction_Mode

--Reward Usage
SELECT t.Reward, COUNT(*) AS Total_Reward
FROM [dbo].[transaction] AS t
GROUP BY t.Reward




