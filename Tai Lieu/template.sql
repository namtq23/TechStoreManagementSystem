-- 1. Roles – Branch Manager/Sale/Warehouse Manager 
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY,
    RoleName NVARCHAR(50)
);

-- 2. Branches
CREATE TABLE Branches (
    BranchID INT PRIMARY KEY IDENTITY(1,1),
    BranchName NVARCHAR(100),
    Address NVARCHAR(255),
    Phone NVARCHAR(20),
    IsActive BIT
);



-- 8. Warehouse
CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY IDENTITY(1,1),
    WarehouseName NVARCHAR(100),
    Address NVARCHAR(255),
	Phone NVARCHAR(25),
	IsActive BIT
);


-- 3. Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY (1,1),
    PasswordHash NVARCHAR(255),
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    BranchID INT NULL, -- NULL nếu không liên quan đến chi nhánh
    WarehouseID INT NULL, -- NULL nếu không quản lý kho, tham chiếu tới kho duy nhất
    RoleID INT,
    IsActive BIT,
	Gender BIT NULL,
	AvaUrl NVARCHAR(MAX),
	Address NVARCHAR(MAX),
	TaxNumber NVARCHAR(MAX) NULL,
	WebURL NVARCHAR(MAX) NULL,
	DOB DATETIME NULL,
	IdentificationID NVARCHAR(25) NULL,
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
);


-- 4. Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100)
);

-- 5. Suppliers
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName NVARCHAR(100) NOT NULL,
    ContactName NVARCHAR(100),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME
);

-- 6. Brands
CREATE TABLE Brands (
    BrandID INT PRIMARY KEY IDENTITY(1,1),
    BrandName NVARCHAR(100) NOT NULL
);

-- 7. Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(255),
    BrandID INT,
    CategoryID INT,
    SupplierID INT,
    CostPrice DECIMAL(18,2),
    RetailPrice DECIMAL(18,2),
    ImageURL NVARCHAR(MAX),
	VAT DECIMAL(18,2),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    IsActive BIT,
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- 7.1
CREATE TABLE ProductDetails (
    ProductDetailID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT,
    Description NVARCHAR(MAX), 
    ProductCode NVARCHAR(255), 
    WarrantyPeriod NVARCHAR(50), -- e.g., '1 year', '6 months'
	ProductNameUnsigned NVARCHAR(255),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


CREATE TABLE WarehouseProducts (
    WarehouseID INT,
    ProductDetailID INT,
    Quantity INT,
    PRIMARY KEY (WarehouseID, ProductDetailID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (ProductDetailID) REFERENCES ProductDetails(ProductDetailID)
);

-- 9. Inventory
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT UNIQUE,
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

CREATE TABLE InventoryProducts (
    InventoryID INT,
    ProductDetailID INT,
    Quantity INT, 
    PRIMARY KEY (InventoryID, ProductDetailID),
    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID),
    FOREIGN KEY (ProductDetailID) REFERENCES ProductDetails(ProductDetailID)
);

-- 10. StockMovementsRequest
CREATE TABLE StockMovementsRequest (
    MovementID INT PRIMARY KEY IDENTITY(1,1),
    FromSupplierID INT NULL,
    FromBranchID INT NULL,
	FromWarehouseID INT NULL,
    ToBranchID INT NULL,
	ToWarehouseID INT NULL,
    MovementType NVARCHAR(20) NOT NULL,
    CreatedBy INT NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    Note NVARCHAR(1000) NULL,
    
	FOREIGN KEY (FromWarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (FromSupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (FromBranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (ToBranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- 11. StockMovementResponses
CREATE TABLE StockMovementResponses (
    ResponseID INT PRIMARY KEY IDENTITY(1,1),
    MovementID INT NOT NULL,                            
    ResponsedBy INT NOT NULL,                           
    ResponseAt DATETIME NOT NULL DEFAULT GETDATE(),     
    ResponseStatus NVARCHAR(50) NOT NULL,               
    Note NVARCHAR(1000),                                

    FOREIGN KEY (MovementID) REFERENCES StockMovementsRequest(MovementID),
    FOREIGN KEY (ResponsedBy) REFERENCES Users(UserID)
);

-- 11. StockMovementDetail
CREATE TABLE StockMovementDetail (
    MovementDetailID INT PRIMARY KEY IDENTITY(1,1),
    MovementID INT NOT NULL,                            
    ProductDetailID INT NOT NULL,
    Quantity INT NOT NULL,
	QuantityScanned INT DEFAULT 0,

	FOREIGN KEY (MovementID) REFERENCES StockMovementsRequest(MovementID),
	FOREIGN KEY (ProductDetailID) REFERENCES ProductDetails(ProductDetailID)
);



-- 12. Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL UNIQUE,
    Email NVARCHAR(100),
    Address NVARCHAR(255),
    Gender BIT,
    DateOfBirth DATE,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    UpdatedAt DATETIME
);

-- 13. Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    BranchID INT,
    CreatedBy INT,
    OrderStatus NVARCHAR(50),
    CreatedAt DATETIME,
    CustomerID INT,
    PaymentMethod NVARCHAR(50),
    Notes NVARCHAR(255) NULL,
    GrandTotal DECIMAL(18,2) NOT NULL,

	CustomerPay DECIMAL(18,2), -- Tien khach dua
	Change DECIMAL(18,2),-- Tien thua tra cho khach

    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE ProductDetailSerialNumber (
 ProductDetailID INT,
    SerialNumber NVARCHAR(MAX),
	Status BIT,
	OrderID INT NULL,
	BranchID INT NULL,
	WarehouseID INT NULL,
	MovementDetailID INT NULL,
	MovementHistory NVARCHAR(MAX) NULL,
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductDetailID) REFERENCES ProductDetails(ProductDetailID),
	FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
	FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
	FOREIGN KEY (MovementDetailID) REFERENCES StockMovementDetail(MovementDetailID)
);

-- 14. OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT,
    ProductDetailID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductDetailID) REFERENCES ProductDetails(ProductDetailID)
);

-- 15. Promotions
CREATE TABLE Promotions (
    PromotionID INT PRIMARY KEY IDENTITY(1,1),
    PromoName NVARCHAR(255),
    DiscountPercent DECIMAL(5,2),
    StartDate DATE,
    EndDate DATE,
);

-- 16. PromotionBranches
CREATE TABLE PromotionBranches (
    PromotionID INT,
    BranchID INT,
    PRIMARY KEY (PromotionID, BranchID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- 17. PromotionProducts
CREATE TABLE PromotionProducts (
    PromotionID INT,
    ProductDetailID INT,
    PRIMARY KEY (PromotionID, ProductDetailID),
    FOREIGN KEY (PromotionID) REFERENCES Promotions(PromotionID),
    FOREIGN KEY (ProductDetailID) REFERENCES ProductDetails(ProductDetailID)
);

-- 18. Announcement
CREATE TABLE Announcements (
    AnnouncementID INT PRIMARY KEY IDENTITY(1,1),
    FromUserID INT,
    FromBranchID INT NULL,
	FromWarehouseID INT NULL,
	ToBranchID INT NULL,
	ToWarehouseID INT NULL,
    Title NVARCHAR(50),
    Description NVARCHAR(1000),
    CreatedAt DATETIME,
    FOREIGN KEY (FromUserID) REFERENCES Users(UserID),
    FOREIGN KEY (FromBranchID) REFERENCES Branches(BranchID),
	FOREIGN KEY (ToBranchID) REFERENCES Branches(BranchID),
	FOREIGN KEY (FromWarehouseID) REFERENCES Warehouses(WarehouseID),
	FOREIGN KEY (ToWarehouseID) REFERENCES Warehouses(WarehouseID)
);



-- 21. CashFlows
CREATE TABLE CashFlows (
    CashFlowID INT PRIMARY KEY IDENTITY(1,1),
    FlowType NVARCHAR(20) NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    Category NVARCHAR(100) NOT NULL,
    Description NVARCHAR(1000) NULL,
    PaymentMethod NVARCHAR(50),
    RelatedOrderID INT NULL,
    BranchID INT NULL,
    CreatedBy NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (RelatedOrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

CREATE TABLE PasswordResetTokens (
    id INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expiryDate DATETIME NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES Users(UserID) ON DELETE CASCADE,
    UNIQUE(token)
);

CREATE TABLE Shift (
    ShiftID INT PRIMARY KEY IDENTITY(1,1),
    ShiftName NVARCHAR(50) NOT NULL, -- 
    StartTime TIME NOT NULL,        
    EndTime TIME NOT NULL           
);

CREATE TABLE UserShift (
    UserID INT,
    ShiftID INT,
    PRIMARY KEY (UserID, ShiftID), 
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (ShiftID) REFERENCES Shift(ShiftID) ON DELETE CASCADE
);

INSERT INTO Roles (RoleID, RoleName) VALUES
(0, N'Chủ chuỗi cửa hàng'),
(1, N'Quản Lý Chi Nhánh'),
(2, N'Nhân viên bán hàng'),
(3, N'Quản lý kho');




