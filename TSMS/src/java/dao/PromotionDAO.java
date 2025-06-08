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
import java.util.List;
import model.PromotionDTO;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class PromotionDAO {

    /*
      Lấy danh sách khuyến mãi đang áp dụng cho chi nhánh
     */
    public List<PromotionDTO> getActivePromotionsByBranch(String dbName, int branchId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();

        String sql = """
            SELECT DISTINCT
                p.PromotionID,
                p.PromoName,
                p.DiscountPercent,
                p.StartDate,
                p.EndDate,
                p.ApplyToAllBranches
            FROM Promotions p
            LEFT JOIN PromotionBranches pb ON p.PromotionID = pb.PromotionID
            WHERE (p.ApplyToAllBranches = 1 OR pb.BranchID = ?)
                AND GETDATE() BETWEEN p.StartDate AND p.EndDate
            ORDER BY p.StartDate DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, branchId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PromotionDTO promotion = new PromotionDTO(
                            rs.getInt("PromotionID"),
                            rs.getString("PromoName"),
                            rs.getBigDecimal("DiscountPercent"),
                            rs.getDate("StartDate"),
                            rs.getDate("EndDate"),
                            rs.getBoolean("ApplyToAllBranches")
                    );
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getActivePromotionsByBranch: " + e.getMessage());
            throw e;
        }

        return promotions;
    }

    /*
      Lấy tất cả khuyến mãi cho chi nhánh (bao gồm cả hết hạn và chưa áp dụng)
     */
    public List<PromotionDTO> getAllPromotionsByBranch(String dbName, int branchId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();

        String sql = """
            SELECT DISTINCT
                p.PromotionID,
                p.PromoName,
                p.DiscountPercent,
                p.StartDate,
                p.EndDate,
                p.ApplyToAllBranches
            FROM Promotions p
            LEFT JOIN PromotionBranches pb ON p.PromotionID = pb.PromotionID
            WHERE (p.ApplyToAllBranches = 1 OR pb.BranchID = ?)
            ORDER BY p.StartDate DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, branchId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PromotionDTO promotion = new PromotionDTO(
                            rs.getInt("PromotionID"),
                            rs.getString("PromoName"),
                            rs.getBigDecimal("DiscountPercent"),
                            rs.getDate("StartDate"),
                            rs.getDate("EndDate"),
                            rs.getBoolean("ApplyToAllBranches")
                    );
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getAllPromotionsByBranch: " + e.getMessage());
            throw e;
        }

        return promotions;
    }

    /*
      Lấy khuyến mãi áp dụng cho sản phẩm cụ thể
     */
    public List<PromotionDTO> getPromotionsByProduct(String dbName, int productId, int branchId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();

        String sql = """
            SELECT DISTINCT
                p.PromotionID,
                p.PromoName,
                p.DiscountPercent,
                p.StartDate,
                p.EndDate,
                p.ApplyToAllBranches
            FROM Promotions p
            LEFT JOIN PromotionBranches pb ON p.PromotionID = pb.PromotionID
            LEFT JOIN PromotionProducts pp ON p.PromotionID = pp.PromotionID
            WHERE (p.ApplyToAllBranches = 1 OR pb.BranchID = ?)
                AND pp.ProductID = ?
                AND GETDATE() BETWEEN p.StartDate AND p.EndDate
            ORDER BY p.DiscountPercent DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, branchId);
            stmt.setInt(2, productId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PromotionDTO promotion = new PromotionDTO(
                            rs.getInt("PromotionID"),
                            rs.getString("PromoName"),
                            rs.getBigDecimal("DiscountPercent"),
                            rs.getDate("StartDate"),
                            rs.getDate("EndDate"),
                            rs.getBoolean("ApplyToAllBranches")
                    );
                    promotions.add(promotion);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getPromotionsByProduct: " + e.getMessage());
            throw e;
        }

        return promotions;
    }
}
