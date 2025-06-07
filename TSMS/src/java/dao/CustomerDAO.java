package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Customer;
import util.DBUtil;

/**
 * DAO class to interact with the Customers table
 */
public class CustomerDAO {

    // Lấy danh sách tất cả khách hàng
    public List<Customer> getAllCustomers(String dbName) throws SQLException {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM Customers";

        try (
            Connection conn = DBUtil.getConnectionTo(dbName);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()
        ) {
            while (rs.next()) {
                int customerId = rs.getInt("CustomerID");
                String fullName = rs.getString("FullName");
                String phoneNumber = rs.getString("PhoneNumber");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                // Chuyển giới tính từ bit thành String: "Nam"/"Nữ"
                String gender = rs.getString("Gender");
    
                Date dateOfBirth = rs.getDate("DateOfBirth");
                Date createdAt = rs.getTimestamp("CreatedAt");
                Date updatedAt = rs.getTimestamp("UpdatedAt");

                Customer customer = new Customer(
                    customerId, fullName, phoneNumber, email, address,
                    gender, dateOfBirth, createdAt, updatedAt
                );

                customers.add(customer);
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi load danh sách khách hàng: " + e.getMessage());
        }

        return customers;
    }

    // Ví dụ test
    public static void main(String[] args) throws SQLException {
        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers = dao.getAllCustomers("DTB_DatTech");

        for (Customer c : customers) {
            System.out.println(c);
        }
    }
    
    // Tìm kiếm khách hàng theo tên (FullName)
public List<Customer> searchCustomersByName(String dbName, String keyword) throws SQLException {
    List<Customer> customers = new ArrayList<>();
    String sql = "SELECT * FROM Customers WHERE FullName LIKE ?";

    try (
        Connection conn = DBUtil.getConnectionTo(dbName);
        PreparedStatement stmt = conn.prepareStatement(sql)
    ) {
        stmt.setString(1, "%" + keyword + "%"); // Tìm tương đối (chứa từ khoá)

        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                int customerId = rs.getInt("CustomerID");
                String fullName = rs.getString("FullName");
                String phoneNumber = rs.getString("PhoneNumber");
                String email = rs.getString("Email");
                String address = rs.getString("Address");

                String gender = rs.getString("Gender");
                Date dateOfBirth = rs.getDate("DateOfBirth");
                Date createdAt = rs.getTimestamp("CreatedAt");
                Date updatedAt = rs.getTimestamp("UpdatedAt");

                Customer customer = new Customer(
                    customerId, fullName, phoneNumber, email, address,
                    gender, dateOfBirth, createdAt, updatedAt
                );

                customers.add(customer);
            }
        }
    } catch (Exception e) {
        System.out.println("Lỗi khi tìm kiếm khách hàng: " + e.getMessage());
    }

    return customers;
}

    
    
    
}
