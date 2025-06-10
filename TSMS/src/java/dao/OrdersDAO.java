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
import model.OrdersDTO;
import util.DBUtil;

/**
 *
 * @author Dell
 */
public class OrdersDAO {
        // 1. Lấy danh sách đơn hàng phân trang (mỗi dòng là 1 sản phẩm trong đơn)
    public List<OrdersDTO> getOrdersListByPage(String dbName, int page, int pageSize) {
        List<OrdersDTO> orders = new ArrayList<>();
        String query = """
                SELECT 
                    od.OrderDetailID,
                    od.ProductDetailID,
                    od.Quantity,
                    o.OrderID,
                    o.BranchID,
                    o.CreatedBy,
                    o.OrderStatus,
                    o.CreatedAt,
                    o.CustomerID,
                    o.PaymentMethod,
                    o.Notes,
                    o.GrandTotal,
                    o.CustomerPay,
                    o.Change,
                    b.BranchName,
                    c.FullName AS CustomerName,
                    u.FullName AS CreatedByName
                FROM 
                    Orders o
                    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
                    JOIN Branches b ON o.BranchID = b.BranchID
                    JOIN Customers c ON o.CustomerID = c.CustomerID
                    JOIN Users u ON o.CreatedBy = u.UserID
                ORDER BY o.CreatedAt DESC
                OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """;

        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, (page - 1) * pageSize);
            stmt.setInt(2, pageSize);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrdersDTO order = extractOrderDTOFromResultSet(rs);
                orders.add(order);
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong getOrdersListByPage: " + e.getMessage());
            e.printStackTrace();
        }
        return orders;
    }

    // 2. Đếm tổng số dòng (mỗi dòng là 1 chi tiết sản phẩm trong đơn hàng)
    public int countOrderDetails(String dbName) {
        int count = 0;
        String query = "SELECT COUNT(*) " +
                       "FROM Orders o " +
                       "LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement stmt = conn.prepareStatement(query)) {
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Lỗi trong countOrderDetails: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
    // Lấy thông tin đơn hàng theo OrderID (bao gồm thông tin chi nhánh, khách hàng, người tạo, v.v.)
public OrdersDTO getOrderDetailByOrderId(String dbName, int orderId) {
    OrdersDTO order = null;
    String query = """
        SELECT 
            od.OrderDetailID,
            od.ProductDetailID,
            od.Quantity,
            o.OrderID,
            o.BranchID,
            o.CreatedBy,
            o.OrderStatus,
            o.CreatedAt,
            o.CustomerID,
            o.PaymentMethod,
            o.Notes,
            o.GrandTotal,
            o.CustomerPay,
            o.Change,
            b.BranchName,
            c.FullName AS CustomerName,
            u.FullName AS CreatedByName
        FROM 
            Orders o
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            JOIN Branches b ON o.BranchID = b.BranchID
            JOIN Customers c ON o.CustomerID = c.CustomerID
            JOIN Users u ON o.CreatedBy = u.UserID
        WHERE o.OrderID = ?
        """;
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setInt(1, orderId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            order = extractOrderDTOFromResultSet(rs);
        }
    } catch (Exception e) {
        System.err.println("Lỗi trong getOrderDetailByOrderId: " + e.getMessage());
        e.printStackTrace();
    }
    return order;
}

// Nếu đơn hàng có nhiều sản phẩm, trả về list
public List<OrdersDTO> getOrderDetailsByOrderId(String dbName, int orderId) {
    List<OrdersDTO> orderDetails = new ArrayList<>();
    String query = """
        SELECT 
            od.OrderDetailID,
            od.ProductDetailID,
            od.Quantity,
            o.OrderID,
            o.BranchID,
            o.CreatedBy,
            o.OrderStatus,
            o.CreatedAt,
            o.CustomerID,
            o.PaymentMethod,
            o.Notes,
            o.GrandTotal,
            o.CustomerPay,
            o.Change,
            b.BranchName,
            c.FullName AS CustomerName,
            u.FullName AS CreatedByName
        FROM 
            Orders o
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            JOIN Branches b ON o.BranchID = b.BranchID
            JOIN Customers c ON o.CustomerID = c.CustomerID
            JOIN Users u ON o.CreatedBy = u.UserID
        WHERE o.OrderID = ?
    """;
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setInt(1, orderId);
        ResultSet rs = stmt.executeQuery();
        OrdersDAO dao = new OrdersDAO();
        while (rs.next()) {
            OrdersDTO detail = extractOrderDTOFromResultSet(rs);
            // Lấy ProductName từ ProductDetailID
            String productName = dao.getProductNameByProductDetailId(dbName, detail.getProductDetailID());
            // Gắn vào orderDetailDTO (bạn có thể mở rộng OrdersDTO để có thuộc tính productName)
            detail.setProductName(productName);
            orderDetails.add(detail);
        }
    } catch (Exception e) {
        System.err.println("Lỗi trong getOrderDetailsByOrderId: " + e.getMessage());
        e.printStackTrace();
    }
    return orderDetails;
}
public String getProductNameByProductDetailId(String dbName, int productDetailId) {
    String productName = "";
    String query = """
        SELECT p.ProductName
        FROM ProductDetails pd
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE pd.ProductDetailID = ?
    """;
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setInt(1, productDetailId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            productName = rs.getString("ProductName");
        }
    } catch (Exception e) {
        System.err.println("Lỗi trong getProductNameByProductDetailId: " + e.getMessage());
        e.printStackTrace();
    }
    return productName;
}
public void updateOrderStatusAndNotes(String dbName, int orderId, String orderStatus, String notes) {
    String query = "UPDATE Orders SET OrderStatus = ?, Notes = ? WHERE OrderID = ?";
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setString(1, orderStatus);
        stmt.setString(2, notes);
        stmt.setInt(3, orderId);
        stmt.executeUpdate();
    } catch (Exception e) {
        System.err.println("Lỗi trong updateOrderStatusAndNotes: " + e.getMessage());
        e.printStackTrace();
    }
}


    // 3. Hàm extract dữ liệu từ ResultSet sang OrderDTO
    private static OrdersDTO extractOrderDTOFromResultSet(ResultSet rs) throws SQLException {
        OrdersDTO orderDTO = new OrdersDTO(
            rs.getInt("OrderDetailID"),
            rs.getInt("ProductDetailID"),
            rs.getInt("Quantity"),
            rs.getInt("OrderID"),
            rs.getInt("BranchID"),
            rs.getInt("CreatedBy"),
            rs.getString("OrderStatus"),
            rs.getTimestamp("CreatedAt"),
            rs.getInt("CustomerID"),
            rs.getString("PaymentMethod"),
            rs.getString("Notes"),
            rs.getDouble("GrandTotal"),
            rs.getDouble("CustomerPay"),
            rs.getDouble("Change"),
            rs.getString("BranchName"),
            rs.getString("CustomerName"),
            rs.getString("CreatedByName")
        );
        return orderDTO;
    }
    public static void main(String[] args) {
        String dbName = "DTB_Tien"; // Thay bằng tên DB của bạn
        int page = 1;
        int pageSize = 10;

        OrdersDAO dao = new OrdersDAO();

        List<OrdersDTO> ordersList = dao.getOrdersListByPage(dbName, page, pageSize);
        for (OrdersDTO order : ordersList) {
            System.out.println("OrderID: " + order.getOrderID()
                + ", Branch: " + order.getBranchID()
                + ", Customer: " + order.getCustomerID()
                + ", Total: " + order.getGrandTotal()
                + ", Status: " + order.getOrderStatus()
                + ", CreatedAt: " + order.getCreatedAt());
        }

        // Test hàm countOrders
        System.out.println("\n=== Test countOrders ===");
        int totalOrders = dao.countOrderDetails(dbName);
        System.out.println("Total Orders: " + totalOrders);
    }
}

