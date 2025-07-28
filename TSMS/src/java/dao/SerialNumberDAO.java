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
        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(query)) {

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

  public void updateWarehouseForSerials(String dbName, int movementDetailID, int warehouseID) throws SQLException {
    String sql = """
        UPDATE ProductDetailSerialNumber
        SET WarehouseID = ?, 
            MovementDetailID = NULL,
            MovementHistory = CASE 
                WHEN MovementHistory IS NULL THEN CAST(? AS NVARCHAR(MAX))
                ELSE MovementHistory + ',' + CAST(? AS NVARCHAR(MAX))
            END
        WHERE MovementDetailID = ?
          AND OrderID IS NULL 
          AND BranchID IS NULL
          AND WarehouseID IS NULL;
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, warehouseID);
        ps.setInt(2, movementDetailID); // Lưu vào history
        ps.setInt(3, movementDetailID); // Lưu vào history (case ELSE)
        ps.setInt(4, movementDetailID); // WHERE condition
        ps.executeUpdate();
    }
}


    public boolean checkIfSerialAvailableForExport(String dbName, int productDetailID, String serial, int currentMovementDetailID) {
    boolean isInWarehouse = false;
    boolean isNotUsedInOtherExport = false;

    String sqlCheckInWarehouse = """
        SELECT COUNT(*) 
        FROM ProductDetailSerialNumber 
        WHERE ProductDetailID = ? 
          AND SerialNumber = ? 
          AND WarehouseID IS NOT NULL
    """;

    String sqlCheckUsedInExport = """
        SELECT COUNT(*) 
        FROM ProductDetailSerialNumber sn
        JOIN StockMovementDetail d ON sn.MovementDetailID = d.MovementDetailID
        JOIN StockMovementsRequest r ON d.MovementID = r.MovementID
        WHERE sn.ProductDetailID = ? 
          AND sn.SerialNumber = ?
          AND r.MovementType = 'export'
          AND sn.MovementDetailID IS NOT NULL
          AND sn.MovementDetailID <> ?
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName)) {

        // 1. Kiểm tra serial đang nằm trong kho
        try (PreparedStatement ps = conn.prepareStatement(sqlCheckInWarehouse)) {
            ps.setInt(1, productDetailID);
            ps.setString(2, serial);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                isInWarehouse = rs.getInt(1) > 0;
            }
        }

        // 2. Kiểm tra serial có đang dùng trong đơn xuất khác không
        try (PreparedStatement ps = conn.prepareStatement(sqlCheckUsedInExport)) {
            ps.setInt(1, productDetailID);
            ps.setString(2, serial);
            ps.setInt(3, currentMovementDetailID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                isNotUsedInOtherExport = rs.getInt(1) == 0;
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return isInWarehouse && isNotUsedInOtherExport;
}


    public boolean markSerialAsExported(String dbName, int movementDetailID, String serial) {

        String updateSerialSql = """
        UPDATE ProductDetailSerialNumber
        SET 
            MovementDetailID = ?,
            WarehouseID = NULL -- vì đã xuất ra khỏi kho
        WHERE SerialNumber = ?
          AND ProductDetailID = (
              SELECT ProductDetailID
              FROM StockMovementDetail
              WHERE MovementDetailID = ?
          )
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
            SELECT MovementID FROM StockMovementDetail WHERE MovementDetailID = ?
        ) AND ResponseStatus = 'pending'
    """;

        System.out.println("➡️ Đang xử lý xuất serial...");

        try (Connection conn = DBUtil.getConnectionTo(dbName)) {
            conn.setAutoCommit(false);

            // 1. Gắn MovementDetailID + clear WarehouseID
            try (PreparedStatement ps1 = conn.prepareStatement(updateSerialSql)) {
                ps1.setInt(1, movementDetailID); // SET MovementDetailID
                ps1.setString(2, serial);        // WHERE SerialNumber
                ps1.setInt(3, movementDetailID); // SELECT ProductDetailID
                int affected = ps1.executeUpdate();

                if (affected == 0) {
                    conn.rollback();
                    System.err.println("❌ Không tìm thấy serial phù hợp để xuất (hoặc không đúng kho xuất): " + serial);
                    return false;
                }
            }

            // 2. Cập nhật số lượng quét
            try (PreparedStatement ps2 = conn.prepareStatement(updateScannedCountSql)) {
                ps2.setInt(1, movementDetailID);
                ps2.executeUpdate();
            }

            // 3. Cập nhật trạng thái response
            try (PreparedStatement ps3 = conn.prepareStatement(updateResponseStatusSql)) {
                ps3.setInt(1, movementDetailID);
                ps3.executeUpdate();
            }

            conn.commit();
            System.out.println("✅ Đã xác nhận xuất serial: " + serial);
            return true;

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi xác nhận serial xuất kho: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

public void markSerialsAsTransferring(String dbName, int movementDetailID, int warehouseID) throws SQLException {
    // Chỉ cập nhật serial numbers đã được scan trước đó cho movement này
    String sql = """
        UPDATE ProductDetailSerialNumber
        SET WarehouseID = NULL,
            MovementDetailID = ?
        WHERE MovementHistory = ?
          AND WarehouseID = ?
          AND MovementDetailID IS NULL
        """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, movementDetailID);
        ps.setString(2, String.valueOf(movementDetailID));
        ps.setInt(3, warehouseID);
        
        int updatedRows = ps.executeUpdate();
        System.out.println("Updated " + updatedRows + " serial records for export transfer");
    }
}


public boolean markSerialsAsReceivedByBranch(String dbName, int movementDetailId, int branchId) throws SQLException {
    String sql = """
        UPDATE ProductDetailSerialNumber
        SET BranchID = ?,
            WarehouseID = NULL,
            MovementDetailID = NULL,
            MovementHistory = CASE 
                WHEN MovementHistory IS NULL THEN CAST(? AS NVARCHAR(MAX))
                WHEN MovementHistory NOT LIKE '%,' + CAST(? AS NVARCHAR(MAX)) + ',%' 
                     AND MovementHistory NOT LIKE CAST(? AS NVARCHAR(MAX)) + ',%'
                     AND MovementHistory NOT LIKE '%,' + CAST(? AS NVARCHAR(MAX))
                     AND MovementHistory != CAST(? AS NVARCHAR(MAX))
                THEN MovementHistory + ',' + CAST(? AS NVARCHAR(MAX))
                ELSE MovementHistory
            END,
            Status = 1
        WHERE MovementDetailID = ?
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, branchId);
        ps.setInt(2, movementDetailId); // New history if NULL
        ps.setInt(3, movementDetailId); // Check middle
        ps.setInt(4, movementDetailId); // Check start  
        ps.setInt(5, movementDetailId); // Check end
        ps.setInt(6, movementDetailId); // Check exact match
        ps.setInt(7, movementDetailId); // Append if not exists
        ps.setInt(8, movementDetailId); // WHERE condition
        
        int rowsUpdated = ps.executeUpdate();
        System.out.println("🔄 Đã cập nhật " + rowsUpdated + " serial records cho MovementDetailID=" + movementDetailId);
        return rowsUpdated > 0;
    }
}



}
