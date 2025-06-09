/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import model.Order;
import model.OrderDetails;
import model.ProductDTO;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class OrderDAO {

    public static boolean insertOrderWithDetails(String dbName, Order order, List<ProductDTO> products) {
        Connection conn;
        PreparedStatement orderStmt;
        PreparedStatement detailStmt;
        ResultSet generatedKeys;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false);

            String orderSql = "INSERT INTO Orders (BranchID, CreatedBy, OrderStatus, CreatedAt, CustomerID, PaymentMethod, Notes, GrandTotal, CustomerPay, Change) "
                    + "VALUES (?, ?, ?, GETDATE(), ?, ?, ?, ?, ?, ?)";
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, order.getBranchId());
            orderStmt.setInt(2, order.getCreatedBy());
            orderStmt.setString(3, order.getOrderStatus());
            orderStmt.setInt(4, order.getCustomerId());
            orderStmt.setString(5, order.getPaymentMethod());
            orderStmt.setString(6, order.getNote());
            orderStmt.setDouble(7, order.getGrandTotal());
            orderStmt.setDouble(8, order.getCustomerPay());
            orderStmt.setDouble(9, order.getChange());
            orderStmt.executeUpdate();

            generatedKeys = orderStmt.getGeneratedKeys();
            if (!generatedKeys.next()) {
                conn.rollback();
                return false;
            }
            int orderId = generatedKeys.getInt(1);

            String detailSql = "INSERT INTO OrderDetails (OrderID, ProductDetailID, Quantity) VALUES (?, ?, ?)";
            detailStmt = conn.prepareStatement(detailSql);
            for (ProductDTO product : products) {
                detailStmt.setInt(1, orderId);
                detailStmt.setInt(2, product.getProductDetailId());
                detailStmt.setInt(3, product.getQuantity());
                detailStmt.addBatch();
            }
            detailStmt.executeBatch();

            conn.commit();
            return true;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }
}
