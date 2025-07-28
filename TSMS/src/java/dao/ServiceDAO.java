/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import util.DBUtil;
import model.UserServiceMethod;


/**
 *
 * @author admin
 */
public class ServiceDAO {
    public static UserServiceMethod getServiceMethodByOwnerId(int ownerId) throws SQLException {
        String sql = "SELECT Status, TrialEndDate, SubscriptionEnd FROM UserServiceMethod WHERE OwnerId = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String methodType = rs.getString("Status");
                Date trialEnd = rs.getDate("TrialEndDate");
                Date subEnd = rs.getDate("SubscriptionEnd");

                boolean isTrial = "TRIAL".equalsIgnoreCase(methodType);
                return new UserServiceMethod(ownerId, isTrial, trialEnd, subEnd);
            }
        }
        return null;
    }
}
