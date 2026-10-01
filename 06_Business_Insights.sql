USE Global_Electronics;

-- ============================================================
-- 1. High-Value Repeat Customers
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity) AS Total_Quantity,
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
HAVING
    COUNT(DISTINCT s.Order_Number) > 1
ORDER BY
    Total_Sales_Value DESC
LIMIT 20;
-- ============================================================
-- 2. High Order Frequency but Low Sales Value
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
        ),
        2
    ) AS Total_Sales_Value,
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
HAVING
    COUNT(DISTINCT s.Order_Number) >= 5
ORDER BY
    Average_Order_Value ASC
LIMIT 20;
-- ============================================================
-- 3. High-Value Products with Low Sales Volume
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2)),
        2
    ) AS Unit_Price,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    p.Unit_Price_USD
HAVING
    SUM(s.Quantity) <= 20
ORDER BY
    Unit_Price DESC
LIMIT 20;
-- ============================================================
-- 4. High Sales Volume but Low Unit Price
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    ROUND(
        CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2)),
        2
    ) AS Unit_Price,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    p.Unit_Price_USD
HAVING
    SUM(s.Quantity) >= 100
ORDER BY
    Total_Quantity_Sold DESC
LIMIT 20;
-- ============================================================
-- 5. Store Performance vs Store Size
-- ============================================================

SELECT
    st.StoreKey,
    st.Country,
    st.State,
    st.Square_Meters,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Sales_Value,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ) / st.Square_Meters,
        2
    ) AS Sales_Value_Per_Square_Meter
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
ORDER BY
    Sales_Value_Per_Square_Meter DESC;
    -- ============================================================
-- 6. Repeat Customer Rate
-- ============================================================

SELECT
    COUNT(*) AS Total_Customers,
    SUM(
        CASE
            WHEN Total_Orders > 1 THEN 1
            ELSE 0
        END
    ) AS Repeat_Customers,
    ROUND(
        SUM(
            CASE
                WHEN Total_Orders > 1 THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Repeat_Customer_Rate_Percent
FROM (
    SELECT
        c.CustomerKey,
        COUNT(DISTINCT s.Order_Number) AS Total_Orders
    FROM Customers AS c
    INNER JOIN Sales AS s
        ON c.CustomerKey = s.CustomerKey
    GROUP BY c.CustomerKey
) AS Customer_Order_Summary;
-- ============================================================
-- 7. Revenue Contribution by Category
-- ============================================================

SELECT
    p.Category,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Category_Sales_Value,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ) * 100.0
        /
        (
            SELECT
                SUM(
                    s2.Quantity *
                    CAST(REPLACE(p2.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
                )
            FROM Sales AS s2
            INNER JOIN Products AS p2
                ON s2.ProductKey = p2.ProductKey
        ),
        2
    ) AS Sales_Contribution_Percent
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY Category_Sales_Value DESC;
-- ============================================================
-- 8. Top 10 Products by Sales Contribution
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Product_Sales_Value,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ) * 100.0
        /
        (
            SELECT
                SUM(
                    s2.Quantity *
                    CAST(REPLACE(p2.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
                )
            FROM Sales AS s2
            INNER JOIN Products AS p2
                ON s2.ProductKey = p2.ProductKey
        ),
        2
    ) AS Sales_Contribution_Percent
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category
ORDER BY Product_Sales_Value DESC
LIMIT 10;
-- ============================================================
-- 9. Top 10 Brands by Sales Contribution
-- ============================================================

SELECT
    p.Brand,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Brand_Sales_Value,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ) * 100.0
        /
        (
            SELECT
                SUM(
                    s2.Quantity *
                    CAST(REPLACE(p2.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
                )
            FROM Sales AS s2
            INNER JOIN Products AS p2
                ON s2.ProductKey = p2.ProductKey
        ),
        2
    ) AS Sales_Contribution_Percent
FROM Sales AS s
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY p.Brand
ORDER BY Brand_Sales_Value DESC
LIMIT 10;
-- ============================================================
-- 10. Customer Sales Segmentation
-- ============================================================

SELECT
    Customer_Segment,
    COUNT(*) AS Number_of_Customers,
    ROUND(AVG(Total_Sales_Value), 2) AS Average_Sales_Value
FROM (
    SELECT
        c.CustomerKey,
        c.Name,
        ROUND(
            SUM(
                s.Quantity *
                CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
            ),
            2
        ) AS Total_Sales_Value,
        CASE
            WHEN SUM(
                s.Quantity *
                CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
            ) >= 10000
                THEN 'High Value'
            WHEN SUM(
                s.Quantity *
                CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
            ) >= 5000
                THEN 'Medium Value'
            ELSE 'Low Value'
        END AS Customer_Segment
    FROM Customers AS c
    INNER JOIN Sales AS s
        ON c.CustomerKey = s.CustomerKey
    INNER JOIN Products AS p
        ON s.ProductKey = p.ProductKey
    GROUP BY
        c.CustomerKey,
        c.Name
) AS Customer_Segmentation
GROUP BY Customer_Segment
ORDER BY Average_Sales_Value DESC;
-- ============================================================
-- 11. Customer Lifetime Sales Value
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    MIN(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS First_Order_Date,
    MAX(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Last_Order_Date,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Lifetime_Sales_Value
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
INNER JOIN Products AS p
    ON s.ProductKey = p.ProductKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
ORDER BY Lifetime_Sales_Value DESC
LIMIT 20;
-- ============================================================
-- 12. Customer Purchase Recency
-- ============================================================

SELECT
    c.CustomerKey,
    c.Name,
    c.Country,
    MAX(STR_TO_DATE(s.Order_Date, '%m/%d/%Y')) AS Last_Order_Date,
    DATEDIFF(
        (SELECT MAX(STR_TO_DATE(Order_Date, '%m/%d/%Y')) FROM Sales),
        MAX(STR_TO_DATE(s.Order_Date, '%m/%d/%Y'))
    ) AS Days_Since_Last_Order,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Customers AS c
INNER JOIN Sales AS s
    ON c.CustomerKey = s.CustomerKey
GROUP BY
    c.CustomerKey,
    c.Name,
    c.Country
ORDER BY Days_Since_Last_Order DESC
LIMIT 20;
-- ============================================================
-- 13. Monthly Sales Growth
-- ============================================================

WITH Monthly_Sales AS (
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
)

SELECT
    Sales_Year,
    Sales_Month,
    Total_Sales_Value,
    LAG(Total_Sales_Value) OVER (
        ORDER BY Sales_Year, Sales_Month
    ) AS Previous_Month_Sales,
    ROUND(
        (
            Total_Sales_Value
            - LAG(Total_Sales_Value) OVER (
                ORDER BY Sales_Year, Sales_Month
            )
        ) * 100.0
        /
        NULLIF(
            LAG(Total_Sales_Value) OVER (
                ORDER BY Sales_Year, Sales_Month
            ),
            0
        ),
        2
    ) AS Month_over_Month_Growth_Percent
FROM Monthly_Sales
ORDER BY
    Sales_Year,
    Sales_Month;
    -- ============================================================
-- 14. Top 20% Customers Sales Contribution
-- ============================================================

WITH Customer_Sales AS (
    SELECT
        c.CustomerKey,
        c.Name,
        c.Country,
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
),

Ranked_Customers AS (
    SELECT
        CustomerKey,
        Name,
        Country,
        Total_Sales_Value,
        NTILE(5) OVER (
            ORDER BY Total_Sales_Value DESC
        ) AS Customer_Group
    FROM Customer_Sales
)

SELECT
    Customer_Group,
    COUNT(*) AS Number_of_Customers,
    ROUND(
        SUM(Total_Sales_Value),
        2
    ) AS Group_Sales_Value,
    ROUND(
        SUM(Total_Sales_Value) * 100.0
        /
        (SELECT SUM(Total_Sales_Value)
         FROM Customer_Sales),
        2
    ) AS Sales_Contribution_Percent
FROM Ranked_Customers
GROUP BY Customer_Group
ORDER BY Customer_Group;
-- ============================================================
-- 15. Store Sales Efficiency Ranking
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
    ) AS Total_Sales_Value,

    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ) / st.Square_Meters,
        2
    ) AS Sales_Per_Square_Meter,

    DENSE_RANK() OVER (
        ORDER BY
            SUM(
                s.Quantity *
                CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
            ) / st.Square_Meters DESC
    ) AS Efficiency_Rank

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

ORDER BY
    Efficiency_Rank;