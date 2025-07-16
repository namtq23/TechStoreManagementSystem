/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import model.SubscriptionsDTO;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import model.SubscriptionLogDTO;
import util.DBUtil;
import util.Validate;

/**
 *
 * @author admin
 */
public class SubscriptionsDAO {

    public static List<SubscriptionsDTO> getAllSubscriptionSummaryByMethodId(int methodId) throws SQLException {
        List<SubscriptionsDTO> list = new ArrayList<>();

        String sql = """
        SELECT 
            smp.SubscriptionMonths,
            smp.Price,
            COUNT(usm.OwnerID) AS TotalUsers
        FROM ServiceMethodPrice smp
        LEFT JOIN UserServiceMethod usm 
            ON smp.MethodID = usm.MethodID 
            AND smp.SubscriptionMonths = usm.SubscriptionMonths
            AND usm.Status != 'TRIAL'
        WHERE smp.MethodID = ?
        GROUP BY smp.SubscriptionMonths, smp.Price
        ORDER BY smp.SubscriptionMonths
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, methodId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int subscriptionMonths = rs.getInt("SubscriptionMonths");
                    Double price = rs.getDouble("Price");
                    int totalUsers = rs.getInt("TotalUsers");

                    String subscriptionName = subscriptionMonths + " tháng";
                    String formattedPrice = Validate.formatCostPriceToVND(price);
                    SubscriptionsDTO dto = new SubscriptionsDTO(
                            String.valueOf(totalUsers),
                            methodId,
                            subscriptionName,
                            formattedPrice
                    );

                    list.add(dto);
                }
            }
        }

        return list;
    }

    public static List<SubscriptionLogDTO> getAllSubscriptionLogs() throws SQLException {
        List<SubscriptionLogDTO> list = new ArrayList<>();

        String sql = """
        SELECT 
            sl.LogID,
            sl.OwnerID,
            so.FullName AS OwnerName,
            CONCAT(smp.SubscriptionMonths, ' tháng') AS SubscriptionName,
            FORMAT(smp.Price, 'N0') AS SubscriptionPrice, -- định dạng 700,000
            sl.Status,
            sl.CreatedAt,
            DATEDIFF(MINUTE, sl.CreatedAt, GETDATE()) AS MinutesAgo
        FROM SubscriptionLogs sl
        JOIN ShopOwner so ON sl.OwnerID = so.OwnerID
        JOIN ServiceMethodPrice smp ON sl.MethodID = smp.MethodID AND sl.SubscriptionMonths = smp.SubscriptionMonths
        ORDER BY sl.CreatedAt DESC
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SubscriptionLogDTO log = new SubscriptionLogDTO(
                        rs.getInt("LogID"),
                        rs.getInt("OwnerID"),
                        rs.getString("OwnerName"),
                        rs.getString("SubscriptionName"),
                        rs.getString("SubscriptionPrice"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getInt("MinutesAgo")
                );

                list.add(log);
            }
        }

        return list;
    }

    public static boolean insertSubscriptionLog(int ownerId, int methodId, int months, String status) {
        String sql = "INSERT INTO SubscriptionLogs (OwnerID, MethodID, SubscriptionMonths, Status) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, ownerId);
            stmt.setInt(2, methodId);
            stmt.setInt(3, months);
            stmt.setString(4, status);

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<SubscriptionLogDTO> getSubscriptionLogsByOwnerId(int ownerId, int offset, int limit, LocalDate fromDate, LocalDate toDate) throws SQLException {
        List<SubscriptionLogDTO> list = new ArrayList<>();

        // Câu SQL base
        StringBuilder sql = new StringBuilder("""
        SELECT sl.LogID, sl.OwnerID,
               CONCAT(smp.SubscriptionMonths, ' tháng') AS PackageName,
               FORMAT(smp.Price, 'N0') AS Price,
               sl.Status, sl.CreatedAt,
               DATEDIFF(MINUTE, sl.CreatedAt, GETDATE()) AS MinutesAgo
        FROM SubscriptionLogs sl
        JOIN ServiceMethodPrice smp ON sl.MethodID = smp.MethodID AND sl.SubscriptionMonths = smp.SubscriptionMonths
        WHERE sl.OwnerID = ?
    """);

        // Thêm điều kiện lọc ngày nếu fromDate và toDate khác null
        boolean hasDateFilter = (fromDate != null && toDate != null);
        if (hasDateFilter) {
            sql.append(" AND CAST(sl.CreatedAt AS DATE) BETWEEN ? AND ? ");
        }

        sql.append(" ORDER BY sl.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            stmt.setInt(paramIndex++, ownerId);

            if (hasDateFilter) {
                stmt.setDate(paramIndex++, java.sql.Date.valueOf(fromDate));
                stmt.setDate(paramIndex++, java.sql.Date.valueOf(toDate));
            }

            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex++, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SubscriptionLogDTO dto = new SubscriptionLogDTO(
                            rs.getInt("LogID"),
                            rs.getInt("OwnerID"),
                            null,
                            rs.getString("PackageName"),
                            rs.getString("Price"),
                            rs.getString("Status"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getInt("MinutesAgo")
                    );
                    list.add(dto);
                }
            }
        }

        return list;
    }

    public int countSubscriptionLogsByOwnerId(int ownerId, LocalDate fromDate, LocalDate toDate) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM SubscriptionLogs WHERE OwnerID = ?");

        boolean hasDateFilter = (fromDate != null && toDate != null);
        if (hasDateFilter) {
            sql.append(" AND CAST(CreatedAt AS DATE) BETWEEN ? AND ?");
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            stmt.setInt(paramIndex++, ownerId);

            if (hasDateFilter) {
                stmt.setDate(paramIndex++, java.sql.Date.valueOf(fromDate));
                stmt.setDate(paramIndex++, java.sql.Date.valueOf(toDate));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    public static double getTotalSpentByOwner(int ownerId) throws SQLException {
        String sql = """
        SELECT SUM(p.Price) AS TotalSpent
        FROM SubscriptionLogs l
        JOIN ServiceMethodPrice p 
            ON l.MethodID = p.MethodID AND l.SubscriptionMonths = p.SubscriptionMonths
        WHERE l.OwnerID = ? AND l.Status = 'Done'
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("TotalSpent");
                }
            }
        }

        return 0.0;
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(SubscriptionsDAO.getTotalSpentByOwner(1));
    }

}
