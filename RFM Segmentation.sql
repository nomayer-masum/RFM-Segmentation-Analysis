-- RFM SEGMENTATION

CREATE VIEW RFM_SEGMENTATION_DATA AS

with CLV as (
SELECT 
customerid,
customername,
   MAX(orderdate) AS customer_last_transacton_date,
   datediff((SELECT MAX(orderdate) from rfm_sales), 
   MAX(orderdate)) as recency_value,
	COUNT(DISTINCT ordernumber) AS frequency_value,
    SUM(quantityordered) AS total_qty_ordered,
    ROUND(SUM(sales), 0) AS monetary_value
FROM
    rfm_sales
GROUP BY customerid, customername
order by customername),

RFM_Score as
(select 
c.*,
ntile(5) over(order by recency_value desc) as R_Score,
ntile(5) over(order by frequency_value Desc) as F_Score,
ntile(5) over(order by monetary_value desc) as M_Score
from CLV as c),

rfm_combination as
(select 
R.*,
R_Score + F_Score + M_Score as total_rfm_score,
concat_ws('', R_Score, F_Score, M_Score) as rfm_combination
from rfm_score as r)

select 
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
from RFM_Combination as rc;

SELECT * FROM RFM_SEGMENTATION_DATA;

select
customer_segment,
count(customer_segment) as count_of_customer,
sum(monetary_value) as total_spending,
round(avg(monetary_value),0) as avg_spending,
sum(frequency_value) as total_order,
sum(total_qty_ordered) as total_qty_ordered
from
RFM_SEGMENTATION_DATA
group by customer_segment;