-- =================================================================
-- Đảm bảo trong bảng User phải có: 1 shop owner (userId = 1), 2 branch manager, 2 sale, 2 warehouse manager. Tạo khi run web locall. Thì mới chay file db
-- =================================================================

-- Categories
INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, N'Máy tính'),
(2, N'Điện thoại'),
(3, N'Phụ kiện'),
(4, N'Tablet');

-- Suppliers
INSERT INTO Suppliers (SupplierName, ContactName, Phone, Email, CreatedAt) VALUES
(N'Công ty TNHH Apple Việt Nam', N'Nguyễn Văn An', '0901234567', 'apple@vietnam.com', GETDATE()),
(N'Samsung Electronics Việt Nam', N'Trần Thị Bình', '0902345678', 'samsung@vietnam.com', GETDATE()),
(N'Xiaomi Việt Nam', N'Lê Văn Cường', '0903456789', 'xiaomi@vietnam.com', GETDATE()),
(N'Dell Technologies Việt Nam', N'Phạm Thị Dung', '0904567890', 'dell@vietnam.com', GETDATE());

-- Brands
INSERT INTO Brands (BrandName) VALUES
(N'Apple'),
(N'Samsung'),
(N'Xiaomi'),
(N'Dell'),
(N'HP'),
(N'Asus');

-- Products
INSERT INTO Products (ProductName, BrandID, CategoryID, SupplierID, CostPrice, RetailPrice, ImageURL, VAT, IsActive) VALUES
(N'iPhone 15 Pro Max', 1, 2, 1, 25000000, 29990000, 'https://cdn.tgdd.vn/Products/Images/42/305658/iphone-15-pro-max-blue-thumbnew-600x600.jpg', 10.00, 1),
(N'Samsung Galaxy S24 Ultra', 2, 2, 2, 22000000, 26990000, 'https://product.hstatic.net/200000409445/product/10_50219b7dc9a745beb9969bc41d6d435b_master.jpg', 10.00, 1),
(N'Xiaomi 14 Ultra', 3, 2, 3, 18000000, 21990000, 'https://demobile.vn/wp-content/uploads/2024/11/xiaomi-14-ultra-xanh-duong.jpg.webp', 10.00, 1),
(N'Dell XPS 13', 4, 1, 4, 35000000, 42990000, 'https://bizweb.dktcdn.net/thumb/grande/100/512/769/products/dell-xps-13-9340-2-4468b503-5fa5-455e-9b32-37b1944621a2.webp?v=1719892007557', 10.00, 1),
(N'MacBook Air M3', 1, 1, 1, 30000000, 36990000, 'https://ttcenter.com.vn/uploads/photos/1711015691_2705_6abbfd9b5657c5642f77ba67f3eef1bf.webp', 10.00, 1),
(N'AirPods Pro 2nd Gen', 1, 3, 1, 4500000, 5990000, 'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/airpods-pro-2-hero-select-202409_FMT_WHH?wid=750&hei=556&fmt=jpeg&qlt=90&.v=1724041668836', 10.00, 1),
(N'Samsung Galaxy Buds Pro', 2, 3, 2, 3000000, 3990000, 'https://ntstore.com.vn/wp-content/uploads/2021/08/samsung-galaxy-buds-pro-6_1.jpg.webp', 10.00, 1),
(N'iPad Air M2', 1, 4, 1, 15000000, 18990000, 'https://cdn2.cellphones.com.vn/x/media/catalog/product/i/p/ipad-air-6-m2-11-inch_2_1_1_1_1.jpg', 10.00, 1),
(N'Samsung Galaxy Tab S9', 2, 4, 2, 12000000, 15990000, 'https://cdn2.cellphones.com.vn/insecure/rs:fill:0:358/q:90/plain/https://cellphones.com.vn/media/catalog/product/s/a/samsung-galaxy-tab-s9-fe-wifi_3.png', 10.00, 1),
(N'HP Pavilion 15', 5, 1, 4, 15000000, 18990000, 'https://tanphat.com.vn/media/lib/03-10-2023/hp-pavilion-15-sd5.jpg', 10.00, 1);

-- ProductDetails
INSERT INTO ProductDetails (ProductID, Description, ProductCode, WarrantyPeriod, ProductNameUnsigned) VALUES
(1, N'iPhone 15 Pro Max 256GB, chip A17 Pro, màn hình Super Retina XDR 6.7 inch', 'IP15PM256', N'12 tháng', 'iPhone 15 Pro Max 256GB'),
(2, N'Samsung Galaxy S24 Ultra 512GB, S Pen, màn hình Dynamic AMOLED 6.8 inch', 'SGS24U512', N'12 tháng', 'Samsung Galaxy S24 Ultra 512GB'),
(3, N'Xiaomi 14 Ultra 512GB, camera Leica, màn hình LTPO OLED 6.73 inch', 'XM14U512', N'18 tháng', 'Xiaomi 14 Ultra 512GB'),
(4, N'Dell XPS 13 i7 16GB RAM, màn hình InfinityEdge 13.4 inch, CPU Intel Core i7', 'DXPS13I7', N'24 tháng', 'Dell XPS 13 i7 16GB RAM'),
(5, N'MacBook Air 512GB, chip Apple M3, màn hình Liquid Retina 13.6 inch', 'MBAM3512', N'12 tháng', 'MacBook Air M3 512GB'),
(6, N'AirPods Pro 2nd Gen, chip H2, chống ồn chủ động', 'APP2GEN', N'12 tháng', 'AirPods Pro 2nd Gen'),
(7, N'Samsung Galaxy Buds Pro, chống ồn thông minh', 'SGBPRO', N'12 tháng', 'Samsung Galaxy Buds Pro'),
(8, N'iPad Air M2 256GB, chip Apple M2, màn hình Liquid Retina 10.9 inch', 'IPAM2256', N'12 tháng', 'iPad Air M2 256GB'),
(9, N'Samsung Galaxy Tab S9 256GB, S Pen, màn hình Dynamic AMOLED 11 inch', 'SGTS9256', N'12 tháng', 'Samsung Galaxy Tab S9 256GB'),
(10, N'HP Pavilion 15 i5 8GB RAM, CPU Intel Core i5, màn hình 15.6 inch', 'HPP15I5', N'24 tháng', 'HP Pavilion 15 i5 8GB RAM');

-- WarehouseProducts (Tối đa 10 mỗi ProductDetail)
INSERT INTO WarehouseProducts (WarehouseID, ProductDetailID, Quantity) VALUES
(1, 1, 10), (1, 2, 8), (1, 3, 7), (1, 4, 5), (1, 5, 6),
(1, 6, 10), (1, 7, 9), (1, 8, 8), (1, 9, 7), (1, 10, 5),
(2, 1, 8), (2, 2, 6), (2, 3, 5), (2, 4, 4), (2, 5, 5),
(2, 6, 9), (2, 7, 8), (2, 8, 6), (2, 9, 5), (2, 10, 4);

-- InventoryProducts (Tối đa 10 mỗi ProductDetail cho branch 1)
INSERT INTO InventoryProducts (InventoryID, ProductDetailID, Quantity) VALUES
(1, 1, 5), (1, 2, 4), (1, 3, 3), (1, 4, 2), (1, 5, 3),
(1, 6, 10), (1, 7, 8), (1, 8, 4), (1, 9, 3), (1, 10, 2);

-- Tạo SerialNumbers cho sản phẩm trong Warehouse 1
DECLARE @ProductDetailID INT = 1;
WHILE @ProductDetailID <= 10
BEGIN
    DECLARE @WarehouseQty INT;
    SELECT @WarehouseQty = Quantity FROM WarehouseProducts WHERE WarehouseID = 1 AND ProductDetailID = @ProductDetailID;
    
    DECLARE @Counter INT = 1;
    WHILE @Counter <= @WarehouseQty
    BEGIN
        DECLARE @SerialNumber NVARCHAR(MAX);
        DECLARE @ProductCode NVARCHAR(10);
        
        SELECT @ProductCode = ProductCode FROM ProductDetails WHERE ProductDetailID = @ProductDetailID;
        SET @SerialNumber = @ProductCode + 'W1' + RIGHT('000' + CAST(@Counter AS VARCHAR(3)), 3);
        
        INSERT INTO ProductDetailSerialNumber (ProductDetailID, SerialNumber, Status, OrderID, BranchID, WarehouseID, MovementDetailID, MovementHistory)
        VALUES (@ProductDetailID, @SerialNumber, 1, NULL, NULL, 1, NULL, NULL);
        
        SET @Counter = @Counter + 1;
    END;
    
    SET @ProductDetailID = @ProductDetailID + 1;
END;

-- Tạo SerialNumbers cho sản phẩm trong Warehouse 2
SET @ProductDetailID = 1;
WHILE @ProductDetailID <= 10
BEGIN
    DECLARE @WarehouseQty2 INT;
    SELECT @WarehouseQty2 = Quantity FROM WarehouseProducts WHERE WarehouseID = 2 AND ProductDetailID = @ProductDetailID;
    
    DECLARE @Counter2 INT = 1;
    WHILE @Counter2 <= @WarehouseQty2
    BEGIN
        DECLARE @SerialNumber2 NVARCHAR(MAX);
        DECLARE @ProductCode2 NVARCHAR(10);
        
        SELECT @ProductCode2 = ProductCode FROM ProductDetails WHERE ProductDetailID = @ProductDetailID;
        SET @SerialNumber2 = @ProductCode2 + 'W2' + RIGHT('000' + CAST(@Counter2 AS VARCHAR(3)), 3);
        
        INSERT INTO ProductDetailSerialNumber (ProductDetailID, SerialNumber, Status, OrderID, BranchID, WarehouseID, MovementDetailID, MovementHistory)
        VALUES (@ProductDetailID, @SerialNumber2, 1, NULL, NULL, 2, NULL, NULL);
        
        SET @Counter2 = @Counter2 + 1;
    END;
    
    SET @ProductDetailID = @ProductDetailID + 1;
END;

-- Tạo SerialNumbers cho sản phẩm trong Branch 1 Inventory
SET @ProductDetailID = 1;
WHILE @ProductDetailID <= 10
BEGIN
    DECLARE @BranchQty INT;
    SELECT @BranchQty = Quantity FROM InventoryProducts WHERE InventoryID = 1 AND ProductDetailID = @ProductDetailID;
    
    DECLARE @Counter3 INT = 1;
    WHILE @Counter3 <= @BranchQty
    BEGIN
        DECLARE @SerialNumber3 NVARCHAR(MAX);
        DECLARE @ProductCode3 NVARCHAR(10);
        
        SELECT @ProductCode3 = ProductCode FROM ProductDetails WHERE ProductDetailID = @ProductDetailID;
        SET @SerialNumber3 = @ProductCode3 + 'B1' + RIGHT('000' + CAST(@Counter3 AS VARCHAR(3)), 3);
        
        INSERT INTO ProductDetailSerialNumber (ProductDetailID, SerialNumber, Status, OrderID, BranchID, WarehouseID, MovementDetailID, MovementHistory)
        VALUES (@ProductDetailID, @SerialNumber3, 1, NULL, 1, NULL, NULL, NULL);
        
        SET @Counter3 = @Counter3 + 1;
    END;
    
    SET @ProductDetailID = @ProductDetailID + 1;
END;

-- Customers (10 khách hàng)
INSERT INTO Customers (FullName, PhoneNumber, Email, Address, Gender, DateOfBirth) VALUES
(N'Nguyễn Văn An', '0987654001', 'an01@gmail.com', N'Cầu Giấy, Hà Nội', 1, '1990-01-15'),
(N'Trần Thị Bình', '0987654002', 'binh02@gmail.com', N'Đống Đa, Hà Nội', 0, '1985-05-20'),
(N'Lê Văn Cường', '0987654003', 'cuong03@gmail.com', N'Hai Bà Trưng, Hà Nội', 1, '1992-08-10'),
(N'Phạm Thị Dung', '0987654004', 'dung04@gmail.com', N'Hoàn Kiếm, Hà Nội', 0, '1988-12-05'),
(N'Hoàng Văn Em', '0987654005', 'em05@gmail.com', N'Ba Đình, Hà Nội', 1, '1995-03-22'),
(N'Võ Thị Phương', '0987654006', 'phuong06@gmail.com', N'Tây Hồ, Hà Nội', 0, '1993-07-18'),
(N'Đặng Văn Giang', '0987654007', 'giang07@gmail.com', N'Long Biên, Hà Nội', 1, '1987-11-30'),
(N'Bùi Thị Hạnh', '0987654008', 'hanh08@gmail.com', N'Thanh Xuân, Hà Nội', 0, '1991-04-25'),
(N'Trịnh Văn Inh', '0987654009', 'inh09@gmail.com', N'Nam Từ Liêm, Hà Nội', 1, '1989-09-12'),
(N'Lý Thị Kim', '0987654010', 'kim10@gmail.com', N'Bắc Từ Liêm, Hà Nội', 0, '1994-02-28');

-- Generate Orders với SerialNumbers tương ứng THEO ĐÚNG QUANTITY
DECLARE @StartDate DATE = '2025-06-27';
DECLARE @EndDate DATE = '2025-07-27';
DECLARE @CustomerCounter INT = 1;
DECLARE @TotalDays INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;

WHILE @CustomerCounter <= 10
BEGIN
    DECLARE @OrdersPerCustomer INT = FLOOR(RAND() * 2) + 3; -- 3-4 orders
    DECLARE @OrderCounter INT = 1;
    
    WHILE @OrderCounter <= @OrdersPerCustomer
    BEGIN
        DECLARE @RandomDays INT = FLOOR(RAND() * @TotalDays);
        DECLARE @OrderDate DATE = DATEADD(DAY, @RandomDays, @StartDate);
        
        DECLARE @RandomHour INT = FLOOR(RAND() * 10) + 8;
        DECLARE @RandomMinute INT = FLOOR(RAND() * 60);
        DECLARE @OrderDateTime DATETIME = DATEADD(MINUTE, @RandomMinute, 
            DATEADD(HOUR, @RandomHour, CAST(@OrderDate AS DATETIME)));
        
        DECLARE @CreatedBy INT = 5; -- Lo Van D - SALE1
        DECLARE @BranchID INT = 1;
        
        DECLARE @PaymentMethod NVARCHAR(50) = CASE FLOOR(RAND() * 2)
            WHEN 0 THEN N'Tiền mặt'
            ELSE N'Chuyển khoản'
        END;
        
        INSERT INTO Orders (BranchID, CreatedBy, OrderStatus, CreatedAt, CustomerID, PaymentMethod, Notes, GrandTotal, CustomerPay, Change)
        VALUES (@BranchID, @CreatedBy, N'Hoàn thành', @OrderDateTime, @CustomerCounter, @PaymentMethod, N'Đơn hàng bán lẻ', 0, 0, 0);
        
        DECLARE @OrderID INT = SCOPE_IDENTITY();
        DECLARE @GrandTotal DECIMAL(18,2) = 0;
        
        -- Mỗi order có 3 sản phẩm với serial numbers
        DECLARE @ProductCounter INT = 1;
        DECLARE @UsedProducts TABLE (ProductDetailID INT);
        
        WHILE @ProductCounter <= 3
        BEGIN
            DECLARE @SelectedProductDetailID INT;
            
            REPEAT:
            SET @SelectedProductDetailID = FLOOR(RAND() * 10) + 1;
            
            IF EXISTS (SELECT 1 FROM @UsedProducts WHERE ProductDetailID = @SelectedProductDetailID)
                GOTO REPEAT;
            
            INSERT INTO @UsedProducts VALUES (@SelectedProductDetailID);
            
            DECLARE @Quantity INT = 3;
            
            DECLARE @ProductPrice DECIMAL(18,2);
            SELECT @ProductPrice = p.RetailPrice 
            FROM Products p 
            INNER JOIN ProductDetails pd ON p.ProductID = pd.ProductID 
            WHERE pd.ProductDetailID = @SelectedProductDetailID;
            
            INSERT INTO OrderDetails (OrderID, ProductDetailID, Quantity)
            VALUES (@OrderID, @SelectedProductDetailID, @Quantity);
            
            -- SỬA LẠI: Cập nhật SerialNumbers theo đúng QUANTITY (3 serial numbers cho mỗi sản phẩm)
            DECLARE @UpdatedFromBranch INT = 0;
            DECLARE @UpdatedFromWarehouse1 INT = 0;
            DECLARE @UpdatedFromWarehouse2 INT = 0;
            
            -- Lấy từ Branch trước
            UPDATE TOP(@Quantity) ProductDetailSerialNumber 
            SET OrderID = @OrderID, Status = 0
            WHERE ProductDetailID = @SelectedProductDetailID 
            AND BranchID = 1 
            AND OrderID IS NULL
            AND Status = 1;
            
            SET @UpdatedFromBranch = @@ROWCOUNT;
            DECLARE @RemainingQty INT = @Quantity - @UpdatedFromBranch;
            
            -- Nếu không đủ từ Branch, lấy từ Warehouse 1
            IF @RemainingQty > 0
            BEGIN
                UPDATE TOP(@RemainingQty) ProductDetailSerialNumber 
                SET OrderID = @OrderID, Status = 0, BranchID = 1, WarehouseID = NULL
                WHERE ProductDetailID = @SelectedProductDetailID 
                AND WarehouseID = 1 
                AND OrderID IS NULL
                AND Status = 1;
                
                SET @UpdatedFromWarehouse1 = @@ROWCOUNT;
                SET @RemainingQty = @RemainingQty - @UpdatedFromWarehouse1;
            END
            
            -- Nếu vẫn không đủ, lấy từ Warehouse 2
            IF @RemainingQty > 0
            BEGIN
                UPDATE TOP(@RemainingQty) ProductDetailSerialNumber 
                SET OrderID = @OrderID, Status = 0, BranchID = 1, WarehouseID = NULL
                WHERE ProductDetailID = @SelectedProductDetailID 
                AND WarehouseID = 2 
                AND OrderID IS NULL
                AND Status = 1;
                
                SET @UpdatedFromWarehouse2 = @@ROWCOUNT;
            END
            
            SET @GrandTotal = @GrandTotal + (@ProductPrice * @Quantity);
            SET @ProductCounter = @ProductCounter + 1;
        END;
        
        DELETE FROM @UsedProducts;
        
        DECLARE @CustomerPay DECIMAL(18,2) = @GrandTotal + FLOOR(RAND() * 500000);
        DECLARE @Change DECIMAL(18,2) = @CustomerPay - @GrandTotal;
        
        UPDATE Orders 
        SET GrandTotal = @GrandTotal, CustomerPay = @CustomerPay, Change = @Change
        WHERE OrderID = @OrderID;
        
        SET @OrderCounter = @OrderCounter + 1;
    END;
    
    SET @CustomerCounter = @CustomerCounter + 1;
END;

-- Promotions
INSERT INTO Promotions (PromoName, DiscountPercent, StartDate, EndDate) VALUES
(N'Khuyến mãi tháng 7', 10.00, '2025-07-01', '2025-07-31'),
(N'Giảm giá Back to School', 15.00, '2025-08-01', '2025-08-31'),
(N'Flash Sale cuối tuần', 20.00, '2025-07-26', '2025-07-28'),
(N'Khuyến mãi sản phẩm Apple', 8.00, '2025-07-15', '2025-08-15');

-- PromotionProducts
INSERT INTO PromotionProducts (PromotionID, ProductDetailID) VALUES
(1, 1), (1, 2), (1, 3), (1, 6), (1, 7),
(2, 4), (2, 5), (2, 10),
(3, 8), (3, 9),
(4, 1), (4, 5), (4, 6), (4, 8);

-- CashFlows - INCOME from all Orders
INSERT INTO CashFlows (FlowType, Amount, Category, Description, PaymentMethod, RelatedOrderID, BranchID, CreatedBy, CreatedAt)
SELECT 
    'INCOME' as FlowType,
    o.GrandTotal as Amount,
    N'Doanh thu bán hàng' as Category,
    CONCAT(N'Thu tiền từ đơn hàng #', o.OrderID) as Description,
    o.PaymentMethod,
    o.OrderID as RelatedOrderID,
    o.BranchID,
    u.FullName as CreatedBy,
    o.CreatedAt
FROM Orders o
INNER JOIN Users u ON o.CreatedBy = u.UserID
WHERE u.RoleID = 2;

-- CashFlows - OUTCOME (10 records)
DECLARE @OutcomeDate DATE = '2025-06-27';
DECLARE @OutcomeCounter INT = 1;

WHILE @OutcomeCounter <= 10
BEGIN
    DECLARE @OutcomeAmount DECIMAL(18,2) = (FLOOR(RAND() * 3000000) + 500000);
    DECLARE @OutcomeCategory NVARCHAR(100) = CASE FLOOR(RAND() * 4)
        WHEN 0 THEN N'Chi phí vận hành'
        WHEN 1 THEN N'Tiền thuê mặt bằng'
        WHEN 2 THEN N'Lương nhân viên'
        ELSE N'Chi phí marketing'
    END;
    
    DECLARE @OutcomePaymentMethod NVARCHAR(50) = CASE FLOOR(RAND() * 2)
        WHEN 0 THEN N'Tiền mặt'
        ELSE N'Chuyển khoản'
    END;
    
    DECLARE @OutcomeTime DATETIME = DATEADD(DAY, FLOOR(RAND() * 31), 
        CAST(@OutcomeDate AS DATETIME));
    
    INSERT INTO CashFlows (FlowType, Amount, Category, Description, PaymentMethod, RelatedOrderID, BranchID, CreatedBy, CreatedAt)
    VALUES (
        'OUTCOME',
        @OutcomeAmount,
        @OutcomeCategory,
        CONCAT(N'Chi phí ', @OutcomeCategory),
        @OutcomePaymentMethod,
        NULL,
        1,
        N'Nguyễn Văn C',
        @OutcomeTime
    );
    
    SET @OutcomeCounter = @OutcomeCounter + 1;
END;

-- Shift
INSERT INTO Shift (ShiftName, StartTime, EndTime) VALUES
(N'Ca sáng', '08:00:00', '12:00:00'),
(N'Ca chiều', '13:00:00', '17:00:00'),
(N'Ca tối', '18:00:00', '22:00:00');

-- UserShift
INSERT INTO UserShift (UserID, ShiftID) VALUES
(5, 1), (5, 2);



PRINT N'Đã xóa và insert lại dữ liệu thành công! SerialNumbers đã được cập nhật đúng theo Quantity!';
