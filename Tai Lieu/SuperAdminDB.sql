USE master
GO

CREATE DATABASE SuperAdminDB
GO

USE SuperAdminDB

-- Create SuperAdmin table
CREATE TABLE SuperAdmin (
    AdminID INT PRIMARY KEY IDENTITY(1,1),
    Password NVARCHAR(100) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    UserName NVARCHAR(100) NOT NULL UNIQUE,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- Create ShopOwner table
CREATE TABLE ShopOwner (
    OwnerID INT PRIMARY KEY IDENTITY(1,1),
    AdminID INT NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
	FullNameUnsigned NVARCHAR(100) NOT NULL,
    ShopName NVARCHAR(100) NOT NULL,
    DatabaseName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    IdentificationID NVARCHAR(25) NULL,
	Phone NVARCHAR(25) NULL,
    Gender NVARCHAR(25),
    Address NVARCHAR(255),
	TaxNumber NVARCHAR(MAX) NULL,
	WebURL NVARCHAR(MAX) NULL,
	DOB DATETIME NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_ShopOwner_SuperAdmin FOREIGN KEY (AdminID) REFERENCES SuperAdmin(AdminID) ON DELETE CASCADE
);


CREATE TABLE ServiceMethod (
    MethodID INT PRIMARY KEY IDENTITY(1,1),
    MethodName NVARCHAR(100) NOT NULL,
);

CREATE TABLE ServiceMethodPrice (
    MethodID INT,
    SubscriptionMonths INT,
	Price DECIMAL(18,2),
	FOREIGN KEY (MethodID) REFERENCES ServiceMethod (MethodID)
);

CREATE TABLE UserServiceMethod (
    OwnerID INT,
    MethodID INT,
    PRIMARY KEY (OwnerID , MethodID),

    TrialStartDate DATETIME DEFAULT GETDATE(),
	TrialEndDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) DEFAULT 'TRIAL',
    SubscriptionMonths INT DEFAULT 0,
    SubscriptionStart DATETIME NULL,
    SubscriptionEnd DATETIME NULL,

    FOREIGN KEY (OwnerID) REFERENCES ShopOwner(OwnerID),
    FOREIGN KEY (MethodID) REFERENCES ServiceMethod (MethodID)
);

CREATE TABLE SubscriptionLogs (
	LogID INT PRIMARY KEY IDENTITY(1,1),
    OwnerID INT,
    MethodID INT,
	SubscriptionMonths INT DEFAULT 0,
	Status NVARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (OwnerID) REFERENCES ShopOwner(OwnerID),
    FOREIGN KEY (MethodID) REFERENCES ServiceMethod (MethodID)
);


CREATE TABLE PasswordResetTokens (
    id INT PRIMARY KEY IDENTITY(1,1),
    userId INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expiryDate DATETIME NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY (userId) REFERENCES ShopOwner(OwnerID) ON DELETE CASCADE,
    UNIQUE(token)
);



INSERT INTO SuperAdmin (Password, FullName, UserName)
VALUES (N'123', N'Admin', N'admin');


INSERT INTO ServiceMethod (MethodName)
VALUES (N'Quản Lý Chuỗi Cửa Hàng');

INSERT INTO ServiceMethodPrice (MethodID, SubscriptionMonths, Price) VALUES
(1, 3, 700000.00),
(1, 6, 1200000.00),
(1, 12, 2000000.00),
(1, 24, 3700000.00);

 
