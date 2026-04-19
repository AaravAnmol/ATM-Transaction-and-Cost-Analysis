CREATE DATABASE atm_analysis;
USE atm_analysis;

SET GLOBAL local_infile = 1;

DROP TABLE atm_data;

## create table
CREATE TABLE atm_data (
    Year INT,
    Month VARCHAR(10),
    Bank VARCHAR(10),
    State VARCHAR(50),
    City VARCHAR(50),
    Effective_Days INT,
    ATM_Type VARCHAR(20),
    ATM_ID VARCHAR(20),
    Quarter VARCHAR(5),
    Fin_Txn INT,
    Non_Fin_Txn FLOAT,
    Monthly_Txn FLOAT,
    Monthly_Revenue FLOAT,
    MHA_Revenue FLOAT,
    ATM_Revenue_Total FLOAT,
    Rent INT,
    Electricity_Bill FLOAT,
    ATM_AMC INT,
    UPS_AMC INT,
    VSAT_AMC INT,
    Spare_Rep_SLM INT,
    Spare_Rep_AC INT,
    Spare_Rep_UPS INT,
    Compensation INT,
    Penalty INT,
    ATM_Housekeeping INT,
    Security INT,
    Insurance INT,
    Total_Cost FLOAT,
    Gross_Profit FLOAT,
    Gross_Profit_Percent FLOAT,
    Txn_Range_Current VARCHAR(20),
    Txn_Range_Previous VARCHAR(20),
    Txn_Range_Previous_2 VARCHAR(20),
    Margin_Status VARCHAR(20),
    Revenue_Performance VARCHAR(20),
    Uptime FLOAT
);

## Load Data
LOAD DATA LOCAL INFILE 'D:/PowerBI Dashboards/ATM_Transactions_Analysis_Dashboard/ATM_Analytics_Jharkhand.csv'
INTO TABLE atm_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#Chk
SELECT COUNT(*) FROM atm_data;

SELECT MIN(Uptime), MAX(Uptime) FROM atm_data;

SELECT DISTINCT ATM_Type FROM atm_data;

SELECT DISTINCT City FROM atm_data;

SET SQL_SAFE_UPDATES = 0;
## Adding Profile Category

ALTER TABLE atm_data ADD COLUMN Profit_Category VARCHAR(20);
UPDATE atm_data
SET Profit_Category = 
    CASE 
        WHEN Gross_Profit > 20000 THEN 'High Profit'
        WHEN Gross_Profit > 0 THEN 'Low Profit'
        ELSE 'Loss'
    END;
    
    # Monthly Transaction Trend
    SELECT Month, ROUND(SUM(Monthly_Txn), 2) AS Total_Txn
    FROM atm_data
    GROUP BY Month
    ORDER BY field(Month, 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    
    #Top Performing Cities
    
    SELECT City, ROUND(SUM(ATM_Revenue_Total), 2) AS Revenue
    FROM atm_data
    GROUP BY City
    ORDER BY Revenue DESC
    LIMIT 10;
    
# Profit VS Loss

SELECT Profit_Category, COUNT(*) 
FROM atm_data
GROUP BY Profit_Category;
    
# ATM Type Performance 

SELECT ATM_Type, AVG(Gross_Profit) AS Avg_Profit
FROM atm_data
GROUP BY ATM_Type;

# Cost VS Revenue

SELECT 
    SUM(ATM_Revenue_Total) AS Total_Revenue,
    SUM(Total_Cost) AS Total_Cost
FROM atm_data;
