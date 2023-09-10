# USING store

SELECT `Order ID`, `Customer ID`, `Customer Name`, State, Category, Profit
  FROM store.`store order`;
  
SELECT so.*,
	   sr.Returned
  FROM store.`store order` AS so
  LEFT JOIN store.`store return` AS sr
    ON so.`Order ID` = sr.`Order ID`;

SELECT `Customer ID`,`Customer Name`, ROUND((Profit/(Sales*Quantity)*100),2) AS prope_profit
FROM store.`store order`
WHERE city = 'Henderson';

SELECT AVG(ROUND((Profit/(Sales*Quantity)*100),2)) AS avg_prope_profit_Henderson
FROM store.`store order`
WHERE city = 'Henderson';

SELECT DISTINCT State
FROM store.`store order`
ORDER BY State;

/* Collab 2 table toghether
Then change value NULL from Returned 
 */
CREATE TABLE Store_manage_ReNUL
AS SELECT so.*,
	      ifnull(sr.Returned, 'No') AS returned
  FROM store.`store order` AS so
  LEFT JOIN store.`store return` AS sr
    ON so.`Order ID` = sr.`Order ID`;

select * from store.store_manage_renul;

SELECT Region, COUNT(*) AS `total order` 
  FROM store.store_manage_renul
GROUP BY Region
;

CREATE TABLE Store_manage_returned
AS SELECT *
  FROM store.store_manage_renul
WHERE returned = 'Yes';

CREATE TABLE Store_manage_not_returned
AS SELECT *
  FROM store.store_manage_renul
WHERE returned = 'No';


/*2. Revenue per region FOR 4 YEARS*/
SELECT Region, COUNT(*) AS `total order`, SUM(Sales) AS total_sales, SUM(Profit) AS total_protfit,
       ROUND(AVG((Profit/(Sales*Quantity))*100.0),2) AS perce_profit
  FROM store.store_manage_not_returned_year
GROUP BY Region
;

CREATE TABLE Revenue_per_region
AS SELECT Region, COUNT(*) AS `total order`, SUM(Sales) AS total_sales, SUM(Profit) AS total_protfit,
       ROUND(AVG((Profit/(Sales*Quantity))*100.0),2) AS perce_profit
  FROM Store_manage_not_returned_year
GROUP BY Region
;

/*2. Revenue per region in 2017*/
SELECT Region, COUNT(*) AS `total order`, SUM(Sales) AS total_sales, SUM(Profit) AS total_protfit_2017,
       ROUND(AVG((Profit/(Sales*Quantity))*100.0),2) AS perce_profit_2017
  FROM store.store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2017
GROUP BY Region
;

CREATE TABLE Revenue_per_region_2017
AS SELECT Region, COUNT(*) AS `total order`, SUM(Sales) AS total_sales, SUM(Profit) AS total_protfit_2017,
       ROUND(AVG((Profit/(Sales*Quantity))*100.0),2) AS perce_profit_2017
  FROM store.store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2017
GROUP BY Region
;

/*2. Revenue per region in 2016*/
SELECT Region, COUNT(*) AS `total order`, SUM(Sales) AS total_sales, SUM(Profit) AS total_protfit_2016,
       ROUND(AVG((Profit/(Sales*Quantity))*100.0),2) AS perce_profit_2016
  FROM store.store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2016
GROUP BY Region
;

/*2. Revenue per region in 2015*/
SELECT Region, COUNT(*) AS `total order`, SUM(Sales) AS total_sales, SUM(Profit) AS total_protfit_2016,
       ROUND(AVG((Profit/(Sales*Quantity))*100.0),2) AS perce_profit_2015
  FROM store.store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2015
GROUP BY Region
;

/*2. Revenue per region in 2014*/
SELECT Region, COUNT(*) AS `total order`, SUM(Sales) AS total_sales, SUM(Profit) AS total_protfit_2016,
       ROUND(AVG((Profit/(Sales*Quantity))*100.0),2) AS perce_profit_2014
  FROM store.store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2014
GROUP BY Region
;

SELECT `Order ID`, Segment, SUBSTRING(`Order Date`, 7, 10) AS YEAR_S
FROM store.store_manage_renul
;

CREATE TABLE test_date
AS SELECT `Order Date`, date_format(STR_TO_DATE(`Order Date`,'%d/%m/%Y'), '%Y-%m-%d') as fix_date
FROM store.store_manage_renul
;

CREATE TABLE IF NOT EXISTS test_date (
  `Order Date` DATE,
  `fix_date` DATE
);

INSERT INTO test_date (`Order Date`, `fix_date`)
SELECT `Order Date`, STR_TO_DATE(`Order Date`, '%d/%m/%Y') as fix_date
FROM store.store_manage_renul;

SELECT YEAR(fix_date), COUNT(*)
FROM store.test_date
GROUP BY YEAR(fix_date);

CREATE TABLE store_manage_years
SELECT `Row ID`, `Order ID`, date_format(STR_TO_DATE(`Order Date`,'%d/%m/%Y'), '%Y-%m-%d') as `Order Date`,
	   date_format(STR_TO_DATE(`Ship Date`,'%d/%m/%Y'), '%Y-%m-%d') as `Ship Date`, `Ship Mode`, `Customer ID`, `Customer Name`, Segment, Country, City, State, `Postal Code`, Region, `Product ID`, Category,
       `Sub-Category`, `Product Name`, Sales, Quantity, Discount, Profit, returned
  FROM store.store_manage_renul;

CREATE TABLE Store_manage_returned_year
AS SELECT *
  FROM store.store_manage_years
WHERE returned = 'Yes';

CREATE TABLE Store_manage_not_returned_year
AS SELECT *
  FROM store.store_manage_years
WHERE returned = 'No';

/*1. TOTAL ORDER PER YEARS*/
SELECT YEAR(`Order Date`), COUNT(*) AS num_order
  FROM store.store_manage_years
GROUP BY YEAR(`Order Date`)
ORDER BY YEAR(`Order Date`);

/*TOTAL ORDER PER MONTH IN 2014*/
SELECT MONTH(`Order Date`), COUNT(*) AS num_order_2014
  FROM store.store_manage_years
 WHERE YEAR(`Order Date`) = 2014
GROUP BY MONTH(`Order Date`)
ORDER BY MONTH(`Order Date`);

/*TOTAL ORDER PER MONTH IN 2015*/
SELECT MONTH(`Order Date`), COUNT(*) AS num_order_2015
  FROM store.store_manage_years
 WHERE YEAR(`Order Date`) = 2015
GROUP BY MONTH(`Order Date`)
ORDER BY MONTH(`Order Date`);

/*TOTAL ORDER PER MONTH IN 2016*/
SELECT MONTH(`Order Date`), COUNT(*) AS num_order_2016
  FROM store_manage_years
 WHERE YEAR(`Order Date`) = 2016
GROUP BY MONTH(`Order Date`)
ORDER BY MONTH(`Order Date`);

/*TOTAL ORDER PER MONTH IN 2017*/
SELECT MONTH(`Order Date`), COUNT(*) AS num_order_2017
  FROM store_manage_years
 WHERE YEAR(`Order Date`) = 2017
GROUP BY MONTH(`Order Date`)
ORDER BY MONTH(`Order Date`);

/*PROFIT PER STATE FOR ALL 4 YEARS*/
SELECT State, SUM(Profit) AS total_profit
 FROM store.store_manage_not_returned_year
GROUP BY State
ORDER BY total_profit DESC;

/*PROFIT PER SATTE IN 2017*/
SELECT State, SUM(Profit) AS total_profit
 FROM store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2017
GROUP BY State
ORDER BY total_profit DESC;

/*PROFIT PER SATTE IN 2016*/
SELECT State, SUM(Sales*Quantity) AS total_sale, SUM(Profit) AS total_profit
 FROM store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2016
GROUP BY State
ORDER BY total_profit DESC;

/*PROFIT PER SATTE IN 2015*/
SELECT State, SUM(Sales*Quantity) AS total_sale, SUM(Profit) AS total_profit
 FROM store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2015
GROUP BY State
ORDER BY total_profit DESC;

/*PROFIT PER SATTE IN 2014*/
SELECT State, SUM(Sales*Quantity) AS total_sale, SUM(Profit) AS total_profit
 FROM store_manage_not_returned_year
WHERE YEAR(`Order Date`) = 2014
GROUP BY State
ORDER BY total_profit DESC;

/*sub-category that customer interest the most*/
SELECT `Sub-Category`, SUM(Quantity) AS total_order, SUM(Profit) AS total_profit
  FROM store_manage_years
 GROUP BY `Sub-Category`
 ORDER BY total_profit DESC, total_order DESC;

/*sub-category that have the most order and have the most profits, in not returned*/
SELECT `Sub-Category`, SUM(Quantity) AS total_order, SUM(Profit) AS total_profit
  FROM store_manage_not_returned_year
 GROUP BY `Sub-Category`
 ORDER BY total_profit DESC;
 
SELECT `Sub-Category`, SUM(Quantity) AS total_order, SUM(Profit) AS total_profit
  FROM store_manage_not_returned_year
 GROUP BY `Sub-Category`
 ORDER BY total_order DESC;
 
/*sub-category that have the most returned order*/
SELECT `Sub-Category`, SUM(Quantity) AS total_order_returned, SUM(Profit) AS total_profit
  FROM store_manage_returned_year
 GROUP BY `Sub-Category`
 ORDER BY total_order_returned DESC;
 
/*10. Percentage return of order each year*/
SELECT COUNT(*) FROM store_manage_returned_year; /*773*/
SELECT COUNT(*) FROM store_manage_years; /*9694*/
 
/*10. Percentage return of order in 2014*/
SELECT COUNT(*) 
  FROM store_manage_returned_year
 WHERE YEAR(`Order Date`) = 2014; /*145*/
SELECT COUNT(*) FROM store_manage_years
 WHERE YEAR(`Order Date`) = 2014; /*1944*/
   
/*10. Percentage return of order in 2015*/
SELECT COUNT(*) 
  FROM store_manage_returned_year
 WHERE YEAR(`Order Date`) = 2015; /*159*/
SELECT COUNT(*) FROM store_manage_years
 WHERE YEAR(`Order Date`) = 2015; /*2045*/

/*10. Percentage return of order in 2016*/
SELECT COUNT(*) 
  FROM store_manage_returned_year
 WHERE YEAR(`Order Date`) = 2016; /*194*/
SELECT COUNT(*) FROM store_manage_years
 WHERE YEAR(`Order Date`) = 2016; /*2504*/
 
/*10. Percentage returned of order in 2017*/
SELECT COUNT(*) 
  FROM store_manage_returned_year
 WHERE YEAR(`Order Date`) = 2017; /*275*/
SELECT COUNT(*) FROM store_manage_years
 WHERE YEAR(`Order Date`) = 2017; /*3201*/
 
/*4. customer bring the most revenue*/
SELECT `Customer ID`, SUM(Sales*Quantity) AS total_Sales, SUM(Profit) AS total_profit, (SUM(Profit)/SUM(Sales*Quantity))*100 AS gross_profit_margin
  FROM store_manage_not_returned_year
GROUP BY `Customer ID`, `Order Date`
ORDER BY total_profit DESC
LIMIT 5;

/*6.Custome have return order the most*/
SELECT `Customer ID`, SUM(Quantity) AS total_returned_order
  FROM store_manage_returned_year
GROUP BY `Customer ID`
ORDER BY total_returned_order DESC;

SELECT * FROM store_manage_years;

/*6. TYPE OF ship mode that user use the most*/
SELECT `Ship Mode`, SUM(Quantity) AS total_order
  FROM store_manage_years
GROUP BY `Ship Mode`
ORDER BY total_order DESC;

/*7.ship mode that customer use*/
SELECT `Customer ID`, `Ship Mode`, SUM(Quantity) AS ship_mode
  FROM store_manage_years
GROUP BY `Customer ID`, `Ship Mode`
ORDER BY ship_mode DESC;

/* Sales per state, detail Cities*/
SELECT Region, State, SUM(Sales*Quantity) AS Sales_total
  FROM store_manage_years
GROUP BY Region, State
ORDER BY State;

CREATE TABLE Sales_per_region_state_total
AS SELECT Region, State, SUM(Sales*Quantity) AS Sales_total
  FROM store_manage_years
GROUP BY Region, State
ORDER BY State;

 
/* Sales per state, detail Cities 2017*/
CREATE TABLE Sales_per_state_city_2017
AS SELECT State, City, SUM(Sales*Quantity) AS Sales_2017
  FROM store_manage_years
WHERE YEAR(`Order Date`) = 2017
GROUP BY State, City
ORDER BY State;

/* Sales per state, detail Cities 2016*/
CREATE TABLE Sales_per_state_city_2016
AS SELECT State, City, SUM(Sales*Quantity) AS Sales_2016
  FROM store_manage_years
WHERE YEAR(`Order Date`) = 2016
GROUP BY State, City
ORDER BY State;

/* Sales per state, detail Cities 2015*/
CREATE TABLE Sales_per_state_city_2015
AS SELECT State, City, SUM(Sales*Quantity) AS Sales_2015
  FROM store_manage_years
WHERE YEAR(`Order Date`) = 2015
GROUP BY State, City
ORDER BY State;

SELECT State, City, SUM(Sales*Quantity) AS Sales_2015
  FROM store_manage_years
WHERE YEAR(`Order Date`) = 2015
GROUP BY State, City
ORDER BY State; 

/* Sales per state, detail Cities 2014*/
CREATE TABLE Sales_per_state_city_2014
AS SELECT State, City, SUM(Sales*Quantity) AS Sales_2014
  FROM store_manage_years
WHERE YEAR(`Order Date`) = 2014
GROUP BY State, City
ORDER BY State;

SELECT State, SUM(Sales*Quantity) AS Sales_2014
  FROM store_manage_years
WHERE YEAR(`Order Date`) = 2014
GROUP BY State
ORDER BY State;

SELECT t.State, t.City, t.Sales_total,
	   t1.Sales_2017, t2.Sales_2016, t3.Sales_2015, t4.Sales_2014
  FROM sales_per_state_city_total AS t
INNER JOIN sales_per_state_city_2017 AS t1 ON t.City = t1.City
INNER JOIN sales_per_state_city_2016 AS t2 ON t.City = t2.City
INNER JOIN sales_per_state_city_2015 AS t3 ON t.City = t3.City
INNER JOIN sales_per_state_city_2014 AS t4 ON t.City = t4.City;


