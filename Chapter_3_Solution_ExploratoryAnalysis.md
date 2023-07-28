## SOLUTION EXPLORATORY ANALYSIS


I start the database exploration by having a general look at the schema, the columns contained in each table and relationships between tables.

The schema of this assignment consist of 4 tables, 3 dimensional tables with Product, SalesTerritory and Customer data and a Fact table with sales data.


From this first exploration I noticed some ***data quality issues***: 
1. Uncompleted schema:
    - FactResellerSales does not include CustomerKey. This means that there is an isolated dimensional table (DimCustomer), which cannot join with the fact table. 
    - DimCustomer includes a key (GeographyKey) which is not related to any table, including the dimensional table containing geography data (DimSalesTerritory). The schema should include a DimGeography table to be complete.
    - FactResellerSales contains a series of keys (ResellerKey, EmployeeKey, PromotionKey and CurrencyKey) unrelated to any dimensional table. The schema should include a DimReseller, DimEmployer, DimPromotion and DimCurrency tables to be complete.
    - DimProduct includes a key ProductSubcategoryKey which is not related to any table. The schema should include a DimProductSubcategory table to be complete.
2. Data Accuracy issue: 
    - DimSalesTerritory contains a row full of 'NA' (SalesTerritoryKey=11). 
3. Potential bad case practise: 
    - DimSalesTerritory alternate key values are the same as the primary key except for SalesTerritoryKey=11. Normally, an alternate key should contain unique values that identify each row and could be an alternative to the primary. In this case, alternate key values are "correct" but its parallel with the primary key seems a bad practise.

<br/>

After the above general observations, I start using SQL to run a series of general checks: 
1. Primary/Alternate key duplications: the purpose is to verify that those key are unique in the dimensional tables.
2. Referential integrity: the purpose is to verify that relationships between tables are valid and consistent. The fact table should be able to join with the dimensional tables without losing any rows.
3. Validate date columns: the purpose is to check date ranges, future/past dates, or illogical date/time combinations.
4. Validate numerical columns: the purpose is to verify there is no unexpected values (i.e. a negative value in SalesAmount, illogical max/min values) or statistical outliers in the columns with numerical data.

<br/>

**Data quality issues** found using SQL:
1. AlternateKey duplications in DimProduct:
    - DimProduct contains duplicated ProductAlternateKey, which should be unique per Product. The count(distinct) of the ProductAlternateKey should be equal to rownumber, but it isn't as shown in the below query:
    ```
    SELECT  COUNT(*), 
            COUNT (distinct ProductKey) AS Counter1,
            COUNT (distinct ProductAlternateKey) AS Counter2
    FROM Remote.DimProduct
    ```
    - The below query shows the rows having a Product with duplicated AlternateKey (ProductKey has more than 1 ProductAlternateKey)
    ```
    SELECT *
    FROM Remote.DimProduct
    WHERE ProductAlternateKey IN (
            SELECT ProductAlternateKey
            FROM (
                    SELECT  ProductAlternateKey,
                            COUNT (ProductAlternateKey) AS Counter2
                    FROM Remote.DimProduct
                    GROUP BY ProductAlternateKey
                    HAVING counter2>1
            )
    )
    ORDER BY ProductAlternateKey
    ```
    - Scope of the issue: 25% (142) of the ProductKey has more than one ProductAlternateKey
2. Referential integrity between FactResellerSales and DimProduct
    - FactResellerSales loses rows when joined with DimProduct. This means that some ProductKey are missing in DimProduct. The below query shows the list of ProductKey contained in the fact table but missing in the dimensional table.
    ```
    WITH tab1 AS(
        SELECT ft.ProductKey AS P1
        FROM  Remote.FactResellerSales ft
        JOIN Remote.DimProduct dp ON (ft.ProductKey = dp.ProductKey)
        group by P1
        ), tab2 AS(
            SELECT ProductKey AS P2
            FROM  Remote.FactResellerSales
            GROUP BY P2
        )
    SELECT tab2.P2
    FROM tab2
    WHERE tab2.P2 NOT IN (SELECT p1 from tab1)
    GROUP BY P2
    ```
    - Scope of the issue: 10% (6073) rows are lost FactResellerSales and 33 ProductKey missing in DimProduct (5% of Total). Query to measure the number of rows lost:
    ```
    WITH tab1 AS (
        SELECT count(*) JoinedRows
        FROM  Remote.FactResellerSales ft
        JOIN Remote.DimProduct dp ON (ft.ProductKey = dp.ProductKey)
    ), tab2 AS(
        SELECT count(*) FactRows
        FROM  Remote.FactResellerSales
    )
    SELECT  tab1.JoinedRows,
            tab2.FactRows,
            (tab2.factRows-tab1.joinedRows) LostRows
    FROM tab1,tab2
    ```
3. Invalid date in DimProduct: 
    - DimProduct StarDate contains values that are not timestamp (i.e 00:00.0). This forced to set up the column as VARCHAR type instead of TIMESTAMP when creating the database. The below query shows those cases:
    ```
    SELECT  ProductKey,
            StartDate
    FROM    Remote.DimProduct
    WHERE StartDate = '00:00.0'
    ``` 
    - Scope of the issue: 26% (151) of the StarDate are set as '00:00.0'
4. NULL date in DimProduct: 
    - DimProduct has NULL StartDate and EndDate. The below query show the Products in this situation
    ```
    SELECT  ProductKey
    FROM    Remote.DimProduct
    WHERE   (StartDate IS NULL) 
            or (EndDate IS NULL)
    ```
    - Scope of the issue: 23% (132) of the Product are in this situation
5. Critical NULLs in DimProduct: 
    - ProductSubcategoryKey contains NULL values. The below query shows the Products in this situation
    ```
    SELECT  ProductKey,
            ProductSubcategoryKey
    FROM    Remote.DimProduct
    WHERE ProductSubcategoryKey IS NULL
    ```
    - Scope of the issue: 94% of the ProductSubcategoryKey values are null
6. Unexpected Currency in FactResellerSales
    - FactResellerSales transactions in France (SalesTerritoryKey=7) has been done in two difference CurrencyKey. This is a potential data quality issue (except business rules specifies french transactions can be in € and $). The below query shows that France has transactions in two CurrencyKey (36 and 100)
    ```
    SELECT  SalesTerritoryKey,
            CurrencyKey
    FROM    Remote.FactResellerSales
    WHERE   SalesTerritoryKey  = (  
                SELECT  SalesTerritoryKey
                FROM Remote.FactResellerSales
                GROUP BY SalesTerritoryKey
                HAVING COUNT(DISTINCT CurrencyKey)>1
            )
    GROUP BY SalesTerritoryKey, CurrencyKey
    ```
7. Contradicting Children Data in DimCustomer
    - DimCustomer has two columns with children data containing contradicting values for certain customers. The query below shows the customers whose number of NumberChildrenAtHome are bigger than the TotalChildren:
    ```
    SELECT  Customerkey,
            TotalChildren,
            NumberChildrenAtHome
    FROM Remote.DimCustomer
    WHERE TotalChildren < NumberChildrenAtHome
    ```
     - Scope of the issue: 7% (1431) of the customer