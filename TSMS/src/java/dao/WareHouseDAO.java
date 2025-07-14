/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.List;
import model.Warehouse;
import java.sql.SQLException;
import java.util.ArrayList;
import util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author admin
 */
public class WareHouseDAO {

    public static List<Warehouse> getWarehouseList(String dbName) throws SQLException {
        List<Warehouse> warehouses = new ArrayList<>();

        String sql = """
            select * from Warehouses
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Warehouse wh = extractWareHouseFromResultSet(rs);
                warehouses.add(wh);
            }
        }

        return warehouses;
    }

    public List<String> getAllInventoryAndWarehouseNames(String dbName) throws SQLException {
        List<String> names = new ArrayList<>();

        String sql = """
            SELECT WarehouseName AS Name
            FROM Warehouses
            UNION
            SELECT b.BranchName AS Name
            FROM Inventory i
            JOIN Branches b ON i.BranchID = b.BranchID
        """;

        try (
                Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                names.add(rs.getString("Name"));
            }
        }

        return names;
    }

    public List<Warehouse> getAllWarehouses(String dbName) {
        List<Warehouse> warehouses = new ArrayList<>();
        String query = "SELECT WarehouseID, WarehouseName FROM Warehouses";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Warehouse warehouse = new Warehouse();
                warehouse.setWareHouseId(rs.getInt("WarehouseID"));
                warehouse.setWareHouseName(rs.getString("WarehouseName"));
                warehouses.add(warehouse);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllWarehouses: " + e.getMessage());
            e.printStackTrace();
        }
        return warehouses;
    }

    public static boolean createWarehouse(Warehouse warehouse, String dbName) throws SQLException {
        String sql = "INSERT INTO Warehouses (WarehouseName, Address, Phone, IsActive) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, warehouse.getWareHouseName());
            stmt.setString(2, warehouse.getWareHouseAddress());
            stmt.setString(3, warehouse.getPhone());
            stmt.setInt(4, warehouse.getIsActive());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean updateWarehouse(Warehouse warehouse, String dbName) throws SQLException {
        String sql = "UPDATE Warehouses SET WarehouseName = ?, Address = ?, Phone = ?, IsActive = ? WHERE WarehouseID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, warehouse.getWareHouseName());
            stmt.setString(2, warehouse.getWareHouseAddress());
            stmt.setString(3, warehouse.getPhone());
            stmt.setInt(4, warehouse.getIsActive());
            stmt.setInt(5, warehouse.getWareHouseId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteWarehouse(int warehouseId, String dbName) throws SQLException {
        String sql = "DELETE FROM Warehouses WHERE WarehouseID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, warehouseId);
            return stmt.executeUpdate() > 0;
        }
    }

    private static Warehouse extractWareHouseFromResultSet(ResultSet rs) throws SQLException {
        Warehouse wh = new Warehouse(rs.getInt("WarehouseId"), rs.getNString("WarehouseName"), rs.getNString("Address"), rs.getNString("Phone"), rs.getInt("IsActive"));
        return wh;
    }

    public static Warehouse getWarehouseById(String WarehouseId, String dbName) throws SQLException {
        String sql = """
        SELECT 
            WarehouseID,
            WarehouseName,
            Address,
            Phone,
            IsActive
        FROM Warehouses 
        WHERE WarehouseID = ? 
          AND IsActive = 1
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, WarehouseId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Warehouse wh = new Warehouse();
                    wh.setWareHouseId(rs.getInt("WarehouseID"));
                    wh.setWareHouseName(rs.getString("WarehouseName"));
                    wh.setWareHouseAddress(rs.getString("Address"));
                    wh.setPhone(rs.getString("Phone"));
                    wh.setIsActive(rs.getInt("IsActive"));
                    return wh;
                }
            }
        }
        return null;
    }
public void insertWarehouseProduct(String dbName, int warehouseID, int productDetailID, int quantity) throws SQLException {
    String sql = "MERGE INTO " + dbName + ".dbo.WarehouseProducts AS target " +
                 "USING (SELECT ? AS WarehouseID, ? AS ProductDetailID) AS source " +
                 "ON target.WarehouseID = source.WarehouseID AND target.ProductDetailID = source.ProductDetailID " +
                 "WHEN MATCHED THEN UPDATE SET Quantity = target.Quantity + ? " +
                 "WHEN NOT MATCHED THEN INSERT (WarehouseID, ProductDetailID, Quantity) VALUES (?, ?, ?);";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, warehouseID);
        stmt.setInt(2, productDetailID);
        stmt.setInt(3, quantity);
        stmt.setInt(4, warehouseID);
        stmt.setInt(5, productDetailID);
        stmt.setInt(6, quantity);
        stmt.executeUpdate();
    }
}



     

    public static void main(String[] args) throws SQLException {
        List<Warehouse> warehouses = WareHouseDAO.getWarehouseList("DTB_Bm");
        System.out.println(warehouses);
    }
}
