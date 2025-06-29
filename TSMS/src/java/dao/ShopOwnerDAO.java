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
import util.Validate;

/**
 *
 * @author admin
 */
public class ShopOwnerDAO {

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

    public int countFilteredShopOwners(String subscription, String statusStr, String fromDate, String toDate) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM ShopOwner s "
                + "LEFT JOIN UserServiceMethod u ON s.OwnerID = u.OwnerID "
                + "WHERE 1=1"
        );

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
            sql.append(" AND s.IsActive = ?");
            params.add(Integer.parseInt(statusStr));
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND s.CreatedAt >= ?");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            LocalDate nextDay = LocalDate.parse(toDate).plusDays(1);
            sql.append(" AND CreatedAt < ?");
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

    public void updateShopOwnerInfo(int ownerId, String fullName, String shopName, int isActive) throws SQLException {
        String sql = "UPDATE ShopOwner SET FullName = ?, ShopName = ?, IsActive = ? WHERE OwnerID = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setString(2, shopName);
            stmt.setInt(3, isActive);
            stmt.setInt(4, ownerId);
            stmt.executeUpdate();
        }
    }

    public void updateShopOwnerInfoInTheirDTB(String dbName, String fullName, int isActive) throws SQLException {
        String sql = "UPDATE Users SET FullName = ?, IsActive = ? WHERE UserID = 0";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, fullName);
            stmt.setInt(2, isActive);
            stmt.executeUpdate();
        }
    }

    public void voidUpdateDTBShopName(String oldDbName, String newDbName) {
        String sql = "ALTER DATABASE [" + oldDbName + "] MODIFY NAME = [" + newDbName + "]";

        try (Connection conn = DBUtil.getConnectionTo("master"); Statement stmt = conn.createStatement()) {

            stmt.executeUpdate(sql);
            System.out.println("Đã đổi tên DB từ " + oldDbName + " thành " + newDbName);

        } catch (SQLException e) {
            System.err.println("Đổi tên database thất bại.");
        }
    }

    public static ShopOwnerSADTO getDashboardAboutSO() throws SQLException {
        ShopOwnerSADTO soSaDTO = null;
        String sql = """
                     DECLARE @MethodID INT = 1;
                     DECLARE @StartOfThisMonth DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
                     DECLARE @StartOfLastMonth DATE = DATEADD(MONTH, -1, @StartOfThisMonth);
                     DECLARE @EndOfLastMonth DATE = DATEADD(DAY, -1, @StartOfThisMonth);
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
                rs.getDate("TrialEndDate")
        );
        return shopOwnerDTO;
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(ShopOwnerDAO.getDashboardAboutSO());
    }

}
