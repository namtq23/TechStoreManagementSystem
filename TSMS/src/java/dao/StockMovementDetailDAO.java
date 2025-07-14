package dao;

import java.sql.*;
import java.util.*;
import model.StockMovementDetail;
import model.ProductDetailSerialNumber;
import util.DBUtil;

public class StockMovementDetailDAO {

    public List<StockMovementDetail> getDetailsByMovementID(String dbName, int movementID) {
        List<StockMovementDetail> list = new ArrayList<>();
        String query = """
        SELECT 
            d.MovementDetailID AS DetailID,
            d.MovementID,
            pd.ProductID,
            pd.ProductDetailID,
            p.ProductName,
            pd.ProductCode,
            d.Quantity,
            d.QuantityScanned,
            (
                SELECT COUNT(*) 
                FROM ProductDetailSerialNumber 
                WHERE ProductDetailID = d.ProductDetailID 
                  AND MovementDetailID = d.MovementDetailID
                  AND OrderID IS NULL 
                  AND BranchID IS NULL 
                  AND WarehouseID IS NULL
            ) AS Scanned
        FROM StockMovementDetail d
        JOIN ProductDetails pd ON d.ProductDetailID = pd.ProductDetailID
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE d.MovementID = ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, movementID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StockMovementDetail detail = new StockMovementDetail();
                    int detailID = rs.getInt("DetailID");
                    int productDetailID = rs.getInt("ProductDetailID");

                    detail.setDetailID(detailID);
                    detail.setRequestID(rs.getInt("MovementID"));
                    detail.setProductID(rs.getInt("ProductID"));
                    detail.setProductCode(rs.getString("ProductCode"));
                    detail.setProductName(rs.getString("ProductName"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    detail.setQuantityScanned(rs.getInt("QuantityScanned"));  // Dữ liệu từ bảng
                    detail.setScanned(rs.getInt("Scanned"));                  // Subquery đếm tạm thời

                    // Lấy danh sách serial tạm thời theo cả 2 ID
                    List<ProductDetailSerialNumber> serials = getTempSerialsByDetail(dbName, detailID, productDetailID);
                    detail.setSerials(serials != null ? serials : new ArrayList<>());

                    list.add(detail);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ProductDetailSerialNumber> getTempSerialsByDetail(String dbName, int movementDetailID, int productDetailID) {
        List<ProductDetailSerialNumber> serials = new ArrayList<>();
        String sql = """
            SELECT 
                ProductDetailID, 
                MovementDetailID,
                SerialNumber, 
                Status, 
                OrderID, 
                BranchID, 
                WarehouseID 
            FROM ProductDetailSerialNumber 
            WHERE ProductDetailID = ? 
              AND MovementDetailID = ?
              AND OrderID IS NULL 
              AND BranchID IS NULL 
              AND WarehouseID IS NULL
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productDetailID);
            ps.setInt(2, movementDetailID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDetailSerialNumber serial = new ProductDetailSerialNumber();
                    serial.setProductDetailID(rs.getInt("ProductDetailID"));
                    serial.setMovementDetailID(rs.getInt("MovementDetailID"));
                    serial.setSerialNumber(rs.getString("SerialNumber"));
                    serial.setStatus(rs.getString("Status"));
                    serial.setOrderID((Integer) rs.getObject("OrderID"));
                    serial.setBranchID((Integer) rs.getObject("BranchID"));
                    serial.setWarehouseID((Integer) rs.getObject("WarehouseID"));
                    serials.add(serial);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error loading serials: " + e.getMessage());
            e.printStackTrace();
        }

        return serials;
    }

    public void insertMovementDetail(
        String dbName,
        int movementId,
        int productDetailId,
        int quantity
) throws SQLException {
    String sql = """
        INSERT INTO StockMovementDetail (
            MovementID, ProductDetailID, Quantity, QuantityScanned
        ) VALUES (?, ?, ?, 0);
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, movementId);
        ps.setInt(2, productDetailId);
        ps.setInt(3, quantity);

        ps.executeUpdate();
    }
}
public List<StockMovementDetail> getRawDetailsByMovementID(String dbName, int movementID) throws SQLException {
    List<StockMovementDetail> list = new ArrayList<>();
    String sql = "SELECT d.MovementDetailID, d.MovementID, d.ProductDetailID, d.Quantity, d.QuantityScanned, " +
                 "pd.ProductCode, p.ProductName " +
                 "FROM StockMovementDetail d " +
                 "JOIN ProductDetails pd ON d.ProductDetailID = pd.ProductDetailID " +
                 "JOIN Products p ON pd.ProductID = p.ProductID " +
                 "WHERE d.MovementID = ?";

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, movementID);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            StockMovementDetail detail = new StockMovementDetail();
            detail.setDetailID(rs.getInt("MovementDetailID"));
            detail.setRequestID(rs.getInt("MovementID"));
            detail.setProductID(rs.getInt("ProductDetailID"));
            detail.setQuantity(rs.getInt("Quantity"));
            detail.setQuantityScanned(rs.getInt("QuantityScanned"));
            detail.setProductCode(rs.getString("ProductCode"));
            detail.setProductName(rs.getString("ProductName"));
            list.add(detail);
        }
    }
    return list;
}




}
