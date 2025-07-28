package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.StockMovementResponse;
import util.DBUtil;

public class StockMovementResponseDAO {

    public boolean updateResponseStatus(String dbName, int movementID, String newStatus) {
        String sql = """
            UPDATE StockMovementResponses
            SET ResponseStatus = ?
            WHERE MovementID = ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, movementID);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("❌ Lỗi khi cập nhật trạng thái phản hồi: " + e.getMessage());
            return false;
        }
    }
    
   public void markAsCompleted(String dbName, int movementID) throws SQLException {
    String sql = """
        UPDATE StockMovementResponses
        SET ResponseStatus = 'completed', ResponseAt = GETDATE()
        WHERE MovementID = ?;
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, movementID);
        ps.executeUpdate();
    }
}
public void markAsTransferring(String dbName, int movementID) throws SQLException {
    String sql = """
        UPDATE StockMovementResponses
        SET ResponseStatus = 'transfer'
        WHERE MovementID = ?
          AND (ResponseStatus = 'pending' OR ResponseStatus = 'processing')
    """;
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, movementID);
        ps.executeUpdate();
    }
    }
public boolean insertCompletedResponse(String dbName, int movementId, int userId) throws SQLException {
    String sql = """
        INSERT INTO StockMovementResponses (MovementID, ResponsedBy, ResponseStatus, Note)
        VALUES (?, ?, 'completed', N'Đã nhận hàng tại chi nhánh')
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, movementId);
        ps.setInt(2, userId);
        
        int rowsInserted = ps.executeUpdate();
        return rowsInserted > 0;
    }
}


public void markAsCancelled(String dbName, int movementID, int userId) throws SQLException {
    System.out.println("[DAO DEBUG] markAsCancelled called with dbName: " + dbName + ", movementID: " + movementID + ", userId: " + userId);
    
    String sql = """
        UPDATE StockMovementResponses
        SET ResponseStatus = 'cancelled', 
            ResponseAt = GETDATE(),
            ResponsedBy = ?,
            Note = N'Đơn hàng đã được hủy bởi quản lý kho'
        WHERE MovementID = ?
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, userId);      // ResponsedBy
        ps.setInt(2, movementID);  // WHERE MovementID
        
        int rowsAffected = ps.executeUpdate();
        System.out.println("[DAO DEBUG] Rows affected: " + rowsAffected);
        
        if (rowsAffected == 0) {
            System.out.println("[DAO DEBUG] WARNING: No rows were updated!");
        }
    }
}

}
