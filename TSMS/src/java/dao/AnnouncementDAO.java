package dao;

import model.AnnouncementDTO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import util.DBUtil;
import java.util.logging.Logger;

public class AnnouncementDAO {

    public List<AnnouncementDTO> getRecentAnnouncementsForShopOwner(String dbName) throws SQLException {
        List<AnnouncementDTO> list = new ArrayList<>();
        String sql = """
        SELECT TOP 6 a.AnnouncementID, a.Title, a.Description, a.Status, a.CreatedAt,
               ISNULL(u.FullName, N'Hệ thống') AS SenderName,
               ISNULL(b.BranchName, N'Toàn hệ thống') AS LocationName
        FROM Announcements a
        LEFT JOIN Users u ON a.CreatedBy = u.UserID
        LEFT JOIN Branches b ON a.BranchID = b.BranchID
        ORDER BY a.CreatedAt DESC
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AnnouncementDTO dto = new AnnouncementDTO();
                dto.setAnnouncementID(rs.getInt("AnnouncementID"));
                dto.setTitle(rs.getString("Title"));
                dto.setDescription(rs.getString("Description"));
                dto.setStatus(rs.getString("Status"));
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

}
