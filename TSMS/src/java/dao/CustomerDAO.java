package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.CustomerDTO;
import model.Customer;
import util.DBUtil;

/**
 * DAO class to interact with the Customers table
 */
public class CustomerDAO {

    // Lấy danh sách tất cả khách hàng
    public List<CustomerDTO> totalCustomers(String dbName) throws SQLException {
        List<CustomerDTO> customers = new ArrayList<>();
        String sql = """
        SELECT 
            c.CustomerID,
            c.FullName,
            c.PhoneNumber,
            c.Email,
            c.Address,
            c.Gender,
            c.DateOfBirth,
            c.CreatedAt,
            c.UpdatedAt,
            o.BranchID,
            o.grandTotal             
        FROM Customers c
        INNER JOIN (
            SELECT CustomerID, MIN(OrderID) AS FirstOrderID
            FROM Orders
            GROUP BY CustomerID
        ) fo ON c.CustomerID = fo.CustomerID
        INNER JOIN Orders o ON fo.FirstOrderID = o.OrderID
    """;

        try (
                Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int customerId = rs.getInt("CustomerID");
                String fullName = rs.getString("FullName");
                String phoneNumber = rs.getString("PhoneNumber");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                // Chuyển giới tính từ bit thành String: "Nam"/"Nữ"
                Boolean gender = null;
                boolean genderValue = rs.getBoolean("Gender");
                if (!rs.wasNull()) {
                    gender = genderValue;
                }

                Date dateOfBirth = rs.getDate("DateOfBirth");
                Date createdAt = rs.getTimestamp("CreatedAt");
                Date updatedAt = rs.getTimestamp("UpdatedAt");
                int branchId = rs.getInt("BranchID");
                double grandTotal = rs.getDouble("GrandTotal");

                CustomerDTO customer = new CustomerDTO(
                        customerId, fullName, phoneNumber, email, address,
                        gender, dateOfBirth, createdAt, updatedAt, branchId, grandTotal
                );

                customers.add((CustomerDTO) customer);
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi load danh sách khách hàng: " + e.getMessage());
        }

        return customers;
    }

    // Ví dụ test
    public static void main(String[] args) throws SQLException {
        CustomerDAO dao = new CustomerDAO();

        List<CustomerDTO> customers = dao.totalCustomers("DTB_Test3");
        for (Customer c : customers) {
            System.out.println(c);
        }
    }

    // Tìm kiếm khách hàng theo tên (FullName)
    public List<CustomerDTO> filterCustomers(String dbName, String keyword, String genderFilter) throws SQLException {
        List<CustomerDTO> customers = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT 
                    c.CustomerID,
                    c.FullName,
                    c.PhoneNumber,
                    c.Email,
                    c.Address,
                    c.Gender,
                    c.DateOfBirth,
                    c.CreatedAt,
                    c.UpdatedAt,
                    o.BranchID,      
                    o.grandTotal                                                   
                FROM Customers c
                JOIN (
                SELECT CustomerID, MIN(OrderID) AS FirstOrderID
                FROM Orders
                GROUP BY CustomerID
                ) fo ON c.CustomerID = fo.CustomerID
                JOIN Orders o ON fo.FirstOrderID = o.OrderID      
        WHERE RIGHT(FullName, CHARINDEX(' ', REVERSE(FullName)) - 1) COLLATE Latin1_General_CI_AI LIKE ?
    """);

        if ("male".equalsIgnoreCase(genderFilter)) {
            sql.append(" AND Gender = 1");
        } else if ("female".equalsIgnoreCase(genderFilter)) {
            sql.append(" AND Gender = 0");
        }

        sql.append(" ORDER BY CustomerID");

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            stmt.setString(1, "%" + keyword + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customers.add((CustomerDTO) extractCustomerFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi tìm kiếm khách hàng: " + e.getMessage());
        }

        return customers;
    }

    // ✅ Hàm dùng chung để map ResultSet → Customer object
    private Customer extractCustomerFromResultSet(ResultSet rs) throws SQLException {
        int customerId = rs.getInt("CustomerID");
        String fullName = rs.getString("FullName");
        String phoneNumber = rs.getString("PhoneNumber");
        String email = rs.getString("Email");
        String address = rs.getString("Address");

        Boolean gender = null;
        boolean genderValue = rs.getBoolean("Gender");
        if (!rs.wasNull()) {
            gender = genderValue;
        }  // đã dùng CASE WHEN để trả về Nam/Nữ
        Date dateOfBirth = rs.getDate("DateOfBirth");
        Date createdAt = rs.getTimestamp("CreatedAt");
        Date updatedAt = rs.getTimestamp("UpdatedAt");
        int branchId = rs.getInt("BranchID");
        double grandTotal = rs.getDouble("GrandTotal");

        return new CustomerDTO(customerId, fullName, phoneNumber, email, address,
                gender, dateOfBirth, createdAt, updatedAt ,branchId, grandTotal );
    }

    // ✅ Đếm tổng số khách hàng (loại bỏ branchId)
    public int countCustomers(String dbName, String genderFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Customers WHERE 1=1");

        if ("male".equalsIgnoreCase(genderFilter)) {
            sql.append(" AND Gender = 1");
        } else if ("female".equalsIgnoreCase(genderFilter)) {
            sql.append(" AND Gender = 0");
        }

        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql.toString()); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi đếm khách hàng theo giới tính: " + e.getMessage());
        }

        return count;
    }

    // ✅ Phân trang danh sách khách hàng
    public List<CustomerDTO> getCustomerListByPage(String dbName, int offset, int limit, String genderFilter) {
        List<CustomerDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT 
            c.CustomerID,
            c.FullName,
            c.PhoneNumber,
            c.Email,
            c.Address,
            c.Gender,
            c.DateOfBirth,
            c.CreatedAt,
            c.UpdatedAt,
            o.BranchID,
            o.grandTotal                                                               
        FROM Customers c
        JOIN (
        SELECT CustomerID, MIN(OrderID) AS FirstOrderID
        FROM Orders
        GROUP BY CustomerID
        ) fo ON c.CustomerID = fo.CustomerID
        JOIN Orders o ON fo.FirstOrderID = o.OrderID                                              
        WHERE 1=1
    """);

        if ("male".equalsIgnoreCase(genderFilter)) {
            sql.append(" AND Gender = 1");
        } else if ("female".equalsIgnoreCase(genderFilter)) {
            sql.append(" AND Gender = 0");
        }

        sql.append(" ORDER BY CustomerID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection con = DBUtil.getConnectionTo(dbName); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add((CustomerDTO) extractCustomerFromResultSet(rs));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi phân trang khách hàng theo giới tính: " + e.getMessage());
        }
        return list;
    }

    //  Lấy 10 khách hàng có GrandTotal cao nhất
public List<CustomerDTO> getTopCustomersBySpending(double minTotal, double maxTotal, String dbName) {
    List<CustomerDTO> customers = new ArrayList<>();

    String sql = """
        SELECT 
            c.CustomerID,
            c.FullName,
            c.PhoneNumber,
            c.Email,
            c.Address,
            c.Gender,
            c.DateOfBirth,
            c.CreatedAt,
            c.UpdatedAt,
            MAX(o.BranchID) AS BranchID,
            SUM(o.GrandTotal) AS TotalSpent
        FROM Customers c
        JOIN Orders o ON c.CustomerID = o.CustomerID
        GROUP BY 
            c.CustomerID, c.FullName, c.PhoneNumber, c.Email, c.Address,
            c.Gender, c.DateOfBirth, c.CreatedAt, c.UpdatedAt
        HAVING SUM(o.GrandTotal) BETWEEN ? AND ?
        ORDER BY TotalSpent DESC
        
    """;

    try (
        Connection conn = DBUtil.getConnectionTo(dbName);
        PreparedStatement stmt = conn.prepareStatement(sql)
    ) {
        stmt.setDouble(1, minTotal);
        stmt.setDouble(2, maxTotal);

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                // Map với TotalSpent thay vì GrandTotal
                int customerId = rs.getInt("CustomerID");
                String fullName = rs.getString("FullName");
                String phoneNumber = rs.getString("PhoneNumber");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                Boolean gender = null;
                boolean genderValue = rs.getBoolean("Gender");
                if (!rs.wasNull()) {
                    gender = genderValue;
                }

                Date dateOfBirth = rs.getDate("DateOfBirth");
                Date createdAt = rs.getTimestamp("CreatedAt");
                Date updatedAt = rs.getTimestamp("UpdatedAt");
                int branchId = rs.getInt("BranchID");
                double totalSpent = rs.getDouble("TotalSpent");

                CustomerDTO customer = new CustomerDTO(
                    customerId, fullName, phoneNumber, email, address,
                    gender, dateOfBirth, createdAt, updatedAt, branchId, totalSpent
                );

                customers.add(customer);
            }
        }
    } catch (Exception e) {
        System.out.println("Lỗi khi lọc khách theo khoảng chi tiêu: " + e.getMessage());
    }

    return customers;
}


// ✅ Cập nhật đầy đủ thông tin khách hàng
public boolean updateCustomer(int id, String fullName, String email, boolean gender, String phoneNumber, String address, String dbName) throws SQLException {
    String sql = "UPDATE Customers SET FullName = ?, Email = ?, Gender = ?, PhoneNumber = ?, Address = ? WHERE CustomerID = ?";

    try (Connection conn = DBUtil.getConnectionTo(dbName);  // ✅ Kết nối đúng DB
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, fullName);
        ps.setString(2, email);
        ps.setBoolean(3, gender);
        ps.setString(4, phoneNumber);
        ps.setString(5, address);
        ps.setInt(6, id);

        int rowsUpdated = ps.executeUpdate();
        return rowsUpdated > 0;
    }
}

    //Phuong
    public static boolean insertCustomer(String dbName, Customer customer) {
        Connection conn;
        PreparedStatement stmt;

        try {
            conn = DBUtil.getConnectionTo(dbName);

            String sql = "INSERT INTO Customers (FullName, PhoneNumber, Email, Address, Gender, DateOfBirth, CreatedAt, UpdatedAt) "
                    + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), NULL)";

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, customer.getFullName());
            stmt.setString(2, customer.getPhoneNumber());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getAddress());
            stmt.setBoolean(5, customer.getGender());
            stmt.setDate(6, (java.sql.Date) customer.getDateOfBirth());

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            return false;
        }
    }

    //Phuong
    public static int getCustomerId(String dbName, String phone) {
        int customerId = -1;
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs;

        try {
            conn = DBUtil.getConnectionTo(dbName);

            String sql = "SELECT CustomerID FROM Customers WHERE PhoneNumber = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, phone);

            rs = stmt.executeQuery();

            if (rs.next()) {
                customerId = rs.getInt("CustomerID");
            }
        } catch (SQLException e) {
            System.out.println(e);
        }

        return customerId;
    }

    //Phuong
    public static boolean checkCustomerExist(String dbName, String phone) {
        boolean exists = false;
        Connection conn;
        PreparedStatement stmt;
        ResultSet rs;

        try {
            conn = DBUtil.getConnectionTo(dbName);

            String sql = "SELECT 1 FROM Customers WHERE PhoneNumber = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, phone);

            rs = stmt.executeQuery();
            exists = rs.next();
        } catch (SQLException e) {
            System.out.println(e);
        }

        return exists;
    }
    
    public List<Customer> getCustomers(String dbName) throws SQLException {
        List<Customer> customers = new ArrayList<>();
        String sql = """
        SELECT 
            c.CustomerID,
            c.FullName,
            c.PhoneNumber,
            c.Email,
            c.Address,
            c.Gender,
            c.DateOfBirth,
            c.CreatedAt,
            c.UpdatedAt,
            o.BranchID,
            o.grandTotal             
        FROM Customers c
        INNER JOIN (
            SELECT CustomerID, MIN(OrderID) AS FirstOrderID
            FROM Orders
            GROUP BY CustomerID
        ) fo ON c.CustomerID = fo.CustomerID
        INNER JOIN Orders o ON fo.FirstOrderID = o.OrderID
    """;

        try (
                Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int customerId = rs.getInt("CustomerID");
                String fullName = rs.getString("FullName");
                String phoneNumber = rs.getString("PhoneNumber");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                // Chuyển giới tính từ bit thành String: "Nam"/"Nữ"
                Boolean gender = null;
                boolean genderValue = rs.getBoolean("Gender");
                if (!rs.wasNull()) {
                    gender = genderValue;
                }

                Date dateOfBirth = rs.getDate("DateOfBirth");
                Date createdAt = rs.getTimestamp("CreatedAt");
                Date updatedAt = rs.getTimestamp("UpdatedAt");
                int branchId = rs.getInt("BranchID");
                double grandTotal = rs.getDouble("GrandTotal");

                CustomerDTO customer = new CustomerDTO(
                        customerId, fullName, phoneNumber, email, address,
                        gender, dateOfBirth, createdAt, updatedAt, branchId, grandTotal
                );

                customers.add((CustomerDTO) customer);
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi load danh sách khách hàng: " + e.getMessage());
        }

        return customers;
    }

}
