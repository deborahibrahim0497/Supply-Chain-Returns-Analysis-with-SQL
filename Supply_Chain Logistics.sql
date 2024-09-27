 SELECT * 
  FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]


  --Removing duplicate
  WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Driver_ID, Return_Date, Product_ID ORDER BY (SELECT NULL)) AS RowNum
    FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
)
 DELETE FROM CTE
 WHERE RowNum > 1;


--Handing Missing Values
UPDATE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
SET Driver_Name = 'Unknown'
WHERE Driver_Name IS NULL OR Driver_Name = '';

UPDATE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
SET Company_Name = 'Unknown'
WHERE Company_Name IS NULL OR Company_Name = '';

UPDATE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
SET Return_Complaint = 'Unknown'
WHERE Return_Complaint IS NULL OR Return_Complaint = '';

--Convert Return_Date to Date Format
UPDATE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
SET Return_Date = DATEADD(DAY, CAST(Return_Date AS INT), '1899-12-30');

select [Return_Date]
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]

UPDATE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
SET Return_Date = DATEADD(DAY, TRY_CAST(Return_Date AS INT), '1899-12-30')
WHERE TRY_CAST(Return_Date AS INT) IS NOT NULL;


--Check for Missing Values in Key Columns
SELECT *
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
WHERE Driver_ID IS NULL OR Driver_ID = ''
   OR Company_ID IS NULL OR Company_ID = ''
   OR Product_ID IS NULL OR Product_ID = '';


 --Final Check for Clean Data
 -- Check for duplicates
SELECT Driver_ID, Return_Date, Product_ID, COUNT(*) AS Count
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Driver_ID, Return_Date, Product_ID
HAVING COUNT(*) > 1;

-- Check for missing values
SELECT *
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
WHERE Driver_Name IS NULL OR Company_Name IS NULL OR Product_Name IS NULL;


-- Ensure Return_Date is in DATETIME format
SELECT CAST(Return_Date AS DATETIME) AS Converted_Return_Date
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)];



-- Extract time part
SELECT CONVERT(VARCHAR(8), CAST(Return_Date AS DATETIME), 108) AS Return_Time
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)];


-- Add a new column for time
ALTER TABLE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
ADD Return_Time VARCHAR(8);

-- Update the new column with the extracted time
UPDATE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
SET Return_Time = CONVERT(VARCHAR(8), CAST(Return_Date AS DATETIME), 108);

--create a month column
ALTER TABLE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
ADD Return_Month AS MONTH(CONVERT(DATE, Return_Date));


ALTER TABLE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
ADD Return_MonthName AS DATENAME(MONTH, CONVERT(DATE, Return_Date));

--create a days column
ALTER TABLE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
ADD Return_Day AS DAY(CONVERT(DATE, Return_Date));

ALTER TABLE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
ADD Return_Weekday AS DATENAME(WEEKDAY, CONVERT(DATE, Return_Date));

--create a Year column
ALTER TABLE [Supply].[dbo].[Supply Chain Returns 250224 (1)]
ADD Return_Year AS YEAR(Return_Date);

SELECT *
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]

-- Total Amount
SELECT SUM(CAST (Amount AS Float)) AS total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)];

--Get a breakdown of product types
SELECT Product_Name, COUNT(*) AS Product_count
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Product_Name;

--Count the total number of products in the dataset
SELECT COUNT(*) AS total_Product
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)];


--Total Amount by Risk Category
SELECT Risk_Category, SUM(CAST (Amount AS FLOAT)) AS Total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Risk_Category;

--Average Quantity and Amount by Company
SELECT Company_Name, AVG(CAST (Quantity AS FLOAT)) AS Avg_Quantity, AVG(CAST (Amount AS FLOAT)) AS Avg_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Company_Name;

--Top 3 Products by Total Amount
SELECT TOP 3 Product_Name, SUM(CAST (Amount AS FLOAT)) AS Total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Product_Name
ORDER BY Total_Amount DESC;

--Count of Complaints by Risk Category
SELECT Risk_Category, COUNT(*) AS Complaint_Count
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Risk_Category;

--Product with the Highest Unit Price
SELECT TOP 1 Product_Name, Unit_Price
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
ORDER BY Unit_Price DESC;

--Total Amount and Quantity by Driver
SELECT Driver_Name, SUM(CAST (Amount AS FLOAT)) AS Total_Amount, SUM(CAST (Quantity AS FLOAT)) AS Total_Quantity
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Driver_Name;

--Total Amount and Average Unit Price by Risk Category
SELECT Risk_Category, SUM(CAST (Amount AS FLOAT)) AS Total_Amount, AVG(CAST (Unit_Price AS FLOAT)) AS Avg_Unit_Price
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Risk_Category;

--Driver with the Highest Total Amount
SELECT TOP 1 Driver_Name, SUM(CAST (Amount AS FLOAT)) AS Total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Driver_Name
ORDER BY Total_Amount DESC;

--Product with the Lowest Quantity
SELECT TOP 1 Product_Name, MIN(Quantity) AS Lowest_Quantity
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Product_Name
ORDER BY Lowest_Quantity ASC;

--Company with the Most Complaints
SELECT Company_Name, COUNT(*) AS Complaint_Count
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Company_Name
ORDER BY Complaint_Count DESC;

--Total Amount and Quantity by Product and Risk Category
SELECT Product_Name, Risk_Category, SUM(CAST (Amount AS FLOAT)) AS Total_Amount, SUM(CAST (Quantity AS FLOAT)) AS Total_Quantity
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Product_Name, Risk_Category
ORDER BY Product_Name, Risk_Category;



--Top 5 Products by Quantity Sold
SELECT TOP 5 Product_Name, SUM(CAST (Quantity AS FLOAT)) AS Total_Quantity
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Product_Name
ORDER BY Total_Quantity DESC;

--Comparison of Average Unit Price by Product Name and Risk Category
SELECT Product_Name, Risk_Category, AVG(CAST (Unit_Price AS FLOAT)) AS Avg_Unit_Price
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Product_Name, Risk_Category
ORDER BY Product_Name, Risk_Category;

--Count of Complaints by Product and Risk Category
SELECT Product_Name, Risk_Category, COUNT(*) AS Complaint_Count
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Product_Name, Risk_Category
ORDER BY Product_Name, Risk_Category;

--Total Amount by Driver and Product
SELECT Driver_Name, Product_Name, SUM(CAST (Amount AS FLOAT)) AS Total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Driver_Name, Product_Name
ORDER BY Driver_Name, Total_Amount DESC;

--Total Amount by Month
SELECT Return_MonthName, SUM(CAST (Amount AS FLOAT)) AS Total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Return_MonthName
ORDER BY Return_MonthName;

--Total Amount by Month
SELECT Return_MonthName, SUM(CAST (Amount AS FLOAT)) AS Total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Return_MonthName
ORDER BY Return_MonthName;

SELECT *
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]

--Total Complaints by Day
SELECT Return_Weekday, COUNT(*) AS Total_Complaints
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Return_Weekday
ORDER BY Return_Weekday;

--Total Amount by Year and Month
SELECT Return_Year, Return_MonthName, SUM(CAST (Amount AS FLOAT)) AS Total_Amount
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Return_Year, Return_MonthName
ORDER BY Return_Year, Return_MonthName;

--Count of Complaints by Year and Risk Category
SELECT Return_Year, Risk_Category, COUNT(*) AS Complaint_Count
FROM [Supply].[dbo].[Supply Chain Returns 250224 (1)]
GROUP BY Return_Year, Risk_Category
ORDER BY Return_Year, Risk_Category;