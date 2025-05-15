CREATE DATABASE TechStore;
GO

USE TechStore;
GO

-- 1. Roles
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY,
    RoleName NVARCHAR(100) NOT NULL
);

-- 3. Branches
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY IDENTITY,
    BranchName NVARCHAR(255),
    Address NVARCHAR(255),
    Phone NVARCHAR(20),
    ManagerID INT
);

-- 2. Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(255),
    Username NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    RoleID INT,
    BranchID INT,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);



-- 4. Product Categories
CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY IDENTITY,
    CategoryName NVARCHAR(100),
    Description NVARCHAR(255)
);

-- 19. Suppliers
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY,
    SupplierName NVARCHAR(255),
    ContactName NVARCHAR(255),
    Phone NVARCHAR(50),
    Email NVARCHAR(100),
    Address NVARCHAR(255)
);

-- 5. Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY,
    ProductName NVARCHAR(255),
    CategoryID INT,
    SupplierID INT NOT NULL,
    Price DECIMAL(18, 2),
    Description NVARCHAR(MAX),
    WarrantyMonths INT,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CategoryID) REFERENCES ProductCategories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


-- 6. Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(255),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 7. Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY,
    CustomerID INT,
    UserID INT,
    BranchID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18, 2),
    OrderStatus VARCHAR(20) CHECK (OrderStatus IN ('Pending Confirmation', 'Packing', 'Delivering', 'Delivered')),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);


-- 8. OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    Discount DECIMAL(5,2),
    Total AS (Quantity * UnitPrice * (1 - Discount / 100)),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 11. Shifts
CREATE TABLE Shifts (
    ShiftID INT PRIMARY KEY IDENTITY,
    BranchID INT,
    StartTime DATETIME,
    EndTime DATETIME,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 9. Invoices
CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY IDENTITY,
    OrderID INT,
    IssuedBy INT,
    IssuedDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18,2),
    ShiftID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (IssuedBy) REFERENCES Users(UserID),
    FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID)
);

-- 10. InvoiceDetails
CREATE TABLE InvoiceDetails (
    InvoiceDetailID INT PRIMARY KEY IDENTITY,
    InvoiceID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    Discount DECIMAL(5,2),
    Total AS (Quantity * UnitPrice * (1 - Discount / 100)),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);



-- 12. ShiftReports
CREATE TABLE ShiftReports (
    ShiftReportID INT PRIMARY KEY IDENTITY,
    ShiftID INT,
    UserID INT,
    ReportDate DATE,
    OpeningAmount DECIMAL(18,2),
    ClosingAmount DECIMAL(18,2),
    TotalSales DECIMAL(18,2),
    TotalInvoices INT,
    FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 13. Inventory
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY,
    ProductID INT,
    BranchID INT,
    Quantity INT,
    LastUpdated DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 14. Promotions
CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    Description NVARCHAR(MAX),
    Type NVARCHAR(50)
);

-- 15. PromotionProducts
CREATE TABLE PromotionProducts (
    PromotionProductID INT PRIMARY KEY IDENTITY,
    PromotionID INT,
    ProductID INT,
    DiscountRate DECIMAL(5,2),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 16. ImportRequests
CREATE TABLE ImportRequests (
    ImportRequestID INT PRIMARY KEY IDENTITY,
    CreatedBy INT,
    BranchID INT,
    CreatedDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 17. ImportRequestDetails
CREATE TABLE ImportRequestDetails (
    ImportRequestDetailID INT PRIMARY KEY IDENTITY,
    ImportRequestID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    FOREIGN KEY (ImportRequestID) REFERENCES ImportRequests(ImportRequestID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 18. Returns
CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY IDENTITY,
    InvoiceID INT,
    ProductID INT,
    Quantity INT,
    ReturnDate DATETIME DEFAULT GETDATE(),
    Reason NVARCHAR(255),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- 20. ActivityLogs
CREATE TABLE ActivityLogs (
    LogID INT PRIMARY KEY IDENTITY,
    UserID INT,
	OrderID INT,
    BranchID INT,
    ActionType VARCHAR(50), -- 'Create Order', 'Update Order Status', 'Import Request'
    TargetEntityID INT,     -- ID of Order or ImportRequest
    EntityType VARCHAR(20), -- 'Order' or 'ImportRequest'
    ActionDescription NVARCHAR(MAX),
    Timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);