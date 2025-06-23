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
import model.Brand;
import util.DBUtil;

/**
 *
 * @author Dell
 */
public class BrandDAO {
    public List<Brand> getAllBrands(String dbName) throws SQLException {
        List<Brand> brands = new ArrayList<>();
        String sql = "SELECT BrandID, BrandName FROM Brands ORDER BY BrandName";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Brand brand = new Brand();
                brand.setBrandID(rs.getInt("BrandID"));
                brand.setBrandName(rs.getString("BrandName"));
                brands.add(brand);
            }
        }
        return brands;
    }
    public boolean isBrandNameExists(String dbName, String brandName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Brands WHERE BrandName = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, brandName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    public boolean addBrand(String dbName, String brandName) throws SQLException {
        String sql = "INSERT INTO Brands (BrandName) VALUES (?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, brandName);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }
}
