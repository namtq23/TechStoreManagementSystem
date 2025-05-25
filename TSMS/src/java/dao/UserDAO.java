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
import model.ShopOwner;

/**
 *
 * @author admin
 */
public class UserDAO {
    private static final String ADMIN_DB_URL =
        "jdbc:sqlserver://ND2P:1433;instanceName=PHUONG;databaseName=SuperAdminDB;encrypt=false"; //Đổi port ở đây -> sqlserver:... instanceName=...
    private static final String USER = "sa";
    private static final String PASSWORD = "123"; // hãy dùng mật khẩu thật

    public static void insertShopOwner(ShopOwner owner) throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQL Server không tìm thấy", e);
        }

        try (Connection conn = DriverManager.getConnection(ADMIN_DB_URL, USER, PASSWORD)) {
            String sql = "INSERT INTO ShopOwner (AdminID, Password, FullName, ShopName, DatabaseName, Email) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
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
            String sql = "SELECT COUNT(*) FROM ShopOwners WHERE Email = ?";
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
}
