Create	Database RFM_Sales_db;
CREATE TABLE rfm_sales (
    CUSTOMERID INT,
    ORDERNUMBER INT,
    QUANTITYORDERED INT,
    PRICEEACH DECIMAL(10,2),
    ORDERLINENUMBER INT,
    SALES DECIMAL(15,2),
    ORDERDATE DATE,
    STATUS VARCHAR(50),
    QTR_ID INT,
    MONTH_ID INT,
    YEAR_ID INT,
    PRODUCTLINE VARCHAR(50),
    MSRP DECIMAL(10,2),
    PRODUCTCODE VARCHAR(50),
    CUSTOMERNAME VARCHAR(100),
    PHONE VARCHAR(50),
    ADDRESSLINE1 VARCHAR(150),
    ADDRESSLINE2 VARCHAR(150),
    CITY VARCHAR(50),
    STATE VARCHAR(50),
    POSTALCODE VARCHAR(20),
    COUNTRY VARCHAR(50),
    TERRITORY VARCHAR(50),
    CONTACTLASTNAME VARCHAR(50),
    CONTACTFIRSTNAME VARCHAR(50),
    DEALSIZE VARCHAR(20),
    PRIMARY KEY (CUSTOMERID, ORDERNUMBER, ORDERLINENUMBER)
);

use rfm_sales_db;

SELECT 
    *
FROM
    rfm_sales;


SELECT 
customerid,
customername,
    ROUND(SUM(sales), 0) AS Customer_Lifetime_Value,
    COUNT(DISTINCT ordernumber) AS frequency,
    SUM(quantityordered) AS total_qty_ordered,
   MAX(orderdate) AS customer_last_transacton_date,
   datediff((SELECT MAX(orderdate) from rfm_sales), 
   MAX(orderdate)) as recency_value
FROM
    rfm_sales
GROUP BY customerid, customername
order by customername;