USE Global_Electronics;
-- ============================================================
-- 1. Top 10 Products by Quantity Sold
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    SUM(s.Quantity) AS Total_Quantity_Sold
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;
-- ============================================================
-- 2. Top 10 Products by Revenue
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
    ) AS Total_Revenue
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category
ORDER BY Total_Revenue DESC
LIMIT 10;
-- ============================================================
-- 3. Brand-wise Sales Performance
-- ============================================================

SELECT
    p.Brand,
    COUNT(DISTINCT p.ProductKey) AS Total_Products,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Revenue
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY p.Brand
ORDER BY Total_Revenue DESC;
-- ============================================================
-- 4. Category-wise Sales Performance
-- ============================================================

SELECT
    p.Category,
    COUNT(DISTINCT p.ProductKey) AS Total_Products,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Revenue
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY p.Category
ORDER BY Total_Revenue DESC;
-- ============================================================
-- 5. Subcategory-wise Sales Performance
-- ============================================================

SELECT
    p.Subcategory,
    p.Category,
    COUNT(DISTINCT p.ProductKey) AS Total_Products,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Revenue
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.Subcategory,
    p.Category
ORDER BY Total_Revenue DESC;
-- ============================================================
-- 6. Top 10 Subcategories by Revenue
-- ============================================================

SELECT
    p.Subcategory,
    p.Category,
    ROUND(
        SUM(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Total_Revenue
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.Subcategory,
    p.Category
ORDER BY Total_Revenue DESC
LIMIT 10;
-- ============================================================
-- 7. Top 10 Products by Average Selling Value
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    ROUND(
        AVG(
            s.Quantity *
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Average_Selling_Value
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category
ORDER BY Average_Selling_Value DESC
LIMIT 10;
-- ============================================================
-- 8. Brand-wise Average Product Price
-- ============================================================

SELECT
    p.Brand,
    COUNT(DISTINCT p.ProductKey) AS Total_Products,
    ROUND(
        AVG(
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Average_Product_Price
FROM Products AS p
GROUP BY p.Brand
ORDER BY Average_Product_Price DESC;
-- ============================================================
-- 9. Category-wise Average Product Price
-- ============================================================

SELECT
    p.Category,
    COUNT(DISTINCT p.ProductKey) AS Total_Products,
    ROUND(
        AVG(
            CAST(REPLACE(p.Unit_Price_USD, '$', '') AS DECIMAL(10,2))
        ),
        2
    ) AS Average_Product_Price
FROM Products AS p
GROUP BY p.Category
ORDER BY Average_Product_Price DESC;
-- ============================================================
-- 10. Products Never Sold
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    p.Subcategory,
    p.Unit_Price_USD
FROM Products AS p
LEFT JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
WHERE s.ProductKey IS NULL
ORDER BY p.Product_Name;
-- ============================================================
-- 11. Top 10 Products by Number of Orders
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category
ORDER BY Total_Orders DESC
LIMIT 10;
-- ============================================================
-- 12. Top 10 Products by Average Quantity per Order
-- ============================================================

SELECT
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category,
    ROUND(
        SUM(s.Quantity) / COUNT(DISTINCT s.Order_Number),
        2
    ) AS Average_Quantity_Per_Order
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY
    p.ProductKey,
    p.Product_Name,
    p.Brand,
    p.Category
ORDER BY Average_Quantity_Per_Order DESC
LIMIT 10;
-- ============================================================
-- 13. Brand-wise Average Quantity per Order
-- ============================================================

SELECT
    p.Brand,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(
        SUM(s.Quantity) / COUNT(DISTINCT s.Order_Number),
        2
    ) AS Average_Quantity_Per_Order
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY p.Brand
ORDER BY Average_Quantity_Per_Order DESC;
-- ============================================================
-- 14. Category-wise Average Quantity per Order
-- ============================================================

SELECT
    p.Category,
    SUM(s.Quantity) AS Total_Quantity_Sold,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    ROUND(
        SUM(s.Quantity) / COUNT(DISTINCT s.Order_Number),
        2
    ) AS Average_Quantity_Per_Order
FROM Products AS p
INNER JOIN Sales AS s
    ON p.ProductKey = s.ProductKey
GROUP BY p.Category
ORDER BY Average_Quantity_Per_Order DESC;
-- ============================================================
-- 15. Product Sales Coverage
-- ============================================================

SELECT
    COUNT(DISTINCT p.ProductKey) AS Total_Products,
    COUNT(DISTINCT s.ProductKey) AS Products_Sold,
    COUNT(DISTINCT p.ProductKey)
        - COUNT(DISTINCT s.ProductKey) AS Products_Never_Sold,
    ROUND(
        COUNT(DISTINCT s.ProductKey) * 100.0
        / COUNT(DISTINCT p.ProductKey),
        2
    ) AS Sales_Coverage_Percentage
FROM Products AS p
LEFT JOIN Sales AS s
    ON p.ProductKey = s.ProductKey;