package dao;

import model.ProductDetails;
import util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.StockMovement;
import model.Warehouse;

public class StockMovementDAO {

    public List<ProductDetails> getAvailableProductsByBranch(int branchId, String dbName) throws SQLException {
        List<ProductDetails> result = new ArrayList<>();

        String sql = """
            SELECT pd.ProductDetailID, pd.ProductCode, pd.Description, pd.ProductNameUnsigned,
                   pd.WarrantyPeriod, pd.CreatedAt, pd.UpdatedAt , ip.Quantity
            FROM InventoryProducts ip
            JOIN Inventory i ON ip.InventoryID = i.InventoryID
            JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
            WHERE i.BranchID = ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDetails pd = new ProductDetails();
                    pd.setProductDetailID(rs.getInt("ProductDetailID"));
                    pd.setProductCode(rs.getString("ProductCode"));
                    pd.setDescription(rs.getString("Description"));
                    pd.setProductNameUnsigned(rs.getString("ProductNameUnsigned"));
                    pd.setWarrantyPeriod(rs.getString("WarrantyPeriod"));
                    pd.setDetailCreatedAt(rs.getTimestamp("CreatedAt"));
                    pd.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    pd.setQuantity(rs.getInt("Quantity"));

                    result.add(pd);
                }
            }
        }

        return result;
    }

    public List<ProductDetails> searchProductsByName(int branchId, String keyword, String dbName) throws SQLException {
        List<ProductDetails> result = new ArrayList<>();

        String sql = """
            SELECT pd.ProductDetailID, pd.ProductCode, pd.Description, pd.ProductNameUnsigned,
                   pd.WarrantyPeriod, pd.CreatedAt, pd.UpdatedAt
            FROM InventoryProducts ip
            JOIN Inventory i ON ip.InventoryID = i.InventoryID
            JOIN ProductDetails pd ON ip.ProductDetailID = pd.ProductDetailID
            JOIN Products p ON pd.ProductID = p.ProductID
            WHERE i.BranchID = ? AND p.ProductName LIKE ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, branchId);
            ps.setString(2, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDetails pd = new ProductDetails();
                    pd.setProductDetailID(rs.getInt("ProductDetailID"));
                    pd.setProductCode(rs.getString("ProductCode"));
                    pd.setDescription(rs.getString("Description"));
                    pd.setProductNameUnsigned(rs.getString("ProductNameUnsigned"));
                    pd.setWarrantyPeriod(rs.getString("WarrantyPeriod"));
                    pd.setDetailCreatedAt(rs.getTimestamp("CreatedAt"));
                    pd.setUpdatedAt(rs.getTimestamp("UpdatedAt"));
                    result.add(pd);
                }
            }
        }

        return result;
    }

    public void createStockRequest(StockMovement movement, String dbName) throws SQLException {
        String insertRequestSQL = """
        INSERT INTO StockMovementsRequest 
        (FromSupplierID, FromBranchID, FromWarehouseID, ToBranchID, ToWarehouseID, MovementType, CreatedBy, CreatedAt, Note)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """;

        String insertDetailSQL = """
        INSERT INTO StockMovementDetail (MovementID, ProductDetailID, Quantity)
        VALUES (?, ?, ?)
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName)) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps = conn.prepareStatement(insertRequestSQL, Statement.RETURN_GENERATED_KEYS)) {
                ps.setObject(1, movement.getFromSupplierID());
                ps.setObject(2, movement.getFromBranchID());
                ps.setObject(3, movement.getFromWarehouseID());
                ps.setObject(4, movement.getToBranchID());
                ps.setObject(5, movement.getToWarehouseID());
                ps.setString(6, movement.getMovementType());
                ps.setInt(7, movement.getCreatedBy());
                ps.setTimestamp(8, movement.getCreatedAt());
                ps.setString(9, movement.getNote());

                ps.executeUpdate();

                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int movementID = rs.getInt(1);

                        try (PreparedStatement psDetail = conn.prepareStatement(insertDetailSQL)) {
                            for (StockMovement.StockMovementDetail detail : movement.getDetails()) {
                                psDetail.setInt(1, movementID);
                                psDetail.setInt(2, detail.getProductDetailID());
                                psDetail.setInt(3, detail.getQuantity());
                                psDetail.addBatch();
                            }
                            psDetail.executeBatch();
                        }
                    } else {
                        conn.rollback();
                        throw new SQLException("Không lấy được MovementID mới.");
                    }
                }

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public List<StockMovement> getRequestsByBranch(int branchId, String dbName) throws SQLException {
        List<StockMovement> result = new ArrayList<>();

        String sql = """
        SELECT MovementID, FromSupplierID, FromBranchID, FromWarehouseID,
               ToBranchID, ToWarehouseID, MovementType, CreatedBy, CreatedAt, Note
        FROM StockMovementsRequest
        WHERE FromBranchID = ?
        ORDER BY CreatedAt DESC
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StockMovement m = new StockMovement();
                    m.setMovementID(rs.getInt("MovementID"));
                    m.setFromSupplierID((Integer) rs.getObject("FromSupplierID"));
                    m.setFromBranchID((Integer) rs.getObject("FromBranchID"));
                    m.setFromWarehouseID((Integer) rs.getObject("FromWarehouseID"));
                    m.setToBranchID((Integer) rs.getObject("ToBranchID"));
                    m.setToWarehouseID((Integer) rs.getObject("ToWarehouseID"));
                    m.setMovementType(rs.getString("MovementType"));
                    m.setCreatedBy(rs.getInt("CreatedBy"));
                    m.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    m.setNote(rs.getString("Note"));

                    result.add(m);
                }
            }
        }

        return result;
    }

    public List<Warehouse> getAllWarehouses(String dbName) throws SQLException {
        List<Warehouse> list = new ArrayList<>();
        String sql = "SELECT WarehouseID, WarehouseName, Address FROM Warehouses";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Warehouse w = new Warehouse();
                w.setWareHouseId(rs.getInt("WarehouseID"));
                w.setWareHouseName(rs.getString("WarehouseName"));
                w.setWareHouseAddress(rs.getString("Address"));
                list.add(w);
            }
        }
        return list;
    }

}
