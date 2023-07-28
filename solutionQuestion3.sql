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