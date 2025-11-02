# RFM Segmentation Analysis in SQL and Power BI

## What is RFM?

RFM stands for **Recency**, **Frequency**, and **Monetary** analysis, a marketing technique used to segment customers based on their purchasing behavior. It evaluates:

- **Recency**: How recently a customer made a purchase (time since last transaction).
- **Frequency**: How often a customer makes purchases (number of orders).
- **Monetary**: How much a customer spends (total sales value).

Each customer is assigned a score based on these metrics, enabling businesses to categorize them into segments for targeted marketing strategies.

## Why We Need RFM Segmentation Analysis

RFM segmentation helps businesses understand customer behavior and prioritize marketing efforts. It identifies high-value customers, those at risk of churn, and those who need re-engagement. By analyzing purchasing patterns, businesses can tailor strategies to improve retention, increase sales, and optimize resource allocation.

## Database Setup

The analysis uses a sales dataset stored in a MySQL database. Below is the SQL code to create the database and table:

```sql
CREATE DATABASE RFM_Sales_db;
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
```

## Exploring Sales Data

The dataset contains sales records with details like customer IDs, order numbers, quantities, prices, order dates, and customer information. Below are exploratory queries and their outputs:

### Sample Records

```sql
SELECT * FROM rfm_sales LIMIT 10;
```

**Output**:

| CUSTOMERID | ORDERNUMBER | QUANTITYORDERED | PRICEEACH | ORDERLINENUMBER | SALES    | ORDERDATE   | STATUS    | QTR_ID | MONTH_ID | YEAR_ID | PRODUCTLINE   | MSRP | PRODUCTCODE | CUSTOMERNAME  | PHONE      | ADDRESSLINE1            | ADDRESSLINE2 | CITY | STATE | POSTALCODE | COUNTRY | TERRITORY | CONTACTLASTNAME | CONTACTFIRSTNAME | DEALSIZE |
|------------|-------------|-----------------|-----------|-----------------|----------|-------------|-----------|--------|----------|---------|---------------|------|-------------|---------------|------------|-------------------------|--------------|------|-------|------------|---------|-----------|-----------------|------------------|----------|
| 1          | 10107       | 21              | 100       | 1               | 3036.6   | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 150  | S12_2823    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Medium   |
| 1          | 10107       | 30              | 95.7      | 2               | 2871     | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 95   | S10_1678    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Small    |
| 1          | 10107       | 25              | 100       | 3               | 2845.75  | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 112  | S24_1578    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Small    |
| 1          | 10107       | 27              | 100       | 4               | 6065.55  | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 193  | S10_4698    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Medium   |
| 1          | 10107       | 39              | 99.91     | 5               | 3896.49  | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 118  | S10_2016    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Medium   |
| 1          | 10107       | 29              | 70.87     | 6               | 2055.23  | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 60   | S18_2625    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Small    |
| 1          | 10107       | 38              | 83.03     | 7               | 3155.14  | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 76   | S24_2000    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Medium   |
| 1          | 10107       | 20              | 92.9      | 8               | 1858     | 2003-02-24 | Shipped   | 1      | 2        | 2003    | Motorcycles   | 99   | S32_1374    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Small    |
| 1          | 10248       | 21              | 73.98     | 1               | 1553.58  | 2004-05-07 | Cancelled | 2      | 5        | 2004    | Ships         | 86   | S18_3029    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Small    |
| 1          | 10248       | 23              | 76.31     | 2               | 1755.13  | 2004-05-07 | Cancelled | 2      | 5        | 2004    | Vintage Cars  | 83   | S24_3816    | Arif Hossain  | 2125557818 | 897 Long Airport Avenue | NULL         | NYC  | NY    | 10022      | USA     | NULL      | Yu              | Kwai             | Small    |

## RFM Segmentation Analysis

### RFM Segmentation View

This SQL query creates a view to calculate RFM scores and assign customers to segments based on their recency, frequency, and monetary values. Customers are scored from 1 to 5 (higher is better) using `NTILE`, and segments are defined based on RFM score combinations.

```sql
CREATE VIEW RFM_SEGMENTATION_DATA AS
WITH CLV AS (
    SELECT 
        customerid,
        customername,
        MAX(orderdate) AS customer_last_transaction_date,
        DATEDIFF((SELECT MAX(orderdate) FROM rfm_sales), MAX(orderdate)) AS recency_value,
        COUNT(DISTINCT ordernumber) AS frequency_value,
        SUM(quantityordered) AS total_qty_ordered,
        ROUND(SUM(sales), 0) AS monetary_value
    FROM
        rfm_sales
    GROUP BY customerid, customername
    ORDER BY customername
),
RFM_Score AS (
    SELECT 
        c.*,
        NTILE(5) OVER (ORDER BY recency_value DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY frequency_value DESC) AS F_Score,
        NTILE(5) OVER (ORDER BY monetary_value DESC) AS M_Score
    FROM CLV AS c
),
rfm_combination AS (
    SELECT 
        R.*,
        R_Score + F_Score + M_Score AS total_rfm_score,
        CONCAT_WS('', R_Score, F_Score, M_Score) AS rfm_combination
    FROM RFM_Score AS R
)
SELECT 
    rc.*,
    CASE
        WHEN rfm_combination IN (111,112,113,114,115,121,122,123,124,125) THEN 'Can’t Lose Them'
        WHEN rfm_combination IN (131,132,133,134,135,141,142,143,144,145,151,152,153,154,155) THEN 'At Risk'
        WHEN rfm_combination IN (211,212,213,214,215,221,222,223,224,225) THEN 'About to Sleep'
        WHEN rfm_combination IN (231,232,233,234,235,241,242,243,244,245,251,252,253,254,255) THEN 'Needs Attention'
        WHEN rfm_combination IN (311,312,313,314,315,321,322,323,324,325,331,332,333,334,335) THEN 'Promising Customers'
        WHEN rfm_combination IN (341,342,343,344,345,351,352,353,354,355,441,442,443,451,452,453,541,542,543,551,552,553) THEN 'Loyal Customers'
        WHEN rfm_combination IN (411,412,413,414,415,421,422,423,424,425,431,432,433,434,435,511,512,513,514,515,521,522,523,524,525,531,532,533,534,535) THEN 'Potential Loyalists'
        WHEN rfm_combination IN (444,445,454,455,544,545,554,555) THEN 'Champions'
    END AS customer_segment
FROM rfm_combination AS rc;
```

### RFM Segmentation Results

This query retrieves the RFM segmentation data, showing each customer's RFM scores and assigned segment.

```sql
SELECT * FROM RFM_SEGMENTATION_DATA;
```

**Output** (Sample):

| customerid | customername     | customer_last_transaction_date | recency_value | frequency_value | total_qty_ordered | monetary_value | R_Score | F_Score | M_Score | total_rfm_score | rfm_combination | customer_segment    |
|------------|------------------|--------------------------------|---------------|-----------------|-------------------|----------------|---------|---------|---------|-----------------|-----------------|--------------------|
| 24         | Jubayer Rahman   | 2005-05-31                     | 0             | 26              | 9327              | 912294         | 5       | 1       | 1       | 7               | 511             | Potential Loyalists |
| 40         | Samia Afrin      | 2005-05-29                     | 2             | 17              | 6366              | 654858         | 5       | 1       | 1       | 7               | 511             | Potential Loyalists |
| 11         | Mahfuz Alam      | 2004-11-29                     | 183           | 5               | 1926              | 200995         | 3       | 1       | 1       | 5               | 311             | Promising Customers |
| 75         | Arafat Hossain   | 2004-12-01                     | 181           | 4               | 1775              | 197737         | 3       | 1       | 1       | 5               | 311             | Promising Customers |
| 15         | Fahmida Sultana  | 2005-05-31                     | 0             | 4               | 1832              | 180125         | 5       | 1       | 1       | 7               | 511             | Potential Loyalists |
| 27         | Omar Faruk       | 2005-03-02                     | 90            | 5               | 1524              | 172990         | 4       | 1       | 1       | 6               | 411             | Potential Loyalists |
| 1          | Arif Hossain     | 2004-11-15                     | 197           | 4               | 1631              | 164069         | 2       | 1       | 1       | 4               | 211             | About to Sleep     |
| 62         | Sumona Akter     | 2005-04-22                     | 39            | 4               | 1656              | 160010         | 5       | 2       | 1       | 8               | 521             | Potential Loyalists |
| 78         | Pinky Akter      | 2004-11-17                     | 195           | 3               | 1778              | 157808         | 3       | 3       | 1       | 7               | 331             | Promising Customers |
| 43         | Tanvir Hasan     | 2005-03-09                     | 83            | 4               | 1469              | 153996         | 4       | 1       | 1       | 6               | 411             | Potential Loyalists |
| ...        | ...              | ...                            | ...           | ...             | ...               | ...            | ...     | ...     | ...     | ...             | ...             | ...                |

### Segment Summary

This query summarizes the number of customers, total spending, average spending, total orders, and total quantity ordered per segment.

```sql
SELECT
    customer_segment,
    COUNT(customer_segment) AS count_of_customer,
    SUM(monetary_value) AS total_spending,
    ROUND(AVG(monetary_value), 0) AS avg_spending,
    SUM(frequency_value) AS total_order,
    SUM(total_qty_ordered) AS total_qty_ordered
FROM
    RFM_SEGMENTATION_DATA
GROUP BY customer_segment;
```

**Output**:

| customer_segment    | count_of_customer | total_spending | avg_spending | total_order | total_qty_ordered |
|---------------------|-------------------|----------------|--------------|-------------|-------------------|
| Potential Loyalists | 28                | 4538281        | 162081       | 137         | 44792             |
| Promising Customers | 18                | 1742004        | 96778        | 59          | 17229             |
| About to Sleep      | 7                 | 844137         | 120591       | 24          | 8372              |
| Can’t Lose Them     | 2                 | 254514         | 127257       | 6           | 2401              |
| Loyal Customers     | 4                 | 448803         | 112201       | 12          | 4423              |
| At Risk             | 17                | 1098537        | 64620        | 33          | 10937             |
| Needs Attention     | 12                | 915001         | 76250        | 25          | 9047              |
| Champions           | 4                 | 191350         | 47838        | 11          | 1866              |

## Power BI Dashboard

The Power BI dashboard is connected to the MySQL database and visualizes the RFM segmentation results. It includes the following components:

### Overview Page
- **Key Metrics**
    - Total Sales
    - Total Customers
    - Total Qty Order
- **Sales by Segment**
- **Customers by Segment**
- **Scatter Plot**
- **Line Chart**
- **Filters**
- **Drill Through**

### Customer Details Page
- Table displaying customer ID, Name, Last Transaction Date, Total Sales, Total Orders, R_Score, F_Score, M_Score, RFM Combination, Customer Segment.

### RFM Analysis and Marketing Actions Page
- Definitions of Recency, Frequency, Monetary Value.
- Table of segments with descriptions and recommended marketing actions.

To integrate with Power BI:
- Connect to the MySQL database using Power BI's connector.
- Use the `RFM_SEGMENTATION_DATA` view as the data source.
- Create visuals as described for interactive analysis.

- **Live Link**: https://tinyurl.com/y2d2mb27

<p align="center">
  <img src="https://raw.githubusercontent.com/nomayer-masum/RFM-Segmentation-Analysis/main/RFM%20Segmentation_page-0001.jpg" alt="RFM Segmentation - Page 1" width="800"/>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/nomayer-masum/RFM-Segmentation-Analysis/main/RFM%20Segmentation_page-0002.jpg" alt="RFM Segmentation - Page 2" width="800"/>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/nomayer-masum/RFM-Segmentation-Analysis/main/RFM%20Segmentation_page-0003.jpg" alt="RFM Segmentation - Page 3" width="800"/>
</p>

