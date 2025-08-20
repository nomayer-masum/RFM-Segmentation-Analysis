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

### Customer-Level Summary

This query calculates key RFM metrics for each customer, including total spend, order frequency, total quantity ordered, and recency.

```sql
SELECT 
    customerid,
    customername,
    ROUND(SUM(sales), 0) AS Customer_Lifetime_Value,
    COUNT(DISTINCT ordernumber) AS frequency,
    SUM(quantityordered) AS total_qty_ordered,
    MAX(orderdate) AS customer_last_transaction_date,
    DATEDIFF((SELECT MAX(orderdate) FROM rfm_sales), MAX(orderdate)) AS recency_value
FROM
    rfm_sales
GROUP BY customerid, customername
ORDER BY customername;
```

**Output**:

| customerid | customername      | Customer_Lifetime_Value | frequency | total_qty_ordered | customer_last_transaction_date | recency_value |
|------------|-------------------|-------------------------|-----------|-------------------|--------------------------------|---------------|
| 70         | Afrin Rahman      | 117714                  | 2         | 1078              | 2004-08-30                     | 274           |
| 84         | Afrin Sultana     | 80438                   | 3         | 779               | 2005-04-14                     | 47            |
| 17         | Afsana Mim        | 111250                  | 3         | 1051              | 2005-02-09                     | 111           |
| 60         | Anika Sultana     | 78241                   | 2         | 895               | 2004-11-01                     | 211           |
| 75         | Arafat Hossain    | 197737                  | 4         | 1775              | 2004-12-01                     | 181           |
| 1          | Arif Hossain      | 164069                  | 4         | 1631              | 2004-11-15                     | 197           |
| 67         | Arman Chowdhury   | 94016                   | 3         | 961               | 2004-11-16                     | 196           |
| 81         | Arman Hossain     | 9129                    | 2         | 102               | 2005-02-08                     | 112           |
| 31         | Ashraful Alam     | 142874                  | 3         | 1428              | 2004-03-02                     | 455           |
| 22         | Asif Mahmud       | 98924                   | 3         | 903               | 2005-03-03                     | 89            |
| 65         | Ehsanul Kabir     | 70860                   | 2         | 695               | 2004-04-26                     | 400           |
| 49         | Emon Hossain      | 145042                  | 5         | 1315              | 2005-04-15                     | 46            |
| 91         | Fahim Rahman      | 33440                   | 4         | 278               | 2005-01-10                     | 141           |
| 15         | Fahmida Sultana   | 180125                  | 4         | 1832              | 2005-05-31                     | 0             |
| 61         | Fardin Khan       | 104370                  | 3         | 1110              | 2005-01-31                     | 120           |
| 74         | Faria Jahan       | 113961                  | 3         | 1031              | 2005-01-06                     | 145           |
| 26         | Farzana Haque     | 120615                  | 3         | 1163              | 2004-11-01                     | 211           |
| 9          | Farzana Islam     | 74476                   | 3         | 692               | 2004-11-18                     | 194           |
| 41         | Foysal Ahmed      | 131685                  | 3         | 1248              | 2004-11-04                     | 208           |
| 16         | Imran Hossain     | 103080                  | 2         | 976               | 2004-10-13                     | 230           |
| 45         | Imtiaz Hossain    | 67605                   | 2         | 692               | 2004-04-13                     | 413           |
| 57         | Jahidul Islam     | 74973                   | 3         | 796               | 2005-05-30                     | 1             |
| 79         | Jahin Rahman      | 100596                  | 2         | 882               | 2004-10-22                     | 221           |
| 19         | Jannatul Ferdous  | 122138                  | 4         | 1111              | 2005-05-30                     | 1             |
| 86         | Jeba Rahman       | 79224                   | 2         | 787               | 2004-08-21                     | 283           |
| 69         | Jubair Hossain    | 100307                  | 2         | 936               | 2004-10-16                     | 227           |
| 24         | Jubayer Rahman    | 912294                  | 26        | 9327              | 2005-05-31                     | 0             |
| 36         | Jui Chowdhury     | 120563                  | 4         | 1150              | 2005-04-22                     | 39            |
| 6          | Kamrul Hasan      | 120783                  | 4         | 1179              | 2005-01-05                     | 146           |
| 51         | Kawsar Ahmed      | 108951                  | 3         | 1140              | 2005-01-07                     | 144           |
| 54         | Lamia Chowdhury   | 78412                   | 3         | 882               | 2004-11-24                     | 188           |
| 76         | Lamiya Akter      | 57756                   | 2         | 490               | 2004-09-16                     | 257           |
| 28         | Lima Akter        | 77795                   | 3         | 720               | 2004-11-21                     | 191           |
| 11         | Mahfuz Alam       | 200995                  | 5         | 1926              | 2004-11-29                     | 183           |
| 90         | Mahia Jahan       | 34994                   | 1         | 401               | 2004-09-15                     | 258           |
| 63         | Mahir Hossain     | 97204                   | 3         | 836               | 2004-11-20                     | 192           |
| 53         | Mamun Hossain     | 36019                   | 2         | 357               | 2004-01-22                     | 495           |
| 23         | Mehnaz Chowdhury  | 118008                  | 3         | 1046              | 2005-04-08                     | 53            |
| 68         | Monira Akter      | 74936                   | 3         | 804               | 2005-01-06                     | 145           |
| 88         | Mou Akter         | 64591                   | 3         | 705               | 2005-05-09                     | 22            |
| 58         | Moumita Akter     | 74635                   | 2         | 873               | 2004-08-20                     | 284           |
| 38         | Mouri Akter       | 134259                  | 3         | 1359              | 2005-03-03                     | 89            |
| 21         | Nabila Karim      | 151571                  | 4         | 1601              | 2005-05-29                     | 2             |
| 83         | Nahid Hasan       | 50219                   | 2         | 514               | 2004-02-10                     | 476           |
| 2          | Nayeem Rahman     | 135043                  | 5         | 1433              | 2005-03-30                     | 62            |
| 46         | Naznin Akter      | 83682                   | 3         | 730               | 2004-11-17                     | 195           |
| 39         | Noman Hossain     | 64834                   | 2         | 637               | 2004-10-11                     | 232           |
| 34         | Nowrin Sultana    | 36164                   | 2         | 357               | 2004-05-08                     | 388           |
| 64         | Nowshin Rahman    | 52264                   | 3         | 532               | 2005-03-10                     | 82            |
| 5          | Nusrat Jahan      | 149883                  | 4         | 1447              | 2005-02-23                     | 97            |
| 44         | Oishi Rahman      | 74205                   | 3         | 717               | 2005-05-01                     | 30            |
| 27         | Omar Faruk        | 172990                  | 5         | 1524              | 2005-03-02                     | 90            |
| 47         | Parvez Rahman     | 24180                   | 3         | 270               | 2004-11-25                     | 187           |
| 78         | Pinky Akter       | 157808                  | 3         | 1778              | 2004-11-17                     | 195           |
| 82         | Priyanka Akter    | 54724                   | 2         | 589               | 2004-10-06                     | 237           |
| 32         | Priyanka Das      | 75239                   | 2         | 703               | 2004-10-22                     | 221           |
| 89         | Rakib Hasan       | 57294                   | 3         | 666               | 2004-12-04                     | 178           |
| 14         | Rakibul Islam     | 101895                  | 3         | 903               | 2005-05-05                     | 26            |
| 12         | Rashed Karim      | 88041                   | 3         | 787               | 2004-11-05                     | 207           |
| 29         | Rayhanul Islam    | 59469                   | 3         | 545               | 2005-02-02                     | 118           |
| 73         | Rehanul Islam     | 85172                   | 4         | 811               | 2004-11-05                     | 207           |
| 33         | Rezaul Karim      | 46085                   | 2         | 511               | 2004-01-29                     | 488           |
| 37         | Riaz Mahmud       | 94117                   | 2         | 843               | 2004-09-09                     | 264           |
| 18         | Ridwan Hasan      | 116599                  | 4         | 1082              | 2004-11-05                     | 207           |
| 55         | Rifat Hossain     | 48048                   | 2         | 500               | 2004-01-09                     | 508           |
| 80         | Rodela Islam      | 33145                   | 2         | 381               | 2004-11-03                     | 209           |
| 48         | Rubaida Islam     | 85556                   | 2         | 929               | 2004-10-15                     | 228           |
| 85         | Rubel Hossain     | 82751                   | 3         | 929               | 2004-11-29                     | 183           |
| 77         | Sabbir Ahmed      | 49642                   | 2         | 468               | 2004-03-19                     | 438           |
| 50         | Sadia Jahan       | 88805                   | 3         | 937               | 2004-12-03                     | 179           |
| 20         | Saiful Islam      | 149799                  | 4         | 1442              | 2005-05-17                     | 14            |
| 71         | Salman Khan       | 142601                  | 3         | 1280              | 2005-05-10                     | 21            |
| 40         | Samia Afrin       | 654858                  | 17        | 6366              | 2005-05-29                     | 2             |
| 52         | Sanjida Akter     | 70488                   | 3         | 687               | 2005-03-28                     | 64            |
| 10         | Sayeed Anwar      | 93171                   | 3         | 1001              | 2005-04-07                     | 54            |
| 8          | Shafiq Ahmed      | 111640                  | 3         | 973               | 2004-09-03                     | 270           |
| 87         | Shakib Hasan      | 137956                  | 3         | 1650              | 2004-11-12                     | 200           |
| 13         | Sharmin Akter     | 83228                   | 3         | 906               | 2005-04-03                     | 58            |
| 59         | Shohan Rahman     | 83210                   | 3         | 933               | 2005-05-06                     | 25            |
| 35         | Shohidul Islam    | 79472                   | 2         | 636               | 2004-05-04                     | 392           |
| 92         | Shorna Akter      | 26479                   | 3         | 287               | 2004-12-03                     | 179           |
| 3          | Sumaiya Akter     | 78570                   | 3         | 684               | 2005-03-17                     | 75            |
| 42         | Sumi Akter        | 81578                   | 3         | 795               | 2005-01-20                     | 131           |
| 62         | Sumona Akter      | 160010                  | 4         | 1656              | 2005-04-22                     | 39            |
| 56         | Tabassum Jahan    | 87489                   | 2         | 954               | 2004-02-26                     | 460           |
| 4          | Tahmid Chowdhury  | 104562                  | 3         | 1060              | 2005-01-12                     | 139           |
| 25         | Tahsin Khan       | 75755                   | 4         | 647               | 2004-11-19                     | 193           |
| 30         | Tamanna Rahman    | 67507                   | 2         | 668               | 2004-10-14                     | 229           |
| 7          | Tania Rahman      | 69052                   | 2         | 699               | 2004-02-21                     | 465           |
| 43         | Tanvir Hasan      | 153996                  | 4         | 1469              | 2005-03-09                     | 83            |
| 66         | Tasnim Akter      | 115499                  | 4         | 1236              | 2005-04-23                     | 38            |
| 72         | Tumpa Sultana     | 57198                   | 2         | 572               | 2004-09-10                     | 263           |

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
- 
### RFM Analysis and Marketing Actions Page
- Definitions of Recency, Frequency, Monetary Value.
- Table of segments with descriptions and recommended marketing actions.

To integrate with Power BI:
- Connect to the MySQL database using Power BI's connector.
- Use the `RFM_SEGMENTATION_DATA` view as the data source.
- Create visuals as described for interactive analysis.

- **Live Link**: https://lnkd.in/gcaWW7nn
