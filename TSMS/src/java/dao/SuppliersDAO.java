package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Supplier;
import util.DBUtil;

public class SuppliersDAO {

    // Lấy danh sách tất cả nhà cung cấp
    public List<Supplier> getAllSuppliers(String dbName) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = """
            SELECT 
                SupplierID,
                SupplierName,
                ContactName,
                Phone,
                Email
            FROM Suppliers
        """;

        try (
            Connection conn = DBUtil.getConnectionTo(dbName);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()
        ) {
            while (rs.next()) {
                suppliers.add(new Supplier(
                    rs.getInt("SupplierID"),
                    rs.getString("SupplierName"),
                    rs.getString("ContactName"),
                    rs.getString("Phone"),
                    rs.getString("Email")
                ));
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách nhà cung cấp: " + e.getMessage());
        }

        return suppliers;
    }
    public List<Supplier> getAllSupplier(String dbName) throws SQLException {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT SupplierID, SupplierName, ContactName, Phone, Email FROM Suppliers";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setSupplierID(rs.getInt("SupplierID"));
                supplier.setSupplierName(rs.getString("SupplierName"));
                supplier.setContactName(rs.getString("ContactName"));
                supplier.setPhone(rs.getString("Phone"));
                supplier.setEmail(rs.getString("Email"));
                suppliers.add(supplier);
            }
        }
        return suppliers;
    }
    public boolean isSupplierNameExists(String dbName, String supplierName) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Suppliers WHERE SupplierName = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, supplierName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }
    public boolean addSupplier(String dbName, String supplierName, String contactName, String phone, String email) throws SQLException {
        String sql = "INSERT INTO Suppliers (SupplierName, ContactName, Phone, Email) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, supplierName);
            ps.setString(2, contactName.isEmpty() ? null : contactName);
            ps.setString(3, phone.isEmpty() ? null : phone);
            ps.setString(4, email.isEmpty() ? null : email);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        }
    }

    // Tìm kiếm nhà cung cấp theo tên
    public List<Supplier> searchSuppliersByName(String dbName, String keyword) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = """
            SELECT 
                SupplierID,
                SupplierName,
                ContactName,
                Phone,
                Email
            FROM Suppliers
            WHERE SupplierName COLLATE Latin1_General_CI_AI LIKE ?
            ORDER BY SupplierID
        """;

        try (
            Connection conn = DBUtil.getConnectionTo(dbName);
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setString(1, "%" + keyword + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    suppliers.add(new Supplier(
                        rs.getInt("SupplierID"),
                        rs.getString("SupplierName"),
                        rs.getString("ContactName"),
                        rs.getString("Phone"),
                        rs.getString("Email")
                    ));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi tìm kiếm nhà cung cấp: " + e.getMessage());
        }

        return suppliers;
    }

    // Đếm tổng số nhà cung cấp
    public int countSuppliers(String dbName) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM Suppliers";

        try (
            Connection conn = DBUtil.getConnectionTo(dbName);
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery()
        ) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi đếm nhà cung cấp: " + e.getMessage());
        }

        return count;
    }

    // Phân trang danh sách nhà cung cấp
    public List<Supplier> getSuppliersByPage(String dbName, int offset, int limit) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = """
            SELECT 
                SupplierID,
                SupplierName,
                ContactName,
                Phone,
                Email
            FROM Suppliers
            ORDER BY SupplierID
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (
            Connection conn = DBUtil.getConnectionTo(dbName);
            PreparedStatement stmt = conn.prepareStatement(sql)
        ) {
            stmt.setInt(1, offset);
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    suppliers.add(new Supplier(
                        rs.getInt("SupplierID"),
                        rs.getString("SupplierName"),
                        rs.getString("ContactName"),
                        rs.getString("Phone"),
                        rs.getString("Email")
                    ));
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi phân trang nhà cung cấp: " + e.getMessage());
        }

        return suppliers;
    }

    // Test main method
    public static void main(String[] args) {
        SuppliersDAO dao = new SuppliersDAO();
        List<Supplier> suppliers = dao.getAllSuppliers("DTB_Test3");
        for (Supplier s : suppliers) {
            System.out.println(s);
        }
    }


public boolean updateSupplier(String dbName, int supplierID, String supplierName, String contactName, String phone, String email) throws SQLException {
    String sql = """
        UPDATE Suppliers
        SET SupplierName = ?, ContactName = ?, Phone = ?, Email = ?
        WHERE SupplierID = ?
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, supplierName);
        stmt.setString(2, contactName.isEmpty() ? null : contactName);
        stmt.setString(3, phone.isEmpty() ? null : phone);
        stmt.setString(4, email.isEmpty() ? null : email);
        stmt.setInt(5, supplierID);

        return stmt.executeUpdate() > 0;
    }
}
}