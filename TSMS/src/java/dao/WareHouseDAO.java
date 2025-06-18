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

    public static List<Warehouse> getBranchList(String dbName) throws SQLException {
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
                Connection conn = DBUtil.getConnectionTo(dbName); 
                 PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                names.add(rs.getString("Name"));
            }
        }

        return names;
    }

    private static Warehouse extractWareHouseFromResultSet(ResultSet rs) throws SQLException {
        Warehouse wh = new Warehouse(rs.getInt("WarehouseId"), rs.getNString("WarehouseName"), rs.getNString("Address"));
        return wh;
    }

    public static void main(String[] args) throws SQLException {
        List<Warehouse> warehouses = WareHouseDAO.getBranchList("DTB_Bm");
        System.out.println(warehouses);
    }
}
