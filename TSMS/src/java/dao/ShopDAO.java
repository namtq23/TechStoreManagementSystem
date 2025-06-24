/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBUtil;
import util.Validate;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class ShopDAO {

    public static boolean isShopTaken(String dbName) throws SQLException {
        String newDbName = Validate.shopNameConverter(dbName);
        String sql = """
                     select *
                     from ShopOwner where DatabaseName = ?""";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newDbName);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public static boolean renameDatabase(String oldDbName, String newDbName) {
        Connection conn = null;
        Statement stmt = null;
        boolean success = false;

        try {
            // Kết nối tới master (không được kết nối đến chính database cần đổi tên)
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();

            String sql = "ALTER DATABASE [" + oldDbName + "] MODIFY NAME = [" + newDbName + "]";
            stmt.executeUpdate(sql);
            success = true;

        } catch (SQLException e) {
            System.out.println(e);
        }
        return success;
    }

    public static boolean updateShopInfo(int ownerId, String newShopName, String newDbName) {
        Connection conn;
        PreparedStatement stmt;
        boolean success = false;

        try {
            conn = DBUtil.getConnection();

            String sql = "UPDATE ShopOwners SET ShopName = ?, DatabaseName = ? WHERE OwnerID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newShopName);
            stmt.setString(2, newDbName);
            stmt.setInt(3, ownerId);

            int rows = stmt.executeUpdate();
            success = (rows > 0);

        } catch (SQLException e) {
            System.out.println(e);
        }
        return success;
    }

    public static boolean updateSubscription(int ownerId, int months) {
        Connection conn;
        PreparedStatement stmt;
        boolean success = false;

        try {
            conn = DBUtil.getConnection();

            LocalDateTime start = LocalDateTime.now();
            LocalDateTime end = start.plusMonths(months);

            String sql = "UPDATE UserServiceMethod "
                    + "SET SubscriptionMonths = ?, "
                    + "    SubscriptionStart = ?, "
                    + "    SubscriptionEnd = ?, TrialStatus = ?"
                    + "WHERE OwnerID = ?";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, months);
            stmt.setTimestamp(2, Timestamp.valueOf(start));
            stmt.setTimestamp(3, Timestamp.valueOf(end));
            stmt.setString(4, "Active");
            stmt.setInt(5, ownerId);

            int rows = stmt.executeUpdate();
            success = (rows > 0);

        } catch (SQLException e) {
            System.out.println(e);
        }
        return success;
    }

    public static String getDatabaseNameByOwnerId(int ownerId) {
        Connection conn = null;
        PreparedStatement stmt;
        ResultSet rs;
        String dbName = null;

        try {
            conn = DBUtil.getConnection();

            String sql = "SELECT DatabaseName FROM ShopOwner WHERE OwnerID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ownerId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                dbName = rs.getString("DatabaseName");
            }

        } catch (SQLException e) {
            System.out.println(e);
        }
        return dbName;
    }

    public static boolean updateShopOwnerNameInAdminDB(int ownerId, String fullName) {
        String sql = "UPDATE ShopOwner SET FullName = ? WHERE OwnerID = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, fullName);
            stmt.setInt(2, ownerId);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean updateShopOwnerNameInShopDB(String databaseName, String fullName) {
        String sql = "UPDATE Users SET FullName = ? WHERE RoleID = 0";

        try (Connection conn = DBUtil.getConnectionTo(databaseName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, fullName);
            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) throws SQLException {

    }
}
