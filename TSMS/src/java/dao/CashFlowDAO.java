/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dao;

 import java.lang.*;
 import java.util.*;
 import java.io.*;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProductDTO;
import util.DBUtil;
/**
 *
 * @author Trieu Quang Nam
 */
public class CashFlowDAO {
    
   
 
    
//Truy vấn tổng doanh thu (income) trong bảng CashFlows của ngày hôm nay. 
public BigDecimal getTodayIncome(String dbName) throws SQLException {
    String sql = """
        SELECT ISNULL(SUM(Amount), 0) AS TotalIncome
        FROM CashFlows
        WHERE FlowType = 'income'
        AND CONVERT(DATE, CreatedAt) = CONVERT(DATE, GETDATE());
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        if (rs.next()) {
            return rs.getBigDecimal("TotalIncome");
        }
    } catch (Exception e) {
        System.out.println("Lỗi khi lấy tổng thu nhập hôm nay: " + e.getMessage());
    }

    return BigDecimal.ZERO;
}


//Đếm số hóa đơn tổng trong ngày của tất cả các tri nhánh
public int getTodayInvoiceCount(String dbName) throws SQLException {
    String sql = """
        SELECT COUNT(*) AS InvoiceCount
        FROM CashFlows
        WHERE CONVERT(DATE, CreatedAt) = CONVERT(DATE, GETDATE());
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {

        if (rs.next()) {
            return rs.getInt("InvoiceCount");
        }
    } catch (Exception e) {
        System.out.println("Lỗi khi đếm số hóa đơn hôm nay: " + e.getMessage());
    }

    return 0;
}

}
