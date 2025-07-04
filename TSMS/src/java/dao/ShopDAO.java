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
    
    public static String getSOPhone(String dbName) throws SQLException {
        String sql = "SELECT Phone FROM Users WHERE UserId = 1";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getString("Phone");
            }
        }
        return null;
    }
    
    public static void main(String[] args) throws SQLException {
        ShopDAO shop = new ShopDAO();
        System.out.println(shop.getSOPhone("DTB_P"));
    }
}
