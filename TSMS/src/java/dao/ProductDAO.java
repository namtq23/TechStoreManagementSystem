/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProductDTO;
import model.ProductStatsDTO;
import model.PromotionDTO;
import model.SalesStatisticsDTO;
import model.SalesTransactionDTO;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class ProductDAO {

    //Phuong
    public List<ProductDTO> getInventoryProductListByPageByBranchId(String dbName, int branchId, int offset, int limit) {
        List<ProductDTO> list = new ArrayList<>();
        String sql = """
                     SELECT 
                         i.InventoryID,
                         p.ProductID,
                         ip.ProductDetailID,
                         ip.Quantity AS InventoryQuantity,
                         p.ProductName,
                         b.BrandName,
                         c.CategoryName,
                         s.SupplierName,
                         p.CostPrice,
                         p.RetailPrice,
                         p.ImageURL,
                         CASE WHEN p.IsActive = 1 THEN N'\u0110ang kinh doanh' ELSE N'Kh\u00f4ng kinh doanh' END AS Status,
                         pd.Description,
                         pd.SerialNumber,
                         pd.WarrantyPeriod,
                         p.CreatedAt
                     FROM 
                         Inventory i
                         LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID
                         LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
                         LEFT JOIN Products p ON pd.ProductID = p.ProductID
                         LEFT JOIN Brands b ON p.BrandID = b.BrandID
                         LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                         LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
                     WHERE 
                         i.InventoryID = ?
                     ORDER BY
                         ip.ProductDetailID 
                     OFFSET ? ROWS
                     FETCH NEXT ? ROWS ONLY;
                     """;
        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductDTO product = extractProductDTOFromResultSet(rs);
                list.add(product);
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }

    //Phuong
    public int countProductsByBranchId(String dbName, int branchId) {
        int count = 0;
        String sql = """
                     SELECT 
                         InventoryID,
                         COUNT(DISTINCT ProductDetailID) AS ProductCount
                     FROM 
                         InventoryProducts
                     WHERE 
                        InventoryID = ?
                     GROUP BY 
                         InventoryID;""";
        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("ProductCount");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return count;
    }

//    lay danh sach hang hoa 
    public List<ProductDTO> getWarehouseProductList(String dbName, int warehouseId) throws SQLException {
        List<ProductDTO> products = new ArrayList<>();

        String sql = """
        SELECT 
            wp.WarehouseID,
            p.ProductID,
            pd.ProductDetailID,
            wp.Quantity AS InventoryQuantity,
            p.ProductName,
            b.BrandName,
            c.CategoryName,
            s.SupplierName,
            p.CostPrice,
            p.RetailPrice,
            p.ImageURL,
            CASE WHEN p.IsActive = 1 THEN N'Đang kinh doanh' ELSE N'Không kinh doanh' END AS Status,
            pd.Description,
            pd.SerialNumber,
            pd.WarrantyPeriod,
            p.CreatedAt
        FROM 
            WarehouseProducts wp
            LEFT JOIN ProductDetails pd ON wp.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            LEFT JOIN Brands b ON p.BrandID = b.BrandID
            LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
            LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
        WHERE 
            wp.WarehouseID = ?
    """;
        try (
                  Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement statement = conn.prepareStatement(sql)) {
            statement.setInt(1, warehouseId);

            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                ProductDTO product = new ProductDTO(
                          rs.getInt("ProductDetailId"),
                          rs.getInt("InventoryQuantity"),
                          rs.getString("Description"),
                          rs.getString("SerialNumber"),
                          rs.getString("WarrantyPeriod"),
                          rs.getInt("ProductID"),
                          rs.getString("ProductName"),
                          rs.getString("BrandName"),
                          rs.getString("CategoryName"),
                          rs.getString("SupplierName"),
                          rs.getString("CostPrice"),
                          rs.getString("RetailPrice"),
                          rs.getString("ImageURL"),
                          rs.getDate("CreatedAt"),
                          rs.getString("Status")
                );

                products.add(product);
            }

        } catch (Exception e) {
            System.out.println("Error loading warehouse products: " + e.getMessage());
        }

        return products;
    }

    private static ProductDTO extractProductDTOFromResultSet(ResultSet rs) throws SQLException {
        ProductDTO productDTO = new ProductDTO(
                  rs.getInt("ProductDetailId"),
                  rs.getInt("InventoryQuantity"),
                  rs.getString("Description"),
                  rs.getString("SerialNumber"),
                  rs.getString("WarrantyPeriod"),
                  rs.getInt("ProductID"),
                  rs.getString("ProductName"),
                  rs.getString("BrandName"),
                  rs.getString("CategoryName"),
                  rs.getString("SupplierName"),
                  rs.getString("CostPrice"),
                  rs.getString("RetailPrice"),
                  rs.getString("ImageURL"),
                  rs.getDate("CreatedAt"),
                  rs.getString("Status")
        );
        return productDTO;
    }
    /*
      Lấy thống kê bán hàng của nhân viên trong tháng hiện tại
     */
    public SalesStatisticsDTO getSalesStatisticsByUser(String dbName, int userId) throws SQLException {
        String sql = """
            SELECT 
                u.UserID,
                u.FullName,
                ISNULL(SUM(o.GrandTotal), 0) as CurrentMonthSales,
                200000000 as SalesTarget,
                COUNT(DISTINCT o.OrderID) as OrdersCount,
                COUNT(DISTINCT o.CustomerID) as CustomersServed
            FROM Users u
            LEFT JOIN Orders o ON u.UserID = o.CreatedBy 
                AND MONTH(o.CreatedAt) = MONTH(GETDATE()) 
                AND YEAR(o.CreatedAt) = YEAR(GETDATE())
                AND o.OrderStatus = 'Completed'
            WHERE u.UserID = ? AND u.RoleID = 2
            GROUP BY u.UserID, u.FullName
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new SalesStatisticsDTO(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getBigDecimal("CurrentMonthSales"),
                        rs.getBigDecimal("SalesTarget"),
                        rs.getInt("OrdersCount"),
                        rs.getInt("CustomersServed")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getSalesStatisticsByUser: " + e.getMessage());
            throw e;
        }
        return null;
    }
    
    /*
      Lấy danh sách giao dịch của nhân viên
     */
    public List<SalesTransactionDTO> getTransactionsByUser(String dbName, int userId) throws SQLException {
        List<SalesTransactionDTO> transactions = new ArrayList<>();
        
        String sql = """
            SELECT 
                o.OrderID,
                c.FullName as CustomerName,
                c.PhoneNumber as CustomerPhone,
                STRING_AGG(p.ProductName, ', ') as ProductNames,
                o.GrandTotal,
                o.CreatedAt,
                o.OrderStatus,
                o.PaymentMethod,
                o.Notes
            FROM Orders o
            LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            WHERE o.CreatedBy = ?
            GROUP BY o.OrderID, c.FullName, c.PhoneNumber, o.GrandTotal, 
                     o.CreatedAt, o.OrderStatus, o.PaymentMethod, o.Notes
            ORDER BY o.CreatedAt DESC
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SalesTransactionDTO transaction = new SalesTransactionDTO(
                        rs.getInt("OrderID"),
                        rs.getString("CustomerName"),
                        rs.getString("CustomerPhone"),
                        rs.getString("ProductNames"),
                        rs.getBigDecimal("GrandTotal"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OrderStatus"),
                        rs.getString("PaymentMethod")
                    );
                    transaction.setNotes(rs.getString("Notes"));
                    transactions.add(transaction);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getTransactionsByUser: " + e.getMessage());
            throw e;
        }
        
        return transactions;
    }
    
    /*
      Tìm kiếm giao dịch theo từ khóa
     */
    public List<SalesTransactionDTO> searchTransactionsByUser(String dbName, int userId, String keyword) throws SQLException {
        List<SalesTransactionDTO> transactions = new ArrayList<>();
        
        String sql = """
            SELECT 
                o.OrderID,
                c.FullName as CustomerName,
                c.PhoneNumber as CustomerPhone,
                STRING_AGG(p.ProductName, ', ') as ProductNames,
                o.GrandTotal,
                o.CreatedAt,
                o.OrderStatus,
                o.PaymentMethod,
                o.Notes
            FROM Orders o
            LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            WHERE o.CreatedBy = ? 
                AND (c.FullName LIKE ? OR c.PhoneNumber LIKE ? OR CAST(o.OrderID as NVARCHAR) LIKE ?)
            GROUP BY o.OrderID, c.FullName, c.PhoneNumber, o.GrandTotal, 
                     o.CreatedAt, o.OrderStatus, o.PaymentMethod, o.Notes
            ORDER BY o.CreatedAt DESC
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setInt(1, userId);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SalesTransactionDTO transaction = new SalesTransactionDTO(
                        rs.getInt("OrderID"),
                        rs.getString("CustomerName"),
                        rs.getString("CustomerPhone"),
                        rs.getString("ProductNames"),
                        rs.getBigDecimal("GrandTotal"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("OrderStatus"),
                        rs.getString("PaymentMethod")
                    );
                    transaction.setNotes(rs.getString("Notes"));
                    transactions.add(transaction);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in searchTransactionsByUser: " + e.getMessage());
            throw e;
        }
        
        return transactions;
    }
    
    /*
      Lấy danh sách khuyến mãi đang áp dụng cho chi nhánh
     */
    public List<PromotionDTO> getActivePromotionsByBranch(String dbName, int branchId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();
        
        String sql = """
            SELECT DISTINCT
                p.PromotionID,
                p.PromoName,
                p.DiscountPercent,
                p.StartDate,
                p.EndDate,
                p.ApplyToAllBranches
            FROM Promotions p
            LEFT JOIN PromotionBranches pb ON p.PromotionID = pb.PromotionID
            WHERE (p.ApplyToAllBranches = 1 OR pb.BranchID = ?)
                AND GETDATE() BETWEEN p.StartDate AND p.EndDate
            ORDER BY p.StartDate DESC
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, branchId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PromotionDTO promotion = new PromotionDTO(
                        rs.getInt("PromotionID"),
                        rs.getString("PromoName"),
                        rs.getBigDecimal("DiscountPercent"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate"),
                        rs.getBoolean("ApplyToAllBranches")
                    );
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getActivePromotionsByBranch: " + e.getMessage());
            throw e;
        }
        
        return promotions;
    }

    /*
      Lấy tất cả khuyến mãi cho chi nhánh (bao gồm cả hết hạn và chưa áp dụng)
     */
    public List<PromotionDTO> getAllPromotionsByBranch(String dbName, int branchId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();
        
        String sql = """
            SELECT DISTINCT
                p.PromotionID,
                p.PromoName,
                p.DiscountPercent,
                p.StartDate,
                p.EndDate,
                p.ApplyToAllBranches
            FROM Promotions p
            LEFT JOIN PromotionBranches pb ON p.PromotionID = pb.PromotionID
            WHERE (p.ApplyToAllBranches = 1 OR pb.BranchID = ?)
            ORDER BY p.StartDate DESC
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, branchId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PromotionDTO promotion = new PromotionDTO(
                        rs.getInt("PromotionID"),
                        rs.getString("PromoName"),
                        rs.getBigDecimal("DiscountPercent"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate"),
                        rs.getBoolean("ApplyToAllBranches")
                    );
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllPromotionsByBranch: " + e.getMessage());
            throw e;
        }
        
        return promotions;
    }
    
    /*
      Lấy khuyến mãi áp dụng cho sản phẩm cụ thể
     */
    public List<PromotionDTO> getPromotionsByProduct(String dbName, int productId, int branchId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();
        
        String sql = """
            SELECT DISTINCT
                p.PromotionID,
                p.PromoName,
                p.DiscountPercent,
                p.StartDate,
                p.EndDate,
                p.ApplyToAllBranches
            FROM Promotions p
            LEFT JOIN PromotionBranches pb ON p.PromotionID = pb.PromotionID
            LEFT JOIN PromotionProducts pp ON p.PromotionID = pp.PromotionID
            WHERE (p.ApplyToAllBranches = 1 OR pb.BranchID = ?)
                AND pp.ProductID = ?
                AND GETDATE() BETWEEN p.StartDate AND p.EndDate
            ORDER BY p.DiscountPercent DESC
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, branchId);
            stmt.setInt(2, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PromotionDTO promotion = new PromotionDTO(
                        rs.getInt("PromotionID"),
                        rs.getString("PromoName"),
                        rs.getBigDecimal("DiscountPercent"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate"),
                        rs.getBoolean("ApplyToAllBranches")
                    );
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getPromotionsByProduct: " + e.getMessage());
            throw e;
        }
        
        return promotions;
    }

    /*
      Lấy sản phẩm theo ID
     */
    public ProductDTO getProductById(String dbName, int productId) throws SQLException {
        String sql = """
            SELECT 
                pd.ProductDetailID,
                ISNULL(ip.Quantity, 0) AS InventoryQuantity,
                pd.Description,
                pd.SerialNumber,
                pd.WarrantyPeriod,
                p.ProductID,
                p.ProductName,
                b.BrandName,
                c.CategoryName,
                s.SupplierName,
                p.CostPrice,
                p.RetailPrice,
                p.ImageURL,
                p.CreatedAt,
                CASE WHEN p.IsActive = 1 THEN N'Đang kinh doanh' ELSE N'Không kinh doanh' END AS Status
            FROM Products p
            LEFT JOIN ProductDetails pd ON p.ProductID = pd.ProductID
            LEFT JOIN InventoryProducts ip ON pd.ProductDetailID = ip.ProductDetailID
            LEFT JOIN Brands b ON p.BrandID = b.BrandID
            LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
            LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
            WHERE p.ProductID = ?
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractProductDTOFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getProductById: " + e.getMessage());
            throw e;
        }
        
        return null;
    }

    /*
     Tìm kiếm sản phẩm theo tên hoặc mã
     */
    public List<ProductDTO> searchProducts(String dbName, int branchId, String keyword) throws SQLException {
        List<ProductDTO> products = new ArrayList<>();
        
        String sql = """
            SELECT 
                i.InventoryID,
                p.ProductID,
                ip.ProductDetailID,
                ip.Quantity AS InventoryQuantity,
                p.ProductName,
                b.BrandName,
                c.CategoryName,
                s.SupplierName,
                p.CostPrice,
                p.RetailPrice,
                p.ImageURL,
                CASE WHEN p.IsActive = 1 THEN N'Đang kinh doanh' ELSE N'Không kinh doanh' END AS Status,
                pd.Description,
                pd.SerialNumber,
                pd.WarrantyPeriod,
                p.CreatedAt
            FROM 
                Inventory i
                LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID
                LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
                LEFT JOIN Products p ON pd.ProductID = p.ProductID
                LEFT JOIN Brands b ON p.BrandID = b.BrandID
                LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
            WHERE 
                i.InventoryID = ?
                AND (p.ProductName LIKE ? OR CAST(p.ProductID as NVARCHAR) LIKE ?)
            ORDER BY p.ProductName
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setInt(1, branchId);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductDTO product = extractProductDTOFromResultSet(rs);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in searchProducts: " + e.getMessage());
            throw e;
        }
        
        return products;
    }

    /*
      Lấy sản phẩm theo danh mục
     */
    public List<ProductDTO> getProductsByCategory(String dbName, int branchId, String categoryName) throws SQLException {
        List<ProductDTO> products = new ArrayList<>();
        
        String sql = """
            SELECT 
                i.InventoryID,
                p.ProductID,
                ip.ProductDetailID,
                ip.Quantity AS InventoryQuantity,
                p.ProductName,
                b.BrandName,
                c.CategoryName,
                s.SupplierName,
                p.CostPrice,
                p.RetailPrice,
                p.ImageURL,
                CASE WHEN p.IsActive = 1 THEN N'Đang kinh doanh' ELSE N'Không kinh doanh' END AS Status,
                pd.Description,
                pd.SerialNumber,
                pd.WarrantyPeriod,
                p.CreatedAt
            FROM 
                Inventory i
                LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID
                LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
                LEFT JOIN Products p ON pd.ProductID = p.ProductID
                LEFT JOIN Brands b ON p.BrandID = b.BrandID
                LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
            WHERE 
                i.InventoryID = ?
                AND c.CategoryName LIKE ?
            ORDER BY p.ProductName
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, branchId);
            stmt.setString(2, "%" + categoryName + "%");
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductDTO product = extractProductDTOFromResultSet(rs);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getProductsByCategory: " + e.getMessage());
            throw e;
        }
        
        return products;
    }

    /*
      Lấy sản phẩm theo trạng thái tồn kho
     */
    public List<ProductDTO> getProductsByStockStatus(String dbName, int branchId, String stockStatus) throws SQLException {
        List<ProductDTO> products = new ArrayList<>();
        
        String sql = """
            SELECT 
                i.InventoryID,
                p.ProductID,
                ip.ProductDetailID,
                ip.Quantity AS InventoryQuantity,
                p.ProductName,
                b.BrandName,
                c.CategoryName,
                s.SupplierName,
                p.CostPrice,
                p.RetailPrice,
                p.ImageURL,
                CASE WHEN p.IsActive = 1 THEN N'Đang kinh doanh' ELSE N'Không kinh doanh' END AS Status,
                pd.Description,
                pd.SerialNumber,
                pd.WarrantyPeriod,
                p.CreatedAt
            FROM 
                Inventory i
                LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID
                LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
                LEFT JOIN Products p ON pd.ProductID = p.ProductID
                LEFT JOIN Brands b ON p.BrandID = b.BrandID
                LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
            WHERE 
                i.InventoryID = ?
        """;
        
        // Thêm điều kiện WHERE dựa trên stockStatus
        switch (stockStatus.toLowerCase()) {
            case "below":
                sql += " AND ip.Quantity > 0 AND ip.Quantity < 10";
                break;
            case "above":
                sql += " AND ip.Quantity >= 20";
                break;
            case "in-stock":
                sql += " AND ip.Quantity > 0";
                break;
            case "out-stock":
                sql += " AND (ip.Quantity IS NULL OR ip.Quantity <= 0)";
                break;
            default:
                // "all" - không thêm điều kiện
                break;
        }
        
        sql += " ORDER BY p.ProductName";
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, branchId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductDTO product = extractProductDTOFromResultSet(rs);
                    products.add(product);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getProductsByStockStatus: " + e.getMessage());
            throw e;
        }
        
        return products;
    }

    /*
      Lấy thống kê tổng quan về sản phẩm
     */
    public ProductStatsDTO getProductStats(String dbName, int branchId) throws SQLException {
        String sql = """
            SELECT 
                COUNT(DISTINCT p.ProductID) as TotalProducts,
                COUNT(CASE WHEN ip.Quantity > 0 THEN 1 END) as InStockProducts,
                COUNT(CASE WHEN ip.Quantity <= 0 OR ip.Quantity IS NULL THEN 1 END) as OutOfStockProducts,
                COUNT(CASE WHEN ip.Quantity > 0 AND ip.Quantity < 10 THEN 1 END) as LowStockProducts,
                SUM(ISNULL(ip.Quantity, 0)) as TotalQuantity,
                SUM(ISNULL(ip.Quantity, 0) * CAST(p.RetailPrice AS DECIMAL(18,2))) as TotalValue
            FROM 
                Inventory i
                LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID
                LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
                LEFT JOIN Products p ON pd.ProductID = p.ProductID
            WHERE 
                i.InventoryID = ?
        """;
        
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, branchId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new ProductStatsDTO(
                        rs.getInt("TotalProducts"),
                        rs.getInt("InStockProducts"),
                        rs.getInt("OutOfStockProducts"),
                        rs.getInt("LowStockProducts"),
                        rs.getInt("TotalQuantity"),
                        rs.getBigDecimal("TotalValue")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getProductStats: " + e.getMessage());
            throw e;
        }
        
        return null;
    }


    
    public static void main(String[] args) throws SQLException {
        ProductDAO p = new ProductDAO();
        List<ProductDTO> products = p.getWarehouseProductList("DTB_DatTech", 1);
        for (ProductDTO product : products) {
            System.out.println(product);
        }
    }
}
