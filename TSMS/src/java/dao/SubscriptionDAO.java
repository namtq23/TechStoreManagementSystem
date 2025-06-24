/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class SubscriptionDAO {

    public static boolean isTrialExpired(int ownerId) {
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs = null;
        boolean isExpired = false;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT TrialStartDate, TrialStatus FROM UserServiceMethod WHERE OwnerID = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, ownerId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                Timestamp trialStart = rs.getTimestamp("TrialStartDate");
                String status = rs.getString("TrialStatus");

                if ("TRIAL".equalsIgnoreCase(status)) {
                    // Tính số ngày đã dùng thử
                    long now = System.currentTimeMillis();
                    long trialDuration = now - trialStart.getTime(); 
                    long daysPassed = trialDuration / (1000 * 60 * 60 * 24);

                    if (daysPassed >= 7) {
                        isExpired = true;

                        // Cập nhật TrialStatus -> EXPIRED
                        String updateSql = "UPDATE UserServiceMethod SET TrialStatus = 'EXPIRED' WHERE OwnerID = ?";
                        PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                        updateStmt.setInt(1, ownerId);
                        updateStmt.executeUpdate();
                        updateStmt.close();
                    }
                }
            }

        } catch (SQLException e) {
            System.out.println(e);
        }

        return isExpired;
    }
    
    public static void main(String[] args) {
        System.out.println(SubscriptionDAO.isTrialExpired(1));
    }
}
