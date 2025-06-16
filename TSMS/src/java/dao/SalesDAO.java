package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.SalesStatisticsDTO;
import model.SalesTransactionDTO;
import model.PromotionDTO;
import util.DBUtil;

public class SalesDAO {

    /*
     Lấy thống kê bán hàng của nhân viên trong tháng hiện tại
     */
    public SalesStatisticsDTO getSalesStatistics(String dbName, int salespersonId) throws SQLException {
        String sql = """
            SELECT 
                u.UserID,
                u.FullName,
                ISNULL(SUM(o.GrandTotal), 0) as CurrentMonthSales,
                200000000 as SalesTarget, -- Mục tiêu cố định 200M, có thể lưu trong bảng riêng
                COUNT(DISTINCT o.OrderID) as OrdersCount,
                COUNT(DISTINCT o.CustomerID) as CustomersServed
            FROM Users u
            LEFT JOIN Orders o ON u.UserID = o.CreatedBy 
                AND MONTH(o.CreatedAt) = MONTH(GETDATE()) 
                AND YEAR(o.CreatedAt) = YEAR(GETDATE())
                AND o.OrderStatus = 'Completed'
            WHERE u.UserID = ? AND u.RoleID = 2
            GROUP BY u.UserID, u.FullName
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, salespersonId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new SalesStatisticsDTO(
                            rs.getInt("UserID"),
                            rs.getString("FullName"),
                            rs.getBigDecimal("CurrentMonthSales"),
                            rs.getBigDecimal("SalesTarget"),
                            rs.getInt("OrdersCount"),
                            rs.getInt("CustomersServed")
                    );
                }
            }
        }
        return null;
    }

    /*
      Lấy danh sách giao dịch của nhân viên
     */
    public List<SalesTransactionDTO> getTransactionsBySalesperson(String dbName, int salespersonId) throws SQLException {
        List<SalesTransactionDTO> transactions = new ArrayList<>();

        String sql = """
            SELECT 
                o.OrderID,
                c.FullName as CustomerName,
                c.PhoneNumber as CustomerPhone,
                STRING_AGG(p.ProductName, ', ') as ProductNames,
                o.GrandTotal,
                o.CreatedAt,
                o.OrderStatus,
                o.PaymentMethod,
                o.Notes
            FROM Orders o
            LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN Products p ON od.ProductID = p.ProductID
            WHERE o.CreatedBy = ?
            GROUP BY o.OrderID, c.FullName, c.PhoneNumber, o.GrandTotal, 
                     o.CreatedAt, o.OrderStatus, o.PaymentMethod, o.Notes
            ORDER BY o.CreatedAt DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, salespersonId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SalesTransactionDTO transaction = new SalesTransactionDTO(
                            rs.getInt("OrderID"),
                            rs.getString("CustomerName"),
                            rs.getString("CustomerPhone"),
                            rs.getString("ProductNames"),
                            rs.getBigDecimal("GrandTotal"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getString("OrderStatus"),
                            rs.getString("PaymentMethod")
                    );
                    transaction.setNotes(rs.getString("Notes"));
                    transactions.add(transaction);
                }
            }
        }

        return transactions;
    }

    /*
      Lấy danh sách khuyến mãi đang áp dụng
     */
    public List<PromotionDTO> getActivePromotions(String dbName, int branchId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();

        String sql = """
            SELECT DISTINCT
                p.PromotionID,
                p.PromoName,
                p.DiscountPercent,
                p.StartDate,
                p.EndDate,
                p.ApplyToAllBranches
            FROM Promotions p
            LEFT JOIN PromotionBranches pb ON p.PromotionID = pb.PromotionID
            WHERE (p.ApplyToAllBranches = 1 OR pb.BranchID = ?)
                AND GETDATE() BETWEEN p.StartDate AND p.EndDate
            ORDER BY p.StartDate DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, branchId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    PromotionDTO promotion = new PromotionDTO(
                            rs.getInt("PromotionID"),
                            rs.getString("PromoName"),
                            rs.getDouble("DiscountPercent"),
                            rs.getDate("StartDate"),
                            rs.getDate("EndDate")
                    );
                    promotions.add(promotion);
                }
            }
        }

        return promotions;
    }

    /*
      Tìm kiếm giao dịch theo từ khóa
     */
    public List<SalesTransactionDTO> searchTransactions(String dbName, int salespersonId, String keyword) throws SQLException {
        List<SalesTransactionDTO> transactions = new ArrayList<>();

        String sql = """
            SELECT 
                o.OrderID,
                c.FullName as CustomerName,
                c.PhoneNumber as CustomerPhone,
                STRING_AGG(p.ProductName, ', ') as ProductNames,
                o.GrandTotal,
                o.CreatedAt,
                o.OrderStatus,
                o.PaymentMethod,
                o.Notes
            FROM Orders o
            LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN Products p ON od.ProductID = p.ProductID
            WHERE o.CreatedBy = ? 
                AND (c.FullName LIKE ? OR c.PhoneNumber LIKE ? OR CAST(o.OrderID as NVARCHAR) LIKE ?)
            GROUP BY o.OrderID, c.FullName, c.PhoneNumber, o.GrandTotal, 
                     o.CreatedAt, o.OrderStatus, o.PaymentMethod, o.Notes
            ORDER BY o.CreatedAt DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            stmt.setInt(1, salespersonId);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SalesTransactionDTO transaction = new SalesTransactionDTO(
                            rs.getInt("OrderID"),
                            rs.getString("CustomerName"),
                            rs.getString("CustomerPhone"),
                            rs.getString("ProductNames"),
                            rs.getBigDecimal("GrandTotal"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getString("OrderStatus"),
                            rs.getString("PaymentMethod")
                    );
                    transaction.setNotes(rs.getString("Notes"));
                    transactions.add(transaction);
                }
            }
        }

        return transactions;
    }

    public SalesStatisticsDTO getSalesStatisticsByUser(String dbName, int userId) throws SQLException {
        String sql = """
            SELECT 
                u.UserID,
                u.FullName,
                ISNULL(SUM(o.GrandTotal), 0) as CurrentMonthSales,
                200000000 as SalesTarget,
                COUNT(DISTINCT o.OrderID) as OrdersCount,
                COUNT(DISTINCT o.CustomerID) as CustomersServed
            FROM Users u
            LEFT JOIN Orders o ON u.UserID = o.CreatedBy 
                AND MONTH(o.CreatedAt) = MONTH(GETDATE()) 
                AND YEAR(o.CreatedAt) = YEAR(GETDATE())
                AND o.OrderStatus = 'Completed'
            WHERE u.UserID = ? AND u.RoleID = 2
            GROUP BY u.UserID, u.FullName
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new SalesStatisticsDTO(
                            rs.getInt("UserID"),
                            rs.getString("FullName"),
                            rs.getBigDecimal("CurrentMonthSales"),
                            rs.getBigDecimal("SalesTarget"),
                            rs.getInt("OrdersCount"),
                            rs.getInt("CustomersServed")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getSalesStatisticsByUser: " + e.getMessage());
            throw e;
        }
        return null;
    }

    /*
      Lấy danh sách giao dịch của nhân viên
     */
    public List<SalesTransactionDTO> getTransactionsByUser(String dbName, int userId) throws SQLException {
        List<SalesTransactionDTO> transactions = new ArrayList<>();

        String sql = """
            SELECT 
                o.OrderID,
                c.FullName as CustomerName,
                c.PhoneNumber as CustomerPhone,
                STRING_AGG(p.ProductName, ', ') as ProductNames,
                o.GrandTotal,
                o.CreatedAt,
                o.OrderStatus,
                o.PaymentMethod,
                o.Notes
            FROM Orders o
            LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            WHERE o.CreatedBy = ?
            GROUP BY o.OrderID, c.FullName, c.PhoneNumber, o.GrandTotal, 
                     o.CreatedAt, o.OrderStatus, o.PaymentMethod, o.Notes
            ORDER BY o.CreatedAt DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SalesTransactionDTO transaction = new SalesTransactionDTO(
                            rs.getInt("OrderID"),
                            rs.getString("CustomerName"),
                            rs.getString("CustomerPhone"),
                            rs.getString("ProductNames"),
                            rs.getBigDecimal("GrandTotal"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getString("OrderStatus"),
                            rs.getString("PaymentMethod")
                    );
                    transaction.setNotes(rs.getString("Notes"));
                    transactions.add(transaction);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in getTransactionsByUser: " + e.getMessage());
            throw e;
        }

        return transactions;
    }

    /*
      Tìm kiếm giao dịch theo từ khóa
     */
    public List<SalesTransactionDTO> searchTransactionsByUser(String dbName, int userId, String keyword) throws SQLException {
        List<SalesTransactionDTO> transactions = new ArrayList<>();

        String sql = """
            SELECT 
                o.OrderID,
                c.FullName as CustomerName,
                c.PhoneNumber as CustomerPhone,
                STRING_AGG(p.ProductName, ', ') as ProductNames,
                o.GrandTotal,
                o.CreatedAt,
                o.OrderStatus,
                o.PaymentMethod,
                o.Notes
            FROM Orders o
            LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
            LEFT JOIN OrderDetails od ON o.OrderID = od.OrderID
            LEFT JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID
            LEFT JOIN Products p ON pd.ProductID = p.ProductID
            WHERE o.CreatedBy = ? 
                AND (c.FullName LIKE ? OR c.PhoneNumber LIKE ? OR CAST(o.OrderID as NVARCHAR) LIKE ?)
            GROUP BY o.OrderID, c.FullName, c.PhoneNumber, o.GrandTotal, 
                     o.CreatedAt, o.OrderStatus, o.PaymentMethod, o.Notes
            ORDER BY o.CreatedAt DESC
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + keyword + "%";
            stmt.setInt(1, userId);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    SalesTransactionDTO transaction = new SalesTransactionDTO(
                            rs.getInt("OrderID"),
                            rs.getString("CustomerName"),
                            rs.getString("CustomerPhone"),
                            rs.getString("ProductNames"),
                            rs.getBigDecimal("GrandTotal"),
                            rs.getTimestamp("CreatedAt"),
                            rs.getString("OrderStatus"),
                            rs.getString("PaymentMethod")
                    );
                    transaction.setNotes(rs.getString("Notes"));
                    transactions.add(transaction);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error in searchTransactionsByUser: " + e.getMessage());
            throw e;
        }

        return transactions;
    }
}
