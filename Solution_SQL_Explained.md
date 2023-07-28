## PART 3 - SQL QUESTIONS 
### EXERCISE 1
Query solution:
```
WITH 
  TempTab AS (
    SELECT  ft.OrderDate,
            ft.SalesAmount,
            RANK() OVER (PARTITION BY FORMAT_TIMESTAMP('%Y%m', ft.OrderDate) ORDER BY ft.SalesAmount DESC) AS rank
    FROM  Remote.FactResellerSales ft
    JOIN Remote.DimProduct dp ON (ft.ProductKey = dp.ProductKey)
    WHERE FORMAT_TIMESTAMP('%Y', ft.OrderDate) = '2012'
          AND dp.ProductName = "Sport-100 Helmet, Red"
  )
SELECT  FORMAT_TIMESTAMP('%m-%Y', OrderDate) AS Month,
        SalesAmount,
        FORMAT_TIMESTAMP('%Y-%m-%d', OrderDate) AS OrderDate
FROM  TempTab
WHERE rank=1
ORDER BY Month
```
Context before query explanation: 
1. The product "Sport-100 Helmet, Red" belong to the data quality issue explained in the prior section (it has 3 different ProductKeys in DimProduct). However, this is not going to affect the analysis. Due to there is only one ProductKey value per month during 2012, (Pk=123 Jan-Nov ; Pk=214 Dec)
2. Combining all keys (ProductKey, OrderDateKey, DueDateKey, ShipDateKey, ResezllzerKey, EmployeeKey, PromotionKey, CurrencyKey, SalesTerritoryKey) per row in the fact table, I deduce that all rows are unique transactions. This means that no sum(SalesAmount) is needed in this analysis. 
3. DimProduct and FactResellerSales can be connected using ProductKey

Query explanation:
1. The solution includes a temporay table - WITH (...) - and the main query. 
2. Temporary table: it ranks the transactions per month. For this purpose, I use rank() which partitions the fact table by month and rank rows based on SalesAmount. The transaction with the highest SalesAmount per month will have a rank of 1. Moreover, the WHERE clause limit this table to the desired year and product. To get the ProductName, I join the fact and DimProduct using the common key (ProductKey).
3. The main query retrieves from the temporary table the highest transactions for each month (rank=1). It also formats the dates as specified in the assigment.


Result observation: all biggest sales happened the last few days of each month. 

### EXERCISE 2
Query solution:
```
SELECT  dp.ProductName,
        sum(ft.SalesAmount) AS SalesAmount,
        FORMAT_TIMESTAMP('%m-%Y',ft.OrderDate) AS Month
FROM  Remote.FactResellerSales ft
      JOIN Remote.DimProduct dp ON (ft.ProductKey = dp.ProductKey)
WHERE FORMAT_TIMESTAMP('%Y', ft.OrderDate) = '2012'
GROUP BY dp.ProductName, Month
```
Context before query explanation: 
1. As a result of the database referential integrity issues, there are 33 ProductKey included in FactResellerSales but missing DimProduct. Those products are excluded from this analysis.

Query explanation:
1. The total sales is calculated using sum() combined with GROUP BY per product and month 
2. Fact and dimensional table are joined using ProductKey. This inner join ensures that product without any sales in 2012 are excluded. Also, the join allows to retrieve ProductName from the dimensional table. 

### EXERCISE 3
Query solution:
```
WITH TempTab AS 
  (
    SELECT  CustomerKey,
            CASE WHEN DATE_DIFF(CURRENT_DATE(), BirthDate, YEAR) < 35 THEN 1 ELSE 0 END AS AgeBelow35,
            CASE WHEN DATE_DIFF(CURRENT_DATE(), BirthDate, YEAR) BETWEEN 35 AND 50 THEN 1 ELSE 0 END AS AgeBetween35and50,
            CASE WHEN DATE_DIFF(CURRENT_DATE(), BirthDate, YEAR) > 50 THEN 1 ELSE 0 END AS AgeAbove50
    FROM Remote.DimCustomer
)
SELECT  dc.MaritalStatus,
        dc.Gender,
        SUM(tab.AgeBelow35) AS AgeBelow35,
        SUM(tab.AgeBetween35and50) AS AgeBetween35and50,
        SUM(tab.AgeAbove50) AS AgeAbove50
FROM TempTab tab
JOIN Remote.DimCustomer dc ON (tab.CustomerKey = dc.CustomerKey)
GROUP BY dc.MaritalStatus, dc.Gender
```
Query explanation:
1. The solution includes a temporay table - WITH (...) - and the main query.
2. Temporary table: it classifyies each customer per age range. For this purpose, it creates three columns (AgeBelow35, AgeBetween35and50 and AgeAbove50) using CASE(). Each CASE contains a binary indicator (1 or 0) depending on Age. Age is calculated as the difference between current_Date and BirthDate. Each customer has only one of those columns set as 1, the rest as 0.
3. Main query: by sum() the indicators created in TempTab , it shows the number of customers per age group for each unique combination of MaritalStatus and Gender. To 

Result observation: Married Men are the biggest group in all age buckets

### EXERCISE 4
Query solution:
```
WITH 
  TempTab1 AS (
    SELECT  ProductKey,
            SalesTerritoryKey,
            FORMAT_TIMESTAMP('%m-%Y', OrderDate) AS Month,
            sum(SalesAmount) AS SalesAmount
    FROM  Remote.FactResellerSales
    WHERE FORMAT_TIMESTAMP('%Y', OrderDate) = '2012'
    GROUP BY ProductKey, SalesTerritoryKey, Month
  ),
  TempTab2 AS (
    SELECT  ProductKey,
            SalesTerritoryKey,
            Month,
            SalesAmount,
            RANK() OVER (PARTITION BY Month ORDER BY SalesAmount) AS rank
    FROM  TempTab1
  )
SELECT  Month,
        ds.SalesTerritoryCountry,      
        dc.ProductName,
        SalesAmount
FROM TempTab2 tt
JOIN Remote.DimProduct dc ON (tt.ProductKey = dc.ProductKey)
JOIN Remote.DimSalesTerritory ds ON (tt.SalesTerritoryKey = ds.SalesTerritoryKey)
WHERE rank=1
ORDER BY Month
```
Query explanation:
1. The solution includes two temporay tables - WITH (...) - and the main query.
2. Temporary table 1 (TempTab1): it calculates the monthly total sales per Product and Territory
3. Temporary table 2 (TempTab2): it ranks TempTab1 results, obtaining the rank of the Product & Territory total sales per month. For this purpose, I use rank(), which partitions TempTab1 by month and ranks rows based on SalesAmount. The Product & Territory with the highest total sales per month will have a rank of 1
4. Main query: it retrieves from TempTab2 the highest transactions for each month (rank=1). It also gets the ProductName and SalesTerritoryCountry by joining TempTab2 with the dimensional tables.

<br>
Result notes: for some months, there are 2 combinations of Product & Country with the lowest sales amount.