/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.ArrayList;
import java.util.List;
import model.Category;
import util.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Dell
 */
public class CategoryDAO {
    public List<Category> getAllCategories(String dbName) {
        List<Category> categories = new ArrayList<>();
        String query = "SELECT CategoryID, CategoryName FROM Categories";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryID(rs.getInt("CategoryID"));
                category.setCategoryName(rs.getString("CategoryName"));
                categories.add(category);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return categories;
    }
    public boolean isCategoryNameExists(String dbName, String categoryName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Categories WHERE CategoryName = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    public boolean addCategory(String dbName, String categoryName) throws SQLException {
    String maxIdSql = "SELECT MAX(CategoryID) FROM Categories";
    int newId;
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement psMax = conn.prepareStatement(maxIdSql);
         ResultSet rs = psMax.executeQuery()) {
        newId = rs.next() ? rs.getInt(1) + 1 : 1;
    }

    String sql = "INSERT INTO Categories (CategoryID, CategoryName) VALUES (?, ?)";
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, newId);
        ps.setString(2, categoryName);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    }
}
}
