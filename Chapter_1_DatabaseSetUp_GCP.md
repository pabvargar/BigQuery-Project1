## CHAPTER 1 - DATABASE CREATION (MySQL 8.0 in GCP)

Database selection: MySQL 8.0 Google Cloud Platform (SQL)

_Note_: if not interested in learning how to set up a database in GCP(SQL), jump to Chapter_2_DatabaseConnection_BigQuery.md and learn how to create the database directly in Google BigQuery


Database set up process step by step:
1. Create a free account in [Google Cloud Platform](https://cloud.google.com/)
2. Create a [MySQL 8.0 database intance](https://cloud.google.com/sql/docs/mysql/create-instance) using the default settings (CPU, Memory...)
3. Go to the recently created MySQL instance
4. Allow permissions API for [Cloud SQL](https://cloud.google.com/sql/docs/mysql/admin-api), [Cloud Shell Terminal](https://cloud.google.com/endpoints/docs/openapi/enable-api) and [BigQuery](https://cloud.google.com/bigquery/docs/enable-transfer-service)
5. Create database and tables schema using Cloud Shell Terminal:
    - Login to the MySQL instance
    ```
    gcloud sql connect <your-instance-ID> --user=root --quiet
    ```    
    - Create a database named Remote and access it
    ```
    create database Remote;
    use <database name>;
    ```
    - Create the tables using SQL
    ```
    create table factResellerSales(
        ProductKey INT,
        OrderDateKey INT,
        DueDateKey INT,
        ShipDateKey INT,
        ResellerKey INT,
        EmployeeKey INT,
        PromotionKey INT,
        CurrencyKey int,
        SalesTerritoryKey VARCHAR(255),
        SalesOrderNumber INT,
        SalesOrderLineNumber INT,
        RevisionNumber INT,
        OrderQuantity float,
        UnitPrice  float,
        ExtendedAmount INT,
        UnitPriceDiscountPct INT,
        DiscountAmount float,
        ProductStandardCost float,
        TotalProductCost float,
        SalesAmount float,
        TaxAmt float,
        Freight varchar(255),
        CarrierTrackingNumber varchar (255),
        CustomerPONumber TIMESTAMP,
        OrderDate TIMESTAMP,
        DueDate TIMESTAMP,
        ShipDate TIMESTAMP
    );
    create table DimCustomer(
        CustomerKey INT,
        GeographyKey INT,
        CustomerAlternateKey VARCHAR(255),
        Title VARCHAR(255),
        FirstName VARCHAR(255),
        MiddleName VARCHAR(255),
        LastName VARCHAR(255),
        NameStyle INT,
        BirthDate DATE,
        MaritalStatus VARCHAR(255),
        Suffix VARCHAR(255),
        Gender VARCHAR(255),
        EmailAddress VARCHAR(255),
        YearlyIncome INT,
        TotalChildren INT,
        NumberChildrenAtHome INT,
        EnglishEducation VARCHAR(255),
        SpanishEducation VARCHAR(255),
        FrenchEducation VARCHAR(255),
        EnglishOccupation VARCHAR(255),
        SpanishOccupation VARCHAR(255),
        FrenchOccupation VARCHAR(255),
        HouseOwnerFlag INT,
        NumberCarsOwned INT,
        AddressLine1 VARCHAR(255),
        AddressLine2 VARCHAR(255),
        Phone VARCHAR(255),
        DateFirstPurchase DATE,
        CommuteDistance VARCHAR(255)
    );
    create table DimProduct(
        ProductKey INT,
        ProductAlternateKey VARCHAR(255),
        ProductSubcategoryKey VARCHAR(255),
        WeightUnitMeasureCode VARCHAR(255),
        SizeUnitMeasureCode VARCHAR(255),
        ProductName VARCHAR(255),
        StandardCost VARCHAR(255),
        FinishedGoodsFlag INT,
        Color VARCHAR(255),
        SafetyStockLevel INT,
        ReorderPoint INT,
        ListPrice VARCHAR(255),
        Size VARCHAR(255),
        SizeRange VARCHAR(255),
        Weight VARCHAR(255),
        DaysToManufacture INT,
        ProductLine VARCHAR(255),
        DealerPrice VARCHAR(255),
        Class VARCHAR(255),
        Style VARCHAR(255),
        ModelName VARCHAR(255),
        StartDate VARCHAR(255),
        EndDate VARCHAR(255),
        Status VARCHAR(255)
    );

    create table DimSalesTerritory (
        SalesTerritoryKey INT,
        SalesTerritoryAlternateKey INT,
        SalesTerritoryRegion VARCHAR(255),
        SalesTerritoryCountry VARCHAR(255),
        SalesTerritoryGroup VARCHAR(255)

    );
    ``` 
      - Screenshot below references the above shell code (only includes factResellerSales creation)
        ![Alt text](/Screenshots/screenshot-1.png)
        - Check the new Remote database is created in the MySQL instance
        ![Alt text](/Screenshots/screenshot-2.png)
6. Load tables:
    - Download each tab of the assigment google sheet in .csv in your local machine
    - Go to Google Storage 
    ![Alt text](/Screenshots/screenshot-3.png)
    - Upload the .csv files to [Google Storage Buckets]( https://cloud.google.com/storage/docs/uploading-objects)
    ![Alt text](/Screenshots/screenshot-4.png)
    - Go back to to Google SQL>Overview page>Insert
    ![Alt text](/Screenshots/screenshot-5.png)
    - Import the each csv into the correct table inside Remote database (example below FactResellerSales) 
    ![Alt text](/Screenshots/screenshot-6.png)
7. Connect Google BigQuery to Google Cloud SQL [(guide)](https://cloud.google.com/bigquery/docs/connect-to-sql)
    - Go to [IAM](https://cloud.google.com/sql/docs/mysql/users) (Information Access Management) 
    ![Alt text](/Screenshots/screenshot-7.png)
    - Grant your user Cloud SQL admin and user rights
    ![Alt text](/Screenshots/screenshot-8.png)
    ![Alt text](/Screenshots/screenshot-9.png)
    -  Go to BigQuery 
    ![Alt text](/Screenshots/screenshot-10.png)
    - Click on Add>Connections to external data sources
    ![Alt text](/Screenshots/screenshot-11.png)
    ![Alt text](/Screenshots/screenshot-12.png)
    - Configure the external data source connection as shown below:
    ![Alt text](/Screenshots/screenshot-13.png)
    - Now you can start querying the tables!
    ![Alt text](/Screenshots/screenshot-14.png)