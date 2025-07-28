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

    public List<OrdersDTO> getFilteredOrdersListByPage(String dbName, int page, int pageSize,
            String branchID, String[] creatorIDs, String startDate, String endDate,
            Double minPrice, Double maxPrice, String searchKeyword) {

        List<OrdersDTO> orders = new ArrayList<>();

        StringBuilder query = new StringBuilder("""
                SELECT 
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
                    COALESCE(
                        STRING_AGG(
                            CASE 
                                WHEN p.ProductName IS NOT NULL 
                                THEN CONCAT(od.Quantity, ' ', p.ProductName)
                                ELSE NULL
                            END, 
                            '; '
                        ), 
                        'Không có sản phẩm'
                    ) AS ProductDetails
                FROM Orders o
                INNER JOIN Branches b ON o.BranchID = b.BranchID
                INNER JOIN Customers c ON o.CustomerID = c.CustomerID
                INNER JOIN Users u ON o.CreatedBy = u.UserID
                LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
                LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
                LEFT JOIN Products p ON pd.ProductID = p.ProductID
                WHERE 1=1
            """);

        List<Object> parameters = new ArrayList<>();

        // Filter by single branch ID
        if (branchID != null && !branchID.trim().isEmpty()) {
            query.append(" AND o.BranchID = ?");
            parameters.add(Integer.parseInt(branchID));
        }

        // Filter by multiple creator IDs (giữ nguyên vì có thể cần multiple creators)
        if (creatorIDs != null && creatorIDs.length > 0) {
            query.append(" AND o.CreatedBy IN (");
            query.append("?,".repeat(creatorIDs.length));
            query.setLength(query.length() - 1);
            query.append(")");
            for (String id : creatorIDs) {
                parameters.add(Integer.parseInt(id));
            }
        }

        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(" AND CAST(o.CreatedAt AS DATE) >= ?");
            parameters.add(startDate);
        }

        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(" AND CAST(o.CreatedAt AS DATE) <= ?");
            parameters.add(endDate);
        }

        if (minPrice != null) {
            query.append(" AND o.GrandTotal >= ?");
            parameters.add(minPrice);
        }

        if (maxPrice != null) {
            query.append(" AND o.GrandTotal <= ?");
            parameters.add(maxPrice);
        }

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            query.append(" AND (");
            query.append("c.FullName LIKE ? OR ");
            query.append("CAST(o.OrderID AS NVARCHAR) LIKE ? OR ");
            query.append("EXISTS (SELECT 1 FROM OrderDetails od2 ");
            query.append("JOIN ProductDetails pd2 ON od2.ProductDetailID = pd2.ProductDetailID ");
            query.append("JOIN Products p2 ON pd2.ProductID = p2.ProductID ");
            query.append("WHERE od2.OrderID = o.OrderID AND p2.ProductName LIKE ?)");
            query.append(")");
            String pattern = "%" + searchKeyword + "%";
            parameters.add(pattern);
            parameters.add(pattern);
            parameters.add(pattern);
        }

        // GROUP BY
        query.append("""
                    GROUP BY 
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
                        c.FullName,
                        u.FullName
                    ORDER BY o.CreatedAt DESC
                    OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
                """);

        parameters.add((page - 1) * pageSize);
        parameters.add(pageSize);

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            System.out.println("Executing query: " + query);
            System.out.println("Parameters: " + parameters);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrdersDTO order = extractOrderDTOFromResultSet(rs);
                orders.add(order);
            }

        } catch (SQLException e) {
            System.err.println("Error in getFilteredOrdersListByPage: " + e.getMessage());
            e.printStackTrace();
        }

        return orders;
    }

    public int countFilteredOrders(String dbName, String branchID, String[] creatorIDs,
            String startDate, String endDate, Double minPrice, Double maxPrice, String searchKeyword) {
        int count = 0;
        StringBuilder query = new StringBuilder("""
            SELECT COUNT(DISTINCT o.OrderID)
            FROM Orders o
            INNER JOIN Branches b ON o.BranchID = b.BranchID
            INNER JOIN Customers c ON o.CustomerID = c.CustomerID
            INNER JOIN Users u ON o.CreatedBy = u.UserID
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            WHERE 1=1
        """);
        List<Object> parameters = new ArrayList<>();

        // Filter by single branch ID
        if (branchID != null && !branchID.trim().isEmpty()) {
            query.append(" AND o.BranchID = ?");
            parameters.add(Integer.parseInt(branchID));
        }

        // Filter theo Creator (giữ nguyên vì có thể cần multiple creators)
        if (creatorIDs != null && creatorIDs.length > 0) {
            query.append(" AND o.CreatedBy IN (");
            query.append("?,".repeat(creatorIDs.length));
            query.setLength(query.length() - 1);
            query.append(")");
            for (String id : creatorIDs) {
                parameters.add(Integer.parseInt(id));
            }
        }

        // Filter theo ngày
        if (startDate != null && !startDate.trim().isEmpty()) {
            query.append(" AND CAST(o.CreatedAt AS DATE) >= ?");
            parameters.add(startDate);
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            query.append(" AND CAST(o.CreatedAt AS DATE) <= ?");
            parameters.add(endDate);
        }

        // Filter theo giá
        if (minPrice != null) {
            query.append(" AND o.GrandTotal >= ?");
            parameters.add(minPrice);
        }
        if (maxPrice != null) {
            query.append(" AND o.GrandTotal <= ?");
            parameters.add(maxPrice);
        }

        // Filter theo từ khoá tìm kiếm
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            query.append(" AND (");
            query.append("c.FullName LIKE ? OR ");
            query.append("CAST(o.OrderID AS NVARCHAR) LIKE ? OR ");
            query.append("EXISTS (");
            query.append("    SELECT 1 FROM OrderDetails od2 ");
            query.append("    JOIN ProductDetails pd2 ON od2.ProductDetailID = pd2.ProductDetailID ");
            query.append("    JOIN Products p2 ON pd2.ProductID = p2.ProductID ");
            query.append("    WHERE od2.OrderID = o.OrderID AND p2.ProductName LIKE ?");
            query.append(")");
            query.append(")");
            String searchPattern = "%" + searchKeyword + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error in countFilteredOrders: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    private static OrdersDTO extractOrderDTOFromResultSet(ResultSet rs) throws SQLException {
        String productDetails = rs.getString("ProductDetails");
        if (rs.wasNull() || productDetails == null || productDetails.trim().isEmpty()) {
            productDetails = "Không có sản phẩm";
        }

        return new OrdersDTO(
                0, // orderDetailID (not needed since we're aggregating)
                0, // productDetailID (not needed since we're aggregating)
                0, // quantity (not needed since we're aggregating)
                rs.getString("BranchName"),
                rs.getString("CustomerName"),
                rs.getString("CreatedByName"),
                productDetails, // ProductDetails được gán vào productName
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

    // Thêm method mới để lấy danh sách sản phẩm trong đơn hàng
    public List<OrdersDTO> getOrderProductsById(String dbName, int orderID) {
        List<OrdersDTO> orderProducts = new ArrayList<>();
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
            c.PhoneNumber AS CustomerPhone,
            c.Email AS CustomerEmail,
            c.Address AS CustomerAddress,
            c.Gender AS CustomerGender,
            c.DateOfBirth AS CustomerDOB,
            u.UserID,
            u.FullName AS CreatedByName,
            u.Email AS CreatedByEmail,
            u.Phone AS CreatedByPhone,
            u.Gender AS CreatedByGender,
            u.Address AS CreatedByAddress,
            u.AvaUrl AS CreatedByAvaUrl,
            r.RoleName,
            p.ProductID,
            p.ProductName,
            p.CostPrice,
            p.RetailPrice,
            p.VAT,
            p.IsActive AS ProductIsActive,
            p.ImageURL,
            pd.Description AS ProductDescription,
            pd.ProductCode,
            pd.WarrantyPeriod,
            STRING_AGG(pdsn.SerialNumber, ', ') AS SerialNumbers
        FROM 
            Orders o
            INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
            INNER JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            INNER JOIN Products p ON pd.ProductID = p.ProductID
            LEFT JOIN ProductDetailSerialNumber pdsn ON pd.ProductDetailID = pdsn.ProductDetailID 
                AND pdsn.OrderID = o.OrderID AND pdsn.Status = 1
            INNER JOIN Branches b ON o.BranchID = b.BranchID
            INNER JOIN Customers c ON o.CustomerID = c.CustomerID
            INNER JOIN Users u ON o.CreatedBy = u.UserID
            INNER JOIN Roles r ON u.RoleID = r.RoleID
        WHERE 
            o.OrderID = ?
        GROUP BY 
            od.OrderDetailID, od.ProductDetailID, od.Quantity, o.OrderID, o.BranchID, 
            o.CreatedBy, o.OrderStatus, o.CreatedAt, o.CustomerID, o.PaymentMethod, 
            o.Notes, o.GrandTotal, o.CustomerPay, o.Change, b.BranchName, 
            c.FullName, c.PhoneNumber, c.Email, c.Address, c.Gender, c.DateOfBirth,
            u.UserID, u.FullName, u.Email, u.Phone, u.Gender, u.Address, u.AvaUrl,
            r.RoleName, p.ProductID, p.ProductName, p.CostPrice, p.RetailPrice, p.VAT, p.IsActive,
            p.ImageURL, pd.Description, pd.ProductCode, pd.WarrantyPeriod
        ORDER BY od.OrderDetailID
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, orderID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                OrdersDTO orderProduct = extractOrderDTOFromResultSetDetailed(rs);
                orderProducts.add(orderProduct);
            }

        } catch (Exception e) {
            System.err.println("Error in getOrderProductsById: " + e.getMessage());
            e.printStackTrace();
        }

        return orderProducts;
    }

// Sửa lại method getOrderById để chỉ lấy thông tin cơ bản của đơn hàng
    public OrdersDTO getOrderBasicInfo(String dbName, int orderID) {
        OrdersDTO order = null;
        String query = """
        SELECT 
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
            c.PhoneNumber AS CustomerPhone,
            c.Email AS CustomerEmail,
            c.Address AS CustomerAddress,
            c.Gender AS CustomerGender,
            c.DateOfBirth AS CustomerDOB,
            u.UserID,
            u.FullName AS CreatedByName,
            u.Email AS CreatedByEmail,
            u.Phone AS CreatedByPhone,
            u.Gender AS CreatedByGender,
            u.Address AS CreatedByAddress,
            u.AvaUrl AS CreatedByAvaUrl,
            r.RoleName
        FROM 
            Orders o
            INNER JOIN Branches b ON o.BranchID = b.BranchID
            INNER JOIN Customers c ON o.CustomerID = c.CustomerID
            INNER JOIN Users u ON o.CreatedBy = u.UserID
            INNER JOIN Roles r ON u.RoleID = r.RoleID
        WHERE 
            o.OrderID = ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, orderID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                order = new OrdersDTO(
                        0, 0, 0, // orderDetailID, productDetailID, quantity - không cần cho basic info
                        rs.getString("BranchName"),
                        rs.getString("CustomerName"),
                        rs.getString("CreatedByName"),
                        "", // productName - không cần cho basic info
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

                // Set additional customer info
                order.setCustomerPhone(rs.getString("CustomerPhone"));
                order.setCustomerEmail(rs.getString("CustomerEmail"));
                order.setCustomerAddress(rs.getString("CustomerAddress"));
                order.setCustomerGender(rs.getBoolean("CustomerGender"));
                order.setCustomerDOB(rs.getDate("CustomerDOB"));

                // Set additional creator info
                order.setCreatedByEmail(rs.getString("CreatedByEmail"));
                order.setCreatedByPhone(rs.getString("CreatedByPhone"));
                order.setCreatedByGender(rs.getBoolean("CreatedByGender"));
                order.setCreatedByAddress(rs.getString("CreatedByAddress"));
                order.setCreatedByAvaUrl(rs.getString("CreatedByAvaUrl"));
                order.setRoleName(rs.getString("RoleName"));
            }

        } catch (Exception e) {
            System.err.println("Error in getOrderBasicInfo: " + e.getMessage());
            e.printStackTrace();
        }

        return order;
    }

// Giữ nguyên method getOrderById để tương thích ngược
    public OrdersDTO getOrderById(String dbName, int orderID) {
        // Lấy thông tin cơ bản của đơn hàng
        OrdersDTO order = getOrderBasicInfo(dbName, orderID);

        // Lấy sản phẩm đầu tiên (để tương thích với code cũ)
        List<OrdersDTO> products = getOrderProductsById(dbName, orderID);
        if (!products.isEmpty()) {
            OrdersDTO firstProduct = products.get(0);
            // Copy thông tin sản phẩm vào order
            order.setOrderDetailID(firstProduct.getOrderDetailID());
            order.setProductDetailID(firstProduct.getProductDetailID());
            order.setQuantity(firstProduct.getQuantity());
            order.setProductName(firstProduct.getProductName());
            order.setProductID(firstProduct.getProductID());
            order.setCostPrice(firstProduct.getCostPrice());
            order.setVAT(firstProduct.getVAT());
            order.setProductIsActive(firstProduct.getProductIsActive());
            order.setImageURL(firstProduct.getImageURL());
            order.setProductDescription(firstProduct.getProductDescription());
            order.setProductCode(firstProduct.getProductCode());
            order.setWarrantyPeriod(firstProduct.getWarrantyPeriod());
            order.setSerialNumber(firstProduct.getSerialNumber());
        }

        return order;
    }

    private OrdersDTO extractOrderDTOFromResultSetDetailed(ResultSet rs) throws SQLException {
        OrdersDTO order = new OrdersDTO(
                rs.getInt("OrderDetailID"),
                rs.getInt("ProductDetailID"),
                rs.getInt("Quantity"),
                rs.getString("BranchName"),
                rs.getString("CustomerName"),
                rs.getString("CreatedByName"),
                rs.getString("ProductName"),
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

        // Set additional fields for detailed view
        order.setCustomerPhone(rs.getString("CustomerPhone"));
        order.setCustomerEmail(rs.getString("CustomerEmail"));
        order.setCustomerAddress(rs.getString("CustomerAddress"));
        order.setCustomerGender(rs.getBoolean("CustomerGender"));
        order.setCustomerDOB(rs.getDate("CustomerDOB"));
        order.setCreatedByEmail(rs.getString("CreatedByEmail"));
        order.setCreatedByPhone(rs.getString("CreatedByPhone"));
        order.setCreatedByGender(rs.getBoolean("CreatedByGender"));
        order.setCreatedByAddress(rs.getString("CreatedByAddress"));
        order.setCreatedByAvaUrl(rs.getString("CreatedByAvaUrl"));
        order.setRoleName(rs.getString("RoleName"));
        order.setProductID(rs.getInt("ProductID"));
        order.setCostPrice(rs.getDouble("CostPrice"));
        order.setVAT(rs.getDouble("VAT"));
        order.setProductIsActive(rs.getBoolean("ProductIsActive"));
        order.setImageURL(rs.getString("ImageURL"));
        order.setProductDescription(rs.getString("ProductDescription"));
        order.setProductCode(rs.getString("ProductCode"));
        order.setWarrantyPeriod(rs.getString("WarrantyPeriod"));
        order.setSerialNumber(rs.getString("SerialNumbers"));

        return order;
    }

    public void deleteOrder(String dbName, int orderID) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false); // Start transaction

            System.out.println("Starting delete process for OrderID: " + orderID);

            // 1. Check if OrderID exists
            String checkOrderSql = "SELECT OrderID FROM Orders WHERE OrderID = ?";
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
            System.out.println("Order exists, proceeding with deletion...");

            // 2. Delete from CashFlows where RelatedOrderID = orderID
            String deleteCashFlowsSql = "DELETE FROM CashFlows WHERE RelatedOrderID = ?";
            pstmt = conn.prepareStatement(deleteCashFlowsSql);
            pstmt.setInt(1, orderID);
            int cashFlowsDeleted = pstmt.executeUpdate();
            pstmt.close();
            System.out.println("Deleted " + cashFlowsDeleted + " cash flow records");

            // 3. Update ProductDetailSerialNumber - set OrderID to NULL instead of deleting
            String updateSerialSql = "UPDATE ProductDetailSerialNumber SET OrderID = NULL, Status = 0 WHERE OrderID = ?";
            pstmt = conn.prepareStatement(updateSerialSql);
            pstmt.setInt(1, orderID);
            int serialUpdated = pstmt.executeUpdate();
            pstmt.close();
            System.out.println("Updated " + serialUpdated + " serial number records");

            // 4. Delete from OrderDetails
            String deleteOrderDetailsSql = "DELETE FROM OrderDetails WHERE OrderID = ?";
            pstmt = conn.prepareStatement(deleteOrderDetailsSql);
            pstmt.setInt(1, orderID);
            int detailsDeleted = pstmt.executeUpdate();
            pstmt.close();
            System.out.println("Deleted " + detailsDeleted + " order detail records");

            // 5. Delete from Orders
            String deleteOrderSql = "DELETE FROM Orders WHERE OrderID = ?";
            pstmt = conn.prepareStatement(deleteOrderSql);
            pstmt.setInt(1, orderID);
            int ordersDeleted = pstmt.executeUpdate();
            pstmt.close();
            System.out.println("Deleted " + ordersDeleted + " order records");

            if (ordersDeleted == 0) {
                conn.rollback();
                throw new SQLException("Không thể xóa đơn hàng với OrderID: " + orderID);
            }

            conn.commit(); // Commit transaction
            System.out.println("Successfully deleted order with OrderID: " + orderID);

        } catch (SQLException e) {
            System.err.println("Error in deleteOrder: " + e.getMessage());
            e.printStackTrace();

            if (conn != null) {
                try {
                    conn.rollback();
                    System.out.println("Transaction rolled back");
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
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
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    DBUtil.closeConnection(conn);
                } catch (SQLException ignored) {
                }
            }
        }
    }

    public List<Branch> getAllBranches(String dbName) {
        List<Branch> branches = new ArrayList<>();
        // Fixed SQL query to include all fields that we're trying to access
        String query = "SELECT BranchID, BranchName, Address, Phone, IsActive FROM Branches WHERE IsActive = 1 ORDER BY BranchName";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Branch branch = new Branch();
                branch.setBranchId(rs.getInt("BranchID"));
                branch.setBranchName(rs.getString("BranchName"));
                branch.setAddress(rs.getString("Address"));
                branch.setPhone(rs.getString("Phone"));
                branch.setIsActive(rs.getInt("IsActive"));
                branches.add(branch);
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllBranches: " + e.getMessage());
            e.printStackTrace();
        }
        return branches;
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
                if (i < creatorIDs.length - 1) {
                    query.append(",");
                }
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

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {

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
                if (i < creatorIDs.length - 1) {
                    query.append(",");
                }
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

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query.toString())) {

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
        OrdersDAO orderPagination = new OrdersDAO();
        String dbName = "DTB_Tad"; // Replace with your actual database name

        // Test Case: Retrieve orders to check product details (page 1, pageSize=5)
        System.out.println("Test: Displaying orders with product details (page 1, pageSize=5)");
        List<OrdersDTO> orders = orderPagination.getFilteredOrdersListByPage(
                dbName, 1, 30, null, null, null, null, null, null, null);
        printOrders(orders);
        int count = orderPagination.countFilteredOrders(dbName, null, null, null, null, null, null, null);
        System.out.println("Total orders: " + count);
        System.out.println("------------------------");
    }

    private static void printOrders(List<OrdersDTO> orders) {
        if (orders.isEmpty()) {
            System.out.println("No orders found.");
            return;
        }
        for (OrdersDTO order : orders) {
            System.out.println("OrderID: " + order.getOrderID());

            System.out.println("------------------------");
        }

    }
}
