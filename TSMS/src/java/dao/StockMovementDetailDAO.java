package dao;

import java.sql.*;
import java.util.*;
import model.StockMovementDetail;
import model.ProductDetailSerialNumber;
import util.DBUtil;

public class StockMovementDetailDAO {

    public List<StockMovementDetail> getDetailsByMovementID(String dbName, int movementID) {
        List<StockMovementDetail> list = new ArrayList<>();
        String query = "SELECT d.DetailID, d.MovementID, pd.ProductID, p.ProductName, p.ProductCode, d.Quantity, pd.Unit, d.Note, " +
                       "       (SELECT COUNT(*) FROM ProductDetailSerialNumber WHERE ProductDetailID = d.DetailID AND OrderID IS NULL AND BranchID IS NULL AND WarehouseID IS NULL) AS Scanned " +
                       "FROM StockMovementDetail d " +
                       "JOIN ProductDetails pd ON d.ProductDetailID = pd.ProductDetailID " +
                       "JOIN Products p ON pd.ProductID = p.ProductID " +
                       "WHERE d.MovementID = ?";

        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, movementID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StockMovementDetail detail = new StockMovementDetail();
                    detail.setDetailID(rs.getInt("DetailID"));
                    detail.setRequestID(rs.getInt("MovementID"));
                    detail.setProductID(rs.getInt("ProductID"));
                    detail.setProductName(rs.getString("ProductName"));
                    detail.setProductCode(rs.getString("ProductCode"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    detail.setUnit(rs.getString("Unit"));
                    detail.setNote(rs.getString("Note"));
                    detail.setScanned(rs.getInt("Scanned"));

                    // Gán serials tạm vào model
                    List<ProductDetailSerialNumber> serials = getTempSerialsByDetailID(dbName, detail.getDetailID());
                    detail.setSerials(serials);

                    list.add(detail);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ProductDetailSerialNumber> getTempSerialsByDetailID(String dbName, int detailID) {
        List<ProductDetailSerialNumber> serials = new ArrayList<>();
        String sql = "SELECT ProductDetailID, SerialNumber, Status, OrderID, BranchID, WarehouseID FROM ProductDetailSerialNumber " +
                     "WHERE ProductDetailID = ? AND OrderID IS NULL AND BranchID IS NULL AND WarehouseID IS NULL";

        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDetailSerialNumber serial = new ProductDetailSerialNumber();
                    serial.setProductDetailID(rs.getInt("ProductDetailID"));
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
}
