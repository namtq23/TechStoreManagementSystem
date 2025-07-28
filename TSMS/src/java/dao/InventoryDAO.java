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
import java.util.Date;
import java.util.List;
import model.CustomerDTO;
import model.Customer;
import util.DBUtil;


/**
 *
 * @author Trieu Quang Nam
 */
public class InventoryDAO {
    
    public int getInventoryIdByBranchId(String dbName, int branchId) throws SQLException {
    String sql = "SELECT InventoryID FROM Inventory WHERE BranchID = ?";
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, branchId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("InventoryID");
        }
        return 0; // Không tìm thấy
    }
}
public boolean addOrUpdateInventoryProduct(String dbName, int inventoryId, int productDetailId, int quantity) throws SQLException {
    String sql = """
        MERGE InventoryProducts AS target
        USING (SELECT ? AS InventoryID, ? AS ProductDetailID, ? AS Quantity) AS source
        ON (target.InventoryID = source.InventoryID AND target.ProductDetailID = source.ProductDetailID)
        WHEN MATCHED THEN
            UPDATE SET Quantity = target.Quantity + source.Quantity
        WHEN NOT MATCHED THEN
            INSERT (InventoryID, ProductDetailID, Quantity)
            VALUES (source.InventoryID, source.ProductDetailID, source.Quantity);
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, inventoryId);
        ps.setInt(2, productDetailId);
        ps.setInt(3, quantity);
        
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    }
}



}
