/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ShopOwner;
import model.User;
import model.UserDTO;

/**
 *
 * @author admin
 */
public class UserDAO {

    private static final String ADMIN_DB_URL
            = "jdbc:sqlserver://ND2P:1433;instanceName=PHUONG;databaseName=SuperAdminDB;encrypt=false"; //Đổi port ở đây -> sqlserver:... instanceName=...
    private static final String USER = "sa";
    private static final String PASSWORD = "123"; // hãy dùng mật khẩu thật

    public static void insertShopOwner(ShopOwner owner) throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQL Server không tìm thấy", e);
        }

        try (Connection conn = DriverManager.getConnection(ADMIN_DB_URL, USER, PASSWORD)) {
            String sql = "INSERT INTO ShopOwner (AdminID, RoleID, Password, FullName, ShopName, DatabaseName, Email) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, 1);
                stmt.setInt(1, 1);
                stmt.setString(2, owner.getPassword());
                stmt.setString(3, owner.getFullName());
                stmt.setString(4, owner.getShopName());
                stmt.setString(5, owner.getDatabaseName());
                stmt.setString(6, owner.getDatabaseName());
                stmt.executeUpdate();
            }
        }
    }

    public static boolean isAccountTaken(String email) throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQL Server không tìm thấy", e);
        }

        try (Connection conn = DriverManager.getConnection(ADMIN_DB_URL, USER, PASSWORD)) {
            String sql = "SELECT COUNT(*) FROM ShopOwner WHERE Email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        }
        return false;
    }

    public User getUserByEmail(String email) throws SQLException {
        User user = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQL Server không tìm thấy", e);
        }

        try (Connection conn = DriverManager.getConnection(ADMIN_DB_URL, USER, PASSWORD)) {
            String sql = "SELECT \n"
                    + "    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS AccountID,\n"
                    + "    RoleID,\n"
                    + "    FullName,\n"
                    + "    Email,\n"
                    + "    Password\n"
                    + "FROM (\n"
                    + "    SELECT RoleID, FullName, Email, Password FROM ShopOwner WHERE Email = ?\n"
                    + "    UNION ALL\n"
                    + "    SELECT RoleID, FullName, Email, Password FROM Staff WHERE Email = ?\n"
                    + ") AS Combined";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setString(2, email);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        user = extractUserFromResultSet(rs);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<UserDTO> getUsers() throws SQLException {
        List<UserDTO> users = new ArrayList<>();
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQL Server không tìm thấy", e);
        }

        try (Connection conn = DriverManager.getConnection(ADMIN_DB_URL, USER, PASSWORD)) {
            String sql = "SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS AccountID, \n"
                    + "       RoleID, FullName, Email, Password, ShopName, CreatedAt, IsActive\n"
                    + "FROM (\n"
                    + "    SELECT RoleID, FullName, Email, Password, ShopName, CreatedAt, IsActive FROM ShopOwner\n"
                    + "    UNION ALL\n"
                    + "    SELECT RoleID, FullName, Email, Password, ShopName, CreatedAt, IsActive FROM Staff\n"
                    + ") AS Combined";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        UserDTO user = extractUserDTOFromResultSet(rs);
                        users.add(user);
                    }
                }
            }

        } catch (SQLException e) {
        }
        return users;
    }
    
    public void updateIsActiveByEmail(String email, int newStatus) throws SQLException {
        String sql = """
            UPDATE ShopOwner SET IsActive = ? WHERE Email = ?;
            UPDATE Staff SET IsActive = ? WHERE Email = ?;
        """;

        try (Connection conn = DriverManager.getConnection(ADMIN_DB_URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, newStatus);
            stmt.setString(2, email);
            stmt.setInt(3, newStatus);
            stmt.setString(4, email);

            stmt.executeUpdate();
        }
    }

    private User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User(
                rs.getInt("AccountID"),
                rs.getInt("RoleID"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("Password")
        );
        return user;
    }
    
    private UserDTO extractUserDTOFromResultSet(ResultSet rs) throws SQLException {
        UserDTO user = new UserDTO(
                rs.getString("ShopName"),
                rs.getInt("IsActive"),
                rs.getDate("CreatedAt"),
                rs.getInt("AccountID"),
                rs.getInt("RoleID"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("Password")
                
        );
        return user;
    }

    public static void main(String[] args) throws SQLException {
        UserDAO ud = new UserDAO();
//        User u = ud.getUserByEmail("ndpp.work@gmail.com");
        List<UserDTO> users = ud.getUsers();
        System.out.println(users);
    }
}
