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
-- Database Setup
-- ============================================================

-- 1. Create Database


-- 2. Select Database
USE Global_Electronics;


-- ============================================================
-- 3. Customers Table
-- ============================================================

CREATE TABLE IF NOT EXISTS Customers (
    CustomerKey INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(100),
    State_Code VARCHAR(20),
    State VARCHAR(100),
    Zip_Code VARCHAR(20),
    Country VARCHAR(100),
    Continent VARCHAR(100),
    Birthday DATE,
    Gender VARCHAR(20)
);


-- ============================================================
-- 4. Products Table
-- ============================================================

CREATE TABLE IF NOT EXISTS Products (
    ProductKey INT PRIMARY KEY,
    Product_Name VARCHAR(255),
    Brand VARCHAR(100),
    Color VARCHAR(50),
    Unit_Cost_USD VARCHAR(50),
    Unit_Price_USD VARCHAR(50),
    SubcategoryKey INT,
    Subcategory VARCHAR(100),
    CategoryKey INT,
    Category VARCHAR(100)
);


-- ============================================================
-- 5. Stores Table
-- ============================================================

CREATE TABLE IF NOT EXISTS Stores (
    StoreKey INT PRIMARY KEY,
    Country VARCHAR(100),
    State VARCHAR(100),
    Square_Meters DECIMAL(10,2),
    Open_Date DATE
);


-- ============================================================
-- 6. Sales Table
-- ============================================================

CREATE TABLE IF NOT EXISTS Sales (
    Order_Number VARCHAR(50),
    Line_Item INT,
    Order_Date DATE,
    Delivery_Date DATE,
    CustomerKey INT,
    StoreKey INT,
    ProductKey INT,
    Quantity INT,

    PRIMARY KEY (Order_Number, Line_Item),

    FOREIGN KEY (CustomerKey)
        REFERENCES Customers(CustomerKey),

    FOREIGN KEY (StoreKey)
        REFERENCES Stores(StoreKey),

    FOREIGN KEY (ProductKey)
        REFERENCES Products(ProductKey)
);


-- ============================================================
-- 7. Exchange Rates Table
-- ============================================================

CREATE TABLE IF NOT EXISTS Exchange_Rates (
    Date DATE,
    Currency_Code VARCHAR(10),
    Exchange_Rate DECIMAL(10,4),

    PRIMARY KEY (Date, Currency_Code)
);


-- ============================================================
-- 8. Verify Tables
-- ============================================================

SHOW TABLES;