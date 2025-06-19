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
import java.util.List;
import java.sql.Statement;
import model.Category;
import model.ProductDTO;
import model.ProductStatsDTO;
import util.DBUtil;
import java.util.logging.Logger;
import model.BMProductFilter;
import model.Brand;
import model.ProductDetailDTO;
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
        String sql8 = "DELETE FROM " + dbName + ".dbo.Products " +
                      "WHERE ProductID = ? AND NOT EXISTS (SELECT 1 FROM " + dbName + ".dbo.ProductDetails WHERE ProductID = ?)";
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
            } catch (SQLException ignored) {}
        }
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException ignored) {}
        }
        if (conn != null) {
            DBUtil.closeConnection(conn);
        }
    }
}

    public void updateProductDetails(String dbName, ProductDTO product) {
        StringBuilder query = new StringBuilder("""
                    BEGIN TRANSACTION;
                    UPDATE Products
                    SET RetailPrice = ?, CostPrice = ?, IsActive = ?
                    WHERE ProductID = ?;
                    UPDATE ProductDetails
                    SET Description = ?, UpdatedAt = GETDATE()
                    WHERE ProductDetailID = ?;
                    COMMIT;
                """);

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            int paramIndex = 1;
            stmt.setBigDecimal(paramIndex++, new java.math.BigDecimal(product.getRetailPrice()));
            stmt.setBigDecimal(paramIndex++, new java.math.BigDecimal(product.getCostPrice()));
            stmt.setBoolean(paramIndex++, product.isActive());
            stmt.setInt(paramIndex++, product.getProductId());
            stmt.setString(paramIndex++, product.getDescription());
            stmt.setInt(paramIndex, product.getProductDetailId());
            stmt.executeUpdate();
            System.out.println("Cập nhật sản phẩm thành công: ProductDetailID = " + product.getProductDetailId());
        } catch (Exception e) {
            System.err.println("Lỗi trong updateProductDetails: " + e.getMessage());
            e.printStackTrace();
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

    public List<Category> getAllCategory(String dbName) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT CategoryID, CategoryName FROM " + dbName + ".dbo.Categories";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Brand> getAllBrands(String dbName) {
        List<Brand> brands = new ArrayList<>();
        String query = "SELECT BrandID, BrandName FROM " + dbName + ".dbo.Brands";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Brand brand = new Brand();
                brand.setBrandID(rs.getInt("BrandID"));
                brand.setBrandName(rs.getString("BrandName"));
                brands.add(brand);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }

    public List<Supplier> getAllSuppliers(String dbName) {
        List<Supplier> suppliers = new ArrayList<>();
        String query = "SELECT SupplierID, SupplierName, ContactName, Phone, Email FROM " + dbName + ".dbo.Suppliers";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("SupplierID"));
                supplier.setSupplierName(rs.getString("SupplierName"));
                supplier.setContactName(rs.getString("ContactName"));
                supplier.setPhone(rs.getString("Phone"));
                supplier.setEmail(rs.getString("Email"));
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }

    public boolean brandExists(String dbName, String brandName) throws SQLException {
        String query = "SELECT COUNT(*) FROM " + dbName + ".dbo.Brands WHERE LOWER(BrandName) = LOWER(?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, brandName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public boolean productNameExists(String dbName, String productName) throws SQLException {
        String query = "SELECT COUNT(*) FROM " + dbName + ".dbo.Products WHERE LOWER(ProductName) = LOWER(?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, productName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public int addBrand(String dbName, String brandName) throws SQLException {
        String query = "INSERT INTO " + dbName + ".dbo.Brands (BrandName) VALUES (?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, brandName);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        throw new SQLException("Không thể thêm thương hiệu");
    }

    public boolean categoryExists(String dbName, String categoryName) throws SQLException {
        String query = "SELECT COUNT(*) FROM " + dbName + ".dbo.Categories WHERE LOWER(CategoryName) = LOWER(?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, categoryName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public int addCategory(String dbName, String categoryName) throws SQLException {
        String query = "SELECT ISNULL(MAX(CategoryID), 0) + 1 AS NextID FROM " + dbName + ".dbo.Categories";
        int categoryId;
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            rs.next();
            categoryId = rs.getInt("NextID");
        }
        query = "INSERT INTO " + dbName + ".dbo.Categories (CategoryID, CategoryName) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, categoryId);
            stmt.setString(2, categoryName);
            stmt.executeUpdate();
            return categoryId;
        }
    }

    public boolean supplierExists(String dbName, String supplierName) throws SQLException {
        String query = "SELECT COUNT(*) FROM " + dbName + ".dbo.Suppliers WHERE LOWER(SupplierName) = LOWER(?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, supplierName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public int addSupplier(String dbName, String supplierName, String contactName, String phone, String email)
            throws SQLException {
        String query = "INSERT INTO " + dbName
                + ".dbo.Suppliers (SupplierName, ContactName, Phone, Email) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, supplierName);
            stmt.setString(2, contactName != null && !contactName.isEmpty() ? contactName : null);
            stmt.setString(3, phone != null && !phone.isEmpty() ? phone : null);
            stmt.setString(4, email != null && !email.isEmpty() ? email : null);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        throw new SQLException("Không thể thêm nhà cung cấp");
    }

    public int addProduct(String dbName, String productName, int brandId, int categoryId, int supplierId,
            double costPrice, double retailPrice, String imageURL, boolean isActive) throws SQLException {
        String query = "INSERT INTO " + dbName
                + ".dbo.Products (ProductName, BrandID, CategoryID, SupplierID, CostPrice, RetailPrice, ImageURL, IsActive) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, productName);
            stmt.setInt(2, brandId);
            stmt.setInt(3, categoryId);
            stmt.setInt(4, supplierId);
            stmt.setDouble(5, costPrice);
            stmt.setDouble(6, retailPrice);
            stmt.setString(7, imageURL != null && !imageURL.isEmpty() ? imageURL : null);
            stmt.setBoolean(8, isActive);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        throw new SQLException("Không thể thêm sản phẩm");
    }

    public int addProductDetail(String dbName, int productId, String description, String serialNumber,
            String warrantyPeriod) throws SQLException {
        String query = "INSERT INTO " + dbName
                + ".dbo.ProductDetails (ProductID, Description, ProductCode, WarrantyPeriod) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, productId);
            stmt.setString(2, description != null && !description.isEmpty() ? description : null);
            stmt.setString(3, serialNumber != null && !serialNumber.isEmpty() ? serialNumber : null);
            stmt.setString(4, warrantyPeriod != null && !warrantyPeriod.isEmpty() ? warrantyPeriod : null);
            stmt.executeUpdate();
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        throw new SQLException("Không thể thêm chi tiết sản phẩm");
    }

    public void addWarehouseProduct(String dbName, int warehouseId, int productDetailId, int quantity)
            throws SQLException {
        String query = "INSERT INTO " + dbName
                + ".dbo.WarehouseProducts (WarehouseID, ProductDetailID, Quantity) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, warehouseId);
            stmt.setInt(2, productDetailId);
            stmt.setInt(3, quantity);
            stmt.executeUpdate();
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
    public static boolean markSerialAsSold(String dbName, int productDetailId, int orderId) {
        String query = "WITH RandomSerial AS ( \n"
                + "    SELECT TOP (1) ProductDetailID, SerialNumber \n"
                + "    FROM ProductDetailSerialNumber \n"
                + "    WHERE ProductDetailID = ? AND Status = 1 \n"
                + "    ORDER BY NEWID() \n"
                + ") \n"
                + "UPDATE p SET Status = 0, OrderID = ? \n"
                + "FROM ProductDetailSerialNumber p \n"
                + "INNER JOIN RandomSerial r ON p.ProductDetailID = r.ProductDetailID \n"
                + "    AND p.SerialNumber = r.SerialNumber \n"
                + "WHERE p.Status = 1";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, productDetailId);
            stmt.setInt(2, orderId);

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

    public static void main(String[] args) throws SQLException {
        System.out.println(ProductDAO.getTotalProduct("DTB_P"));
    }

}
