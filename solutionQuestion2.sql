SELECT  dp.ProductName,
        sum(ft.SalesAmount) AS SalesAmount,
        FORMAT_TIMESTAMP('%m-%Y',ft.OrderDate) AS Month
FROM  Remote.FactResellerSales ft
      JOIN Remote.DimProduct dp ON (ft.ProductKey = dp.ProductKey)
WHERE FORMAT_TIMESTAMP('%Y', ft.OrderDate) = '2012'
GROUP BY dp.ProductName, Month