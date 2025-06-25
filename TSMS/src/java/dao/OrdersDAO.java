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
import model.OrdersDTO;
import util.DBUtil;

/**
 *
 * @author Dell
 */
public class OrdersDAO {

    public List<OrdersDTO> getOrdersListByPage(String dbName, int page, int pageSize, Integer branchID) {
    List<OrdersDTO> orders = new ArrayList<>();
    StringBuilder query = new StringBuilder("""
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
            u.FullName AS CreatedByName,
            p.ProductName
        FROM 
            Orders o
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            JOIN Branches b ON o.BranchID = b.BranchID
            JOIN Customers c ON o.CustomerID = c.CustomerID
            JOIN Users u ON o.CreatedBy = u.UserID
        """);

    if (branchID != null && branchID > 0) {
        query.append(" WHERE o.BranchID = ?");
    }

    query.append(" ORDER BY o.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement stmt = conn.prepareStatement(query.toString())) {
        int paramIndex = 1;
        if (branchID != null && branchID > 0) {
            stmt.setInt(paramIndex++, branchID);
        }
        stmt.setInt(paramIndex++, (page - 1) * pageSize);
        stmt.setInt(paramIndex, pageSize);

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            OrdersDTO order = extractOrderDTOFromResultSet(rs);
            orders.add(order);
        }
    } catch (SQLException e) {
        System.err.println("Error in getOrdersListByPage: " + e.getMessage());
        e.printStackTrace();
    }
    return orders;
}

public int countOrderDetails(String dbName, Integer branchID) {
    int count = 0;
    StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM Orders o LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID");
    
    if (branchID != null && branchID > 0) {
        query.append(" WHERE o.BranchID = ?");
    }

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement stmt = conn.prepareStatement(query.toString())) {
        if (branchID != null && branchID > 0) {
            stmt.setInt(1, branchID);
        }
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        System.err.println("Error in countOrderDetails: " + e.getMessage());
        e.printStackTrace();
    }
    return count;
}

    public void updateOrderDetails(String dbName, OrdersDTO order) {
        String query = """
            UPDATE Orders 
            SET OrderStatus = ?, Notes = ?, CreatedAt = GETDATE()
            WHERE OrderID = ?;
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            int paramIndex = 1;
            stmt.setString(paramIndex++, order.getOrderStatus());
            stmt.setString(paramIndex++, order.getNotes());
            stmt.setInt(paramIndex, order.getOrderID());
            stmt.executeUpdate();
            System.out.println("Cập nhật đơn hàng thành công: OrderID = " + order.getOrderID());
        } catch (Exception e) {
            System.err.println("Lỗi trong updateOrderDetails: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public OrdersDTO getOrderById(String dbName, int orderID) {
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
                    u.FullName AS CreatedByName,
                    p.ProductName
                FROM 
                    Orders o
                    LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
                    LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
                    LEFT JOIN Products p ON pd.ProductID = p.ProductID
                    JOIN Branches b ON o.BranchID = b.BranchID
                    JOIN Customers c ON o.CustomerID = c.CustomerID
                    JOIN Users u ON o.CreatedBy = u.UserID
                WHERE 
                    o.OrderID = ?
                """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, orderID);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                order = extractOrderDTOFromResultSet(rs);
            }
        } catch (Exception e) {
            System.err.println("Error in getOrderById: " + e.getMessage());
            e.printStackTrace();
        }
        return order;
    }

    public void deleteOrder(String dbName, int orderID) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false); // Start transaction

            // 1. Check if OrderID exists
            String checkOrderSql = "SELECT OrderID FROM " + dbName + ".dbo.Orders WHERE OrderID = ?";
            pstmt = conn.prepareStatement(checkOrderSql);
            pstmt.setInt(1, orderID);
            ResultSet rs = pstmt.executeQuery();
            if (!rs.next()) {
                rs.close();
                pstmt.close();
                conn.rollback();
                throw new SQLException("Không tìm thấy đơn hàng với OrderID: " + orderID);
            }
            rs.close();
            pstmt.close();

            // 2. Delete from OrderDetails
            String deleteOrderDetailsSql = "DELETE FROM " + dbName + ".dbo.OrderDetails WHERE OrderID = ?";
            pstmt = conn.prepareStatement(deleteOrderDetailsSql);
            pstmt.setInt(1, orderID);
            pstmt.executeUpdate();
            pstmt.close();

            // 3. Delete from Orders
            String deleteOrderSql = "DELETE FROM " + dbName + ".dbo.Orders WHERE OrderID = ?";
            pstmt = conn.prepareStatement(deleteOrderSql);
            pstmt.setInt(1, orderID);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();

            if (rowsAffected == 0) {
                conn.rollback();
                throw new SQLException("Không thể xóa đơn hàng với OrderID: " + orderID);
            }

            conn.commit(); // Commit transaction
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException ignored) {
                }
            }
            if (conn != null) {
                DBUtil.closeConnection(conn);
            }
        }
    }
    public List<Branch> getAllBranches(String dbName) {
    List<Branch> branches = new ArrayList<>();
    String query = "SELECT BranchID, BranchName FROM Branches WHERE IsActive = 1 ORDER BY BranchName";

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement stmt = conn.prepareStatement(query)) {
        ResultSet rs = stmt.executeQuery();
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

    private static OrdersDTO extractOrderDTOFromResultSet(ResultSet rs) throws SQLException {
        int orderDetailID = rs.getInt("OrderDetailID");
        if (rs.wasNull()) {
            orderDetailID = 0;
        }

        int productDetailID = rs.getInt("ProductDetailID");
        if (rs.wasNull()) {
            productDetailID = 0;
        }

        int quantity = rs.getInt("Quantity");
        if (rs.wasNull()) {
            quantity = 0;
        }

        String productName = rs.getString("ProductName");
        if (rs.wasNull()) {
            productName = "N/A";
        }

        return new OrdersDTO(
                orderDetailID,
                productDetailID,
                quantity,
                rs.getString("BranchName"),
                rs.getString("CustomerName"),
                rs.getString("CreatedByName"),
                productName,
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
                rs.getDouble("Change")
        );
    }
    private static OrdersDTO extractBranchOrderDTOFromResultSet(ResultSet rs) throws SQLException {
    int orderDetailID = rs.getInt("OrderDetailID");
    if (rs.wasNull()) {
        orderDetailID = 0;
    }

    int productDetailID = rs.getInt("ProductDetailID");
    if (rs.wasNull()) {
        productDetailID = 0;
    }

    int quantity = rs.getInt("Quantity");
    if (rs.wasNull()) {
        quantity = 0;
    }

    String productName = rs.getString("ProductName");
    if (rs.wasNull()) {
        productName = "N/A";
    }

    String customerName = rs.getString("CustomerName");
    if (rs.wasNull()) {
        customerName = "N/A";
    }

    String createdByName = rs.getString("CreatedByName");
    if (rs.wasNull()) {
        createdByName = "N/A";
    }

    return new OrdersDTO(
            orderDetailID,
            productDetailID,
            quantity,
            null, // branchName not needed for branch manager
            customerName,
            createdByName,
            productName,
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
            rs.getDouble("Change")
    );
}
    public List<OrdersDTO> getBranchFilteredOrdersListByPage(String dbName, int branchID, int page, int pageSize, 
        String[] creatorIDs, String startDate, String endDate, 
        Double minPrice, Double maxPrice, String searchKeyword) {
    List<OrdersDTO> orders = new ArrayList<>();
    StringBuilder query = new StringBuilder("""
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
            c.FullName AS CustomerName,
            u.FullName AS CreatedByName,
            p.ProductName
        FROM 
            Orders o
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            JOIN Customers c ON o.CustomerID = c.CustomerID
            JOIN Users u ON o.CreatedBy = u.UserID
        WHERE o.BranchID = ?
        """);

    List<Object> parameters = new ArrayList<>();
    parameters.add(branchID);

    // Creator filter
    if (creatorIDs != null && creatorIDs.length > 0) {
        query.append(" AND o.CreatedBy IN (");
        for (int i = 0; i < creatorIDs.length; i++) {
            query.append("?");
            if (i < creatorIDs.length - 1) query.append(",");
            parameters.add(Integer.parseInt(creatorIDs[i]));
        }
        query.append(")");
    }

    // Date filter
    if (startDate != null && !startDate.trim().isEmpty()) {
        query.append(" AND CAST(o.CreatedAt AS DATE) >= ?");
        parameters.add(startDate);
    }

    // Price range filter
    if (minPrice != null) {
        query.append(" AND o.GrandTotal >= ?");
        parameters.add(minPrice);
    }
    if (maxPrice != null) {
        query.append(" AND o.GrandTotal <= ?");
        parameters.add(maxPrice);
    }

    // Search filter
    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
        query.append(" AND (p.ProductName LIKE ? OR c.FullName LIKE ? OR CAST(o.OrderID AS NVARCHAR) LIKE ?)");
        String searchPattern = "%" + searchKeyword + "%";
        parameters.add(searchPattern);
        parameters.add(searchPattern);
        parameters.add(searchPattern);
    }

    query.append(" ORDER BY o.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    parameters.add((page - 1) * pageSize);
    parameters.add(pageSize);

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement stmt = conn.prepareStatement(query.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            stmt.setObject(i + 1, parameters.get(i));
        }

        ResultSet rs = stmt.executeQuery();
        while (rs.next()) {
            OrdersDTO order = extractBranchOrderDTOFromResultSet(rs);
            orders.add(order);
        }
    } catch (SQLException e) {
        System.err.println("Error in getBranchFilteredOrdersListByPage: " + e.getMessage());
        e.printStackTrace();
    }
    return orders;
}

// Count filtered orders for specific branch
public int countBranchFilteredOrders(String dbName, int branchID, String[] creatorIDs, 
        String startDate, String endDate, Double minPrice, Double maxPrice, String searchKeyword) {
    int count = 0;
    StringBuilder query = new StringBuilder("""
        SELECT COUNT(DISTINCT o.OrderID) 
        FROM Orders o 
        LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID 
        LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
        LEFT JOIN Products p ON pd.ProductID = p.ProductID
        JOIN Customers c ON o.CustomerID = c.CustomerID
        WHERE o.BranchID = ?
        """);

    List<Object> parameters = new ArrayList<>();
    parameters.add(branchID);

    // Creator filter
    if (creatorIDs != null && creatorIDs.length > 0) {
        query.append(" AND o.CreatedBy IN (");
        for (int i = 0; i < creatorIDs.length; i++) {
            query.append("?");
            if (i < creatorIDs.length - 1) query.append(",");
            parameters.add(Integer.parseInt(creatorIDs[i]));
        }
        query.append(")");
    }

    // Date filter
    if (startDate != null && !startDate.trim().isEmpty()) {
        query.append(" AND CAST(o.CreatedAt AS DATE) >= ?");
        parameters.add(startDate);
    }

    // Price range filter
    if (minPrice != null) {
        query.append(" AND o.GrandTotal >= ?");
        parameters.add(minPrice);
    }
    if (maxPrice != null) {
        query.append(" AND o.GrandTotal <= ?");
        parameters.add(maxPrice);
    }

    // Search filter
    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
        query.append(" AND (p.ProductName LIKE ? OR c.FullName LIKE ? OR CAST(o.OrderID AS NVARCHAR) LIKE ?)");
        String searchPattern = "%" + searchKeyword + "%";
        parameters.add(searchPattern);
        parameters.add(searchPattern);
        parameters.add(searchPattern);
    }

    try (Connection conn = DBUtil.getConnectionTo(dbName); 
         PreparedStatement stmt = conn.prepareStatement(query.toString())) {
        
        for (int i = 0; i < parameters.size(); i++) {
            stmt.setObject(i + 1, parameters.get(i));
        }

        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
        }
    } catch (SQLException e) {
        System.err.println("Error in countBranchFilteredOrders: " + e.getMessage());
        e.printStackTrace();
    }
    return count;
}

    public static void main(String[] args) {
    }
}
