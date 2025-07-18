/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.StockMovementsRequest;
import util.DBUtil;
import java.sql.Timestamp;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Trieu Quang Nam
 */
public class StockMovementsRequestDAO {

    //Nam: Lấy yêu cầu nhập hàng từ chủ shop với từng kho tương ứng
public List<StockMovementsRequest> getImportRequests(String dbName, String warehouseId) {
    List<StockMovementsRequest> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT 
            smr.MovementID,
            smr.FromSupplierID,
            s.SupplierName AS FromSupplierName,
            smr.FromWarehouseID,
            smr.ToBranchID,
            smr.ToWarehouseID,
            smr.MovementType,
            smr.CreatedAt,
            smr.CreatedBy,
            u.FullName AS CreatedByName,
            smr.Note,
            ISNULL(SUM(smd.Quantity * p.CostPrice), 0) AS TotalAmount,
            MAX(smrsp.ResponseStatus) AS ResponseStatus
        FROM StockMovementsRequest smr
        LEFT JOIN Suppliers s ON smr.FromSupplierID = s.SupplierID
        LEFT JOIN Users u ON smr.CreatedBy = u.UserID
        LEFT JOIN StockMovementDetail smd ON smr.MovementID = smd.MovementID
        LEFT JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        LEFT JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN StockMovementResponses smrsp ON smr.MovementID = smrsp.MovementID
        WHERE smr.ToWarehouseID = ?
          AND smr.MovementType = 'import'
        GROUP BY 
            smr.MovementID, smr.FromSupplierID, s.SupplierName,
            smr.FromWarehouseID, smr.ToBranchID, smr.ToWarehouseID,
            smr.MovementType, smr.CreatedAt, smr.CreatedBy, u.FullName, smr.Note
        ORDER BY smr.CreatedAt DESC
    """);

    try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        ps.setString(1, warehouseId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockMovementsRequest smr = new StockMovementsRequest();
                smr.setMovementID(rs.getInt("MovementID"));
                smr.setFromSupplierID(rs.getObject("FromSupplierID") != null ? rs.getInt("FromSupplierID") : null);
                smr.setFromSupplierName(rs.getString("FromSupplierName"));
                smr.setFromWarehouseID(rs.getObject("FromWarehouseID") != null ? rs.getInt("FromWarehouseID") : null);
                smr.setToBranchID(rs.getObject("ToBranchID") != null ? rs.getInt("ToBranchID") : null);
                smr.setToWarehouseID(rs.getObject("ToWarehouseID") != null ? rs.getInt("ToWarehouseID") : null);
                smr.setMovementType(rs.getString("MovementType"));
                smr.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                smr.setCreatedBy(rs.getInt("CreatedBy"));
                smr.setCreatedByName(rs.getString("CreatedByName"));
                smr.setNote(rs.getString("Note"));
                smr.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                smr.setResponseStatus(rs.getString("ResponseStatus"));

                list.add(smr);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getImportRequests(): " + e.getMessage());
        e.printStackTrace();
    }

    return list;
}


public int insertMovementRequest(
        String dbName,
        int fromSupplierId,
        int toWarehouseId,
        String movementType,
        String note,
        int createdBy
) throws SQLException {
    String sql = """
        INSERT INTO StockMovementsRequest (
            FromSupplierID, FromBranchID, FromWarehouseID, 
            ToBranchID, ToWarehouseID, 
            MovementType, Note, CreatedBy, CreatedAt
        ) VALUES (?, NULL, NULL, NULL, ?, ?, ?, ?, GETDATE());
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

        ps.setInt(1, fromSupplierId);
        ps.setInt(2, toWarehouseId);
        ps.setString(3, movementType);
        ps.setString(4, note);
        ps.setInt(5, createdBy);

        ps.executeUpdate();

        try (ResultSet rs = ps.getGeneratedKeys()) {
            if (rs.next()) {
                return rs.getInt(1); // MovementID
            }
        }
    }

    throw new SQLException("Không thể lấy MovementID sau khi insert StockMovementsRequest.");
}
//Được sử dụng khi export tạo ra một MovementRequest
public int insertExportMovementRequest(
        String dbName,
        int fromBranchId,
        int toWarehouseId,
        String movementType,
        String note,
        int createdBy
) throws SQLException {
    String sql = """
        INSERT INTO StockMovementsRequest (
            FromSupplierID, FromBranchID, FromWarehouseID, 
            ToBranchID, ToWarehouseID, 
            MovementType, Note, CreatedBy, CreatedAt
        ) VALUES (NULL, ?, NULL, NULL, ?, ?, ?, ?, GETDATE());
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

        ps.setInt(1, fromBranchId);     // FromBranchID
        ps.setInt(2, toWarehouseId);    // ToWarehouseID
        ps.setString(3, movementType);  // "export"
        ps.setString(4, note);
        ps.setInt(5, createdBy);

        ps.executeUpdate();

        try (ResultSet rs = ps.getGeneratedKeys()) {
            if (rs.next()) {
                return rs.getInt(1); // MovementID
            }
        }
    }

    throw new SQLException("Không thể lấy MovementID sau khi insert StockMovementsRequest.");
}



public  void insertMovementResponse(
        String dbName,
        int movementId,
        int userId,
        String status,
        String note
) throws SQLException {
    String sql = """
        INSERT INTO StockMovementResponses (
            MovementID, ResponsedBy, ResponseAt, ResponseStatus, Note
        ) VALUES (?, ?, GETDATE(), ?, ?);
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, movementId);
        ps.setInt(2, userId);
        ps.setString(3, status);
        if (note != null) {
            ps.setString(4, note);
        } else {
            ps.setNull(4, java.sql.Types.NVARCHAR);
        }

        ps.executeUpdate();
    }
}
public List<StockMovementsRequest> getExportRequests(String dbName, String warehouseId) {
    List<StockMovementsRequest> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT 
            smr.MovementID,
            smr.FromBranchID,
            smr.FromWarehouseID,
            smr.ToBranchID,
            smr.ToWarehouseID,
            smr.MovementType,
            smr.CreatedAt,
            smr.CreatedBy,
            smr.Note,
            -- Lấy tên hiển thị
            CASE 
                WHEN smr.FromBranchID IS NOT NULL THEN b1.BranchName
                WHEN smr.FromWarehouseID IS NOT NULL THEN w1.WarehouseName
                ELSE 'Không xác định'
            END AS FromName,
            CASE 
                WHEN smr.ToBranchID IS NOT NULL THEN b2.BranchName
                WHEN smr.ToWarehouseID IS NOT NULL THEN w2.WarehouseName
                ELSE 'Không xác định'
            END AS ToName,
            u.FullName AS CreatedByName,
            ISNULL(SUM(smd.Quantity * p.CostPrice), 0) AS TotalAmount,
            MAX(smrsp.ResponseStatus) AS ResponseStatus
        FROM StockMovementsRequest smr
        LEFT JOIN Branches b1 ON smr.FromBranchID = b1.BranchID
        LEFT JOIN Branches b2 ON smr.ToBranchID = b2.BranchID
        LEFT JOIN Warehouses w1 ON smr.FromWarehouseID = w1.WarehouseID
        LEFT JOIN Warehouses w2 ON smr.ToWarehouseID = w2.WarehouseID
        LEFT JOIN Users u ON smr.CreatedBy = u.UserID
        LEFT JOIN StockMovementDetail smd ON smr.MovementID = smd.MovementID
        LEFT JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        LEFT JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN StockMovementResponses smrsp ON smr.MovementID = smrsp.MovementID
        WHERE smr.MovementType = 'export'
          AND (
              -- Đơn chờ xử lý (chưa xuất)
              (smr.ToWarehouseID = ? AND smr.FromWarehouseID IS NULL) OR  
              -- Đơn đã xuất (đang transfer)
              (smr.FromWarehouseID = ? AND smrsp.ResponseStatus = 'transfer')
          )
        GROUP BY 
            smr.MovementID, smr.FromBranchID, smr.FromWarehouseID, smr.ToBranchID, smr.ToWarehouseID,
            smr.MovementType, smr.CreatedAt, smr.CreatedBy, smr.Note,
            b1.BranchName, b2.BranchName, w1.WarehouseName, w2.WarehouseName, u.FullName
        ORDER BY smr.CreatedAt DESC
    """);

    try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        ps.setString(1, warehouseId);
        ps.setString(2, warehouseId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockMovementsRequest smr = new StockMovementsRequest();
                smr.setMovementID(rs.getInt("MovementID"));
                smr.setFromBranchID(rs.getObject("FromBranchID") != null ? rs.getInt("FromBranchID") : null);
                smr.setFromWarehouseID(rs.getObject("FromWarehouseID") != null ? rs.getInt("FromWarehouseID") : null);
                smr.setToBranchID(rs.getObject("ToBranchID") != null ? rs.getInt("ToBranchID") : null);
                smr.setToWarehouseID(rs.getObject("ToWarehouseID") != null ? rs.getInt("ToWarehouseID") : null);
                smr.setMovementType(rs.getString("MovementType"));
                smr.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                smr.setCreatedBy(rs.getInt("CreatedBy"));
                smr.setNote(rs.getString("Note"));
                
                // Sử dụng lại field có sẵn để lưu tên hiển thị
                smr.setFromBranchName(rs.getString("FromName"));     // Dùng fromBranchName để lưu tên nguồn
                smr.setCreatedByName(rs.getString("CreatedByName")); // Tên người tạo
                smr.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                smr.setResponseStatus(rs.getString("ResponseStatus"));
                
                // Lưu tên đích vào note tạm thời (hoặc có thể extend model)
                String toName = rs.getString("ToName");
                String originalNote = smr.getNote();
                smr.setNote(originalNote + "|TO:" + toName); // Trick: ghép tên đích vào note
                
                list.add(smr);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getExportRequests(): " + e.getMessage());
        e.printStackTrace();
    }

    return list;
}




public void updateExportRequestTransferInfo(String dbName, int movementID, int fromWarehouseID) throws SQLException {
    String sql = """
        UPDATE StockMovementsRequest
        SET FromWarehouseID = ?,
            ToBranchID = FromBranchID,
            FromBranchID = NULL,
            ToWarehouseID = NULL
        WHERE MovementID = ?
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, fromWarehouseID);
        ps.setInt(2, movementID);
        
        int rowsUpdated = ps.executeUpdate();
        if (rowsUpdated > 0) {
            System.out.println("🔄 Cập nhật request thành công: FromWarehouseID=" + fromWarehouseID + 
                             ", ToBranchID=FromBranchID (chuyển từ FromBranchID)");
        } else {
            System.out.println("⚠️ Không tìm thấy request với MovementID=" + movementID);
        }
    }
}

public List<StockMovementsRequest> getExportRequestsByToBranch(String dbName, String branchId) {
    List<StockMovementsRequest> list = new ArrayList<>();

    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT 
            smr.MovementID,
            smr.FromBranchID,
            smr.FromWarehouseID,
            smr.ToBranchID,
            smr.ToWarehouseID,
            smr.MovementType,
            smr.CreatedAt,
            smr.CreatedBy,
            smr.Note,
            -- Lấy tên hiển thị
            CASE 
                WHEN smr.FromBranchID IS NOT NULL THEN b1.BranchName
                WHEN smr.FromWarehouseID IS NOT NULL THEN w1.WarehouseName
                ELSE 'Không xác định'
            END AS FromName,
            CASE 
                WHEN smr.ToBranchID IS NOT NULL THEN b2.BranchName
                WHEN smr.ToWarehouseID IS NOT NULL THEN w2.WarehouseName
                ELSE 'Không xác định'
            END AS ToName,
            u.FullName AS CreatedByName,
            ISNULL(SUM(smd.Quantity * p.CostPrice), 0) AS TotalAmount,
            MAX(smrsp.ResponseStatus) AS ResponseStatus
        FROM StockMovementsRequest smr
        LEFT JOIN Branches b1 ON smr.FromBranchID = b1.BranchID
        LEFT JOIN Branches b2 ON smr.ToBranchID = b2.BranchID
        LEFT JOIN Warehouses w1 ON smr.FromWarehouseID = w1.WarehouseID
        LEFT JOIN Warehouses w2 ON smr.ToWarehouseID = w2.WarehouseID
        LEFT JOIN Users u ON smr.CreatedBy = u.UserID
        LEFT JOIN StockMovementDetail smd ON smr.MovementID = smd.MovementID
        LEFT JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        LEFT JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN StockMovementResponses smrsp ON smr.MovementID = smrsp.MovementID
        WHERE smr.MovementType = 'export'
          AND smr.ToBranchID = ?
        GROUP BY 
            smr.MovementID, smr.FromBranchID, smr.FromWarehouseID, smr.ToBranchID, smr.ToWarehouseID,
            smr.MovementType, smr.CreatedAt, smr.CreatedBy, smr.Note,
            b1.BranchName, b2.BranchName, w1.WarehouseName, w2.WarehouseName, u.FullName
        ORDER BY smr.CreatedAt DESC
    """);

    try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        ps.setString(1, branchId);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockMovementsRequest smr = new StockMovementsRequest();
                smr.setMovementID(rs.getInt("MovementID"));
                smr.setFromBranchID(rs.getObject("FromBranchID") != null ? rs.getInt("FromBranchID") : null);
                smr.setFromWarehouseID(rs.getObject("FromWarehouseID") != null ? rs.getInt("FromWarehouseID") : null);
                smr.setToBranchID(rs.getObject("ToBranchID") != null ? rs.getInt("ToBranchID") : null);
                smr.setToWarehouseID(rs.getObject("ToWarehouseID") != null ? rs.getInt("ToWarehouseID") : null);
                smr.setMovementType(rs.getString("MovementType"));
                smr.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                smr.setCreatedBy(rs.getInt("CreatedBy"));
                smr.setNote(rs.getString("Note"));
                
                // Sử dụng lại field có sẵn để lưu tên hiển thị
                smr.setFromBranchName(rs.getString("FromName"));     // Tên nguồn
                smr.setCreatedByName(rs.getString("CreatedByName")); // Tên người tạo
                smr.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                smr.setResponseStatus(rs.getString("ResponseStatus"));
                
                // Lưu tên đích vào note tạm thời
                String toName = rs.getString("ToName");
                String originalNote = smr.getNote();
                smr.setNote(originalNote + "|TO:" + toName);
                
                list.add(smr);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getExportRequestsByToBranch(): " + e.getMessage());
        e.printStackTrace();
    }

    return list;
}



}
