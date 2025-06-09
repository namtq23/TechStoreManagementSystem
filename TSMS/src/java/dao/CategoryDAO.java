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
    List<Category> list = new ArrayList<>();
    String sql = "SELECT CategoryID, CategoryName FROM Categories";
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            list.add(new Category(rs.getInt("CategoryID"), rs.getString("CategoryName")));
        }
    } catch (Exception e) {
        System.out.println(e.getMessage());
    }
    return list;
}
}
