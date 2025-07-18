package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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


}
