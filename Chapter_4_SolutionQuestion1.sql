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
