/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.ShopOwnerDTO;
import util.DBUtil;
import java.sql.Timestamp;
import model.ShopOwnerSADTO;
import model.ShopOwnerSubsDTO;
import util.Validate;

/**
 *
 * @author admin
 */
public class ShopOwnerDAO {

    //Phuong
    public List<ShopOwnerDTO> getFilteredShopOwners(String subscription, String statusStr, String fromDate, String toDate, String search,
            int offset, int limit) throws SQLException {
        List<ShopOwnerDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT \n"
                + "    s.*,\n"
                + "    u.MethodID,\n"
                + "    u.TrialStartDate,\n"
                + "    u.TrialEndDate,\n"
                + "    u.Status,\n"
                + "    u.SubscriptionMonths,\n"
                + "    u.SubscriptionStart,\n"
                + "    u.SubscriptionEnd\n"
                + "FROM \n"
                + "    ShopOwner s\n"
                + "LEFT JOIN \n"
                + "    UserServiceMethod u ON s.OwnerID = u.OwnerID WHERE 1=1");

        // Các tham số lọc
        List<Object> params = new ArrayList<>();

        if (subscription != null && !subscription.isEmpty()) {
            if (subscription.equalsIgnoreCase("TRIAL")) {
                sql.append(" AND u.Status = 'TRIAL'");
            } else {
                sql.append(" AND u.SubscriptionMonths = ?");
                params.add(Integer.parseInt(subscription));
            }
        }

        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND IsActive = ?");
            params.add(Integer.parseInt(statusStr));
        }

        if (search != null && !search.isEmpty()) {
            String keywordUnsigned = Validate.normalizeSearch(search);
            sql.append("AND (s.FullNameUnsigned LIKE ? OR s.Phone LIKE ? OR s.ShopName LIKE ?) ");
            String searchPattern = "%" + keywordUnsigned + "%";
            params.add(searchPattern);
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND CreatedAt >= ?");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            LocalDate nextDay = LocalDate.parse(toDate).plusDays(1);
            sql.append(" AND CreatedAt < ?");
            params.add(Timestamp.valueOf(nextDay.atStartOfDay()));
        }

        sql.append(" ORDER BY CreatedAt ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ShopOwnerDTO owner = extractShopOwnerDTOFromResultSet(rs);
                    list.add(owner);
                }
            }
        }

        return list;
    }

    //Phuong
    public List<ShopOwnerSubsDTO> getFilteredShopOwnersFromLogs(String subscription, String statusStr, String fromDate, String toDate, String search,
            int offset, int limit) throws SQLException {
        List<ShopOwnerSubsDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
                                              SELECT 
                                                  s.*, 
                                                  l.MethodID, 
                                                  l.SubscriptionMonths, 
                                                  l.Status AS LogStatus, 
                                                  l.CreatedAt AS LogCreatedAt 
                                              FROM 
                                                  SubscriptionLogs l 
                                              JOIN 
                                                  ShopOwner s ON l.OwnerID = s.OwnerID 
                                              WHERE 
                                                  l.Status = 'Pending' """);

        List<Object> params = new ArrayList<>();

        if (subscription != null && !subscription.isEmpty()) {
            sql.append(" AND l.SubscriptionMonths = ? ");
            params.add(Integer.parseInt(subscription));
        }

        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND s.IsActive = ? ");
            params.add(Integer.parseInt(statusStr));
        }

        if (search != null && !search.isEmpty()) {
            String keywordUnsigned = Validate.normalizeSearch(search);
            sql.append(" AND (s.FullNameUnsigned LIKE ? OR s.Phone LIKE ? OR s.ShopName LIKE ?) ");
            String pattern = "%" + keywordUnsigned + "%";
            params.add(pattern);
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND l.CreatedAt >= ? ");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            LocalDate nextDay = LocalDate.parse(toDate).plusDays(1);
            sql.append(" AND l.CreatedAt < ? ");
            params.add(Timestamp.valueOf(nextDay.atStartOfDay()));
        }

        sql.append(" ORDER BY l.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ");
        params.add(offset);
        params.add(limit);

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ShopOwnerSubsDTO owner = extractShopOwnerSubsDTOFromResultSet(rs);
                    list.add(owner);
                }
            }
        }

        return list;
    }

    //Phuong
    public int countFilteredShopOwners(String subscription, String statusStr, String fromDate, String toDate, String search) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM ShopOwner s "
                + "LEFT JOIN UserServiceMethod u ON s.OwnerID = u.OwnerID "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (subscription != null && !subscription.isEmpty()) {
            if (subscription.equalsIgnoreCase("TRIAL")) {
                sql.append(" AND u.Status = 'TRIAL' ");
            } else {
                sql.append(" AND u.SubscriptionMonths = ? ");
                params.add(Integer.parseInt(subscription));
            }
        }

        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND s.IsActive = ? ");
            params.add(Integer.parseInt(statusStr));
        }

        if (search != null && !search.isEmpty()) {
            String keywordUnsigned = Validate.normalizeSearch(search);
            sql.append("AND (s.FullNameUnsigned LIKE ? OR s.Phone LIKE ? OR s.ShopName LIKE ?) ");
            String searchPattern = "%" + keywordUnsigned + "%";
            params.add(searchPattern);
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND s.CreatedAt >= ? ");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            LocalDate nextDay = LocalDate.parse(toDate).plusDays(1);
            sql.append(" AND s.CreatedAt < ? ");
            params.add(Timestamp.valueOf(nextDay.atStartOfDay()));
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    //Phuong
    public int countFilteredShopOwnersFromLogs(String subscription, String statusStr, String fromDate, String toDate, String search) throws SQLException {
        int total = 0;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) \n"
                + "FROM SubscriptionLogs l \n"
                + "JOIN ShopOwner s ON l.OwnerID = s.OwnerID \n"
                + "WHERE l.Status = 'Pending' ");

        List<Object> params = new ArrayList<>();

        if (subscription != null && !subscription.isEmpty()) {
            sql.append(" AND l.SubscriptionMonths = ? ");
            params.add(Integer.parseInt(subscription));
        }

        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND s.IsActive = ? ");
            params.add(Integer.parseInt(statusStr));
        }

        if (search != null && !search.isEmpty()) {
            String keywordUnsigned = Validate.normalizeSearch(search);
            sql.append(" AND (s.FullNameUnsigned LIKE ? OR s.Phone LIKE ? OR s.ShopName LIKE ?) ");
            String pattern = "%" + keywordUnsigned + "%";
            params.add(pattern);
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND l.CreatedAt >= ? ");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            LocalDate nextDay = LocalDate.parse(toDate).plusDays(1);
            sql.append(" AND l.CreatedAt < ? ");
            params.add(Timestamp.valueOf(nextDay.atStartOfDay()));
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        }

        return total;
    }

    //Phuong
    public void updateShopOwnerInfo(int ownerId, String fullName, String shopName, int isActive, String dbName) throws SQLException {
        String sql = "UPDATE ShopOwner SET FullName = ?, FullNameUnsigned = ?,  ShopName = ?, IsActive = ?, DatabaseName = ? WHERE OwnerID = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, Validate.normalizeSearch(fullName));
            stmt.setString(3, shopName);
            stmt.setInt(4, isActive);
            stmt.setString(5, dbName);
            stmt.setInt(6, ownerId);
            stmt.executeUpdate();
        }
    }

    public void updateShopOwnerInfo(int ownerId, String fullName, String shopName, String dbName,
            String email, String identificationId, String phone,
            String address, int gender, String taxNumber,
            String webURL, Date dob) throws SQLException {
        String sql = "UPDATE ShopOwner SET "
                + "FullName = ?, "
                + "FullNameUnsigned = ?, "
                + "ShopName = ?, "
                + "DatabaseName = ?, "
                + "Email = ?, "
                + "IdentificationID = ?, "
                + "Phone = ?, "
                + "Address = ?, "
                + "Gender = ?, "
                + "TaxNumber = ?, "
                + "WebURL = ?, "
                + "DOB = ? "
                + "WHERE OwnerID = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, Validate.normalizeSearch(fullName));
            stmt.setString(3, shopName);
            stmt.setString(4, dbName);
            stmt.setString(5, email);
            stmt.setString(6, identificationId);
            stmt.setString(7, phone);
            stmt.setString(8, address);
            stmt.setInt(9, gender);
            stmt.setString(10, taxNumber);
            stmt.setString(11, webURL);
            stmt.setDate(12, dob);
            stmt.setInt(13, ownerId);

            stmt.executeUpdate();
        }
    }

    //Phuong
    public void updateShopOwnerInfoInTheirDTB(String dbName, String fullName, int isActive) throws SQLException {
        String sql = "UPDATE Users SET FullName = ?, IsActive = ? WHERE UserID = 1";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setInt(2, isActive);
            stmt.executeUpdate();
        }
    }

    public void updateShopOwnerInfoInTheirDTB(String fullName,
            String email, String identificationId, String phone,
            String address, int gender, String taxNumber,
            String webURL, Date dob, String oldDbName) throws SQLException {
        String sql = "UPDATE Users SET "
                + "FullName = ?, "
                + "Email = ?, "
                + "IdentificationID = ?, "
                + "Phone = ?, "
                + "Address = ?, "
                + "Gender = ?, "
                + "TaxNumber = ?, "
                + "WebURL = ?, "
                + "DOB = ? "
                + "WHERE UserID = 1";

        try (Connection conn = DBUtil.getConnectionTo(oldDbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, email);
            stmt.setString(3, identificationId);
            stmt.setString(4, phone);
            stmt.setString(5, address);
            stmt.setInt(6, gender);
            stmt.setString(7, taxNumber);
            stmt.setString(8, webURL);
            stmt.setDate(9, dob);

            stmt.executeUpdate();
        }
    }

    //Phuong
    public void voidUpdateDTBShopName(String oldDbName, String newDbName) {
        String alterSql = "ALTER DATABASE [" + oldDbName + "] MODIFY NAME = [" + newDbName + "]";

        try (Connection conn = DBUtil.getConnectionTo("master"); Statement stmt = conn.createStatement()) {

            String findSessionsSql
                    = "SELECT session_id FROM sys.dm_exec_sessions "
                    + "WHERE database_id = DB_ID('" + oldDbName + "')";

            ResultSet rs = stmt.executeQuery(findSessionsSql);
            List<Integer> sessionIds = new ArrayList<>();

            while (rs.next()) {
                int sessionId = rs.getInt("session_id");
                if (sessionId != 1) { // bỏ qua system session
                    sessionIds.add(sessionId);
                }
            }

            for (int spid : sessionIds) {
                try {
                    stmt.execute("KILL " + spid);
                    System.out.println("Đã kill session: " + spid);
                } catch (SQLException killEx) {
                    System.err.println("Không thể kill session " + spid + ": " + killEx.getMessage());
                }
            }

            stmt.executeUpdate(alterSql);
            System.out.println("Đã đổi tên database từ [" + oldDbName + "] sang [" + newDbName + "]");

        } catch (SQLException e) {
            System.err.println("Lỗi khi đổi tên database: " + e.getMessage());
        }
    }

    //Phuong
    public static ShopOwnerSADTO getDashboardAboutSO() throws SQLException {
        ShopOwnerSADTO soSaDTO = null;
        String sql = """
                     DECLARE @MethodID INT = 1;
                     DECLARE @StartOfThisMonth DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
                     DECLARE @StartOfLastMonth DATE = DATEADD(MONTH, -1, @StartOfThisMonth);
                     DECLARE @EndOfLastMonth DATETIME = DATEADD(MILLISECOND, -3, CAST(DATEADD(MONTH, 1, @StartOfLastMonth) AS DATETIME));
                     DECLARE @Today DATETIME = GETDATE();
                     
                     DECLARE @TotalUsersThisMonth INT = (SELECT COUNT(*) FROM ShopOwner);
                     DECLARE @NewUsersLastMonth INT = (SELECT COUNT(*) FROM ShopOwner WHERE CreatedAt BETWEEN @StartOfLastMonth AND @EndOfLastMonth);
                     
                     DECLARE @ActiveSubscribersThisMonth INT = (
                         SELECT COUNT(*) FROM UserServiceMethod 
                         WHERE MethodID = @MethodID AND Status != 'TRIAL'
                     );
                     
                     DECLARE @ActiveSubscribersLastMonth INT = (
                         SELECT COUNT(*) FROM UserServiceMethod 
                         WHERE MethodID = @MethodID AND Status != 'TRIAL' 
                           AND SubscriptionStart BETWEEN @StartOfLastMonth AND @EndOfLastMonth
                     );
                     
                     WITH RevenueCTE AS (
                         SELECT
                             CASE 
                                 WHEN sl.CreatedAt BETWEEN @StartOfThisMonth AND @Today THEN 'this'
                                 WHEN sl.CreatedAt BETWEEN @StartOfLastMonth AND @EndOfLastMonth THEN 'last'
                             END AS PeriodType,
                             sl.SubscriptionMonths * (smp.Price * 1.0 / smp.SubscriptionMonths) AS Revenue
                         FROM SubscriptionLogs sl
                         JOIN ServiceMethodPrice smp 
                             ON sl.MethodID = smp.MethodID AND sl.SubscriptionMonths = smp.SubscriptionMonths
                         WHERE sl.Status = 'Done' AND sl.MethodID = @MethodID
                     )
                     SELECT
                         ISNULL(SUM(CASE WHEN PeriodType = 'this' THEN Revenue ELSE 0 END), 0) AS RevenueThisMonth,
                         ISNULL(SUM(CASE WHEN PeriodType = 'last' THEN Revenue ELSE 0 END), 0) AS RevenueLastMonth,
                     
                         CASE 
                             WHEN SUM(CASE WHEN PeriodType = 'last' THEN Revenue ELSE 0 END) = 0 
                                  AND SUM(CASE WHEN PeriodType = 'this' THEN Revenue ELSE 0 END) > 0 THEN 100.0
                             WHEN SUM(CASE WHEN PeriodType = 'last' THEN Revenue ELSE 0 END) = 0 
                                  AND SUM(CASE WHEN PeriodType = 'this' THEN Revenue ELSE 0 END) = 0 THEN 0.0
                             ELSE ROUND(
                                 (SUM(CASE WHEN PeriodType = 'this' THEN Revenue ELSE 0 END) - 
                                  SUM(CASE WHEN PeriodType = 'last' THEN Revenue ELSE 0 END)) * 100.0 / 
                                  SUM(CASE WHEN PeriodType = 'last' THEN Revenue ELSE 0 END), 2)
                         END AS RevenueGrowthPercent,
                     
                         @TotalUsersThisMonth AS TotalUsersThisMonth,
                     
                         @NewUsersLastMonth AS NewUsersLastMonth,
                     
                         CASE 
                             WHEN @NewUsersLastMonth = 0 AND @TotalUsersThisMonth > 0 THEN 100.0
                             WHEN @NewUsersLastMonth = 0 AND @TotalUsersThisMonth = 0 THEN 0.0
                             ELSE ROUND(
                                 (@TotalUsersThisMonth - @NewUsersLastMonth) * 100.0 / @NewUsersLastMonth
                                 , 2)
                         END AS UserGrowthPercent,
                     
                         @ActiveSubscribersThisMonth AS ActiveSubscribersThisMonth,
                     
                         @ActiveSubscribersLastMonth AS ActiveSubscribersLastMonth,
                     
                         CASE 
                             WHEN @ActiveSubscribersLastMonth = 0 AND @ActiveSubscribersThisMonth > 0 THEN 100.0
                             WHEN @ActiveSubscribersLastMonth = 0 AND @ActiveSubscribersThisMonth = 0 THEN 0.0
                             ELSE ROUND(
                                 (@ActiveSubscribersThisMonth - @ActiveSubscribersLastMonth) * 100.0 / @ActiveSubscribersLastMonth
                                 , 2)
                         END AS ActiveSubscribersGrowthPercent
                     
                     FROM RevenueCTE;""";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    soSaDTO = new ShopOwnerSADTO(
                            rs.getDouble("RevenueThisMonth"),
                            rs.getDouble("RevenueLastMonth"),
                            rs.getObject("RevenueGrowthPercent", Double.class),
                            rs.getInt("TotalUsersThisMonth"),
                            rs.getInt("NewUsersLastMonth"),
                            rs.getObject("UserGrowthPercent", Double.class),
                            rs.getInt("ActiveSubscribersThisMonth"),
                            rs.getInt("ActiveSubscribersLastMonth"),
                            rs.getObject("ActiveSubscribersGrowthPercent", Double.class)
                    );
                }
            }
        }
        return soSaDTO;
    }

    //Phuong
    public void activateShopOwnerIfInactive(int ownerId) throws SQLException {
        String sql = "UPDATE ShopOwner SET IsActive = 1 WHERE OwnerID = ? AND IsActive = 0";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.executeUpdate();
        }
    }

    //Phuong
    public void markSubscriptionLogAsDone(int ownerId, int methodId) throws SQLException {
        String sql = "UPDATE SubscriptionLogs SET Status = 'Done' WHERE OwnerID = ? AND MethodID = ? AND Status = 'Pending'";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setInt(2, methodId);
            ps.executeUpdate();
        }
    }
    
    public void markSubscriptionLogAsRefuse(int ownerId, int methodId) throws SQLException {
        String sql = "UPDATE SubscriptionLogs SET Status = 'Refuse' WHERE OwnerID = ? AND MethodID = ? AND Status = 'Pending'";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setInt(2, methodId);
            ps.executeUpdate();
        }
    }

    //Phuong
    public void updateUserServiceMethod(int ownerId, int methodId, int subsMonth) throws SQLException {
        String sql = """
        UPDATE UserServiceMethod
        SET 
            Status = ?,
            SubscriptionMonths = ?,
            SubscriptionStart = GETDATE(),
            SubscriptionEnd = DATEADD(MONTH, ?, GETDATE())
        WHERE OwnerID = ? AND MethodID = ?
        """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, subsMonth + " THÁNG");
            ps.setInt(2, subsMonth);
            ps.setInt(3, subsMonth);
            ps.setInt(4, ownerId);
            ps.setInt(5, methodId);
            ps.executeUpdate();
        }
    }

    public static int getOwnerIdByPhone(String phone) throws SQLException {
        String sql = "SELECT OwnerId FROM ShopOwner WHERE Phone = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("OwnerId");
            }
        }
        return -1;
    }

    public static void deactivateOwner(int ownerId) throws SQLException {
        String sql = "UPDATE ShopOwner SET IsActive = 0 WHERE OwnerId = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.executeUpdate();
        }
    }

    //Phuong
    private static ShopOwnerDTO extractShopOwnerDTOFromResultSet(ResultSet rs) throws SQLException {
        ShopOwnerDTO shopOwnerDTO = new ShopOwnerDTO(
                rs.getDate("TrialStartDate"),
                rs.getString("Status"),
                rs.getString("SubscriptionMonths"),
                rs.getDate("SubscriptionStart"),
                rs.getDate("SubscriptionEnd"),
                rs.getInt("OwnerID"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("ShopName"),
                rs.getString("DatabaseName"),
                rs.getString("Email"),
                rs.getString("IdentificationID"),
                rs.getString("Gender"),
                rs.getString("Address"),
                rs.getString("Phone"),
                rs.getInt("IsActive"),
                rs.getDate("CreatedAt"),
                rs.getString("TaxNumber"),
                rs.getString("WebUrl"),
                rs.getDate("TrialEndDate"),
                rs.getDate("DOB")
        );
        return shopOwnerDTO;
    }

    private static ShopOwnerSubsDTO extractShopOwnerSubsDTOFromResultSet(ResultSet rs) throws SQLException {
        ShopOwnerSubsDTO shopOwnerSubsDTO = new ShopOwnerSubsDTO(
                rs.getInt("MethodID"),
                rs.getString("SubscriptionMonths"),
                rs.getTimestamp("LogCreatedAt"),
                rs.getInt("OwnerID"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("FullNameUnsigned"),
                rs.getString("ShopName"),
                rs.getString("DatabaseName"),
                rs.getString("Email"),
                rs.getString("IdentificationID"),
                rs.getString("Gender"),
                rs.getString("Address"),
                rs.getString("Phone"),
                rs.getInt("IsActive"));
        return shopOwnerSubsDTO;
    }

    //Phuong
    public static void main(String[] args) throws SQLException {
        System.out.println(ShopOwnerDAO.getDashboardAboutSO());
    }

}
