## SQL BUSINESS QUESTIONS

### Question 1: What is the highest transaction of each month in 2012 for the product Sport-100 Helmet, Red?

💡 Tables containing the information are *DimProduct*, *FactResellerSales*

❗️ Do not use max() SQL function

📦 Expected output columns & value format:

| Month | SalesAmount | OrderDate |
| --- | --- | --- |
| MM-YYYY | 0.0 (with . as decimals) | YYYY-MM-DD |

### Question 2: Find all the products and their total sales amount by month. Only consider products that had at least one sale in **2012.**

💡 Tables containing the information are *DimProduct, FactResellerSales*

📦  Expected output columns are *ProductName, SalesAmount, OrderMonth*

| ProductName | SalesAmount | Month |
| --- | --- | --- |
| 1234 | 0.0 (decimals) | MM-YYYY |

### Question 3: What are the age groups of customers categorised by marital status and gender?

💡 Tables containing the information is *DimCustomer*

❗️ Bucket them by Age Groups: a) Less than 35, b) Between 35 and 50, c) Greater than 50. Segregate the Number of Customers in each age group by **Marital Status** and **Gender**.

📦 Expected output columns are:

| MaritalStatus | Gender | AgeBelow35 | AgeBetween35and50 | AgeAbove50 |
| --- | --- | --- | --- | --- |
| M | F | 0 (integer) | 0 (integer) | 0 (integer) |

### Question 4: What is the combination of product & country with the lowest amount of sales per month in 2012?

💡 Tables containing the information are *DimProduct, DimSalesTerritory, FactResellerSales*

❗️ *SalesTerritoryCountry* & *ProductName* should be included

📦 Expected output columns are:

| Month | SalesTerritoryCountry | ProductName | SalesAmount |
| --- | --- | --- | --- |
| MM-YYYY | United States | Name | 0.0 (decimals) |
