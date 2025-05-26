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
import model.Admin;

/**
 *
 * @author admin
 */
public class AdminDAO {

    private static final String ADMIN_DB_URL
            = "jdbc:sqlserver://ND2P:1433;instanceName=PHUONG;databaseName=SuperAdminDB;encrypt=false"; //Đổi port ở đây -> sqlserver:... instanceName=...
    private static final String USER = "sa";
    private static final String PASSWORD = "123"; // hãy dùng mật khẩu thật

    public Admin getAdmin(String username) throws SQLException {
        Admin admin = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Driver SQL Server không tìm thấy", e);
        }

        try (Connection conn = DriverManager.getConnection(ADMIN_DB_URL, USER, PASSWORD)) {
            String sql = "SELECT \n"
                    + "    AdminID,\n"
                    + "    FullName,\n"
                    + "    Email,\n"
                    + "    Password\n"
                    + "FROM SuperAdmin WHERE Email = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        admin = extractUserFromResultSet(rs);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return admin;
    }

    // Helper method to extract User from ResultSet
    private Admin extractUserFromResultSet(ResultSet rs) throws SQLException {
        Admin admin = new Admin(
                rs.getInt("AdminID"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("Password")
        );
        return admin;
    }

    public static void main(String[] args) throws SQLException {
        AdminDAO ad = new AdminDAO();
        Admin u = ad.getAdmin("admin");
        System.out.println(u);
    }
}
