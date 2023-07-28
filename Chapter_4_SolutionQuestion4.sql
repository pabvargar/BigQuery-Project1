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
