/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ShopOwner;
import model.ShopOwnerDTO;
import model.User;
import model.UserDTO;
import util.DBUtil;
/**
 *
 * @author Dell
 */
public class RoleDAO {
    public List<Role> getAllRoles(String dbName) {
    List<Role> roles = new ArrayList<>();
    String query = "SELECT RoleID, RoleName FROM Roles WHERE RoleID != 0";

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(query);
         ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
            Role role = new Role();
            role.setRoleID(rs.getInt("RoleID"));
            role.setRoleName(rs.getString("RoleName"));
            roles.add(role);
        }
    } catch (SQLException e) {
        System.err.println("Error in getAllRoles: " + e.getMessage());
        e.printStackTrace();
    }
    return roles;
}
}
