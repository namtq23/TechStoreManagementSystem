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
import model.Branch;
import util.DBUtil;
/**
 *
 * @author Trieu Quang Nam
 */
public class SerialNumberDAO {
public boolean checkIfSerialExists(String dbName, String serial) {
        String query = "SELECT COUNT(*) FROM  ProductDetailSerialNumber WHERE SerialNumber = ?";
        try (Connection con = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, serial);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
public boolean addScannedSerial(String dbName, int movementDetailID, String serial) {
    String insertSerialSql = """
        INSERT INTO ProductDetailSerialNumber
        (ProductDetailID, SerialNumber, MovementDetailID, WarehouseID, OrderID, BranchID)
        SELECT 
            ProductDetailID,
            ?, ?, NULL, NULL, NULL
        FROM StockMovementDetail
        WHERE MovementDetailID = ?
    """;

    String updateScannedCountSql = """
        UPDATE StockMovementDetail
        SET QuantityScanned = QuantityScanned + 1
        WHERE MovementDetailID = ?
    """;

    String updateResponseStatusSql = """
        UPDATE StockMovementResponses
        SET ResponseStatus = 'processing'
        WHERE MovementID = (
            SELECT MovementID 
            FROM StockMovementDetail 
            WHERE MovementDetailID = ?
        )
        AND ResponseStatus = 'pending'
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName)) {
        conn.setAutoCommit(false);

        // 1. Insert Serial
        try (PreparedStatement ps1 = conn.prepareStatement(insertSerialSql)) {
            ps1.setString(1, serial);                 // SerialNumber
            ps1.setInt(2, movementDetailID);          // MovementDetailID
            ps1.setInt(3, movementDetailID);          // WHERE MovementDetailID = ?
            ps1.executeUpdate();
        }

        // 2. Update scanned quantity
        try (PreparedStatement ps2 = conn.prepareStatement(updateScannedCountSql)) {
            ps2.setInt(1, movementDetailID);
            ps2.executeUpdate();
        }

        // 3. Update response status
        try (PreparedStatement ps3 = conn.prepareStatement(updateResponseStatusSql)) {
            ps3.setInt(1, movementDetailID);
            ps3.executeUpdate();
        }

        conn.commit();
        System.out.println("✅ Thêm serial và cập nhật thành công: " + serial);
        return true;
    } catch (SQLException e) {
        System.err.println("❌ Lỗi khi thêm serial: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}



}
