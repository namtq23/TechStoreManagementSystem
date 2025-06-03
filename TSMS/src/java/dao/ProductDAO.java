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
import util.DBUtil;

/**
 *
 * @author admin
 */
public class ProductDAO {

    public List<ProductDTO> getInventoryProductListByBranchId(String dbName, int branchId) throws SQLException {
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
                    i.InventoryID = ?;
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, branchId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductDTO product = extractProductDTOFromResultSet(rs);
                    products.add(product);
                }
            } catch (Exception e) {
                System.out.println(e);
            }
        }

        return products;
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
        Connection conn = DBUtil.getConnectionTo(dbName);
        PreparedStatement statement = conn.prepareStatement(sql)
    ) {
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
    

    public static void main(String[] args) throws SQLException {
        ProductDAO p = new ProductDAO();
        List<ProductDTO> products = p.getWarehouseProductList("DTB_DatTech", 1);
        for (ProductDTO product : products) {
            System.out.println(product);
        }
    }
}
