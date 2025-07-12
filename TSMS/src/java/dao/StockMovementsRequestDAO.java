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
                    smr.setMovementType(rs.getString("MovementType"));
                    smr.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    smr.setCreatedBy(rs.getInt("CreatedBy"));
                    smr.setCreatedByName(rs.getString("CreatedByName"));
                    smr.setNote(rs.getString("Note"));
                    smr.setTotalAmount(rs.getBigDecimal("TotalAmount"));

                    // ✅ Thêm dòng này để lấy responseStatus
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
public static void insertMovementResponse(
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




}
