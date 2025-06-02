/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Admin;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class AdminDAO {

    public Admin getAdmin(String username) throws SQLException {
        Admin admin = null;
        String sql = "SELECT \n"
                    + "    AdminID,\n"
                    + "    FullName,\n"
                    + "    UserName,\n"
                    + "    Password\n"
                    + "FROM SuperAdmin WHERE UserName = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setString(1, username);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        admin = extractUserFromResultSet(rs);
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
                rs.getString("UserName"),
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
