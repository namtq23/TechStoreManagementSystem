/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.sql.SQLException;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class PasswordResetTokenDAO {

    public static void saveToken(int userId, String token, Timestamp expiry) throws SQLException {
        String sql = "INSERT INTO PasswordResetTokens(userId, token, expiryDate) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setObject(3, expiry); 
            ps.executeUpdate();
        }
    }
    
    public static void saveTokenInEachShop(int userId, String token, Timestamp expiry, String dbName) throws SQLException {
        String sql = "INSERT INTO PasswordResetTokens(userId, token, expiryDate) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, token);
            ps.setObject(3, expiry); 
            ps.executeUpdate();
        }
    }

    public static int getUserIdByToken(String token) throws SQLException {
        String sql = "SELECT userId FROM PasswordResetTokens WHERE token = ? AND expiryDate > CURRENT_TIMESTAMP";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("userId");
                }
            }
        }
        return -1; // Token hết hạn hoặc không hợp lệ
    }
    
    public static int getUserIdByTokenInEachShop(String token, String dbName) throws SQLException {
        String sql = "SELECT userId FROM PasswordResetTokens WHERE token = ? AND expiryDate > CURRENT_TIMESTAMP";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("userId");
                }
            }
        }
        return -1; // Token hết hạn hoặc không hợp lệ
    }

    public static void deleteToken(String token) throws SQLException {
        String sql = "DELETE FROM PasswordResetTokens WHERE token = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        }
    }
    
    public static void deleteTokenInEachShop(String token, String dbName) throws SQLException {
        String sql = "DELETE FROM PasswordResetTokens WHERE token = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        }
    }
}
