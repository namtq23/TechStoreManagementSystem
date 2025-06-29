/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import model.SubscriptionsDTO;
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.SubscriptionLogDTO;
import util.DBUtil;
import util.Validate;

/**
 *
 * @author admin
 */
public class SubscriptionsDAO {

    public static List<SubscriptionsDTO> getAllSubscriptionSummaryByMethodId(int methodId) throws SQLException {
        List<SubscriptionsDTO> list = new ArrayList<>();

        String sql = """
        SELECT 
            smp.SubscriptionMonths,
            smp.Price,
            COUNT(usm.OwnerID) AS TotalUsers
        FROM ServiceMethodPrice smp
        LEFT JOIN UserServiceMethod usm 
            ON smp.MethodID = usm.MethodID 
            AND smp.SubscriptionMonths = usm.SubscriptionMonths
            AND usm.Status != 'TRIAL'
        WHERE smp.MethodID = ?
        GROUP BY smp.SubscriptionMonths, smp.Price
        ORDER BY smp.SubscriptionMonths
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, methodId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int subscriptionMonths = rs.getInt("SubscriptionMonths");
                    Double price = rs.getDouble("Price");
                    int totalUsers = rs.getInt("TotalUsers");

                    String subscriptionName = subscriptionMonths + " tháng";
                    String formattedPrice = Validate.formatCostPriceToVND(price);
                    SubscriptionsDTO dto = new SubscriptionsDTO(
                            String.valueOf(totalUsers),
                            methodId,
                            subscriptionName,
                            formattedPrice
                    );

                    list.add(dto);
                }
            }
        }

        return list;
    }

    public static List<SubscriptionLogDTO> getAllSubscriptionLogs() throws SQLException {
        List<SubscriptionLogDTO> list = new ArrayList<>();

        String sql = """
        SELECT 
            sl.LogID,
            sl.OwnerID,
            so.FullName AS OwnerName,
            CONCAT(smp.SubscriptionMonths, ' tháng') AS SubscriptionName,
            FORMAT(smp.Price, 'N0') AS SubscriptionPrice, -- định dạng 700,000
            sl.Status,
            sl.CreatedAt,
            DATEDIFF(MINUTE, sl.CreatedAt, GETDATE()) AS MinutesAgo
        FROM SubscriptionLogs sl
        JOIN ShopOwner so ON sl.OwnerID = so.OwnerID
        JOIN ServiceMethodPrice smp ON sl.MethodID = smp.MethodID AND sl.SubscriptionMonths = smp.SubscriptionMonths
        ORDER BY sl.CreatedAt DESC
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SubscriptionLogDTO log = new SubscriptionLogDTO(
                        rs.getInt("LogID"),
                        rs.getInt("OwnerID"),
                        rs.getString("OwnerName"),
                        rs.getString("SubscriptionName"),
                        rs.getString("SubscriptionPrice"),
                        rs.getString("Status"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getInt("MinutesAgo")
                );

                list.add(log);
            }
        }

        return list;
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(SubscriptionsDAO.getAllSubscriptionSummaryByMethodId(1));
    }

}
