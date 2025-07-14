package dao;

import model.AnnouncementDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;
import java.util.logging.Logger;
import model.Announcement;

public class AnnouncementDAO {

    public AnnouncementDAO() {
    }

    public List<AnnouncementDTO> getRecentAnnouncementsForShopOwner(String dbName) throws SQLException {
        List<AnnouncementDTO> list = new ArrayList<>();
        String sql = """
        SELECT TOP 6 a.AnnouncementID, a.Title, a.Description, a.CreatedAt,
                       ISNULL(u.FullName, N'Hệ thống') AS SenderName,
                       ISNULL(b.BranchName, N'Toàn hệ thống') AS LocationName
                FROM Announcements a
                LEFT JOIN Users u ON a.FromUserID = u.UserID
                LEFT JOIN Branches b ON a.ToBranchID = b.BranchID
                ORDER BY a.CreatedAt DESC
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AnnouncementDTO dto = new AnnouncementDTO();
                dto.setAnnouncementID(rs.getInt("AnnouncementID"));
                dto.setTitle(rs.getString("Title"));
                dto.setDescription(rs.getString("Description"));
                dto.setCreatedAt(rs.getTimestamp("CreatedAt"));
                dto.setSenderName(rs.getString("SenderName"));
                dto.setLocationName(rs.getString("LocationName"));
                list.add(dto);
            }
        }
        return list;
    }

    public List<AnnouncementDTO> getRecentActivitiesForShopOwner(String dbName) throws SQLException {
        List<AnnouncementDTO> list = new ArrayList<>();

        String sql
                = "SELECT TOP 5 ID, Status, CreatedAt, UserName, LocationName, Category, RawDescription, DetailInfo, SenderRole, FromLocation, ToLocation FROM ("
                // --- Đơn hàng ---
                + " SELECT o.OrderID AS ID, o.OrderStatus AS Status, o.CreatedAt, "
                + "        ISNULL(u.FullName, N'Hệ thống') AS UserName, "
                + "        ISNULL(b.BranchName, N'Chi nhánh không xác định') AS LocationName, "
                + "        N'Đơn hàng' AS Category, "
                + "        CONCAT(N'Đơn hàng ', o.OrderID, "
                + "               CASE WHEN o.Notes IS NOT NULL AND LEN(LTRIM(RTRIM(o.Notes))) > 0 "
                + "                    THEN CONCAT(N' - ', o.Notes) ELSE '' END) AS RawDescription, "
                + "        CONCAT(     FORMAT(o.GrandTotal, 'N0'), ' VNĐ') AS DetailInfo, "
                + "        NULL AS SenderRole, NULL AS FromLocation, NULL AS ToLocation "
                + " FROM Orders o "
                + " LEFT JOIN Users u ON o.CreatedBy = u.UserID "
                + " LEFT JOIN Branches b ON u.BranchID = b.BranchID "
                + " UNION ALL "
                // --- Nhập / Xuất kho ---
                + " SELECT s.MovementID AS ID, s.MovementType AS Status, s.CreatedAt, "
                + "        ISNULL(u.FullName, N'Hệ thống') AS UserName, "
                + "        CASE "
                + "            WHEN w.WarehouseName IS NOT NULL THEN w.WarehouseName "
                + "            WHEN b.BranchName IS NOT NULL THEN b.BranchName "
                + "            ELSE N'Kho không xác định' "
                + "        END AS LocationName, "
                + "        s.MovementType AS Category, "
                + "        CONCAT(N'Yêu cầu ', s.MovementID, "
                + "               CASE "
                + "                   WHEN s.Note IS NOT NULL AND LEN(LTRIM(RTRIM(s.Note))) > 0 "
                + "                   THEN CONCAT(N' - ', s.Note) "
                + "                   ELSE '' "
                + "               END "
                + "        ) AS RawDescription, "
                + "        CONCAT(N'Yêu cầu ', s.MovementID, ' - ', s.MovementType) AS DetailInfo, "
                + "        CASE "
                + "            WHEN u.BranchID IS NOT NULL THEN N'BM' "
                + "            WHEN u.WarehouseID IS NOT NULL THEN N'WM' "
                + "            ELSE NULL "
                + "        END AS SenderRole, "
                + "        ISNULL(fb.BranchName, fw.WarehouseName) AS FromLocation, "
                + "        ISNULL(tb.BranchName, tw.WarehouseName) AS ToLocation "
                + " FROM StockMovementsRequest s "
                + " LEFT JOIN Users u ON s.CreatedBy = u.UserID "
                + " LEFT JOIN Branches b ON u.BranchID = b.BranchID "
                + " LEFT JOIN Warehouses w ON u.WarehouseID = w.WarehouseID "
                + " LEFT JOIN Branches fb ON s.FromBranchID = fb.BranchID "
                + " LEFT JOIN Warehouses fw ON s.FromWarehouseID = fw.WarehouseID "
                + " LEFT JOIN Branches tb ON s.ToBranchID = tb.BranchID "
                + " LEFT JOIN Warehouses tw ON s.ToWarehouseID = tw.WarehouseID "
                + " UNION ALL "
                // --- Dòng tiền ---
                + " SELECT c.CashFlowID AS ID, c.FlowType AS Status, c.CreatedAt, "
                + "        c.CreatedBy AS UserName, "
                + "        ISNULL(b.BranchName, 'Chi nhánh không xác định') AS LocationName, "
                + "        c.Category AS Category, "
                + "        c.Description AS RawDescription, "
                + "        CASE "
                + "            WHEN c.Description IS NOT NULL AND LEN(LTRIM(RTRIM(c.Description))) > 0 "
                + "            THEN CONCAT( FORMAT(c.Amount, 'N0'), ' VNĐ') "
                + "            ELSE CONCAT(c.Category, ' - ', FORMAT(c.Amount, 'N0'), ' VNĐ') "
                + "        END AS DetailInfo, "
                + "        NULL AS SenderRole, NULL AS FromLocation, NULL AS ToLocation "
                + " FROM CashFlows c "
                + " LEFT JOIN Branches b ON c.BranchID = b.BranchID "
                + ") AS Combined ORDER BY CreatedAt DESC";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AnnouncementDTO dto = new AnnouncementDTO();
                dto.setAnnouncementID(rs.getInt("ID"));
                dto.setStatus(rs.getString("Status"));
                dto.setCreatedAt(rs.getTimestamp("CreatedAt"));
                dto.setTitle(rs.getString("UserName"));
                dto.setDescription(rs.getString("DetailInfo")); // Chi tiết hoạt động
                dto.setSenderName(rs.getString("UserName"));
                dto.setLocationName(rs.getString("LocationName"));
                dto.setCategory(rs.getString("Category"));
                dto.setRawDescription(rs.getString("RawDescription"));
                dto.setSenderRole(rs.getString("SenderRole"));
                dto.setFromLocation(rs.getString("FromLocation"));
                dto.setToLocation(rs.getString("ToLocation"));

                list.add(dto);
            }
        }
        System.out.println("🟡 Tổng số hoạt động lấy được: " + list.size());

        return list;
    }

    /* Lấy thông báo gần đây cho Branch Manager
     */
    public List<AnnouncementDTO> getRecentAnnouncementsForBranchManager(String dbName, int branchID) throws SQLException {
        List<AnnouncementDTO> list = new ArrayList<>();
        String sql = """
        SELECT TOP 6 a.AnnouncementID, a.Title, a.Description, a.Status, a.CreatedAt,
               ISNULL(u.FullName, N'Hệ thống') AS SenderName,
               ISNULL(b.BranchName, N'Chi nhánh không xác định') AS LocationName
        FROM Announcements a
        LEFT JOIN Users u ON a.CreatedBy = u.UserID
        LEFT JOIN Branches b ON a.BranchID = b.BranchID
        WHERE a.BranchID = ? OR a.BranchID IS NULL
        ORDER BY a.CreatedAt DESC
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, branchID);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AnnouncementDTO dto = new AnnouncementDTO();
                    dto.setAnnouncementID(rs.getInt("AnnouncementID"));
                    dto.setTitle(rs.getString("Title"));
                    dto.setDescription(rs.getString("Description"));
                    dto.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    dto.setSenderName(rs.getString("SenderName"));
                    dto.setLocationName(rs.getString("LocationName"));
                    list.add(dto);
                }
            }
        }

        System.out.println("🟡 Branch Manager - Tổng số thông báo lấy được cho BranchID " + branchID + ": " + list.size());
        return list;
    }

    /* Lấy hoạt động gần đây cho Branch Manager
     */
    public List<AnnouncementDTO> getRecentActivitiesForBranchManager(String dbName, int branchID) throws SQLException {
        List<AnnouncementDTO> list = new ArrayList<>();

        String sql = """
        SELECT TOP 5 ID, Status, CreatedAt, UserName, LocationName, Category, RawDescription, DetailInfo, SenderRole, FromLocation, ToLocation FROM (
            -- === ĐƠN HÀNG của chi nhánh ===
            SELECT o.OrderID AS ID, o.OrderStatus AS Status, o.CreatedAt,
                   ISNULL(u.FullName, N'Hệ thống') AS UserName,
                   ISNULL(b.BranchName, N'Chi nhánh không xác định') AS LocationName,
                   N'Đơn hàng' AS Category,
                   CONCAT(N'Đơn hàng ', o.OrderID,
                          CASE WHEN o.Notes IS NOT NULL AND LEN(LTRIM(RTRIM(o.Notes))) > 0 
                               THEN CONCAT(N' - ', o.Notes) ELSE '' END) AS RawDescription,
                   CONCAT(FORMAT(o.GrandTotal, 'N0'), ' VNĐ') AS DetailInfo,
                   NULL AS SenderRole, NULL AS FromLocation, NULL AS ToLocation
            FROM Orders o
            LEFT JOIN Users u ON o.CreatedBy = u.UserID
            LEFT JOIN Branches b ON o.BranchID = b.BranchID
            WHERE o.BranchID = ?
            
            UNION ALL
            
            -- === NHẬP/XUẤT KHO liên quan đến chi nhánh ===
            SELECT s.MovementID AS ID, s.MovementType AS Status, s.CreatedAt,
                   ISNULL(u.FullName, N'Hệ thống') AS UserName,
                   CASE 
                       WHEN w.WarehouseName IS NOT NULL THEN w.WarehouseName
                       WHEN b.BranchName IS NOT NULL THEN b.BranchName
                       ELSE N'Kho không xác định'
                   END AS LocationName,
                   s.MovementType AS Category,
                   CONCAT(N'Yêu cầu ', s.MovementID,
                          CASE 
                              WHEN s.Note IS NOT NULL AND LEN(LTRIM(RTRIM(s.Note))) > 0 
                              THEN CONCAT(N' - ', s.Note)
                              ELSE ''
                          END
                   ) AS RawDescription,
                   CONCAT(N'Yêu cầu ', s.MovementID, ' - ', s.MovementType) AS DetailInfo,
                   CASE 
                       WHEN u.BranchID IS NOT NULL THEN N'BM'
                       WHEN u.WarehouseID IS NOT NULL THEN N'WM'
                       ELSE NULL
                   END AS SenderRole,
                   ISNULL(fb.BranchName, fw.WarehouseName) AS FromLocation,
                   ISNULL(tb.BranchName, tw.WarehouseName) AS ToLocation
            FROM StockMovementsRequest s
            LEFT JOIN Users u ON s.CreatedBy = u.UserID
            LEFT JOIN Branches b ON u.BranchID = b.BranchID
            LEFT JOIN Warehouses w ON u.WarehouseID = w.WarehouseID
            LEFT JOIN Branches fb ON s.FromBranchID = fb.BranchID
            LEFT JOIN Warehouses fw ON s.FromWarehouseID = fw.WarehouseID
            LEFT JOIN Branches tb ON s.ToBranchID = tb.BranchID
            LEFT JOIN Warehouses tw ON s.ToWarehouseID = tw.WarehouseID
            WHERE s.FromBranchID = ? OR s.ToBranchID = ?
            
            UNION ALL
            
            -- === DÒNG TIỀN của chi nhánh ===
            SELECT c.CashFlowID AS ID, c.FlowType AS Status, c.CreatedAt,
                   c.CreatedBy AS UserName,
                   ISNULL(b.BranchName, 'Chi nhánh không xác định') AS LocationName,
                   c.Category AS Category,
                   c.Description AS RawDescription,
                   CASE 
                       WHEN c.Description IS NOT NULL AND LEN(LTRIM(RTRIM(c.Description))) > 0 
                       THEN CONCAT(FORMAT(c.Amount, 'N0'), ' VNĐ')
                       ELSE CONCAT(c.Category, ' - ', FORMAT(c.Amount, 'N0'), ' VNĐ')
                   END AS DetailInfo,
                   NULL AS SenderRole, NULL AS FromLocation, NULL AS ToLocation
            FROM CashFlows c
            LEFT JOIN Branches b ON c.BranchID = b.BranchID
            WHERE c.BranchID = ?
        ) AS Combined 
        ORDER BY CreatedAt DESC
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameters cho các WHERE clause
            ps.setInt(1, branchID); // Orders.BranchID
            ps.setInt(2, branchID); // StockMovementsRequest.FromBranchID
            ps.setInt(3, branchID); // StockMovementsRequest.ToBranchID  
            ps.setInt(4, branchID); // CashFlows.BranchID

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AnnouncementDTO dto = new AnnouncementDTO();
                    dto.setAnnouncementID(rs.getInt("ID"));
                    dto.setStatus(rs.getString("Status"));
                    dto.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    dto.setTitle(rs.getString("UserName"));
                    dto.setDescription(rs.getString("DetailInfo")); // Chi tiết hoạt động
                    dto.setSenderName(rs.getString("UserName"));
                    dto.setLocationName(rs.getString("LocationName"));
                    dto.setCategory(rs.getString("Category"));
                    dto.setRawDescription(rs.getString("RawDescription"));
                    dto.setSenderRole(rs.getString("SenderRole"));
                    dto.setFromLocation(rs.getString("FromLocation"));
                    dto.setToLocation(rs.getString("ToLocation"));

                    list.add(dto);
                }
            }
        }

        System.out.println("🟡 Branch Manager - Tổng số hoạt động lấy được cho BranchID " + branchID + ": " + list.size());
        return list;
    }

    public static List<Announcement> getReceivedAnnouncements(String dbName, int branchId, int exceptUserId) throws SQLException {
        List<Announcement> list = new ArrayList<>();

        String query = "SELECT a.AnnouncementID, u.FullName AS FromUser, a.Title, a.Description, a.CreatedAt FROM dbo.Announcements a JOIN dbo.Users u ON a.FromUserID = u.UserID WHERE (a.ToBranchID = ?) AND u.UserID != ? ORDER BY a.CreatedAt DESC";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, branchId);
            ps.setInt(2, exceptUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Announcement a = new Announcement();
                    a.setAnnouncementID(rs.getInt("AnnouncementID"));
                    a.setFromUser(rs.getString("FromUser"));
                    a.setTitle(rs.getString("Title"));
                    a.setDescription(rs.getString("Description"));
                    a.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(a);
                }
            }
        }

        return list;
    }
    
    public static List<Announcement> getReceivedAnnouncementsOfWarehouse(String dbName, int whId, int exceptUserId) throws SQLException {
        List<Announcement> list = new ArrayList<>();

        String query = "SELECT a.AnnouncementID, u.FullName AS FromUser, a.Title, a.Description, a.CreatedAt FROM dbo.Announcements a JOIN dbo.Users u ON a.FromUserID = u.UserID WHERE (a.ToWarehouseID = ?) AND u.UserID != ? ORDER BY a.CreatedAt DESC";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, whId);
            ps.setInt(2, exceptUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Announcement a = new Announcement();
                    a.setAnnouncementID(rs.getInt("AnnouncementID"));
                    a.setFromUser(rs.getString("FromUser"));
                    a.setTitle(rs.getString("Title"));
                    a.setDescription(rs.getString("Description"));
                    a.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(a);
                }
            }
        }

        return list;
    }

    public static List<Announcement> getSentAnnouncements(String dbName, int userId) throws SQLException {
        List<Announcement> list = new ArrayList<>();

        String query = "SELECT AnnouncementID, Title, Description, CreatedAt FROM dbo.Announcements WHERE FromUserID = ? ORDER BY CreatedAt DESC";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Announcement a = new Announcement();
                    a.setAnnouncementID(rs.getInt("AnnouncementID"));
                    a.setTitle(rs.getString("Title"));
                    a.setDescription(rs.getString("Description"));
                    a.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(a);
                }
            }
        }

        return list;
    }

    public static void insertImportRequestAnnouncement(String dbName, int fromUserID, int toWarehouseID, String note) throws SQLException {
        String query = "INSERT INTO Announcements "
                + "(FromUserID, FromBranchID, FromWarehouseID, ToWarehouseID, Title, Description, CreatedAt) "
                + "VALUES (?, (SELECT BranchID FROM Users WHERE UserID = ?), NULL, ?, ?, ?, GETDATE())";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, fromUserID); // FromUserID
            stmt.setInt(2, fromUserID); // for subquery: get BranchID
            stmt.setInt(3, toWarehouseID); // ToWarehouseID
            stmt.setString(4, "Tạo thành công yêu cầu nhập hàng"); // Title
            stmt.setString(5, note != null ? note : ""); // Description

            stmt.executeUpdate();
        }
    }

    public static void insertAnnouncement(String dbName, int fromUserId, int toBranchId,
            String title, String description) throws SQLException {
        String sql = "INSERT INTO dbo.Announcements (FromUserID, ToBranchID, Title, Description, CreatedAt) VALUES( ?,  ?,  ?,  ?, GETDATE())";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fromUserId);
            ps.setInt(2, toBranchId);
            ps.setString(3, title);
            ps.setString(4, description);
            ps.executeUpdate();
        }
    }
    
    public static void insertAnnouncementOfWH(String dbName, int fromUserId, int fromWarehouseId,
            String title, String description) throws SQLException {
        String sql = "INSERT INTO dbo.Announcements (FromUserID, FromWarehouseID, Title, Description, CreatedAt) VALUES( ?,  ?,  ?,  ?, GETDATE())";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fromUserId);
            ps.setInt(2, fromWarehouseId);
            ps.setString(3, title);
            ps.setString(4, description);
            ps.executeUpdate();
        }
    }

    public static void main(String[] args) throws SQLException {
        System.out.println(AnnouncementDAO.getSentAnnouncements("DTB_TechStore", 1));
    }

}
