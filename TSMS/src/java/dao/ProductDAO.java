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
import model.Category;
import model.ProductDTO;
import model.ProductStatsDTO;
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
                         CASE 
                             WHEN p.IsActive = 1 THEN N'Đang kinh doanh' 
                             ELSE N'Không kinh doanh' 
                         END AS Status,
                         pd.Description,
                         pd.SerialNumber,
                         pd.WarrantyPeriod,
                         p.CreatedAt,
                     
                         -- Thông tin khuyến mãi hiện tại
                         pr.PromotionID,
                         pr.PromoName,
                         pr.DiscountPercent,
                         pr.StartDate,
                         pr.EndDate,
                         
                         -- Thêm BranchID từ PromotionBranches
                         pb.BranchID
                     
                     FROM 
                         Inventory i
                         LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID
                         LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
                         LEFT JOIN Products p ON pd.ProductID = p.ProductID
                         LEFT JOIN Brands b ON p.BrandID = b.BrandID
                         LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                         LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
                     
                         -- JOIN với bảng khuyến mãi
                         LEFT JOIN PromotionProducts pp ON pd.ProductDetailID = pp.ProductDetailID
                         LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID
                             AND (pr.StartDate IS NULL OR pr.StartDate <= GETDATE())
                             AND (pr.EndDate IS NULL OR pr.EndDate >= GETDATE())
                         
                         -- JOIN với PromotionBranches để lấy BranchID
                         LEFT JOIN PromotionBranches pb ON pr.PromotionID = pb.PromotionID
                     
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

    //Dat
    public void deleteProductAndDetail(String dbName, int productDetailId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false); // Start transaction

            // 1. Get ProductID from ProductDetails first
            int productId = -1;
            String getProductIdSql = "SELECT ProductID FROM " + dbName + ".dbo.ProductDetails WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(getProductIdSql);
            pstmt.setInt(1, productDetailId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                productId = rs.getInt("ProductID");
            }
            rs.close();
            pstmt.close();

            // If not found, nothing to delete
            if (productId == -1) {
                conn.rollback();
                throw new SQLException("Không tìm thấy ProductID từ ProductDetailID");
            }

            // 2. Delete from StockMovementDetail (if exists)
            String sql1 = "DELETE FROM " + dbName + ".dbo.StockMovementDetail WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql1);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 3. Delete from OrderDetails (theo ProductDetailID, KHÔNG phải ProductID)
            String sql2 = "DELETE FROM " + dbName + ".dbo.OrderDetails WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql2);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 4. Delete from InventoryProducts
            String sql3 = "DELETE FROM " + dbName + ".dbo.InventoryProducts WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql3);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 5. Delete from WarehouseProducts
            String sql4 = "DELETE FROM " + dbName + ".dbo.WarehouseProducts WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql4);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 6. Delete from PromotionProducts (nếu có liên kết foreign key)
            String sql5a = "DELETE FROM " + dbName + ".dbo.PromotionProducts WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql5a);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 7. Delete from ProductDetails
            String sql5 = "DELETE FROM " + dbName + ".dbo.ProductDetails WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql5);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 8. Delete from Products if no ProductDetail exists for that ProductID
            String sql6 = "DELETE FROM " + dbName + ".dbo.Products "
                    + "WHERE ProductID = ? AND NOT EXISTS (SELECT 1 FROM " + dbName + ".dbo.ProductDetails WHERE ProductID = ?)";
            pstmt = conn.prepareStatement(sql6);
            pstmt.setInt(1, productId);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
            pstmt.close();

            conn.commit(); // Commit transaction if all successful
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (pstmt != null) try {
                pstmt.close();
            } catch (SQLException ignored) {
            }
            if (conn != null) {
                DBUtil.closeConnection(conn);
            }
        }
    }

    //Dat
    public ProductDTO getProductByDetailId(String dbName, int productDetailId) throws SQLException {
        String query = "SELECT pd.ProductDetailID, p.ProductID, p.ProductName, b.BrandName, c.CategoryName, "
                + "s.SupplierName, p.CostPrice, p.RetailPrice, p.ImageURL, p.CreatedAt, p.IsActive, "
                + "pd.Description, pd.SerialNumber, pd.WarrantyPeriod "
                + "FROM " + dbName + ".dbo.ProductDetails pd "
                + "JOIN " + dbName + ".dbo.Products p ON pd.ProductID = p.ProductID "
                + "JOIN " + dbName + ".dbo.Brands b ON p.BrandID = b.BrandID "
                + "JOIN " + dbName + ".dbo.Categories c ON p.CategoryID = c.CategoryID "
                + "JOIN " + dbName + ".dbo.Suppliers s ON p.SupplierID = s.SupplierID "
                + "WHERE pd.ProductDetailID = ?";
        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, productDetailId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ProductDTO dto = extractProductDTOFromResultSet(rs);
                return dto;
            }
        }
        return null;
    }

    //Dat
    public void updateProductInfo(String dbName, int productDetailId, String productName, String costPrice, String retailPrice, String isActive) throws SQLException {
        String query = "UPDATE p "
                + "SET p.ProductName = ?, p.CostPrice = ?, p.RetailPrice = ?, p.IsActive = ? "
                + "FROM " + dbName + ".dbo.Products p "
                + "JOIN " + dbName + ".dbo.ProductDetails pd ON p.ProductID = pd.ProductID "
                + "WHERE pd.ProductDetailID = ?";
        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, productName);
            ps.setBigDecimal(2, new java.math.BigDecimal(costPrice.replace(",", "")));
            ps.setBigDecimal(3, new java.math.BigDecimal(retailPrice.replace(",", "")));
            ps.setBoolean(4, "1".equals(isActive) || "true".equalsIgnoreCase(isActive));
            ps.setInt(5, productDetailId);
            ps.executeUpdate();
        }
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

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

    public List<Category> getAllCategories(String dbName) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT CategoryID, CategoryName FROM Categories";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                categories.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<ProductDTO> getWarehouseProductListByPageAndCategory(String dbName, int warehouseId, int page, int pageSize, String search, Integer categoryId, String inventory) {
        List<ProductDTO> products = new ArrayList<>();
        StringBuilder query = new StringBuilder("""
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
                     AND p.ProductName LIKE ?
    """);

        if (categoryId != null) {
            query.append(" AND p.CategoryID = ?");
        }
        if ("in-stock".equals(inventory)) {
            query.append(" AND wp.Quantity > 0");
        } else if ("out-stock".equals(inventory)) {
            query.append(" AND wp.Quantity = 0");
        }
        query.append(" ORDER BY p.ProductID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            stmt.setInt(1, warehouseId);
            stmt.setString(2, "%" + search + "%");
            int paramIndex = 3;
            if (categoryId != null) {
                stmt.setInt(paramIndex++, categoryId);
            }
            stmt.setInt(paramIndex++, (page - 1) * pageSize);
            stmt.setInt(paramIndex, pageSize);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ProductDTO product = extractProductDTOFromResultSet(rs);
                products.add(product);
            }

            System.out.println("Sản phẩm lọc theo inventory: " + products.size() + " cho inventory: " + inventory);
        } catch (Exception e) {
            System.err.println("Lỗi trong getWarehouseProductListByPageAndCategory: " + e.getMessage());
            e.printStackTrace();
        }
        return products;
    }

    public int countProductsByWarehouseIdAndCategory(String dbName, int warehouseId, String search, Integer categoryId, String inventory) {
        int count = 0;
        StringBuilder query = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM Products p "
                + "JOIN ProductDetails pd ON p.ProductID = pd.ProductID "
                + "JOIN WarehouseProducts wp ON pd.ProductDetailID = wp.ProductDetailID "
                + "WHERE wp.WarehouseID = ? AND p.ProductName LIKE ?"
        );
        if (categoryId != null) {
            query.append(" AND p.CategoryID = ?");
        }
        if ("in-stock".equals(inventory)) {
            query.append(" AND wp.Quantity > 0");
        } else if ("out-stock".equals(inventory)) {
            query.append(" AND wp.Quantity = 0");
        }
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            stmt.setInt(1, warehouseId);
            stmt.setString(2, "%" + search + "%");
            int paramIndex = 3;
            if (categoryId != null) {
                stmt.setInt(paramIndex++, categoryId);
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
            System.out.println("Tổng sản phẩm theo inventory: " + count + " cho inventory: " + inventory);
        } catch (Exception e) {
            System.err.println("Lỗi trong countProductsByWarehouseIdAndCategory: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    /*      Lấy sản phẩm theo trạng thái tồn kho
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

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

    //KO DONG VAO
    private static ProductDTO extractProductDTOFromResultSet(ResultSet rs) throws SQLException {
        ProductDTO productDTO = new ProductDTO(
                rs.getInt("ProductDetailId"),
                rs.getInt("InventoryQuantity"),
                rs.getString("Description"),
                rs.getString("SerialNumber"),
                rs.getString("WarrantyPeriod"),
                rs.getString("PromoName"),
                rs.getDouble("DiscountPercent"),
                rs.getDate("StartDate"),
                rs.getDate("EndDate"),
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

    public static void main(String[] args) {

    }

}
