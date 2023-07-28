create table factResellerSales(
    ProductKey INT,
    OrderDateKey INT,
    DueDateKey INT,
    ShipDateKey INT,
    ResellerKey INT,
    EmployeeKey INT,
    PromotionKey INT,
    CurrencyKey INT,
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