USE global_electronics;

SHOW TABLES;

SELECT COUNT(*) AS Customer_Rows
FROM Customers;

SELECT COUNT(*) AS Product_Rows
FROM Products;

SELECT COUNT(*) AS Store_Rows
FROM Stores;

SELECT COUNT(*) AS Exchange_Rate_Rows
FROM Exchange_Rates;

SELECT COUNT(*) AS Sales_Rows
FROM Sales;
-- ============================================================
-- GLOBAL ELECTRONICS RETAIL ANALYSIS
-- Data Cleaning & Validation
-- ============================================================

USE Global_Electronics;


-- ============================================================
-- 1. Check Customers Row Count
-- ============================================================

SELECT COUNT(*) AS Total_Customers
FROM Customers;


-- ============================================================
-- 2. Check Duplicate Customer Keys
-- ============================================================

SELECT CustomerKey, COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY CustomerKey
HAVING COUNT(*) > 1;


-- ============================================================
-- 3. Check Missing Customer Keys
-- ============================================================

SELECT COUNT(*) AS Missing_CustomerKey
FROM Customers
WHERE CustomerKey IS NULL;


-- ============================================================
-- 4. Check Invalid Birthday Values
-- ============================================================

SELECT *
FROM Customers
WHERE Birthday IS NULL;


-- ============================================================
-- 5. Check Products Row Count
-- ============================================================

SELECT COUNT(*) AS Total_Products
FROM Products;


-- ============================================================
-- 6. Check Duplicate Product Keys
-- ============================================================

SELECT ProductKey, COUNT(*) AS Duplicate_Count
FROM Products
GROUP BY ProductKey
HAVING COUNT(*) > 1;


-- ============================================================
-- 7. Check Stores Row Count
-- ============================================================

SELECT COUNT(*) AS Total_Stores
FROM Stores;


-- ============================================================
-- 8. Check Duplicate Store Keys
-- ============================================================

SELECT StoreKey, COUNT(*) AS Duplicate_Count
FROM Stores
GROUP BY StoreKey
HAVING COUNT(*) > 1;


-- ============================================================
-- 9. Check Sales Row Count
-- ============================================================

SELECT COUNT(*) AS Total_Sales
FROM Sales;


-- ============================================================
-- 10. Check Missing Customer Keys in Sales
-- ============================================================

SELECT COUNT(*) AS Missing_CustomerKey
FROM Sales
WHERE CustomerKey IS NULL;


-- ============================================================
-- 11. Check Missing Product Keys in Sales
-- ============================================================

SELECT COUNT(*) AS Missing_ProductKey
FROM Sales
WHERE ProductKey IS NULL;


-- ============================================================
-- 12. Check Missing Store Keys in Sales
-- ============================================================

SELECT COUNT(*) AS Missing_StoreKey
FROM Sales
WHERE StoreKey IS NULL;


-- ============================================================
-- 13. Check Invalid Quantity
-- ============================================================

SELECT *
FROM Sales
WHERE Quantity <= 0;


-- ============================================================
-- 14. Check Duplicate Sales Records
-- ============================================================

SELECT
    Order_Number,
    Line_Item,
    COUNT(*) AS Duplicate_Count
FROM Sales
GROUP BY Order_Number, Line_Item
HAVING COUNT(*) > 1;


-- ============================================================
-- 15. Check Sales Date Range
-- ============================================================

SELECT
    MIN(Order_Date) AS First_Order,
    MAX(Order_Date) AS Last_Order
FROM Sales;


-- ============================================================
-- 16. Final Data Validation
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM Customers) AS Customers,
    (SELECT COUNT(*) FROM Products) AS Products,
    (SELECT COUNT(*) FROM Stores) AS Stores,
    (SELECT COUNT(*) FROM Sales) AS Sales;
SELECT COUNT(*) AS Total_Sales
FROM Sales;

-- Check Sales Date Range
SELECT
    MIN(Order_Date) AS First_Order,
    MAX(Order_Date) AS Last_Order
FROM Sales;
-- Check Duplicate Customer Keys
SELECT
    CustomerKey,
    COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY CustomerKey
HAVING COUNT(*) > 1;


-- Check Duplicate Product Keys
SELECT
    ProductKey,
    COUNT(*) AS Duplicate_Count
FROM Products
GROUP BY ProductKey
HAVING COUNT(*) > 1;


-- Check Duplicate Store Keys
SELECT
    StoreKey,
    COUNT(*) AS Duplicate_Count
FROM Stores
GROUP BY StoreKey
HAVING COUNT(*) > 1;
-- Check Duplicate Sales Records

SELECT
    Order_Number,
    Line_Item,
    COUNT(*) AS Duplicate_Count
FROM Sales
GROUP BY Order_Number, Line_Item
HAVING COUNT(*) > 1;
-- Check Missing Values in Sales

SELECT
    SUM(CustomerKey IS NULL) AS Missing_CustomerKey,
    SUM(StoreKey IS NULL) AS Missing_StoreKey,
    SUM(ProductKey IS NULL) AS Missing_ProductKey,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Quantity IS NULL) AS Missing_Quantity
FROM Sales;

-- Check Invalid Quantity

SELECT *
FROM Sales
WHERE Quantity <= 0;
-- Check Sales with Invalid CustomerKey

SELECT COUNT(*) AS Invalid_Customers
FROM Sales s
LEFT JOIN Customers c
    ON s.CustomerKey = c.CustomerKey
WHERE c.CustomerKey IS NULL;


-- Check Sales with Invalid ProductKey

SELECT COUNT(*) AS Invalid_Products
FROM Sales s
LEFT JOIN Products p
    ON s.ProductKey = p.ProductKey
WHERE p.ProductKey IS NULL;


-- Check Sales with Invalid StoreKey

SELECT COUNT(*) AS Invalid_Stores
FROM Sales s
LEFT JOIN Stores st
    ON s.StoreKey = st.StoreKey
WHERE st.StoreKey IS NULL;
-- ============================================================
-- FINAL DATA VALIDATION SUMMARY
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM Customers) AS Total_Customers,
    (SELECT COUNT(*) FROM Products) AS Total_Products,
    (SELECT COUNT(*) FROM Stores) AS Total_Stores,
    (SELECT COUNT(*) FROM Sales) AS Total_Sales;