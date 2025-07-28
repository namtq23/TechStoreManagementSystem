/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.sql.Statement;
import model.Category;
import model.ProductDTO;
import model.ProductStatsDTO;
import util.DBUtil;
import java.util.logging.Logger;
import model.BMProductFilter;
import model.Brand;
import model.ProductDetailDTO;
import model.ProductDetails;
import model.Supplier;
import util.Validate;

/**
 *
 * @author admin
 */
public class ProductDAO {

    // PHÙNG
    private static final Logger LOGGER = Logger.getLogger(ProductDAO.class.getName());

    // Phuong
    public List<ProductDTO> getInventoryProductListByPageByBranchId(String dbName, int branchId, int offset,
            int limit) {
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
                    pd.ProductCode,
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

    // Phuong
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

    // Dat
    public void deleteProductAndDetail(String dbName, int productDetailId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false); // Start transaction

            // 1. Get ProductID from ProductDetails first
            int productId = -1;
            String getProductIdSql = "SELECT ProductID FROM " + dbName + ".dbo.ProductDetails WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(getProductIdSql);
            pstmt.setInt(1, productDetailId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                productId = rs.getInt("ProductID");
            }
            rs.close();
            pstmt.close();

            // If not found, nothing to delete
            if (productId == -1) {
                conn.rollback();
                throw new SQLException("Không tìm thấy ProductID từ ProductDetailID: " + productDetailId);
            }

            // 2. Delete from StockMovementDetail
            String sql1 = "DELETE FROM " + dbName + ".dbo.StockMovementDetail WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql1);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 3. Delete from OrderDetails
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

            // 6. Delete from PromotionProducts
            String sql5 = "DELETE FROM " + dbName + ".dbo.PromotionProducts WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql5);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 7. Delete from ProductDetailSerialNumber
            String sql6 = "DELETE FROM " + dbName + ".dbo.ProductDetailSerialNumber WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql6);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 8. Delete from ProductDetails
            String sql7 = "DELETE FROM " + dbName + ".dbo.ProductDetails WHERE ProductDetailID = ?";
            pstmt = conn.prepareStatement(sql7);
            pstmt.setInt(1, productDetailId);
            pstmt.executeUpdate();
            pstmt.close();

            // 9. Delete from Products if no ProductDetail exists for that ProductID
            String sql8 = "DELETE FROM " + dbName + ".dbo.Products "
                    + "WHERE ProductID = ? AND NOT EXISTS (SELECT 1 FROM " + dbName + ".dbo.ProductDetails WHERE ProductID = ?)";
            pstmt = conn.prepareStatement(sql8);
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
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException ignored) {
                }
            }
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException ignored) {
                }
            }
            if (conn != null) {
                DBUtil.closeConnection(conn);
            }
        }
    }

    public static ProductDTO getProductInInventoryByDetailId(String dbName, int productDetailId, int branchId) {
        ProductDTO product = null;
        StringBuilder query = new StringBuilder("""
                                    SELECT 
                                                        inp.InventoryID,
                                                        p.ProductID,
                                                        pd.ProductDetailID,
                                                        inp.Quantity AS InventoryQuantity,
                                                        p.ProductName,
                                                        b.BrandName,
                                                        c.CategoryName,
                                                        s.SupplierName,
                                                        CAST(p.CostPrice AS NVARCHAR) AS CostPrice,
                                                        CAST(p.RetailPrice AS NVARCHAR) AS RetailPrice,
                                                        p.ImageURL,
                                                        p.CreatedAt,
                                                        CASE 
                                                            WHEN p.IsActive = 1 THEN N'Đang kinh doanh' 
                                                            ELSE N'Không kinh doanh' 
                                                        END AS Status,
                                                        pd.Description,
                                                        pd.ProductCode,
                                                        pd.WarrantyPeriod,
                                                        promo.PromoName,
                                                        promo.DiscountPercent,
                                                        promo.StartDate,
                                                        promo.EndDate
                                                    FROM 
                                                        ProductDetails pd
                                                        LEFT JOIN Products p ON pd.ProductID = p.ProductID
                                                        LEFT JOIN InventoryProducts inp ON pd.ProductDetailID = inp.ProductDetailID
                                                        LEFT JOIN Brands b ON p.BrandID = b.BrandID
                                                        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                                                        LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
                                                        LEFT JOIN PromotionProducts pp ON pp.ProductDetailID = pd.ProductDetailID
                                                        LEFT JOIN Promotions promo ON promo.PromotionID = pp.PromotionID
                                                    WHERE 
                                                        pd.ProductDetailID = ? AND
                                        				inp.InventoryID = ?
                """);

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            stmt.setInt(1, productDetailId);
            stmt.setInt(2, branchId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                product = extractProductDTOFromResultSet(rs);
                System.out.println("Lấy sản phẩm thành công: ProductDetailID = " + productDetailId);
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong getProductByDetailId: " + e.getMessage());
            e.printStackTrace();
        }
        return product;
    }

    public static ProductDetailDTO getProductDetailById(String dbName, int productDetailId) throws SQLException {
        String sql = """
            SELECT 
                pd.ProductDetailID,
                pd.ProductID,
                p.ProductName,
                p.ProductName + ' - ' + pd.ProductCode AS FullName,
                pd.ProductCode,
                pd.Description,
                pd.WarrantyPeriod,
                p.BrandID,
                p.CategoryID,
                p.SupplierID,
                p.CostPrice,
                p.RetailPrice,
                p.VAT,
                p.ImageURL,
                p.IsActive,
                pd.ProductNameUnsigned,
                p.CreatedAt AS ProductCreatedAt,
                pd.CreatedAt AS DetailCreatedAt,
                pd.UpdatedAt
            FROM ProductDetails pd
            JOIN Products p ON pd.ProductID = p.ProductID
            WHERE pd.ProductDetailID = ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, productDetailId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new ProductDetailDTO(
                            rs.getInt("ProductDetailID"),
                            rs.getInt("ProductID"),
                            rs.getString("ProductName"),
                            rs.getString("FullName"),
                            rs.getString("ProductCode"),
                            rs.getString("Description"),
                            rs.getString("WarrantyPeriod"),
                            rs.getInt("BrandID"),
                            rs.getInt("CategoryID"),
                            rs.getInt("SupplierID"),
                            rs.getDouble("CostPrice"),
                            rs.getDouble("RetailPrice"),
                            rs.getDouble("VAT"),
                            rs.getString("ImageURL"),
                            rs.getBoolean("IsActive"),
                            rs.getString("ProductNameUnsigned"),
                            rs.getTimestamp("ProductCreatedAt"),
                            rs.getTimestamp("DetailCreatedAt"),
                            rs.getTimestamp("UpdatedAt")
                    );
                }
            }
        }
        return null;
    }

    // Method để lấy tên Brand theo ID
    public static String getBrandNameById(String dbName, int brandId) throws SQLException {
        String sql = "SELECT BrandName FROM Brands WHERE BrandID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, brandId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("BrandName");
                }
            }
        }
        return "Không xác định";
    }

    // Method để lấy tên Category theo ID
    public static String getCategoryNameById(String dbName, int categoryId) throws SQLException {
        String sql = "SELECT CategoryName FROM Categories WHERE CategoryID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, categoryId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("CategoryName");
                }
            }
        }
        return "Không xác định";
    }

    // Method để lấy tên Supplier theo ID
    public static String getSupplierNameById(String dbName, int supplierId) throws SQLException {
        String sql = "SELECT SupplierName FROM Suppliers WHERE SupplierID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, supplierId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("SupplierName");
                }
            }
        }
        return "Không xác định";
    }

    public boolean updateProductDetailComplete(String dbName, int productDetailId,
            String productName, String description, String warrantyPeriod,
            int brandId, int categoryId, int supplierId,
            double costPrice, double retailPrice, double vat, boolean isActive) throws SQLException {

        String updateProductSql = """
        UPDATE Products 
        SET ProductName = ?, BrandID = ?, CategoryID = ?, SupplierID = ?,
            CostPrice = ?, RetailPrice = ?, VAT = ?, IsActive = ?
        WHERE ProductID = (SELECT ProductID FROM ProductDetails WHERE ProductDetailID = ?)
    """;

        String updateDetailSql = """
        UPDATE ProductDetails 
        SET Description = ?, WarrantyPeriod = ?, UpdatedAt = GETDATE()
        WHERE ProductDetailID = ?
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName)) {
            conn.setAutoCommit(false);
            try {
                // Update Products table
                try (PreparedStatement stmt1 = conn.prepareStatement(updateProductSql)) {
                    stmt1.setString(1, productName);
                    stmt1.setInt(2, brandId);
                    stmt1.setInt(3, categoryId);
                    stmt1.setInt(4, supplierId);
                    stmt1.setDouble(5, costPrice);
                    stmt1.setDouble(6, retailPrice);
                    stmt1.setDouble(7, vat);
                    stmt1.setBoolean(8, isActive);
                    stmt1.setInt(9, productDetailId);
                    stmt1.executeUpdate();
                }

                // Update ProductDetails table
                try (PreparedStatement stmt2 = conn.prepareStatement(updateDetailSql)) {
                    stmt2.setString(1, description);
                    stmt2.setString(2, warrantyPeriod);
                    stmt2.setInt(3, productDetailId);
                    stmt2.executeUpdate();
                }

                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }


    /*
     * PHÙNG
     * Tìm kiếm sản phẩm theo tên hoặc mã
     */
    public List<ProductDTO> searchProducts(String dbName, int branchId, String keyword) throws SQLException {
        List<ProductDTO> products = new ArrayList<>();
        String sql;
        if (keyword != null && keyword.trim().matches("\\d+")) {
            sql = """
                        SELECT
                            pd.ProductDetailID,
                            p.ProductID,
                            p.ProductName,
                            c.CategoryName,
                            b.BrandName,
                            s.SupplierName,
                            p.CostPrice,
                            p.RetailPrice,
                            p.ImageURL,
                            p.CreatedAt,
                            p.IsActive,
                            ISNULL(SUM(ip.Quantity), 0) AS InventoryQuantity,
                            NULL AS Description,
                            NULL AS ProductCode,
                            NULL AS WarrantyPeriod,
                            NULL AS PromoName,
                            NULL AS DiscountPercent,
                            NULL AS StartDate,
                            NULL AS EndDate,
                            NULL AS Status
                        FROM
                            Products p
                            LEFT JOIN ProductDetails pd ON p.ProductID = pd.ProductID
                            LEFT JOIN InventoryProducts ip ON pd.ProductDetailID = ip.ProductDetailID
                            LEFT JOIN Inventory i ON ip.InventoryID = i.InventoryID AND i.BranchID = ?
                            LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                            LEFT JOIN Brands b ON p.BrandID = b.BrandID
                            LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID

                        WHERE
                            p.ProductID = ?
                        GROUP BY
                            pd.ProductDetailID,
                            p.ProductID, p.ProductName, c.CategoryName, b.BrandName, s.SupplierName,
                            p.CostPrice, p.RetailPrice, p.ImageURL, p.CreatedAt, p.IsActive
                        ORDER BY
                            p.ProductID
                    """;
        } else {
            sql = """
                        SELECT
                                        pd.ProductDetailID,
                                        p.ProductID,
                                        p.ProductName,
                                        c.CategoryName,
                                        b.BrandName,
                                        s.SupplierName,
                                        p.CostPrice,
                                        p.RetailPrice,
                                        p.ImageURL,
                                        p.CreatedAt,
                                        p.IsActive,
                                        ISNULL(SUM(ip.Quantity), 0) AS InventoryQuantity,
                                        NULL AS Description,
                                        NULL AS ProductCode,
                                        NULL AS WarrantyPeriod,
                                        NULL AS PromoName,
                                        NULL AS DiscountPercent,
                                        NULL AS StartDate,
                                        NULL AS EndDate,
                                        NULL AS Status
                        FROM
                            Products p
                            LEFT JOIN ProductDetails pd ON p.ProductID = pd.ProductID
                            LEFT JOIN InventoryProducts ip ON pd.ProductDetailID = ip.ProductDetailID
                            LEFT JOIN Inventory i ON ip.InventoryID = i.InventoryID AND i.BranchID = ?
                            LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                            LEFT JOIN Brands b ON p.BrandID = b.BrandID
                            LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
                        WHERE
                            p.ProductName LIKE ?
                        GROUP BY
                            pd.ProductDetailID, p.ProductID, p.ProductName, c.CategoryName, b.BrandName,
                            s.SupplierName, p.CostPrice, p.RetailPrice, p.ImageURL, p.CreatedAt, p.IsActive
                        ORDER BY
                            p.ProductName
                    """;
        }

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && keyword.trim().matches("\\d+")) {
                ps.setInt(1, branchId);
                ps.setInt(2, Integer.parseInt(keyword.trim()));
            } else {
                ps.setInt(1, branchId);
                ps.setString(2, "%" + (keyword != null ? keyword.trim() : "") + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
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

    public boolean addProduct(String dbName, String productName, String imageUrl, String productCode,
            String description, double costPrice, double retailPrice, int brandId,
            int categoryId, int supplierId, String warrantyPeriod, double vat) throws SQLException {
        Connection conn = null;
        PreparedStatement psProduct = null;
        PreparedStatement psProductDetail = null;
        PreparedStatement psInventoryProduct = null;
        PreparedStatement psWarehouseProduct = null;
        ResultSet rs = null;
        boolean success = false;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false); // Start transaction

            // Insert into Products table with ImageURL and default IsActive = 1
            String sqlProduct = "INSERT INTO Products (ProductName, BrandID, CategoryID, SupplierID, "
                    + "CostPrice, RetailPrice, ImageURL, VAT, IsActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psProduct = conn.prepareStatement(sqlProduct, Statement.RETURN_GENERATED_KEYS);
            psProduct.setString(1, productName);
            psProduct.setInt(2, brandId);
            psProduct.setInt(3, categoryId);
            psProduct.setInt(4, supplierId);
            psProduct.setDouble(5, costPrice);
            psProduct.setDouble(6, retailPrice);
            psProduct.setString(7, imageUrl);
            psProduct.setDouble(8, vat);
            psProduct.setBoolean(9, true); // Default IsActive = 1
            int productRows = psProduct.executeUpdate();

            if (productRows > 0) {
                // Get generated ProductID
                rs = psProduct.getGeneratedKeys();
                if (rs.next()) {
                    int productId = rs.getInt(1);

                    // Insert into ProductDetails table
                    String sqlProductDetail = "INSERT INTO ProductDetails (ProductID, Description, ProductCode, "
                            + "WarrantyPeriod, ProductNameUnsigned) VALUES (?, ?, ?, ?, ?)";
                    psProductDetail = conn.prepareStatement(sqlProductDetail, Statement.RETURN_GENERATED_KEYS);
                    psProductDetail.setInt(1, productId);
                    psProductDetail.setString(2, description);
                    psProductDetail.setString(3, productCode);
                    psProductDetail.setString(4, warrantyPeriod.isEmpty() ? null : warrantyPeriod);
                    psProductDetail.setString(5, standardizeName(productName));
                    int detailRows = psProductDetail.executeUpdate();

                    if (detailRows > 0) {
                        // Get generated ProductDetailID
                        rs = psProductDetail.getGeneratedKeys();
                        if (rs.next()) {
                            int productDetailId = rs.getInt(1);

                            // Insert into InventoryProducts for each Inventory
                            String sqlInventoryProduct = "INSERT INTO InventoryProducts (InventoryID, ProductDetailID, Quantity) "
                                    + "SELECT InventoryID, ?, 0 FROM Inventory";
                            psInventoryProduct = conn.prepareStatement(sqlInventoryProduct);
                            psInventoryProduct.setInt(1, productDetailId);
                            psInventoryProduct.executeUpdate();

                            // Insert into WarehouseProducts for each Warehouse
                            String sqlWarehouseProduct = "INSERT INTO WarehouseProducts (WarehouseID, ProductDetailID, Quantity) "
                                    + "SELECT WarehouseID, ?, 0 FROM Warehouses";
                            psWarehouseProduct = conn.prepareStatement(sqlWarehouseProduct);
                            psWarehouseProduct.setInt(1, productDetailId);
                            psWarehouseProduct.executeUpdate();

                            conn.commit();
                            success = true;
                        } else {
                            throw new SQLException("Không thể lấy ProductDetailID sau khi chèn vào ProductDetails.");
                        }
                    } else {
                        throw new SQLException("Không thể chèn vào ProductDetails.");
                    }
                } else {
                    throw new SQLException("Không thể lấy ProductID sau khi chèn vào Products.");
                }
            } else {
                throw new SQLException("Không thể chèn vào Products.");
            }
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    throw new SQLException("Rollback thất bại: " + ex.getMessage(), ex);
                }
            }
            throw e;
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException ignored) {
            }
            if (psWarehouseProduct != null) try {
                psWarehouseProduct.close();
            } catch (SQLException ignored) {
            }
            if (psInventoryProduct != null) try {
                psInventoryProduct.close();
            } catch (SQLException ignored) {
            }
            if (psProductDetail != null) try {
                psProductDetail.close();
            } catch (SQLException ignored) {
            }
            if (psProduct != null) try {
                psProduct.close();
            } catch (SQLException ignored) {
            }
            if (conn != null) try {
                conn.setAutoCommit(true);
                DBUtil.closeConnection(conn);
            } catch (SQLException ignored) {
            }
        }
        return success;
    }

// Keep the existing methods but remove serial number related ones
    public boolean isProductCodeExists(String dbName, String productCode) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ProductDetails WHERE ProductCode = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, productCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private String standardizeName(String name) {
        // Placeholder for name standardization logic
        // Replace with actual implementation from util.Validate if available
        return name.toLowerCase().replaceAll("[^a-z0-9 ]", "");
    }

    // Phuong
    public List<ProductDTO> getProductsByFilter(String dbName, int branchId, int offset, int limit,
            BMProductFilter filter) throws SQLException {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("    i.InventoryID, ");
        sql.append("    p.ProductID, ");
        sql.append("    ip.ProductDetailID, ");
        sql.append("    ip.Quantity AS InventoryQuantity, ");
        sql.append("    p.ProductName, ");
        sql.append("    b.BrandName, ");
        sql.append("    c.CategoryName, ");
        sql.append("    s.SupplierName, ");
        sql.append("    p.CostPrice, ");
        sql.append("    p.RetailPrice, ");
        sql.append("    p.ImageURL, ");
        sql.append("    CASE WHEN p.IsActive = 1 THEN N'Đang bán' ELSE N'Ngừng bán' END AS Status, ");
        sql.append("    pd.Description, ");
        sql.append("    pd.ProductCode, ");
        sql.append("    pd.WarrantyPeriod, ");
        sql.append("    p.CreatedAt, ");
        sql.append("    pr.PromotionID, ");
        sql.append("    pr.PromoName, ");
        sql.append("    pr.DiscountPercent, ");
        sql.append("    pr.StartDate, ");
        sql.append("    pr.EndDate, ");
        sql.append("    pb.BranchID ");
        sql.append("FROM Inventory i ");
        sql.append("    LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID ");
        sql.append("    LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID ");
        sql.append("    LEFT JOIN Products p ON pd.ProductID = p.ProductID ");
        sql.append("    LEFT JOIN Brands b ON p.BrandID = b.BrandID ");
        sql.append("    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID ");
        sql.append("    LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID ");
        sql.append("    LEFT JOIN PromotionProducts pp ON pd.ProductDetailID = pp.ProductDetailID ");
        sql.append("    LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID ");
        sql.append("        AND (pr.StartDate IS NULL OR pr.StartDate <= GETDATE()) ");
        sql.append("        AND (pr.EndDate IS NULL OR pr.EndDate >= GETDATE()) ");
        sql.append("    LEFT JOIN PromotionBranches pb ON pr.PromotionID = pb.PromotionID ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (branchId > 0) {
            sql.append("AND i.InventoryID = ? ");
            parameters.add(branchId);
        }

        if (filter.hasCategories()) {
            sql.append("AND p.CategoryID IN (");
            for (int i = 0; i < filter.getCategories().length; i++) {
                sql.append("?");
                if (i < filter.getCategories().length - 1) {
                    sql.append(",");
                }
                parameters.add(filter.getCategories()[i]);
            }
            sql.append(") ");
        }

        if (filter.hasInventoryFilter()) {
            switch (filter.getInventoryStatus()) {
                case "in-stock":
                    sql.append("AND ip.Quantity > 0 ");
                    break;
                case "out-stock":
                    sql.append("AND ip.Quantity = 0 ");
                    break;
            }
        }

        if (filter.hasSearchKeyword()) {
            String keyword = filter.getSearchKeyword();
            String keywordUnsigned = Validate.normalizeSearch(keyword);

            sql.append("AND (pd.ProductNameUnsigned LIKE ? OR pd.Description LIKE ? OR pd.ProductCode LIKE ?) ");
            String searchPattern = "%" + keywordUnsigned + "%";
            parameters.add(searchPattern);
            parameters.add("%" + keyword + "%");
            parameters.add("%" + keyword + "%");
        }

        if (filter.getMinPrice() != null) {
            sql.append("AND p.RetailPrice >= ? ");
            parameters.add(filter.getMinPrice());
        }

        if (filter.getMaxPrice() != null) {
            sql.append("AND p.RetailPrice <= ? ");
            parameters.add(filter.getMaxPrice());
        }

        if (filter.hasStatusFilter()) {
            switch (filter.getStatus()) {
                case "active":
                    sql.append("AND p.IsActive = 1 ");
                    break;
                case "inactive":
                    sql.append("AND p.IsActive = 0 ");
                    break;
            }
        }

        sql.append("ORDER BY ip.ProductDetailID ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        parameters.add(offset);
        parameters.add(limit);

        List<ProductDTO> products = new ArrayList<>();

        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDTO product = extractProductDTOFromResultSet(rs);
                    products.add(product);
                }
            }
        }

        return products;
    }

    //Phuong
    public int getTotalProductsByFilter(String dbName, int branchId, BMProductFilter filter) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT ip.ProductDetailID) ");
        sql.append("FROM Inventory i ");
        sql.append("    LEFT JOIN InventoryProducts ip ON i.InventoryID = ip.InventoryID ");
        sql.append("    LEFT JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID ");
        sql.append("    LEFT JOIN Products p ON pd.ProductID = p.ProductID ");
        sql.append("    LEFT JOIN Brands b ON p.BrandID = b.BrandID ");
        sql.append("    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID ");
        sql.append("    LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID ");
        sql.append("    LEFT JOIN PromotionProducts pp ON pd.ProductDetailID = pp.ProductDetailID ");
        sql.append("    LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID ");
        sql.append("        AND (pr.StartDate IS NULL OR pr.StartDate <= GETDATE()) ");
        sql.append("        AND (pr.EndDate IS NULL OR pr.EndDate >= GETDATE()) ");
        sql.append("    LEFT JOIN PromotionBranches pb ON pr.PromotionID = pb.PromotionID ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (branchId > 0) {
            sql.append("AND i.InventoryID = ? ");
            parameters.add(branchId);
        }

        if (filter.hasCategories()) {
            sql.append("AND p.CategoryID IN (");
            for (int i = 0; i < filter.getCategories().length; i++) {
                sql.append("?");
                if (i < filter.getCategories().length - 1) {
                    sql.append(",");
                }
                parameters.add(filter.getCategories()[i]);
            }
            sql.append(") ");
        }

        if (filter.hasInventoryFilter()) {
            switch (filter.getInventoryStatus()) {
                case "in-stock":
                    sql.append("AND ip.Quantity > 0 ");
                    break;
                case "out-stock":
                    sql.append("AND ip.Quantity = 0 ");
                    break;
            }
        }

        if (filter.hasSearchKeyword()) {
            String keyword = filter.getSearchKeyword();
            String keywordUnsigned = Validate.normalizeSearch(keyword);

            sql.append("AND (pd.ProductNameUnsigned LIKE ? OR pd.Description LIKE ? OR pd.ProductCode LIKE ?) ");
            parameters.add("%" + keywordUnsigned + "%");
            parameters.add("%" + keyword + "%");
            parameters.add("%" + keyword + "%");
        }

        if (filter.getMinPrice() != null) {
            sql.append("AND p.RetailPrice >= ? ");
            parameters.add(filter.getMinPrice());
        }

        if (filter.getMaxPrice() != null) {
            sql.append("AND p.RetailPrice <= ? ");
            parameters.add(filter.getMaxPrice());
        }

        if (filter.hasStatusFilter()) {
            switch (filter.getStatus()) {
                case "active":
                    sql.append("AND p.IsActive = 1 ");
                    break;
                case "inactive":
                    sql.append("AND p.IsActive = 0 ");
                    break;
            }
        }

        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    // Phuong
    public static boolean updateProductQuantityOfInventory(String dbName, List<ProductDTO> products, int branchId) {
        String sql = "UPDATE InventoryProducts SET Quantity = ? WHERE ProductDetailID = ? AND InventoryID = ?";
        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql)) {
            for (ProductDTO product : products) {
                ps.setInt(1, getNewQuantity(product, dbName, branchId));
                ps.setInt(2, product.getProductDetailId());
                ps.setInt(3, branchId);
                ps.addBatch();
            }
            int[] results = ps.executeBatch();
            for (int result : results) {
                if (result == Statement.EXECUTE_FAILED) {
                    return false; // Nếu có bất kỳ bản ghi nào không cập nhật thành công
                }
            }
            return true; // Tất cả bản ghi đã được cập nhật thành công
        } catch (SQLException e) {
            System.err.println("Lỗi khi cập nhật số lượng sản phẩm trong kho: " + e.getMessage());
            return false;
        }
    }

    //Phuong
    public static boolean markSerialAsSold(String dbName, int productDetailId, int orderId, int branchId) {
        String query = """
                       WITH RandomSerial AS (
                           SELECT TOP (1) ProductDetailID, SerialNumber
                           FROM ProductDetailSerialNumber
                           WHERE ProductDetailID = ? AND Status = 1 AND BranchID = ?
                           ORDER BY NEWID()
                       )
                       UPDATE p
                       SET Status = 0, OrderID = ?
                       FROM ProductDetailSerialNumber p
                       INNER JOIN RandomSerial r 
                           ON p.ProductDetailID = r.ProductDetailID 
                           AND p.SerialNumber = r.SerialNumber
                       WHERE p.Status = 1 AND p.BranchID = ?""";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, productDetailId);
            stmt.setInt(2, branchId);
            stmt.setInt(3, orderId);
            stmt.setInt(4, branchId);

            int updatedRows = stmt.executeUpdate();
            return updatedRows > 0;

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return false;
    }

    //Phuong
    public static int getNewQuantity(ProductDTO product, String dbName, int branchId) {
        int newQuantity = 0;

        ProductDTO productDto = ProductDAO.getProductInInventoryByDetailId(dbName, product.getProductDetailId(),
                branchId);
        if (productDto != null) {
            newQuantity = productDto.getQuantity() - product.getQuantity();
            if (newQuantity < 0) {
                System.out.println("Số lượng mới không thể âm!");
            }
        } else {
            System.out.println("Không tìm thấy sản phẩm nào!");
        }

        return newQuantity;
    }

    //Phuong
    public static List<ProductDetailDTO> getAllProductDetailsByFilter(String dbName, int offset, int limit, BMProductFilter filter) throws SQLException {
        List<ProductDetailDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("""
        SELECT 
            pd.ProductDetailID,
            pd.ProductID,
            p.ProductName,
            p.ProductName + ' - ' + pd.ProductCode AS FullName,
            pd.ProductCode,
            pd.Description,
            pd.WarrantyPeriod,
            p.BrandID,
            p.CategoryID,
            p.SupplierID,
            p.CostPrice,
            p.RetailPrice,
            p.VAT,
            p.ImageURL,
            p.IsActive,
            pd.ProductNameUnsigned,
            p.CreatedAt AS ProductCreatedAt,
            pd.CreatedAt AS DetailCreatedAt,
            pd.UpdatedAt
        FROM ProductDetails pd
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE 1=1
    """);

        List<Object> parameters = new ArrayList<>();

        // Filter theo category
        if (filter != null && filter.hasCategories()) {
            sql.append(" AND p.CategoryID IN (");
            for (int i = 0; i < filter.getCategories().length; i++) {
                sql.append("?");
                if (i < filter.getCategories().length - 1) {
                    sql.append(",");
                }
                parameters.add(filter.getCategories()[i]);
            }
            sql.append(") ");
        }

        // Filter theo trạng thái active/inactive
        if (filter != null && filter.hasStatusFilter()) {
            switch (filter.getStatus()) {
                case "active":
                    sql.append(" AND p.IsActive = 1 ");
                    break;
                case "inactive":
                    sql.append(" AND p.IsActive = 0 ");
                    break;
            }
        }

        // Filter theo keyword (tìm không dấu ở ProductNameUnsigned, hoặc Description, hoặc ProductCode)
        if (filter != null && filter.hasSearchKeyword()) {
            String keyword = filter.getSearchKeyword();
            String keywordUnsigned = Validate.normalizeSearch(keyword);

            sql.append(" AND (pd.ProductNameUnsigned LIKE ? OR pd.Description LIKE ? OR pd.ProductCode LIKE ?) ");
            String searchPattern = "%" + keywordUnsigned + "%";
            parameters.add(searchPattern);
            parameters.add("%" + keyword + "%");
            parameters.add("%" + keyword + "%");
        }

        // Filter theo giá min
        if (filter != null && filter.getMinPrice() != null) {
            sql.append(" AND p.RetailPrice >= ? ");
            parameters.add(filter.getMinPrice());
        }

        // Filter theo giá max
        if (filter != null && filter.getMaxPrice() != null) {
            sql.append(" AND p.RetailPrice <= ? ");
            parameters.add(filter.getMaxPrice());
        }

        // Phân trang: ORDER BY + OFFSET ... FETCH NEXT
        sql.append(" ORDER BY pd.ProductDetailID ");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        parameters.add(offset);
        parameters.add(limit);

        try (
                Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            // Set tham số vào PreparedStatement
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductDetailDTO dto = new ProductDetailDTO(
                            rs.getInt("ProductDetailID"),
                            rs.getInt("ProductID"),
                            rs.getString("ProductName"),
                            rs.getString("FullName"),
                            rs.getString("ProductCode"),
                            rs.getString("Description"),
                            rs.getString("WarrantyPeriod"),
                            rs.getInt("BrandID"),
                            rs.getInt("CategoryID"),
                            rs.getInt("SupplierID"),
                            rs.getDouble("CostPrice"),
                            rs.getDouble("RetailPrice"),
                            rs.getDouble("VAT"),
                            rs.getString("ImageURL"),
                            rs.getBoolean("IsActive"),
                            rs.getString("ProductNameUnsigned"),
                            rs.getTimestamp("ProductCreatedAt"),
                            rs.getTimestamp("DetailCreatedAt"),
                            rs.getTimestamp("UpdatedAt")
                    );
                    list.add(dto);
                }
            }
        }

        return list;
    }

    public static int getTotalProductDetailByFilter(String dbName, BMProductFilter filter) throws SQLException {
        int total = 0;

        StringBuilder sql = new StringBuilder();
        sql.append("""
        SELECT COUNT(*) AS Total
        FROM ProductDetails pd
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE 1=1
    """);

        List<Object> parameters = new ArrayList<>();

        // Filter theo category
        if (filter != null && filter.hasCategories()) {
            sql.append(" AND p.CategoryID IN (");
            for (int i = 0; i < filter.getCategories().length; i++) {
                sql.append("?");
                if (i < filter.getCategories().length - 1) {
                    sql.append(",");
                }
                parameters.add(filter.getCategories()[i]);
            }
            sql.append(") ");
        }

        // Filter theo trạng thái active/inactive
        if (filter != null && filter.hasStatusFilter()) {
            switch (filter.getStatus()) {
                case "active":
                    sql.append(" AND p.IsActive = 1 ");
                    break;
                case "inactive":
                    sql.append(" AND p.IsActive = 0 ");
                    break;
            }
        }

        // Filter theo keyword (tìm không dấu ở ProductNameUnsigned, hoặc Description, hoặc ProductCode)
        if (filter != null && filter.hasSearchKeyword()) {
            String keyword = filter.getSearchKeyword();
            String keywordUnsigned = Validate.normalizeSearch(keyword);

            sql.append(" AND (pd.ProductNameUnsigned LIKE ? OR pd.Description LIKE ? OR pd.ProductCode LIKE ?) ");
            String searchPattern = "%" + keywordUnsigned + "%";
            parameters.add(searchPattern);
            parameters.add("%" + keyword + "%");
            parameters.add("%" + keyword + "%");
        }

        // Filter theo giá min
        if (filter != null && filter.getMinPrice() != null) {
            sql.append(" AND p.RetailPrice >= ? ");
            parameters.add(filter.getMinPrice());
        }

        // Filter theo giá max
        if (filter != null && filter.getMaxPrice() != null) {
            sql.append(" AND p.RetailPrice <= ? ");
            parameters.add(filter.getMaxPrice());
        }

        try (
                Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("Total");
                }
            }
        }

        return total;
    }

    public static int getTotalProduct(String dbName) throws SQLException {
        int total = 0;

        StringBuilder sql = new StringBuilder();
        sql.append("""
        SELECT COUNT(*) AS Total
        FROM ProductDetails pd
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE 1=1
    """);
        try (
                Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("Total");
                }
            }
        }

        return total;
    }

    //Phuong
    public List<ProductDTO> getWareHouseProductsByFilter(String dbName, int warehouseId, int offset, int limit,
            BMProductFilter filter) throws SQLException {

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ");
        sql.append("    w.WarehouseID, ");
        sql.append("    p.ProductID, ");
        sql.append("    wp.ProductDetailID, ");
        sql.append("    wp.Quantity AS WarehouseQuantity, ");
        sql.append("    p.ProductName, ");
        sql.append("    b.BrandName, ");
        sql.append("    c.CategoryName, ");
        sql.append("    s.SupplierName, ");
        sql.append("    p.CostPrice, ");
        sql.append("    p.RetailPrice, ");
        sql.append("    p.ImageURL, ");
        sql.append("    CASE WHEN p.IsActive = 1 THEN N'Đang bán' ELSE N'Ngừng bán' END AS Status, ");
        sql.append("    pd.Description, ");
        sql.append("    pd.ProductCode, ");
        sql.append("    pd.WarrantyPeriod, ");
        sql.append("    p.CreatedAt, ");
        sql.append("    pr.PromotionID, ");
        sql.append("    pr.PromoName, ");
        sql.append("    pr.DiscountPercent, ");
        sql.append("    pr.StartDate, ");
        sql.append("    pr.EndDate, ");
        sql.append("    pb.BranchID ");
        sql.append("FROM Warehouses w ");
        sql.append("    LEFT JOIN WarehouseProducts wp ON w.WarehouseID = wp.WarehouseID ");
        sql.append("    LEFT JOIN ProductDetails pd ON wp.ProductDetailID = pd.ProductDetailID ");
        sql.append("    LEFT JOIN Products p ON pd.ProductID = p.ProductID ");
        sql.append("    LEFT JOIN Brands b ON p.BrandID = b.BrandID ");
        sql.append("    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID ");
        sql.append("    LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID ");
        sql.append("    LEFT JOIN PromotionProducts pp ON pd.ProductDetailID = pp.ProductDetailID ");
        sql.append("    LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID ");
        sql.append("        AND (pr.StartDate IS NULL OR pr.StartDate <= GETDATE()) ");
        sql.append("        AND (pr.EndDate IS NULL OR pr.EndDate >= GETDATE()) ");
        sql.append("    LEFT JOIN PromotionBranches pb ON pr.PromotionID = pb.PromotionID ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (warehouseId > 0) {
            sql.append("AND w.WarehouseID = ? ");
            parameters.add(warehouseId);
        }

        if (filter.hasCategories()) {
            sql.append("AND p.CategoryID IN (");
            for (int i = 0; i < filter.getCategories().length; i++) {
                sql.append("?");
                if (i < filter.getCategories().length - 1) {
                    sql.append(",");
                }
                parameters.add(filter.getCategories()[i]);
            }
            sql.append(") ");
        }

        if (filter.hasInventoryFilter()) {
            switch (filter.getInventoryStatus()) {
                case "in-stock":
                    sql.append("AND wp.Quantity > 0 ");
                    break;
                case "out-stock":
                    sql.append("AND wp.Quantity = 0 ");
                    break;
            }
        }

        if (filter.hasSearchKeyword()) {
            String keyword = filter.getSearchKeyword();
            String keywordUnsigned = Validate.normalizeSearch(keyword);

            sql.append("AND (pd.ProductNameUnsigned LIKE ? OR pd.Description LIKE ? OR pd.ProductCode LIKE ?) ");
            String searchPattern = "%" + keywordUnsigned + "%";
            parameters.add(searchPattern);
            parameters.add("%" + keyword + "%");
            parameters.add("%" + keyword + "%");
        }

        if (filter.getMinPrice() != null) {
            sql.append("AND p.RetailPrice >= ? ");
            parameters.add(filter.getMinPrice());
        }

        if (filter.getMaxPrice() != null) {
            sql.append("AND p.RetailPrice <= ? ");
            parameters.add(filter.getMaxPrice());
        }

        if (filter.hasStatusFilter()) {
            switch (filter.getStatus()) {
                case "active":
                    sql.append("AND p.IsActive = 1 ");
                    break;
                case "inactive":
                    sql.append("AND p.IsActive = 0 ");
                    break;
            }
        }

        sql.append("ORDER BY wp.ProductDetailID ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        parameters.add(offset);
        parameters.add(limit);

        List<ProductDTO> products = new ArrayList<>();

        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDTO product = extractWarehouseProductDTOFromResultSet(rs);
                    products.add(product);
                }
            }
        }

        return products;
    }

    //Phuong
    public int getTotalWarehouseProductsByFilter(String dbName, int warehouseId, BMProductFilter filter) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT wp.ProductDetailID) ");
        sql.append("FROM Warehouses w ");
        sql.append("    LEFT JOIN WarehouseProducts wp ON w.WarehouseID = wp.WarehouseID ");
        sql.append("    LEFT JOIN ProductDetails pd ON wp.ProductDetailID = pd.ProductDetailID ");
        sql.append("    LEFT JOIN Products p ON pd.ProductID = p.ProductID ");
        sql.append("    LEFT JOIN Brands b ON p.BrandID = b.BrandID ");
        sql.append("    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID ");
        sql.append("    LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID ");
        sql.append("    LEFT JOIN PromotionProducts pp ON pd.ProductDetailID = pp.ProductDetailID ");
        sql.append("    LEFT JOIN Promotions pr ON pp.PromotionID = pr.PromotionID ");
        sql.append("        AND (pr.StartDate IS NULL OR pr.StartDate <= GETDATE()) ");
        sql.append("        AND (pr.EndDate IS NULL OR pr.EndDate >= GETDATE()) ");
        sql.append("    LEFT JOIN PromotionBranches pb ON pr.PromotionID = pb.PromotionID ");
        sql.append("WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        if (warehouseId > 0) {
            sql.append("AND w.WarehouseID = ? ");
            parameters.add(warehouseId);
        }

        if (filter.hasCategories()) {
            sql.append("AND p.CategoryID IN (");
            for (int i = 0; i < filter.getCategories().length; i++) {
                sql.append("?");
                if (i < filter.getCategories().length - 1) {
                    sql.append(",");
                }
                parameters.add(filter.getCategories()[i]);
            }
            sql.append(") ");
        }

        if (filter.hasInventoryFilter()) {
            switch (filter.getInventoryStatus()) {
                case "in-stock":
                    sql.append("AND wp.Quantity > 0 ");
                    break;
                case "out-stock":
                    sql.append("AND wp.Quantity = 0 ");
                    break;
            }
        }

        if (filter.hasSearchKeyword()) {
            String keyword = filter.getSearchKeyword();
            String keywordUnsigned = Validate.normalizeSearch(keyword);

            sql.append("AND (pd.ProductNameUnsigned LIKE ? OR pd.Description LIKE ? OR pd.ProductCode LIKE ?) ");
            parameters.add("%" + keywordUnsigned + "%");
            parameters.add("%" + keyword + "%");
            parameters.add("%" + keyword + "%");
        }

        if (filter.getMinPrice() != null) {
            sql.append("AND p.RetailPrice >= ? ");
            parameters.add(filter.getMinPrice());
        }

        if (filter.getMaxPrice() != null) {
            sql.append("AND p.RetailPrice <= ? ");
            parameters.add(filter.getMaxPrice());
        }

        if (filter.hasStatusFilter()) {
            switch (filter.getStatus()) {
                case "active":
                    sql.append("AND p.IsActive = 1 ");
                    break;
                case "inactive":
                    sql.append("AND p.IsActive = 0 ");
                    break;
            }
        }

        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                ps.setObject(i + 1, parameters.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    // KO DONG VAO
    private static ProductDTO extractProductDTOFromResultSet(ResultSet rs) throws SQLException {
        ProductDTO productDTO = new ProductDTO(
                rs.getInt("ProductDetailId"),
                rs.getInt("InventoryQuantity"),
                rs.getString("Description"),
                rs.getString("ProductCode"),
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
                rs.getString("Status"));
        return productDTO;
    }

    private static ProductDTO extractWarehouseProductDTOFromResultSet(ResultSet rs) throws SQLException {
        ProductDTO productDTO = new ProductDTO(
                rs.getInt("ProductDetailId"),
                rs.getInt("WarehouseQuantity"), // Đã đổi tên từ InventoryQuantity
                rs.getString("Description"),
                rs.getString("ProductCode"),
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
                rs.getString("Status"));
        return productDTO;
    }

    public static void main(String[] args) {
    }

public static List<ProductDetailDTO> getProductDetailDTOsBySupplierPaged(String dbName, int supplierId, int offset, int limit) throws SQLException {
    List<ProductDetailDTO> list = new ArrayList<>();

    String sql = """
        SELECT 
            pd.ProductDetailID,
            pd.ProductID,
            p.ProductName,
            p.ProductName + ' - ' + pd.ProductCode AS FullName,
            pd.ProductCode,
            pd.Description,
            pd.WarrantyPeriod,
            p.BrandID,
            p.CategoryID,
            p.SupplierID,
            p.CostPrice,
            p.RetailPrice,
            p.VAT,
            p.ImageURL,
            p.IsActive,
            pd.ProductNameUnsigned,
            p.CreatedAt AS ProductCreatedAt,
            pd.CreatedAt AS DetailCreatedAt,
            pd.UpdatedAt
        FROM ProductDetails pd
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE p.SupplierID = ?
        ORDER BY pd.ProductDetailID DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, supplierId);
        stmt.setInt(2, offset);
        stmt.setInt(3, limit);

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ProductDetailDTO dto = new ProductDetailDTO(
                        rs.getInt("ProductDetailID"),
                        rs.getInt("ProductID"),
                        rs.getString("ProductName"),
                        rs.getString("FullName"),
                        rs.getString("ProductCode"),
                        rs.getString("Description"),
                        rs.getString("WarrantyPeriod"),
                        rs.getInt("BrandID"),
                        rs.getInt("CategoryID"),
                        rs.getInt("SupplierID"),
                        rs.getDouble("CostPrice"),
                        rs.getDouble("RetailPrice"),
                        rs.getDouble("VAT"),
                        rs.getString("ImageURL"),
                        rs.getBoolean("IsActive"),
                        rs.getString("ProductNameUnsigned"),
                        rs.getTimestamp("ProductCreatedAt"),
                        rs.getTimestamp("DetailCreatedAt"),
                        rs.getTimestamp("UpdatedAt")
                );
                list.add(dto);
            }
        }
    }

    return list;
}

public static int countProductDetailBySupplier(String dbName, int supplierId) throws SQLException {
    String sql = "SELECT COUNT(*) FROM ProductDetails pd JOIN Products p ON pd.ProductID = p.ProductID WHERE p.SupplierID = ?";

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, supplierId);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    }
    return 0;
}

// DAO
public static List<ProductDetailDTO> searchProductDetailDTOsBySupplier(String dbName, int supplierId, String keyword, int offset, int limit) throws SQLException {
    List<ProductDetailDTO> list = new ArrayList<>();

    String sql = """
        SELECT 
            pd.ProductDetailID,
            pd.ProductID,
            p.ProductName,
            p.ProductName + ' - ' + pd.ProductCode AS FullName,
            pd.ProductCode,
            pd.Description,
            pd.WarrantyPeriod,
            p.BrandID,
            p.CategoryID,
            p.SupplierID,
            p.CostPrice,
            p.RetailPrice,
            p.VAT,
            p.ImageURL,
            p.IsActive,
            pd.ProductNameUnsigned,
            p.CreatedAt AS ProductCreatedAt,
            pd.CreatedAt AS DetailCreatedAt,
            pd.UpdatedAt
        FROM ProductDetails pd
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE p.SupplierID = ?
          AND (pd.ProductNameUnsigned LIKE ? OR pd.ProductCode LIKE ?)
        ORDER BY pd.ProductDetailID DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, supplierId);
        stmt.setString(2, "%" + keyword + "%");
        stmt.setString(3, "%" + keyword + "%");
        stmt.setInt(4, offset);
        stmt.setInt(5, limit);

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ProductDetailDTO dto = new ProductDetailDTO(
                        rs.getInt("ProductDetailID"),
                        rs.getInt("ProductID"),
                        rs.getString("ProductName"),
                        rs.getString("FullName"),
                        rs.getString("ProductCode"),
                        rs.getString("Description"),
                        rs.getString("WarrantyPeriod"),
                        rs.getInt("BrandID"),
                        rs.getInt("CategoryID"),
                        rs.getInt("SupplierID"),
                        rs.getDouble("CostPrice"),
                        rs.getDouble("RetailPrice"),
                        rs.getDouble("VAT"),
                        rs.getString("ImageURL"),
                        rs.getBoolean("IsActive"),
                        rs.getString("ProductNameUnsigned"),
                        rs.getTimestamp("ProductCreatedAt"),
                        rs.getTimestamp("DetailCreatedAt"),
                        rs.getTimestamp("UpdatedAt")
                );
                list.add(dto);
            }
        }
    }

    return list;
}


    


public static int countSearchProductDetailBySupplier(String dbName, int supplierId, String keyword) throws SQLException {
    String sql = """
        SELECT COUNT(*)
        FROM ProductDetails pd
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE p.SupplierID = ?
          AND (pd.ProductNameUnsigned LIKE ? OR pd.ProductCode LIKE ?)
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setInt(1, supplierId);
        stmt.setString(2, "%" + keyword + "%");
        stmt.setString(3, "%" + keyword + "%");

        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    }

    return 0;
}







}
