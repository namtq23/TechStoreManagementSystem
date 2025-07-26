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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Trieu Quang Nam
 */
public class StockMovementsRequestDAO {

    //Nam: Lấy yêu cầu nhập hàng từ chủ shop với từng kho tương ứng
// Method với filter và pagination
public List<StockMovementsRequest> getImportRequestsWithFilter(String dbName, String warehouseId, 
                                                               String fromDate, String toDate, String branchId, 
                                                               String supplierId, String status, 
                                                               int page, int pageSize) {
    List<StockMovementsRequest> list = new ArrayList<>();
    int offset = (page - 1) * pageSize;

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
            COALESCE(smrsp.ResponseStatus, 'pending') AS ResponseStatus
        FROM StockMovementsRequest smr
        LEFT JOIN Suppliers s ON smr.FromSupplierID = s.SupplierID
        LEFT JOIN Users u ON smr.CreatedBy = u.UserID
        LEFT JOIN StockMovementDetail smd ON smr.MovementID = smd.MovementID
        LEFT JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        LEFT JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN (
            SELECT MovementID, ResponseStatus,
                   ROW_NUMBER() OVER (PARTITION BY MovementID ORDER BY ResponseAt DESC) as rn
            FROM StockMovementResponses
        ) smrsp ON smr.MovementID = smrsp.MovementID AND smrsp.rn = 1
        WHERE smr.ToWarehouseID = ?
          AND smr.MovementType = 'import'
    """);

    List<Object> params = new ArrayList<>();
    params.add(warehouseId);

    // Add date filters
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }

    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }

    // Add branch filter
    if (branchId != null && !branchId.trim().isEmpty()) {
        sql.append(" AND smr.ToBranchID = ?");
        params.add(branchId);
    }

    // Add supplier filter
    if (supplierId != null && !supplierId.trim().isEmpty()) {
        sql.append(" AND smr.FromSupplierID = ?");
        params.add(supplierId);
    }

    sql.append("""
        GROUP BY 
            smr.MovementID, smr.FromSupplierID, s.SupplierName,
            smr.FromWarehouseID, smr.ToBranchID, smr.ToWarehouseID,
            smr.MovementType, smr.CreatedAt, smr.CreatedBy, u.FullName, smr.Note,
            smrsp.ResponseStatus
    """);

    // Add status filter after GROUP BY
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" HAVING COALESCE(smrsp.ResponseStatus, 'pending') = ?");
        params.add(status);
    }

    sql.append(" ORDER BY smr.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    params.add(offset);
    params.add(pageSize);

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

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
        System.err.println("Error in getImportRequestsWithFilter(): " + e.getMessage());
        e.printStackTrace();
    }

    return list;
}

// Method count cho pagination
public int getImportRequestsCount(String dbName, String warehouseId, 
                                 String fromDate, String toDate, String branchId, 
                                 String supplierId, String status) {
    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT COUNT(DISTINCT smr.MovementID)
        FROM StockMovementsRequest smr
        LEFT JOIN (
            SELECT MovementID, ResponseStatus,
                   ROW_NUMBER() OVER (PARTITION BY MovementID ORDER BY ResponseAt DESC) as rn
            FROM StockMovementResponses
        ) smrsp ON smr.MovementID = smrsp.MovementID AND smrsp.rn = 1
        WHERE smr.ToWarehouseID = ?
          AND smr.MovementType = 'import'
    """);

    List<Object> params = new ArrayList<>();
    params.add(warehouseId);

    // Add date filters
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }

    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }

    // Add branch filter
    if (branchId != null && !branchId.trim().isEmpty()) {
        sql.append(" AND smr.ToBranchID = ?");
        params.add(branchId);
    }

    // Add supplier filter
    if (supplierId != null && !supplierId.trim().isEmpty()) {
        sql.append(" AND smr.FromSupplierID = ?");
        params.add(supplierId);
    }

    // Add status filter
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" AND COALESCE(smrsp.ResponseStatus, 'pending') = ?");
        params.add(status);
    }

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getImportRequestsCount(): " + e.getMessage());
        e.printStackTrace();
    }

    return 0;
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
// Method với filter và pagination cho export
public List<StockMovementsRequest> getExportRequestsWithFilter(String dbName, String warehouseId, 
                                                               String fromDate, String toDate, String branchId, 
                                                               String status, int page, int pageSize) {
    List<StockMovementsRequest> list = new ArrayList<>();
    int offset = (page - 1) * pageSize;

    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT 
            smr.MovementID,
            smr.FromBranchID,
            smr.FromWarehouseID,
            smr.FromSupplierID,
            smr.ToBranchID,
            smr.ToWarehouseID,
            smr.MovementType,
            smr.CreatedAt,
            smr.CreatedBy,
            smr.Note,
            CASE 
                WHEN smr.FromBranchID IS NOT NULL THEN b1.BranchName
                WHEN smr.FromWarehouseID IS NOT NULL THEN w1.WarehouseName
                WHEN smr.FromSupplierID IS NOT NULL THEN s.SupplierName
                ELSE 'Không xác định'
            END AS FromName,
            CASE 
                WHEN smr.ToBranchID IS NOT NULL THEN b2.BranchName
                WHEN smr.ToWarehouseID IS NOT NULL THEN w2.WarehouseName
                ELSE 'Không xác định'
            END AS ToName,
            u.FullName AS CreatedByName,
            ISNULL(SUM(smd.Quantity * p.CostPrice), 0) AS TotalAmount,
            COALESCE(smrsp.ResponseStatus, 'pending') AS ResponseStatus
        FROM StockMovementsRequest smr
        LEFT JOIN Branches b1 ON smr.FromBranchID = b1.BranchID
        LEFT JOIN Branches b2 ON smr.ToBranchID = b2.BranchID
        LEFT JOIN Warehouses w1 ON smr.FromWarehouseID = w1.WarehouseID
        LEFT JOIN Warehouses w2 ON smr.ToWarehouseID = w2.WarehouseID
        LEFT JOIN Suppliers s ON smr.FromSupplierID = s.SupplierID
        LEFT JOIN Users u ON smr.CreatedBy = u.UserID
        LEFT JOIN StockMovementDetail smd ON smr.MovementID = smd.MovementID
        LEFT JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        LEFT JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN (
            SELECT MovementID, ResponseStatus,
                   ROW_NUMBER() OVER (PARTITION BY MovementID ORDER BY ResponseAt DESC) as rn
            FROM StockMovementResponses
        ) smrsp ON smr.MovementID = smrsp.MovementID AND smrsp.rn = 1
        WHERE smr.MovementType = 'export'
          AND (
              -- Export orders TO this warehouse (from any source)
              smr.ToWarehouseID = ? OR
              
              -- Export orders FROM this warehouse (all valid statuses except cancelled)
              (smr.FromWarehouseID = ? AND COALESCE(smrsp.ResponseStatus, 'pending') IN ('pending', 'processing', 'transfer', 'completed'))
          )
    """);

    List<Object> params = new ArrayList<>();
    params.add(warehouseId);
    params.add(warehouseId);

    // Add date filters
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }

    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }

    // Add branch filter
    if (branchId != null && !branchId.trim().isEmpty()) {
        sql.append(" AND (smr.FromBranchID = ? OR smr.ToBranchID = ?)");
        params.add(branchId);
        params.add(branchId);
    }

    sql.append("""
        GROUP BY 
            smr.MovementID, smr.FromBranchID, smr.FromWarehouseID, smr.FromSupplierID, smr.ToBranchID, smr.ToWarehouseID,
            smr.MovementType, smr.CreatedAt, smr.CreatedBy, smr.Note,
            b1.BranchName, b2.BranchName, w1.WarehouseName, w2.WarehouseName, s.SupplierName, u.FullName,
            smrsp.ResponseStatus
    """);

    // Add status filter after GROUP BY
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" HAVING COALESCE(smrsp.ResponseStatus, 'pending') = ?");
        params.add(status);
    }

    sql.append(" ORDER BY smr.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    params.add(offset);
    params.add(pageSize);

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockMovementsRequest smr = new StockMovementsRequest();
                smr.setMovementID(rs.getInt("MovementID"));
                smr.setFromBranchID(rs.getObject("FromBranchID") != null ? rs.getInt("FromBranchID") : null);
                smr.setFromWarehouseID(rs.getObject("FromWarehouseID") != null ? rs.getInt("FromWarehouseID") : null);
                smr.setFromSupplierID(rs.getObject("FromSupplierID") != null ? rs.getInt("FromSupplierID") : null);
                smr.setToBranchID(rs.getObject("ToBranchID") != null ? rs.getInt("ToBranchID") : null);
                smr.setToWarehouseID(rs.getObject("ToWarehouseID") != null ? rs.getInt("ToWarehouseID") : null);
                smr.setMovementType(rs.getString("MovementType"));
                smr.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                smr.setCreatedBy(rs.getInt("CreatedBy"));
                smr.setNote(rs.getString("Note"));
                smr.setFromBranchName(rs.getString("FromName"));
                smr.setCreatedByName(rs.getString("CreatedByName"));
                smr.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                smr.setResponseStatus(rs.getString("ResponseStatus"));

                String toName = rs.getString("ToName");
                String originalNote = smr.getNote();
                smr.setNote(originalNote + "|TO:" + toName);

                list.add(smr);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getExportRequestsWithFilter(): " + e.getMessage());
        e.printStackTrace();
    }

    return list;
}


// Method count cho pagination export
public int getExportRequestsCount(String dbName, String warehouseId, 
                                 String fromDate, String toDate, String branchId, String status) {
    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT COUNT(DISTINCT smr.MovementID)
        FROM StockMovementsRequest smr
        LEFT JOIN (
            SELECT MovementID, ResponseStatus,
                   ROW_NUMBER() OVER (PARTITION BY MovementID ORDER BY ResponseAt DESC) as rn
            FROM StockMovementResponses
        ) smrsp ON smr.MovementID = smrsp.MovementID AND smrsp.rn = 1
        WHERE smr.MovementType = 'export'
          AND (
              -- Export orders TO this warehouse
              smr.ToWarehouseID = ? OR
              
              -- Export orders FROM this warehouse (all valid statuses except cancelled)
              (smr.FromWarehouseID = ? AND COALESCE(smrsp.ResponseStatus, 'pending') IN ('pending', 'processing', 'transfer', 'completed'))
          )
    """);

    List<Object> params = new ArrayList<>();
    params.add(warehouseId);
    params.add(warehouseId);

    // Add date filters
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }

    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }

    // Add branch filter
    if (branchId != null && !branchId.trim().isEmpty()) {
        sql.append(" AND (smr.FromBranchID = ? OR smr.ToBranchID = ?)");
        params.add(branchId);
        params.add(branchId);
    }

    // Add status filter
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" AND COALESCE(smrsp.ResponseStatus, 'pending') = ?");
        params.add(status);
    }

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getExportRequestsCount(): " + e.getMessage());
        e.printStackTrace();
    }

    return 0;
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

// Method với filter và pagination
public List<StockMovementsRequest> getExportRequestsByToBranchWithFilter(String dbName, String branchId, 
                                                                         String fromDate, String toDate, String status, 
                                                                         int page, int pageSize) {
    List<StockMovementsRequest> list = new ArrayList<>();
    int offset = (page - 1) * pageSize;

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
            COALESCE(smrsp.ResponseStatus, 'pending') AS ResponseStatus
        FROM StockMovementsRequest smr
        LEFT JOIN Branches b1 ON smr.FromBranchID = b1.BranchID
        LEFT JOIN Branches b2 ON smr.ToBranchID = b2.BranchID
        LEFT JOIN Warehouses w1 ON smr.FromWarehouseID = w1.WarehouseID
        LEFT JOIN Warehouses w2 ON smr.ToWarehouseID = w2.WarehouseID
        LEFT JOIN Users u ON smr.CreatedBy = u.UserID
        LEFT JOIN StockMovementDetail smd ON smr.MovementID = smd.MovementID
        LEFT JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        LEFT JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN (
            SELECT MovementID, ResponseStatus,
                   ROW_NUMBER() OVER (PARTITION BY MovementID ORDER BY ResponseAt DESC) as rn
            FROM StockMovementResponses
        ) smrsp ON smr.MovementID = smrsp.MovementID AND smrsp.rn = 1
        WHERE smr.MovementType = 'export'
          AND (
              (smr.FromBranchID = ? AND smr.ToBranchID IS NULL) OR
              (smr.FromBranchID IS NULL AND smr.ToBranchID = ?) OR
              (smr.FromBranchID = ? AND smr.ToBranchID IS NOT NULL) OR
              (smr.FromBranchID IS NOT NULL AND smr.ToBranchID = ?)
          )
    """);

    List<Object> params = new ArrayList<>();
    params.add(branchId);
    params.add(branchId);
    params.add(branchId);
    params.add(branchId);

    // Add date filters
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }

    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }

    sql.append("""
        GROUP BY 
            smr.MovementID, smr.FromBranchID, smr.FromWarehouseID, smr.ToBranchID, smr.ToWarehouseID,
            smr.MovementType, smr.CreatedAt, smr.CreatedBy, smr.Note,
            b1.BranchName, b2.BranchName, w1.WarehouseName, w2.WarehouseName, u.FullName,
            smrsp.ResponseStatus
    """);

    // Add status filter after GROUP BY
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" HAVING COALESCE(smrsp.ResponseStatus, 'pending') = ?");
        params.add(status);
    }

    sql.append(" ORDER BY smr.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    params.add(offset);
    params.add(pageSize);

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

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
                smr.setFromBranchName(rs.getString("FromName"));
                smr.setCreatedByName(rs.getString("CreatedByName"));
                smr.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                smr.setResponseStatus(rs.getString("ResponseStatus"));

                String toName = rs.getString("ToName");
                String originalNote = smr.getNote();
                smr.setNote(originalNote + "|TO:" + toName);

                list.add(smr);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getExportRequestsByToBranchWithFilter(): " + e.getMessage());
        e.printStackTrace();
    }

    return list;
}

// Method count cho pagination
public int getExportRequestsByToBranchCount(String dbName, String branchId, 
                                           String fromDate, String toDate, String status) {
    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT COUNT(DISTINCT smr.MovementID)
        FROM StockMovementsRequest smr
        LEFT JOIN (
            SELECT MovementID, ResponseStatus,
                   ROW_NUMBER() OVER (PARTITION BY MovementID ORDER BY ResponseAt DESC) as rn
            FROM StockMovementResponses
        ) smrsp ON smr.MovementID = smrsp.MovementID AND smrsp.rn = 1
        WHERE smr.MovementType = 'export'
          AND (
              (smr.FromBranchID = ? AND smr.ToBranchID IS NULL) OR
              (smr.FromBranchID IS NULL AND smr.ToBranchID = ?) OR
              (smr.FromBranchID = ? AND smr.ToBranchID IS NOT NULL) OR
              (smr.FromBranchID IS NOT NULL AND smr.ToBranchID = ?)
          )
    """);

    List<Object> params = new ArrayList<>();
    params.add(branchId);
    params.add(branchId);
    params.add(branchId);
    params.add(branchId);

    // Add date filters
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }

    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }

    // Add status filter
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" AND COALESCE(smrsp.ResponseStatus, 'pending') = ?");
        params.add(status);
    }

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getExportRequestsByToBranchCount(): " + e.getMessage());
        e.printStackTrace();
    }

    return 0;
}



public List<StockMovementsRequest> getMovementsWithFilters(String dbName, String fromDate, String toDate, 
                                                          String status, String movementType, 
                                                          int page, int pageSize) {
    List<StockMovementsRequest> movements = new ArrayList<>();
    int offset = (page - 1) * pageSize;

    StringBuilder sql = new StringBuilder();
    sql.append("""
        WITH FilteredMovements AS (
            SELECT 
                smr.MovementID,
                smr.FromSupplierID,
                smr.FromBranchID,
                smr.FromWarehouseID,
                smr.ToBranchID,
                smr.ToWarehouseID,
                smr.MovementType,
                smr.CreatedAt,
                smr.CreatedBy,
                smr.Note,
                s.SupplierName AS FromSupplierName,
                b1.BranchName AS FromBranchName,
                w1.WarehouseName AS FromWarehouseName,
                b2.BranchName AS ToBranchName,
                w2.WarehouseName AS ToWarehouseName,
                u.FullName AS CreatedByName,
                COALESCE((SELECT TOP 1 ResponseStatus FROM StockMovementResponses smr_resp 
                         WHERE smr_resp.MovementID = smr.MovementID ORDER BY ResponseAt DESC), 'pending') AS ResponseStatus,
                ISNULL((SELECT SUM(smd.Quantity * p.CostPrice) 
                       FROM StockMovementDetail smd 
                       INNER JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
                       INNER JOIN Products p ON pd.ProductID = p.ProductID
                       WHERE smd.MovementID = smr.MovementID), 0) AS TotalAmount
            FROM StockMovementsRequest smr
            LEFT JOIN Suppliers s ON smr.FromSupplierID = s.SupplierID
            LEFT JOIN Branches b1 ON smr.FromBranchID = b1.BranchID
            LEFT JOIN Branches b2 ON smr.ToBranchID = b2.BranchID
            LEFT JOIN Warehouses w1 ON smr.FromWarehouseID = w1.WarehouseID
            LEFT JOIN Warehouses w2 ON smr.ToWarehouseID = w2.WarehouseID
            LEFT JOIN Users u ON smr.CreatedBy = u.UserID
            WHERE 1=1
    """);

    List<Object> params = new ArrayList<>();
    
    // Add filters với StringBuilder
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }
    
    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }
    
    if (movementType != null && !movementType.trim().isEmpty()) {
        sql.append(" AND smr.MovementType = ?");
        params.add(movementType);
    }
    
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" AND COALESCE((SELECT TOP 1 ResponseStatus FROM StockMovementResponses smr_resp WHERE smr_resp.MovementID = smr.MovementID ORDER BY ResponseAt DESC), 'pending') = ?");
        params.add(status);
    }

    sql.append("""
        )
        SELECT * FROM FilteredMovements
        ORDER BY CreatedAt DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """);

    params.add(offset);
    params.add(pageSize);

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {

        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockMovementsRequest smr = new StockMovementsRequest();
                
                smr.setMovementID(rs.getInt("MovementID"));
                smr.setMovementType(rs.getString("MovementType"));
                smr.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                smr.setCreatedBy(rs.getInt("CreatedBy"));
                smr.setNote(rs.getString("Note"));
                
                // Handle nullable foreign keys
                smr.setFromSupplierID(rs.getObject("FromSupplierID") != null ? rs.getInt("FromSupplierID") : null);
                smr.setFromBranchID(rs.getObject("FromBranchID") != null ? rs.getInt("FromBranchID") : null);
                smr.setFromWarehouseID(rs.getObject("FromWarehouseID") != null ? rs.getInt("FromWarehouseID") : null);
                smr.setToBranchID(rs.getObject("ToBranchID") != null ? rs.getInt("ToBranchID") : null);
                smr.setToWarehouseID(rs.getObject("ToWarehouseID") != null ? rs.getInt("ToWarehouseID") : null);
                
                // Set names
                smr.setFromSupplierName(rs.getString("FromSupplierName"));
                smr.setFromBranchName(rs.getString("FromBranchName"));
                smr.setFromWarehouseName(rs.getString("FromWarehouseName"));
                smr.setToBranchName(rs.getString("ToBranchName"));
                smr.setToWarehouseName(rs.getString("ToWarehouseName"));
                smr.setCreatedByName(rs.getString("CreatedByName"));
                
                smr.setTotalAmount(rs.getBigDecimal("TotalAmount"));
                smr.setResponseStatus(rs.getString("ResponseStatus"));
                
                movements.add(smr);
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getMovementsWithFilters(): " + e.getMessage());
        e.printStackTrace();
    }

    return movements;
}


public int getMovementsCount(String dbName, String fromDate, String toDate, 
                            String status, String movementType) {
    StringBuilder sql = new StringBuilder();
    sql.append("SELECT COUNT(DISTINCT smr.MovementID) FROM StockMovementsRequest smr WHERE 1=1");
    
    List<Object> params = new ArrayList<>();
    
    // Add filters với StringBuilder (giống như method trên)
    if (fromDate != null && !fromDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) >= ?");
        params.add(fromDate);
    }
    
    if (toDate != null && !toDate.trim().isEmpty()) {
        sql.append(" AND CAST(smr.CreatedAt AS DATE) <= ?");
        params.add(toDate);
    }
    
    if (movementType != null && !movementType.trim().isEmpty()) {
        sql.append(" AND smr.MovementType = ?");
        params.add(movementType);
    }
    
    if (status != null && !status.trim().isEmpty()) {
        sql.append(" AND COALESCE((SELECT TOP 1 ResponseStatus FROM StockMovementResponses smr_resp WHERE smr_resp.MovementID = smr.MovementID ORDER BY ResponseAt DESC), 'pending') = ?");
        params.add(status);
    }
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
    } catch (SQLException e) {
        System.err.println("Error in getMovementsCount(): " + e.getMessage());
        e.printStackTrace();
    }
    
    return 0;
}


public StockMovementsRequest getMovementById(String dbName, int movementID) {
    String sql = """
        SELECT 
            smr.MovementID, smr.MovementType, smr.CreatedAt, smr.CreatedBy, smr.Note,
            smr.FromSupplierID, smr.FromBranchID, smr.FromWarehouseID,
            smr.ToBranchID, smr.ToWarehouseID,
            s.SupplierName AS FromSupplierName,
            b1.BranchName AS FromBranchName,
            w1.WarehouseName AS FromWarehouseName,
            b2.BranchName AS ToBranchName,
            w2.WarehouseName AS ToWarehouseName,
            u.FullName AS CreatedByName,
            COALESCE((SELECT TOP 1 ResponseStatus FROM StockMovementResponses smr_resp 
                     WHERE smr_resp.MovementID = smr.MovementID ORDER BY ResponseAt DESC), 'pending') AS ResponseStatus
        FROM StockMovementsRequest smr
        LEFT JOIN Suppliers s ON smr.FromSupplierID = s.SupplierID
        LEFT JOIN Branches b1 ON smr.FromBranchID = b1.BranchID
        LEFT JOIN Branches b2 ON smr.ToBranchID = b2.BranchID
        LEFT JOIN Warehouses w1 ON smr.FromWarehouseID = w1.WarehouseID
        LEFT JOIN Warehouses w2 ON smr.ToWarehouseID = w2.WarehouseID
        LEFT JOIN Users u ON smr.CreatedBy = u.UserID
        WHERE smr.MovementID = ?
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, movementID);
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                StockMovementsRequest movement = new StockMovementsRequest();
                
                movement.setMovementID(rs.getInt("MovementID"));
                movement.setMovementType(rs.getString("MovementType"));
                movement.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                movement.setCreatedBy(rs.getInt("CreatedBy"));
                movement.setNote(rs.getString("Note"));
                
                // Handle nullable foreign keys
                Object fromSupplierId = rs.getObject("FromSupplierID");
                movement.setFromSupplierID(fromSupplierId != null ? rs.getInt("FromSupplierID") : null);
                
                Object fromBranchId = rs.getObject("FromBranchID");
                movement.setFromBranchID(fromBranchId != null ? rs.getInt("FromBranchID") : null);
                
                Object fromWarehouseId = rs.getObject("FromWarehouseID");
                movement.setFromWarehouseID(fromWarehouseId != null ? rs.getInt("FromWarehouseID") : null);
                
                Object toBranchId = rs.getObject("ToBranchID");
                movement.setToBranchID(toBranchId != null ? rs.getInt("ToBranchID") : null);
                
                Object toWarehouseId = rs.getObject("ToWarehouseID");
                movement.setToWarehouseID(toWarehouseId != null ? rs.getInt("ToWarehouseID") : null);
                
                // Set names
                movement.setFromSupplierName(rs.getString("FromSupplierName"));
                movement.setFromBranchName(rs.getString("FromBranchName"));
                movement.setFromWarehouseName(rs.getString("FromWarehouseName"));
                movement.setToBranchName(rs.getString("ToBranchName"));
                movement.setToWarehouseName(rs.getString("ToWarehouseName"));
                movement.setCreatedByName(rs.getString("CreatedByName"));
                movement.setResponseStatus(rs.getString("ResponseStatus"));
                
                return movement;
            }
        }
    } catch (SQLException e) {
        System.err.println("Error in getMovementById: " + e.getMessage());
        e.printStackTrace();
    }
    
    return null;
}



}
