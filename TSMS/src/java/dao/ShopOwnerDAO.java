/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.ShopOwnerDTO;
import util.DBUtil;
import java.sql.Timestamp;
import util.Validate;

/**
 *
 * @author admin
 */
public class ShopOwnerDAO {

    public List<ShopOwnerDTO> getFilteredShopOwners(String subscription, String statusStr, String fromDate, String toDate, String search,
            int offset, int limit) throws SQLException {
        List<ShopOwnerDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT \n"
                + "    s.*,\n"
                + "    u.MethodID,\n"
                + "    u.TrialStartDate,\n"
                + "    u.TrialEndDate,\n"
                + "    u.Status,\n"
                + "    u.SubscriptionMonths,\n"
                + "    u.SubscriptionStart,\n"
                + "    u.SubscriptionEnd\n"
                + "FROM \n"
                + "    ShopOwner s\n"
                + "LEFT JOIN \n"
                + "    UserServiceMethod u ON s.OwnerID = u.OwnerID WHERE 1=1");

        // Các tham số lọc
        List<Object> params = new ArrayList<>();

        if (subscription != null && !subscription.isEmpty()) {
            if (subscription.equalsIgnoreCase("TRIAL")) {
                sql.append(" AND u.Status = 'TRIAL'");
            } else {
                sql.append(" AND u.SubscriptionMonths = ?");
                params.add(Integer.parseInt(subscription));
            }
        }

        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND IsActive = ?");
            params.add(Integer.parseInt(statusStr));
        }
        
        if (search != null && !search.isEmpty()) {
            String keywordUnsigned = Validate.normalizeSearch(search);
            sql.append("AND (s.FullNameUnsigned LIKE ? OR s.Phone LIKE ? OR s.ShopName LIKE ?) ");
            String searchPattern = "%" + keywordUnsigned + "%";
            params.add(searchPattern);
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND CreatedAt >= ?");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            LocalDate nextDay = LocalDate.parse(toDate).plusDays(1);
            sql.append(" AND CreatedAt < ?");
            params.add(Timestamp.valueOf(nextDay.atStartOfDay()));
        }

        sql.append(" ORDER BY CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ShopOwnerDTO owner = extractShopOwnerDTOFromResultSet(rs);
                    list.add(owner);
                }
            }
        }

        return list;
    }

    public int countFilteredShopOwners(String subscription, String statusStr, String fromDate, String toDate) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM ShopOwner s "
                + "LEFT JOIN UserServiceMethod u ON s.OwnerID = u.OwnerID "
                + "WHERE 1=1"
        );

        List<Object> params = new ArrayList<>();

        if (subscription != null && !subscription.isEmpty()) {
            if (subscription.equalsIgnoreCase("TRIAL")) {
                sql.append(" AND u.Status = 'TRIAL'");
            } else {
                sql.append(" AND u.SubscriptionMonths = ?");
                params.add(Integer.parseInt(subscription));
            }
        }

        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND s.IsActive = ?");
            params.add(Integer.parseInt(statusStr));
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND s.CreatedAt >= ?");
            params.add(Date.valueOf(fromDate));
        }

        if (toDate != null && !toDate.isEmpty()) {
            LocalDate nextDay = LocalDate.parse(toDate).plusDays(1);
            sql.append(" AND CreatedAt < ?");
            params.add(Timestamp.valueOf(nextDay.atStartOfDay()));
        }

        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    private static ShopOwnerDTO extractShopOwnerDTOFromResultSet(ResultSet rs) throws SQLException {
        ShopOwnerDTO shopOwnerDTO = new ShopOwnerDTO(
                rs.getDate("TrialStartDate"),
                rs.getString("Status"),
                rs.getString("SubscriptionMonths"),
                rs.getDate("SubscriptionStart"),
                rs.getDate("SubscriptionEnd"),
                rs.getInt("OwnerID"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("ShopName"),
                rs.getString("DatabaseName"),
                rs.getString("Email"),
                rs.getString("IdentificationID"),
                rs.getString("Gender"),
                rs.getString("Address"),
                rs.getString("Phone"),
                rs.getInt("IsActive"),
                rs.getDate("CreatedAt")
        );
        return shopOwnerDTO;
    }

}
