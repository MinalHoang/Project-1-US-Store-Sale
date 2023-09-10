SELECT * FROM usstoressales.sales;

SELECT COUNT(`Area Code`)
  FROM usstoressales.sales;
 
#Seraprate date month and year
Create table sale_new
SELECT `Area Code`, State, Market, `Market Size`, Profit, Margin, Sales, COGS, `Total Expenses`, Marketing, Inventory, `Budget Profit`, `Budget COGS`, `Budget Margin`, `Budget Sales`, ProductId, 
	   SUBSTRING(Date,  1, 2) AS Month, SUBSTRING(Date,  7, 10) AS Year, `Product Type`, Product, Type
  FROM sales;
  
SELECT * FROM sale_new;


#A. Market Performance and Trends:
#1. sales and profit data across different states
SELECT State, SUM(Sales) AS total_sales, SUM(Profit) AS total_profit
  FROM sale_new
 GROUP BY State
 ORDER BY State;

# 2. top-performing markets based on sales, profit, and margin.
# top-performing markets based on sales
SELECT Market, SUM(Sales) AS total_sales
  FROM sale_new
 GROUP BY Market
 ORDER BY total_sales;
 
# top-performing markets based on profit
SELECT Market, SUM(Profit) AS total_profit
  FROM sale_new
 GROUP BY Market
 ORDER BY total_profit;
 
 # top-performing markets based on margin
SELECT Market, SUM(Margin) AS total_margin
  FROM sale_new
 GROUP BY Market
 ORDER BY total_margin;
 
#3. ROI - the effectiveness of marketing efforts in different market sizes.
SELECT Month, Year, ProductId, `Product Type`, Profit, Marketing, FORMAT((((Profit-Marketing)/Marketing)*100), 2) AS percent_roi
  FROM sale_new;
  
#Market Size each Years
SELECT Year, `Market Size`, 
		FORMAT(((SUM(Profit) - SUM(Marketing))/SUM(Marketing))*100, 2) AS percent_roi
  FROM sale_new
 WHERE Year = '2010'
 GROUP BY `Market Size`

UNION

SELECT Year, `Market Size`, 
		FORMAT(((SUM(Profit) - SUM(Marketing))/SUM(Marketing))*100, 2) AS percent_roi
  FROM sale_new
 WHERE Year = '2011'
 GROUP BY `Market Size`
;

# Product Type
SELECT `Product Type`, FORMAT(((SUM(Profit) - SUM(Marketing))/SUM(Marketing))*100, 2) AS percent_roi
FROM sale_new
GROUP BY `Product Type`
ORDER BY percent_roi DESC;

#ROI per quater
Create table sale_quater
SELECT `Area Code`, State, Market, `Market Size`, Profit, Margin, Sales, COGS, `Total Expenses`, Marketing, 
	    Inventory, `Budget Profit`, `Budget COGS`, `Budget Margin`, `Budget Sales`, ProductId, Month, 
       CASE 
	 WHEN Month IN ('01', '02', '03') THEN "Q1"
	 WHEN Month IN ('04', '05', '06') THEN "Q2"
	 WHEN Month IN ('07', '08', '09') THEN "Q3"
     WHEN Month IN ('10', '11', '12') THEN "Q4"
     END AS quater,
     Year, `Product Type`, Product, Type
  FROM sale_new;
  
SELECT Year, Quater, FORMAT(((SUM(Profit) - SUM(Marketing))/SUM(Marketing))*100, 2) AS percent_roi
  FROM  sale_quater
 WHERE Year = 2010  
 GROUP BY quater
 
UNION

SELECT Year, Quater, FORMAT(((SUM(Profit) - SUM(Marketing))/SUM(Marketing))*100, 2) AS percent_roi
  FROM  sale_quater
 WHERE Year = 2011 
 GROUP BY quater
 ORDER BY Year, Quater
 ;

#4. Compare KPI by State and Product
# State
 SELECT Year, Market, FORMAT(SUM(Sales), 0) AS total_sale,
       FORMAT((SUM(Sales)/SUM(`Budget Sales`))*100, 2) AS percent_kpi_Sale, FORMAT(SUM(COGS), 0) AS total_cogs,
       FORMAT((SUM(COGS)/SUM(`Budget COGS`))*100, 2) AS percent_kpi_cogs, FORMAT(SUM(`Profit`), 0) AS total_profit,
	   FORMAT((SUM(`Profit`)/SUM(`Budget Profit`))*100, 2) AS percent_kpi_profit
  FROM sale_new
 WHERE Year = 2010
 GROUP BY Market

UNION

SELECT Year, Market, FORMAT(SUM(Sales), 0) AS total_sale,
       FORMAT((SUM(Sales)/SUM(`Budget Sales`))*100, 2) AS percent_kpi_Sale, FORMAT(SUM(COGS), 0) AS total_cogs,
       FORMAT((SUM(COGS)/SUM(`Budget COGS`))*100, 2) AS percent_kpi_cogs, FORMAT(SUM(`Profit`), 0) AS total_profit,
	   FORMAT((SUM(`Profit`)/SUM(`Budget Profit`))*100, 2) AS percent_kpi_profit
  FROM sale_new
 WHERE Year = 2011
 GROUP BY Market;
 
#Product
SELECT Year, `Product Type`, FORMAT(SUM(Sales), 0) AS total_sale,
       FORMAT((SUM(Sales)/SUM(`Budget Sales`))*100, 2) AS percent_kpi_Sale, FORMAT(SUM(COGS), 0) AS total_cogs,
       FORMAT((SUM(COGS)/SUM(`Budget COGS`))*100, 2) AS percent_kpi_cogs, FORMAT(SUM(`Profit`), 0) AS total_profit,
	   FORMAT((SUM(`Profit`)/SUM(`Budget Profit`))*100, 2) AS percent_kpi_profit
  FROM sale_new
 WHERE Year = 2010
 GROUP BY `Product Type`

UNION

SELECT Year, `Product Type`, FORMAT(SUM(Sales), 0) AS total_sale,
       FORMAT((SUM(Sales)/SUM(`Budget Sales`))*100, 2) AS percent_kpi_Sale, FORMAT(SUM(COGS), 0) AS total_cogs,
       FORMAT((SUM(COGS)/SUM(`Budget COGS`))*100, 2) AS percent_kpi_cogs, FORMAT(SUM(`Profit`), 0) AS total_profit,
	   FORMAT((SUM(`Profit`)/SUM(`Budget Profit`))*100, 2) AS percent_kpi_profit
  FROM sale_new
 WHERE Year = 2011
 GROUP BY `Product Type`;

#B. Product Analysis:
#1. Determine the most popular product types and specific products.
#Product Type
SELECT ProductId, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
 GROUP BY ProductId, `Product Type`
 ORDER BY total_profit DESC, total_sale DESC;

#Product
SELECT Product, SUM(Sales) as total_sale, SUM(Profit) as total_profit
  FROM sale_new
 GROUP BY Product
 ORDER BY total_profit DESC;

 
#2. how product types contribute to overall sales and profit to each States
SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Connecticut'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Washington'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'California'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Texas'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'New York'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Ohio'
 GROUP BY `Product Type`
 
UNION
SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Illinois'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Louisiana'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Florida'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Wisconsin'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Colorado'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Missouri'
 GROUP BY `Product Type`
  
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Iowa'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Massachusetts'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Oklahoma'
 GROUP BY `Product Type`
 
UNION
SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Utah'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Oregon'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'New Mexico'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'New Hampshire'
 GROUP BY `Product Type`
 
UNION

SELECT State, `Product Type`, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM sale_new
  WHERE State = 'Nevada'
 GROUP BY `Product Type`
;

#C. Time Series Analysis
#1. Determine whether specific periods (holidays, seasons) drive higher sales.
SELECT Year, Quater, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM  sale_quater
 WHERE Year = 2010  
 GROUP BY quater
 
UNION

SELECT Year, Quater, FORMAT(SUM(Sales), 0) as total_sale, FORMAT(SUM(Profit), 0) as total_profit
  FROM  sale_quater
 WHERE Year = 2011 
 GROUP BY quater
 ORDER BY Year, Quater
;

