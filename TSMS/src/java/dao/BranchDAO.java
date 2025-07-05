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
import model.Branch;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class BranchDAO {

    public static List<Branch> getBranchList(String dbName) throws SQLException {
        List<Branch> branches = new ArrayList<>();

        String sql = """
            select * from Branches
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Branch branch = extractBranchFromResultSet(rs);
                branches.add(branch);
            }
        }

        return branches;
    }

    private static Branch extractBranchFromResultSet(ResultSet rs) throws SQLException {
        Branch branch = new Branch(rs.getInt("BranchID"), rs.getNString("BranchName"), rs.getNString("Address"), rs.getString("Phone"), rs.getByte("isActive"));
        return branch;
    }

    //Lấy ra list
    public List<Branch> getAllBranches(String dbName) throws SQLException {
        List<Branch> branches = new ArrayList<>();

        String sql = """
            SELECT * FROM Branches WHERE isActive = 1
            ORDER BY BranchName
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Branch branch = extractBranchFromResultSet(rs);
                branches.add(branch);
            }
        }

        return branches;
    }

    public List<Branch> getAllBranch(String dbName) {
        List<Branch> branches = new ArrayList<>();
        String query = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Branch branch = new Branch();
                branch.setBranchId(rs.getInt("BranchID"));
                branch.setBranchName(rs.getString("BranchName"));
                branches.add(branch);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllBranches: " + e.getMessage());
            e.printStackTrace();
        }
        return branches;
    }

    //lấy ra thông tin BracnhByID  
    public static Branch getBranchById(String branchId, String dbName) throws SQLException {
        String sql = """
        SELECT 
            BranchID,
            BranchName,
            Address,
            Phone,
            IsActive
        FROM Branches 
        WHERE BranchID = ? 
          AND IsActive = 1
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, branchId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Branch branch = new Branch();
                    branch.setBranchId(rs.getInt("BranchID"));
                    branch.setBranchName(rs.getString("BranchName"));
                    branch.setAddress(rs.getString("Address"));
                    branch.setPhone(rs.getString("Phone"));
                    branch.setIsActive(rs.getInt("IsActive"));
                    return branch;
                }
            }
        }
        return null; // Không tìm thấy chi nhánh
    }

    public static int countBranches(String dbName) throws SQLException {
        int result = 0;
        String sql = "SELECT COUNT(*) AS Branches FROM Branches";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                result = rs.getInt("Branches");
            }
        }
        return result;
    }

    public static boolean insertBranch(String dbName, String branchName, String address, String phone) throws SQLException {
        String sql = "INSERT INTO Branches (BranchName, Address, Phone, IsActive) VALUES (?, ?, ?, 1)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, branchName);
            ps.setString(2, address);
            ps.setString(3, phone);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    public static void updateBranch(int branchId, String name, String address, String phone, boolean isActive, String dbName) throws SQLException {
        String sql = "UPDATE Branches SET BranchName = ?, Address = ?, Phone = ?, IsActive = ? WHERE BranchID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, phone);
            ps.setBoolean(4, isActive);
            ps.setInt(5, branchId);
            ps.executeUpdate();
        }
    }

    public static void deleteBranch(int branchId, String dbName) throws SQLException {
        String sql = "DELETE FROM Branches WHERE BranchID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, branchId);
            ps.executeUpdate();
        }
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(BranchDAO.getBranchById("1", "DTB_TechStore"));
    }

}
