/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.ShopOwner;
import java.util.List;
import model.ShopOwner;
import model.User;
import util.DBUtil;
/**
 *
 * @author admin
 */
public class UserDAO {

    public static void insertShopOwner(ShopOwner owner) throws SQLException {
        String sql = """
        INSERT INTO ShopOwner (AdminID, Password, FullName, ShopName, DatabaseName, Email, IdentificationID, Gender, Address, IsActive, CreatedAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE());
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, 1); // AdminID mặc định là SuperAdmin ID 1
            stmt.setString(2, owner.getPassword());
            stmt.setString(3, owner.getFullName());
            stmt.setString(4, owner.getShopName());
            stmt.setString(5, owner.getDatabaseName());
            stmt.setString(6, owner.getEmail());
            stmt.setString(7, owner.getIdentificationID());
            stmt.setString(8, owner.getGender());
            stmt.setString(9, owner.getAddress());
            stmt.setInt(10, 1);

            stmt.executeUpdate();
        }
    }

    public static void insertUserMethod(String email) throws SQLException {
        ShopOwner shopOwnwer = getShopOwnwerByEmail(email);
        int ownerId = shopOwnwer.getOwnerId();
        String sql = """
        INSERT INTO UserServiceMethod(OwnerID, MethodID, TrialStartDate, TrialStatus, SubscriptionMonths, SubscriptionStart, SubscriptionEnd)
        VALUES (?, 1, GETDATE(), 'TRIAL', 0, NULL, NULL );
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            stmt.executeUpdate();
        }
    }

    public static boolean isAccountTaken(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ShopOwner WHERE Email = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    public static ShopOwner getShopOwnwerByEmail(String email) throws SQLException {
        ShopOwner shopOwner = null;

        String sql = "select * from ShopOwner where Email = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    shopOwner = extractShopOwnerFromResultSet(rs);
                }
            }
        }

        return shopOwner;
    }

    public User getUserByEmail(String email, String dbName) throws SQLException {
        User user = null;

        String sql = "select * from Users where Email = ?";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        }

        return user;
    }

    public List<User> getUsers() throws SQLException {
        List<User> users = new ArrayList<>();

        String sql = """
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS AccountID, 
                   RoleID, FullName, Email, Password, ShopName, CreatedAt, IsActive
            FROM (
                SELECT RoleID, FullName, Email, Password, ShopName, CreatedAt, IsActive FROM ShopOwner
                UNION ALL
                SELECT RoleID, FullName, Email, Password, ShopName, CreatedAt, IsActive FROM Staff
            ) AS Combined
        """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User user = extractUserFromResultSet(rs);
                users.add(user);
            }
        }

        return users;
    }


    public void updateIsActiveByEmail(String email, int newStatus) throws SQLException {
        String sql = """
            UPDATE ShopOwner SET IsActive = ? WHERE Email = ?;
            UPDATE Staff SET IsActive = ? WHERE Email = ?;
        """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, newStatus);
            stmt.setString(2, email);
            stmt.setInt(3, newStatus);
            stmt.setString(4, email);

            stmt.executeUpdate();
        }
    }

    private static ShopOwner extractShopOwnerFromResultSet(ResultSet rs) throws SQLException {
        ShopOwner shopOwner = new ShopOwner(
                rs.getInt("OwnerID"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("ShopName"),
                rs.getString("DatabaseName"),
                rs.getString("Email"),
                rs.getString("IdentificationID"),
                rs.getString("Gender"),
                rs.getString("Address")
        );
        return shopOwner;
    }

    private static User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User(
                rs.getInt("UserID"),
                rs.getString("PasswordHash"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("Phone"),
                rs.getString("BranchID"),
                rs.getString("WarehouseID"),
                rs.getInt("RoleID"),
                rs.getInt("IsActive")
        );

        return user;
    }

    public static void main(String[] args) throws SQLException {
        UserDAO ud = new UserDAO();
        User u = ud.getUserByEmail("ndpp.work@gmail.com", "");
        System.out.println(u);
    }
}
