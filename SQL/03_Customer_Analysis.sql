USE Global_Electronics;

-- ============================================================
-- 1. Top 10 Customers by Number of Orders
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Customers AS c
LEFT JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
ORDER BY Total_Orders DESC
LIMIT 10;
-- ============================================================
-- 2. Top 10 Customers by Total Quantity Purchased
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    SUM(s.Quantity) AS Total_Quantity
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
ORDER BY Total_Quantity DESC
LIMIT 10;
-- ============================================================
-- 3. Top 10 Customers by Total Revenue
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    SUM(
        s.Quantity *
        CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
    ) AS Total_Revenue
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
ORDER BY Total_Revenue DESC
LIMIT 10;
-- ============================================================
-- 4. Average Order Value by Customer
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        )
        / COUNT(DISTINCT s.Order_Number),
        2
    ) AS Average_Order_Value
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
ORDER BY Average_Order_Value DESC
LIMIT 10;
-- ============================================================
-- 5. Repeat Customers
-- Customers with More Than One Order
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
HAVING COUNT(DISTINCT s.Order_Number) > 1
ORDER BY Total_Orders DESC;
-- ============================================================
-- 6. Customer Distribution by Country
-- ============================================================

SELECT
    Country,
    COUNT(*) AS Total_Customers
FROM Customers
GROUP BY Country
ORDER BY Total_Customers DESC;
-- ============================================================
-- 7. Total Revenue by Country
-- ============================================================

SELECT
    c.Country,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Revenue
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY c.Country
ORDER BY Total_Revenue DESC;
-- ============================================================
-- 8. Average Revenue per Customer by Country
-- ============================================================

SELECT
    c.Country,
    COUNT(DISTINCT c.CustomerKey) AS Total_Customers,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        )
        / COUNT(DISTINCT c.CustomerKey),
        2
    ) AS Average_Revenue_Per_Customer
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY c.Country
ORDER BY Average_Revenue_Per_Customer DESC;
-- ============================================================
-- 9. Customer Order Frequency
-- ============================================================

SELECT
    Order_Count_Group,
    COUNT(*) AS Number_of_Customers
FROM (
    SELECT
        c.CustomerKey,
        COUNT(DISTINCT s.Order_Number) AS Total_Orders,
        CASE
            WHEN COUNT(DISTINCT s.Order_Number) = 1
                THEN '1 Order'
            WHEN COUNT(DISTINCT s.Order_Number) BETWEEN 2 AND 5
                THEN '2-5 Orders'
            WHEN COUNT(DISTINCT s.Order_Number) BETWEEN 6 AND 10
                THEN '6-10 Orders'
            ELSE '10+ Orders'
        END AS Order_Count_Group
    FROM Customers AS c
    INNER JOIN Sales AS s
        ON c.CustomerKey = s.CustomerKey
    GROUP BY c.CustomerKey
) AS Customer_Order_Summary
GROUP BY Order_Count_Group
ORDER BY Number_of_Customers DESC;
