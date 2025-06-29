/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;
import java.util.List;
import model.StockMovement;
import model.StockMovement.StockMovementDetail;
import util.DBUtil; // bạn cần đặt đúng package khi dùng

public class StockMovementDAO {

    public int insertStockMovement(StockMovement movement) throws SQLException {
        String sql = "INSERT INTO StockMovementsRequest "
                  + "(FromSupplierID, FromBranchID, FromWarehouseID, ToBranchID, ToWarehouseID, MovementType, CreatedBy, CreatedAt, Note) "
                  + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), ?)";

        int generatedId = -1;
        Connection conn = DBUtil.getConnection();

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setObject(1, movement.getFromSupplierID());
            ps.setObject(2, movement.getFromBranchID());
            ps.setObject(3, movement.getFromWarehouseID());
            ps.setObject(4, movement.getToBranchID());
            ps.setObject(5, movement.getToWarehouseID());
            ps.setString(6, movement.getMovementType());
            ps.setInt(7, movement.getCreatedBy());
            ps.setString(8, movement.getNote());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    generatedId = rs.getInt(1);
                }
            }
        } finally {
            DBUtil.closeConnection(conn);
        }
        return generatedId;
    }

    public void insertMovementDetails(int movementID, List<StockMovementDetail> details) throws SQLException {
        String sql = "INSERT INTO StockMovementDetail (MovementID, ProductDetailID, Quantity) VALUES (?, ?, ?)";
        Connection conn = DBUtil.getConnection();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (StockMovementDetail detail : details) {
                ps.setInt(1, movementID);
                ps.setInt(2, detail.getProductDetailID());
                ps.setInt(3, detail.getQuantity());
                ps.addBatch();
            }
            ps.executeBatch();
        } finally {
            DBUtil.closeConnection(conn);
        }
    }

    public void createFullStockMovement(StockMovement movement) throws SQLException {
        Connection conn = DBUtil.getConnection();
        try {
            conn.setAutoCommit(false);

            int movementID = insertStockMovementTransactional(conn, movement);
            insertMovementDetailsTransactional(conn, movementID, movement.getDetails());

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            DBUtil.closeConnection(conn);
        }
    }

    private int insertStockMovementTransactional(Connection conn, StockMovement movement) throws SQLException {
        String sql = "INSERT INTO StockMovementsRequest "
                  + "(FromSupplierID, FromBranchID, FromWarehouseID, ToBranchID, ToWarehouseID, MovementType, CreatedBy, CreatedAt, Note) "
                  + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setObject(1, movement.getFromSupplierID());
            ps.setObject(2, movement.getFromBranchID());
            ps.setObject(3, movement.getFromWarehouseID());
            ps.setObject(4, movement.getToBranchID());
            ps.setObject(5, movement.getToWarehouseID());
            ps.setString(6, movement.getMovementType());
            ps.setInt(7, movement.getCreatedBy());
            ps.setString(8, movement.getNote());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    private void insertMovementDetailsTransactional(Connection conn, int movementID, List<StockMovementDetail> details) throws SQLException {
        String sql = "INSERT INTO StockMovementDetail (MovementID, ProductDetailID, Quantity) VALUES (?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (StockMovementDetail detail : details) {
                ps.setInt(1, movementID);
                ps.setInt(2, detail.getProductDetailID());
                ps.setInt(3, detail.getQuantity());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }
    
}
