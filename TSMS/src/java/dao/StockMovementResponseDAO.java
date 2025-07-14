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



}
