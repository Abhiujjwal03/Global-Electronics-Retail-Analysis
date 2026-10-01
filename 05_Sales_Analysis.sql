USE Global_Electronics;

-- ============================================================
-- 1. Overall Sales Summary
-- ============================================================

SELECT
    COUNT(DISTINCT Order_Number) AS Total_Orders,
    SUM(Quantity) AS Total_Quantity_Sold,
    COUNT(DISTINCT CustomerKey) AS Total_Customers,
    COUNT(DISTINCT ProductKey) AS Total_Products_Sold,
    ROUND(
        SUM(
            Quantity *
            CAST(REPLACE(
                (SELECT Unit_Price_USD
                 FROM Products
                 WHERE Products.ProductKey = Sales.ProductKey),
                '$', ''
            ) AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Sales;
-- ============================================================
-- 2. Year-wise Sales Performance
-- ============================================================

SELECT
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Year,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
ORDER BY Sales_Year;
-- ============================================================
-- 3. Month-wise Sales Performance
-- ============================================================

SELECT
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Year,
    MONTH(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Month,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')),
    MONTH(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
ORDER BY
    Sales_Year,
    Sales_Month;
    -- ============================================================
-- 4. Year-wise Order Count & Average Order Value
-- ============================================================

SELECT
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Year,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        )
        / COUNT(DISTINCT s.Order_Number),
        2
    ) AS Average_Order_Value
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
ORDER BY Sales_Year;
-- ============================================================
-- 5. Country-wise Sales Performance
-- ============================================================

SELECT
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    COUNT(DISTINCT c.CustomerKey) AS Total_Customers,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Sales AS s
INNER JOIN Customers AS c
    ON s.CustomerKey = c.CustomerKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY c.Country
ORDER BY Total_Sales_Value DESC;
-- ============================================================
-- 6. Store-wise Sales Performance
-- ============================================================

SELECT
    st.StoreKey,
    st.Country,
    st.State,
    st.Square_Meters,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Stores AS st
INNER JOIN Sales AS s
    ON st.StoreKey = s.StoreKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    st.StoreKey,
    st.Country,
    st.State,
    st.Square_Meters
ORDER BY Total_Sales_Value DESC;
-- ============================================================
-- 7. Store-wise Average Order Value
-- ============================================================

SELECT
    st.StoreKey,
    st.Country,
    st.State,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        )
        / COUNT(DISTINCT s.Order_Number),
        2
    ) AS Average_Order_Value
FROM Stores AS st
INNER JOIN Sales AS s
    ON st.StoreKey = s.StoreKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    st.StoreKey,
    st.Country,
    st.State
ORDER BY Average_Order_Value DESC;
-- ============================================================
-- 8. Monthly Order Count
-- ============================================================

SELECT
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Year,
    MONTH(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Month,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Sales AS s
GROUP BY
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')),
    MONTH(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
ORDER BY
    Sales_Year,
    Sales_Month;
    -- ============================================================
-- 9. Monthly Sales Value
-- ============================================================

SELECT
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Year,
    MONTH(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Month,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')),
    MONTH(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
ORDER BY
    Sales_Year,
    Sales_Month;
    -- ============================================================
-- 10. Top 10 Stores by Sales Value
-- ============================================================

SELECT
    st.StoreKey,
    st.Country,
    st.State,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Stores AS st
INNER JOIN Sales AS s
    ON st.StoreKey = s.StoreKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    st.StoreKey,
    st.Country,
    st.State
ORDER BY Total_Sales_Value DESC
LIMIT 10;
-- ============================================================
-- 11. Top 10 Countries by Number of Orders
-- ============================================================

SELECT
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    COUNT(DISTINCT c.CustomerKey) AS Total_Customers
FROM Sales AS s
INNER JOIN Customers AS c
    ON s.CustomerKey = c.CustomerKey
GROUP BY c.Country
ORDER BY Total_Orders DESC
LIMIT 10;
-- ============================================================
-- 12. Top 10 Customers by Sales Value
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
ORDER BY Total_Sales_Value DESC
LIMIT 10;
-- ============================================================
-- 13. Sales by Day of Week
-- ============================================================

SELECT
    DAYNAME(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Day_of_Week,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    DAYNAME(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')),
    DAYOFWEEK(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
ORDER BY
    DAYOFWEEK(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'));
    -- ============================================================
-- 14. Year-wise Quantity Sold
-- ============================================================

SELECT
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Sales_Year,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Sales AS s
GROUP BY
    YEAR(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
ORDER BY Sales_Year;
-- ============================================================
-- 15. Sales Value by Store Country
-- ============================================================

SELECT
    st.Country,
    COUNT(DISTINCT st.StoreKey) AS Total_Stores,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Stores AS st
INNER JOIN Sales AS s
    ON st.StoreKey = s.StoreKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY st.Country
ORDER BY Total_Sales_Value DESC;
