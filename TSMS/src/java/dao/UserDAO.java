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
import model.ShopOwner;
import model.ShopOwnerDTO;
import model.User;
import util.DBUtil;

/**
 *
 * @author admin
 */
public class UserDAO {

    //SO
    public static void insertShopOwner(ShopOwner owner) throws SQLException {
        String sql = """
        INSERT INTO ShopOwner (AdminID, Password, FullName, ShopName, DatabaseName, Email, IdentificationID, Gender, Address, IsActive, CreatedAt)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE());
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, 1); // AdminID mặc định là SuperAdmin ID 1
            stmt.setString(2, owner.getPassword());
            stmt.setString(3, owner.getFullName());
            stmt.setString(4, owner.getShopName());
            stmt.setString(5, owner.getDatabaseName());
            stmt.setString(6, owner.getEmail());
            stmt.setString(7, owner.getIdentificationID());
            stmt.setString(8, owner.getGender());
            stmt.setString(9, owner.getAddress());
            stmt.setInt(10, 1);

            stmt.executeUpdate();
        }
    }

    //SO
    public static void insertUserMethod(String email) throws SQLException {
        ShopOwner shopOwnwer = getShopOwnwerByEmail(email);
        int ownerId = shopOwnwer.getOwnerId();
        String sql = """
        INSERT INTO UserServiceMethod(OwnerID, MethodID, TrialStartDate, TrialStatus, SubscriptionMonths, SubscriptionStart, SubscriptionEnd)
        VALUES (?, 1, GETDATE(), 'TRIAL', 0, NULL, NULL );
    """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ownerId);
            stmt.executeUpdate();
        }
    }

    //SO
    public static boolean isAccountTaken(String email, String phone) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ShopOwner WHERE Email = ? OR Phone = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    //SO
    public static ShopOwner getShopOwnwerByEmail(String email) throws SQLException {
        ShopOwner shopOwner = null;

        String sql = "select * from ShopOwner where Email = ?";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    shopOwner = extractShopOwnerFromResultSet(rs);
                }
            }
        }

        return shopOwner;
    }

    //SO
    public static ShopOwnerDTO getShopOwnerById(int id) throws SQLException {
        ShopOwnerDTO shopOwner = null;

        String sql = "SELECT * \n"
                + "FROM ShopOwner \n"
                + "JOIN UserServiceMethod \n"
                + "ON ShopOwner.OwnerID = UserServiceMethod.OwnerID\n"
                + "WHERE ShopOwner.OwnerID = ?;\n"
                + "";

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    shopOwner = extractShopOwnerDTOFromResultSet(rs);
                }
            }
        }

        return shopOwner;
    }

    //User
    public User getUserByEmail(String email, String dbName) throws SQLException {
        User user = null;

        String sql = "select * from Users where Email = ?";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = extractUserFromResultSet(rs);
                }
            }
        }

        return user;
    }

    //SO
    public List<ShopOwner> getShopOwners() throws SQLException {
        List<ShopOwner> shopOwners = new ArrayList<>();

        String sql = """
            select * from ShopOwner
        """;

        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ShopOwner shopOwner = extractShopOwnerFromResultSet(rs);
                shopOwners.add(shopOwner);
            }
        }

        return shopOwners;
    }

    //SO
    public void updateIsActiveByEmail(String email, int newStatus) throws SQLException {
        String sql = """
            UPDATE ShopOwner SET IsActive = ? WHERE Email = ?;
            UPDATE Staff SET IsActive = ? WHERE Email = ?;
        """;
        try (Connection conn = DBUtil.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newStatus);
            stmt.setString(2, email);
            stmt.setInt(3, newStatus);
            stmt.setString(4, email);

            stmt.executeUpdate();
        }
    }

    //User
    public List<User> getStaffsByBranchID(int branchId, String dbName) throws SQLException {
        List<User> staffs = new ArrayList<>();

        String sql = """
            select * from Users where RoleID = '2' and BranchID = ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, branchId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User staff = extractUserFromResultSet(rs);
                staffs.add(staff);
            }
        }

        return staffs;
    }

    //SO
    public static void insertShopOwnerToUserTable(String email, String dbName) throws SQLException {
        ShopOwner shopOwnwer = getShopOwnwerByEmail(email);
        String sql = """
        INSERT INTO Users (PasswordHash, FullName, Email, Phone, BranchID, WarehouseID, RoleID, IsActive) VALUES
        (?, ?, ?, ?, NULL, NULL, 0, 1);
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, shopOwnwer.getPassword());
            stmt.setString(2, shopOwnwer.getFullName());
            stmt.setString(3, shopOwnwer.getEmail());
            stmt.setString(4, shopOwnwer.getPhone());
            stmt.executeUpdate();
        }
    }

    public static User getUserById(int userId, String dbName) throws SQLException {
        Connection conn;
        PreparedStatement ps;
        ResultSet rs;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            String sql = "SELECT * FROM Users WHERE UserID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                User user = extractUserFromResultSet(rs);
                return user;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public static boolean updateSOPassword(int ownerId, String hashedPassword) throws SQLException {
        String sql = "UPDATE ShopOwner SET Password = ? WHERE OwnerID = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setInt(2, ownerId);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    public static boolean updateSOPasswordInTheirDTB(String dbName, String hashedPassword) throws SQLException {
        String sql = "UPDATE Users SET PasswordHash = ? WHERE UserID = 1";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    public static boolean insertBranchManagerAndSaleIntoUser(String dbName, User user) throws SQLException {
        String sql = """
        INSERT INTO Users (
            PasswordHash, FullName, Email, Phone,
            BranchID, WarehouseID, RoleID, IsActive,
            Gender, AvaUrl
        ) VALUES (?, ?, ?, ?, ?, null, ?, ?, ?, ?);
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getPassword());
            stmt.setString(2, user.getFullName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getBranchId());
            stmt.setInt(6, user.getRoleId());
            stmt.setInt(7, user.getIsActive());
            stmt.setString(8, user.getGender());
            stmt.setString(9, user.getAvaUrl());

            int rs = stmt.executeUpdate();
            if (rs > 0) {
                return true;
            }
        }
        return false;
    }
    
    public static boolean insertWareHouseManagerIntoUser(String dbName, User user) throws SQLException {
        String sql = """
        INSERT INTO Users (
            PasswordHash, FullName, Email, Phone,
            BranchID, WarehouseID, RoleID, IsActive,
            Gender, AvaUrl
        ) VALUES (?, ?, ?, ?, null, ?, ?, ?, ?, ?);
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, user.getPassword());
            stmt.setString(2, user.getFullName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getWarehouseId());
            stmt.setInt(6, user.getRoleId());
            stmt.setInt(7, user.getIsActive());
            stmt.setString(8, user.getGender());
            stmt.setString(9, user.getAvaUrl());

            int rs = stmt.executeUpdate();
            if (rs > 0) {
                return true;
            }
        }
        return false;
    }

    
    //All User
    public static boolean isUserAccountTaken(String dbName, String email, String phone) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Users WHERE Email = ? OR Phone = ?";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setString(2, phone);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
    

    private static ShopOwner extractShopOwnerFromResultSet(ResultSet rs) throws SQLException {
        ShopOwner shopOwner = new ShopOwner(
                rs.getInt("OwnerID"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("ShopName"),
                rs.getString("DatabaseName"),
                rs.getString("Email"),
                rs.getString("IdentificationID"),
                rs.getString("Gender"),
                rs.getString("Address"),
                rs.getString("Phone"),
                rs.getInt("IsActive"),
                rs.getDate("CreatedAt")
        );
        return shopOwner;
    }

    private static ShopOwnerDTO extractShopOwnerDTOFromResultSet(ResultSet rs) throws SQLException {
        ShopOwnerDTO shopOwnerDTO = new ShopOwnerDTO(
                rs.getDate("TrialStartDate"),
                rs.getString("TrialStatus"),
                rs.getString("SubscriptionMonths"),
                rs.getDate("SubscriptionStart"),
                rs.getDate("SubscriptionEnd"),
                rs.getInt("OwnerID"),
                rs.getString("Password"),
                rs.getString("FullName"),
                rs.getString("ShopName"),
                rs.getString("DatabaseName"),
                rs.getString("Email"),
                rs.getString("IdentificationID"),
                rs.getString("Gender"),
                rs.getString("Address"),
                rs.getString("Phone"),
                rs.getInt("IsActive"),
                rs.getDate("CreatedAt")
        );
        return shopOwnerDTO;
    }

    private static User extractUserFromResultSet(ResultSet rs) throws SQLException {
        User user = new User(
                rs.getInt("UserID"),
                rs.getString("PasswordHash"),
                rs.getString("FullName"),
                rs.getString("Email"),
                rs.getString("Phone"),
                rs.getString("BranchID"),
                rs.getString("WarehouseID"),
                rs.getString("Gender"),
                rs.getString("AvaUrl"),
                rs.getInt("RoleID"),
                rs.getInt("IsActive"),
                rs.getString("Address")
        );

        return user;
    }

    public static void main(String[] args) throws SQLException {
        UserDAO ud = new UserDAO();
//        List<ShopOwner> shopOwners = ud.getShopOwners();  
//        List<User> users = ud.getStaffsByBranchID(1, "DTB_StoreTemp");
//        User o = ud.getUserByEmail("an.nguyen@email.com", "DTB_StoreTemp");

        ShopOwner so = ud.getShopOwnwerByEmail("ndpp.work@gmail.com");
        System.out.println(so.getPassword());
    }
}
