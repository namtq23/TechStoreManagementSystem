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
    public static List<Branch> getBranchList(String dbName) throws SQLException{
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
     
     public static void main(String[] args) throws SQLException {
        List<Branch> branches = BranchDAO.getBranchList("DTB_Bm");
         System.out.println(branches);
    }
    
}
