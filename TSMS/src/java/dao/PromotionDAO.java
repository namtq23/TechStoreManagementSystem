package dao;

import model.PromotionDTO;
import model.PromotionSearchCriteria;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.List;
import model.Branch;
import model.ProductDetails;

public class PromotionDAO {

    // Method tìm kiếm với criteria
    public List<PromotionDTO> searchPromotions(String dbName, PromotionSearchCriteria criteria, Integer categoryId) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT PromotionID, PromoName, DiscountPercent, StartDate, EndDate ");
        sql.append("FROM Promotions WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        // Thêm search term condition
        if (criteria.getSearchTerm() != null && !criteria.getSearchTerm().trim().isEmpty()) {
            sql.append("AND PromoName LIKE ? ");
            parameters.add("%" + criteria.getSearchTerm().trim() + "%");
        }

        // Thêm status filter
        if (criteria.getStatusFilter() != null && !criteria.getStatusFilter().equals("all")) {
            Date currentDate = new Date(System.currentTimeMillis());
            switch (criteria.getStatusFilter()) {
                case "active":
                    sql.append("AND StartDate <= ? AND EndDate >= ? ");
                    parameters.add(currentDate);
                    parameters.add(currentDate);
                    break;
                case "scheduled":
                    sql.append("AND StartDate > ? ");
                    parameters.add(currentDate);
                    break;
                case "expired":
                    sql.append("AND EndDate < ? ");
                    parameters.add(currentDate);
                    break;
            }
        }

        //Thêm discount filter
        if (criteria.getDiscountFilter() != null && !criteria.getDiscountFilter().equals("all")) {
            switch (criteria.getDiscountFilter()) {
                case "low":
                    sql.append("AND DiscountPercent < 15 ");
                    break;
                case "medium":
                    sql.append("AND DiscountPercent >= 15 AND DiscountPercent <= 25 ");
                    break;
                case "high":
                    sql.append("AND DiscountPercent > 25 ");
                    break;
            }
        }

        // Thêm category filter (nếu có bảng liên kết)
        if (categoryId != null) {
            // Giả sử có bảng PromotionCategories hoặc field CategoryID trong Promotions
            // sql.append("AND CategoryID = ? ");
            // parameters.add(categoryId);
        }

        // Thêm sorting và pagination
        sql.append("ORDER BY ").append(criteria.getSortBy()).append(" ").append(criteria.getSortOrder()).append(" ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        int offset = (criteria.getPage() - 1) * criteria.getPageSize();
        parameters.add(offset);
        parameters.add(criteria.getPageSize());

        System.out.println("DEBUG: Search SQL: " + sql.toString());
        System.out.println("DEBUG: Parameters: " + parameters);

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            rs = stmt.executeQuery();

            while (rs.next()) {
                PromotionDTO promotion = new PromotionDTO();
                promotion.setPromotionID(rs.getInt("PromotionID"));
                promotion.setPromoName(rs.getString("PromoName"));
                promotion.setDiscountPercent(rs.getDouble("DiscountPercent"));
                promotion.setStartDate(rs.getDate("StartDate"));
                promotion.setEndDate(rs.getDate("EndDate"));

                // Tính toán status
                promotion.setStatus(calculatePromotionStatus(promotion.getStartDate(), promotion.getEndDate()));

                // Lấy thông tin branch và product count
                try {
                    promotion.setBranchCount(getBranchCount(dbName, promotion.getPromotionID()));
                    promotion.setProductCount(getProductCount(dbName, promotion.getPromotionID()));
                } catch (Exception e) {
                    promotion.setBranchCount(0);
                    promotion.setProductCount(0);
                }

                promotions.add(promotion);
            }

        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return promotions;
    }

    // Method đếm số lượng promotions theo criteria
    public int countPromotions(String dbName, PromotionSearchCriteria criteria, Integer categoryId) throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Promotions WHERE 1=1 ");

        List<Object> parameters = new ArrayList<>();

        // Thêm các conditions giống như searchPromotions
        if (criteria.getSearchTerm() != null && !criteria.getSearchTerm().trim().isEmpty()) {
            sql.append("AND PromoName LIKE ? ");
            parameters.add("%" + criteria.getSearchTerm().trim() + "%");
        }

        if (criteria.getStatusFilter() != null && !criteria.getStatusFilter().equals("all")) {
            Date currentDate = new Date(System.currentTimeMillis());
            switch (criteria.getStatusFilter()) {
                case "active":
                    sql.append("AND StartDate <= ? AND EndDate >= ? ");
                    parameters.add(currentDate);
                    parameters.add(currentDate);
                    break;
                case "scheduled":
                    sql.append("AND StartDate > ? ");
                    parameters.add(currentDate);
                    break;
                case "expired":
                    sql.append("AND EndDate < ? ");
                    parameters.add(currentDate);
                    break;
            }
        }

        if (criteria.getDiscountFilter() != null && !criteria.getDiscountFilter().equals("all")) {
            switch (criteria.getDiscountFilter()) {
                case "low":
                    sql.append("AND DiscountPercent < 15 ");
                    break;
                case "medium":
                    sql.append("AND DiscountPercent >= 15 AND DiscountPercent <= 25 ");
                    break;
                case "high":
                    sql.append("AND DiscountPercent > 25 ");
                    break;
            }
        }

        if (categoryId != null) {
            // sql.append("AND CategoryID = ? ");
            // parameters.add(categoryId);
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }

            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return 0;
    }

    // Lấy tất cả khuyến mãi - sửa query theo database thực tế
    public List<PromotionDTO> getAllPromotions(String dbName) throws SQLException {
        List<PromotionDTO> promotions = new ArrayList<>();
        String sql = "SELECT PromotionID, PromoName, DiscountPercent, StartDate, EndDate FROM Promotions ORDER BY PromotionID DESC";

        System.out.println("DEBUG: Getting promotions from database: " + dbName);
        System.out.println("DEBUG: SQL Query: " + sql);

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            // Sử dụng DBUtil.getConnectionTo() với dbName
            conn = DBUtil.getConnectionTo(dbName);
            if (conn == null) {
                System.out.println("ERROR: Connection is null for database: " + dbName);
                throw new SQLException("Cannot connect to database: " + dbName);
            }

            System.out.println("DEBUG: Connection established successfully");
            System.out.println("DEBUG: Connection URL: " + conn.getMetaData().getURL());

            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
                PromotionDTO promotion = new PromotionDTO();
                promotion.setPromotionID(rs.getInt("PromotionID"));
                promotion.setPromoName(rs.getString("PromoName"));
                promotion.setDiscountPercent(rs.getDouble("DiscountPercent"));
                promotion.setStartDate(rs.getDate("StartDate"));
                promotion.setEndDate(rs.getDate("EndDate"));

                // Tính toán status
                promotion.setStatus(calculatePromotionStatus(promotion.getStartDate(), promotion.getEndDate()));

                // Lấy thông tin branch và product count (với error handling)
                try {
                    promotion.setBranchCount(getBranchCount(dbName, promotion.getPromotionID()));
                    promotion.setProductCount(getProductCount(dbName, promotion.getPromotionID()));
                } catch (Exception e) {
                    System.out.println("WARNING: Could not get branch/product count for promotion " + promotion.getPromotionID() + ": " + e.getMessage());
                    promotion.setBranchCount(0);
                    promotion.setProductCount(0);
                }

                promotions.add(promotion);
                System.out.println("DEBUG: Added promotion: " + promotion.getPromoName() + " (ID: " + promotion.getPromotionID() + ")");
            }

            System.out.println("DEBUG: Found " + count + " promotions");

        } catch (SQLException e) {
            System.out.println("ERROR: SQL Exception in getAllPromotions: " + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            // Sử dụng DBUtil.closeConnection()
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return promotions;
    }

    //Lấy khuyến mãi theo ID
    public PromotionDTO getPromotionById(String dbName, int promotionId) throws SQLException {
        String sql = "SELECT PromotionID, PromoName, DiscountPercent, StartDate, EndDate FROM Promotions WHERE PromotionID = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, promotionId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                PromotionDTO promotion = new PromotionDTO();
                promotion.setPromotionID(rs.getInt("PromotionID"));
                promotion.setPromoName(rs.getString("PromoName"));
                promotion.setDiscountPercent(rs.getDouble("DiscountPercent"));
                promotion.setStartDate(rs.getDate("StartDate"));
                promotion.setEndDate(rs.getDate("EndDate"));

                // Tính toán status
                Date currentDate = new Date(System.currentTimeMillis());
                if (currentDate.before(promotion.getStartDate())) {
                    promotion.setStatus("scheduled");
                } else if (currentDate.after(promotion.getEndDate())) {
                    promotion.setStatus("expired");
                } else {
                    promotion.setStatus("active");
                }

                // Lấy danh sách chi nhánh và sản phẩm
                promotion.setBranchIDs(getPromotionBranches(dbName, promotionId));
                promotion.setProductDetailIDs(getPromotionProducts(dbName, promotionId));
                promotion.setBranchCount(promotion.getBranchIDs().size());
                promotion.setProductCount(promotion.getProductDetailIDs().size());

                return promotion;
            }
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return null;
    }

    // Tạo khuyến mãi mới
    public boolean createPromotion(String dbName, PromotionDTO promotion, String[] branchIds, String[] productDetailIds) throws SQLException {
        String sql = "INSERT INTO Promotions (PromoName, DiscountPercent, StartDate, EndDate) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Lưu thông tin khuyến mãi
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            stmt.setString(1, promotion.getPromoName());
            stmt.setDouble(2, promotion.getDiscountPercent());
            stmt.setDate(3, promotion.getStartDate());
            stmt.setDate(4, promotion.getEndDate());

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                // Lấy ID được tạo tự động
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        promotion.setPromotionID(generatedKeys.getInt(1));
                    }
                }
                stmt.close();

                // Lưu chi nhánh áp dụng
                if (branchIds != null && branchIds.length > 0) {
                    String insertBranchSQL = "INSERT INTO PromotionBranches (PromotionID, BranchID) VALUES (?, ?)";
                    stmt = conn.prepareStatement(insertBranchSQL);
                    for (String branchId : branchIds) {
                        stmt.setInt(1, promotion.getPromotionID());
                        stmt.setInt(2, Integer.parseInt(branchId));
                        stmt.executeUpdate();
                    }
                    stmt.close();
                }

                // Lưu sản phẩm áp dụng
                if (productDetailIds != null && productDetailIds.length > 0) {
                    String insertProductSQL = "INSERT INTO PromotionProducts (PromotionID, ProductDetailID) VALUES (?, ?)";
                    stmt = conn.prepareStatement(insertProductSQL);
                    for (String productDetailId : productDetailIds) {
                        stmt.setInt(1, promotion.getPromotionID());
                        stmt.setInt(2, Integer.parseInt(productDetailId));
                        stmt.executeUpdate();
                    }
                    stmt.close();
                }

                conn.commit();
                return true;
            }
            return false;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                DBUtil.closeConnection(conn);
            }
        }
    }

    // Cập nhật khuyến mãi
    public boolean updatePromotion(String dbName, PromotionDTO promotion, String[] branchIds, String[] productDetailIds) throws SQLException {
        String sql = "UPDATE Promotions SET PromoName = ?, DiscountPercent = ?, StartDate = ?, EndDate = ? WHERE PromotionID = ?";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Cập nhật thông tin khuyến mãi
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, promotion.getPromoName());
            stmt.setDouble(2, promotion.getDiscountPercent());
            stmt.setDate(3, promotion.getStartDate());
            stmt.setDate(4, promotion.getEndDate());
            stmt.setInt(5, promotion.getPromotionID());

            int rowsAffected = stmt.executeUpdate();
            stmt.close();

            if (rowsAffected > 0) {
                // Xóa chi nhánh cũ
                String deleteBranchSQL = "DELETE FROM PromotionBranches WHERE PromotionID = ?";
                stmt = conn.prepareStatement(deleteBranchSQL);
                stmt.setInt(1, promotion.getPromotionID());
                stmt.executeUpdate();
                stmt.close();

                // Thêm chi nhánh mới
                if (branchIds != null && branchIds.length > 0) {
                    String insertBranchSQL = "INSERT INTO PromotionBranches (PromotionID, BranchID) VALUES (?, ?)";
                    stmt = conn.prepareStatement(insertBranchSQL);
                    for (String branchId : branchIds) {
                        stmt.setInt(1, promotion.getPromotionID());
                        stmt.setInt(2, Integer.parseInt(branchId));
                        stmt.executeUpdate();
                    }
                    stmt.close();
                }

                // Xóa sản phẩm cũ
                String deleteProductSQL = "DELETE FROM PromotionProducts WHERE PromotionID = ?";
                stmt = conn.prepareStatement(deleteProductSQL);
                stmt.setInt(1, promotion.getPromotionID());
                stmt.executeUpdate();
                stmt.close();

                // Thêm sản phẩm mới
                if (productDetailIds != null && productDetailIds.length > 0) {
                    String insertProductSQL = "INSERT INTO PromotionProducts (PromotionID, ProductDetailID) VALUES (?, ?)";
                    stmt = conn.prepareStatement(insertProductSQL);
                    for (String productDetailId : productDetailIds) {
                        stmt.setInt(1, promotion.getPromotionID());
                        stmt.setInt(2, Integer.parseInt(productDetailId));
                        stmt.executeUpdate();
                    }
                    stmt.close();
                }

                conn.commit();
                return true;
            }
            return false;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (stmt != null) {
                try {
                    stmt.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                DBUtil.closeConnection(conn);
            }
        }
    }

    // Xóa khuyến mãi
    public boolean deletePromotion(String dbName, int promotionId) throws SQLException {
        Connection conn = null;
        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false);

            // Xóa PromotionBranches trước (nếu có)
            String deleteBranchesSQL = "DELETE FROM PromotionBranches WHERE PromotionID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteBranchesSQL)) {
                stmt.setInt(1, promotionId);
                stmt.executeUpdate();
            } catch (SQLException e) {
                System.out.println("WARNING: Could not delete from PromotionBranches: " + e.getMessage());
            }

            // Xóa PromotionProducts (nếu có)
            String deleteProductsSQL = "DELETE FROM PromotionProducts WHERE PromotionID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteProductsSQL)) {
                stmt.setInt(1, promotionId);
                stmt.executeUpdate();
            } catch (SQLException e) {
                System.out.println("WARNING: Could not delete from PromotionProducts: " + e.getMessage());
            }

            // Xóa Promotion
            String deletePromotionSQL = "DELETE FROM Promotions WHERE PromotionID = ?";
            try (PreparedStatement stmt = conn.prepareStatement(deletePromotionSQL)) {
                stmt.setInt(1, promotionId);
                int rowsAffected = stmt.executeUpdate();

                conn.commit();
                return rowsAffected > 0;
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.out.println("ERROR: Could not rollback transaction: " + rollbackEx.getMessage());
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                } catch (SQLException e) {
                    System.out.println("WARNING: Could not reset autocommit: " + e.getMessage());
                }
                DBUtil.closeConnection(conn);
            }
        }
    }

    public boolean deleteSelectedPromotions(String dbName, List<Integer> promotionIds) throws SQLException {
        if (promotionIds == null || promotionIds.isEmpty()) {
            return false;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnectionTo(dbName);
            conn.setAutoCommit(false);

            String placeholder = String.join(",", Collections.nCopies(promotionIds.size(), "?"));

            stmt = conn.prepareStatement("DELETE FROM PromotionBranches WHERE PromotionID IN (" + placeholder + ")");
            for (int i = 0; i < promotionIds.size(); i++) {
                stmt.setInt(i + 1, promotionIds.get(i));
            }
            stmt.executeUpdate();
            stmt.close();

            stmt = conn.prepareStatement("DELETE FROM PromotionProducts WHERE PromotionID IN (" + placeholder + ")");
            for (int i = 0; i < promotionIds.size(); i++) {
                stmt.setInt(i + 1, promotionIds.get(i));
            }
            stmt.executeUpdate();
            stmt.close();

            stmt = conn.prepareStatement("DELETE FROM Promotions WHERE PromotionID IN (" + placeholder + ")");
            for (int i = 0; i < promotionIds.size(); i++) {
                stmt.setInt(i + 1, promotionIds.get(i));
            }
            int rowsAffected = stmt.executeUpdate();

            conn.commit();
            return rowsAffected > 0;
        } catch (SQLException e) {
            if (conn != null) try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            throw e;
        } finally {
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (conn != null) try {
                conn.setAutoCommit(true);
                DBUtil.closeConnection(conn);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Helper methods với proper connection handling
    private int getBranchCount(String dbName, int promotionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM PromotionBranches WHERE PromotionID = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, promotionId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            // Nếu bảng PromotionBranches không tồn tại, return 0
            System.out.println("WARNING: Could not get branch count: " + e.getMessage());
            return 0;
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return 0;
    }

    private int getProductCount(String dbName, int promotionId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM PromotionProducts WHERE PromotionID = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, promotionId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            // Nếu bảng PromotionProducts không tồn tại, return 0
            System.out.println("WARNING: Could not get product count: " + e.getMessage());
            return 0;
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return 0;
    }

    private List<Integer> getPromotionBranches(String dbName, int promotionId) throws SQLException {
        List<Integer> branchIds = new ArrayList<>();
        String sql = "SELECT BranchID FROM PromotionBranches WHERE PromotionID = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, promotionId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                branchIds.add(rs.getInt("BranchID"));
            }
        } catch (SQLException e) {
            System.out.println("WARNING: Could not get promotion branches: " + e.getMessage());
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return branchIds;
    }

    private List<Integer> getPromotionProducts(String dbName, int promotionId) throws SQLException {
        List<Integer> productDetailIds = new ArrayList<>();
        String sql = "SELECT ProductDetailID FROM PromotionProducts WHERE PromotionID = ?";

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, promotionId);
            rs = stmt.executeQuery();

            while (rs.next()) {
                productDetailIds.add(rs.getInt("ProductDetailID"));
            }
        } catch (SQLException e) {
            System.out.println("WARNING: Could not get promotion products: " + e.getMessage());
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            if (stmt != null) try {
                stmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeConnection(conn);
        }

        return productDetailIds;
    }

    //method calculatePromotionStatus
    private String calculatePromotionStatus(java.sql.Date startDate, java.sql.Date endDate) {
        // Lấy ngày hiện tại (chỉ ngày, không có giờ)
        Calendar today = Calendar.getInstance();
        today.set(Calendar.HOUR_OF_DAY, 0);
        today.set(Calendar.MINUTE, 0);
        today.set(Calendar.SECOND, 0);
        today.set(Calendar.MILLISECOND, 0);

        // Convert sql.Date thành Calendar để so sánh
        Calendar startCal = Calendar.getInstance();
        startCal.setTime(startDate);
        startCal.set(Calendar.HOUR_OF_DAY, 0);
        startCal.set(Calendar.MINUTE, 0);
        startCal.set(Calendar.SECOND, 0);
        startCal.set(Calendar.MILLISECOND, 0);

        Calendar endCal = Calendar.getInstance();
        endCal.setTime(endDate);
        endCal.set(Calendar.HOUR_OF_DAY, 23);
        endCal.set(Calendar.MINUTE, 59);
        endCal.set(Calendar.SECOND, 59);
        endCal.set(Calendar.MILLISECOND, 999);

        // Debug logging
        System.out.println("DEBUG Status Calculation:");
        System.out.println("  Today: " + today.getTime());
        System.out.println("  Start: " + startCal.getTime());
        System.out.println("  End: " + endCal.getTime());

        // So sánh ngày hiện tại với khoảng thời gian khuyến mãi
        if (today.before(startCal)) {
            System.out.println("  Result: scheduled");
            return "scheduled";
        } else if (today.after(endCal)) {
            System.out.println("  Result: expired");
            return "expired";
        } else {
            System.out.println("  Result: active");
            return "active";
        }
    }

    public List<ProductDetails> getProductDetailsByPromotionId(String dbName, int promotionId) throws SQLException {
        List<ProductDetails> productDetails = new ArrayList<>();

        String sql = "SELECT pd.ProductDetailID, pd.Description, pd.ProductCode, pd.WarrantyPeriod, "
                  + "pd.CreatedAt AS DetailCreatedAt, pd.UpdatedAt "
                  + "FROM ProductDetails pd "
                  + "JOIN PromotionProducts pp ON pd.ProductDetailID = pp.ProductDetailID "
                  + "WHERE pp.PromotionID = ?";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, promotionId);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProductDetails pd = new ProductDetails(
                              rs.getInt("ProductDetailID"),
                              rs.getString("Description"),
                              rs.getString("ProductCode"),
                              rs.getString("WarrantyPeriod"),
                              rs.getTimestamp("DetailCreatedAt"),
                              rs.getTimestamp("UpdatedAt")
                    );
                    productDetails.add(pd);
                }
            }
        }

        return productDetails;
    }

    public List<Branch> getBranchesByPromotionId(String dbName, int promotionId) throws SQLException {
        List<Branch> branches = new ArrayList<>();
        String sql = "SELECT b.branchId, b.branchName, b.address, b.phone, b.isActive "
                  + "FROM Branches b "
                  + "JOIN PromotionBranches pb ON b.branchId = pb.branchID "
                  + "WHERE pb.promotionID = ?";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, promotionId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Branch branch = new Branch(
                              rs.getInt("branchId"),
                              rs.getString("branchName"),
                              rs.getString("address"),
                              rs.getString("phone"),
                              rs.getInt("isActive")
                    );
                    branches.add(branch);
                }
            }
        }
        return branches;
    }

    public List<ProductDetails> getAllProductDetails(String dbName) throws SQLException {
        List<ProductDetails> productDetails = new ArrayList<>();
        String sql = "SELECT ProductDetailID, Description, ProductCode, WarrantyPeriod, "
                  + "CreatedAt, UpdatedAt "
                  + "FROM ProductDetails";

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                productDetails.add(new ProductDetails(
                          rs.getInt("ProductDetailID"),
                          rs.getString("Description"),
                          rs.getString("ProductCode"),
                          rs.getString("WarrantyPeriod"),
                          rs.getTimestamp("CreatedAt"),
                          rs.getTimestamp("UpdatedAt")
                ));
            }
        }
        return productDetails;
    }

    // Test connection method
    public boolean testConnection(String dbName) {
        Connection conn = null;
        try {
            System.out.println("Testing connection to database: " + dbName);
            conn = DBUtil.getConnectionTo(dbName);

            if (conn != null) {
                System.out.println("✓ Connection successful");
                System.out.println("✓ Database URL: " + conn.getMetaData().getURL());
                System.out.println("✓ Database Product: " + conn.getMetaData().getDatabaseProductName());

                // Test if Promotions table exists
                String checkTableSQL = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Promotions'";
                try (PreparedStatement stmt = conn.prepareStatement(checkTableSQL); ResultSet rs = stmt.executeQuery()) {

                    if (rs.next() && rs.getInt(1) > 0) {
                        System.out.println("✓ Promotions table exists");

                        // Check data count
                        String countSQL = "SELECT COUNT(*) FROM Promotions";
                        try (PreparedStatement countStmt = conn.prepareStatement(countSQL); ResultSet countRs = countStmt.executeQuery()) {

                            if (countRs.next()) {
                                int count = countRs.getInt(1);
                                System.out.println("✓ Total promotions in table: " + count);
                                return true;
                            }
                        }
                    } else {
                        System.out.println("✗ Promotions table does not exist");
                        return false;
                    }
                }
            } else {
                System.out.println("✗ Connection failed");
                return false;
            }
        } catch (SQLException e) {
            System.out.println("✗ Database error: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.closeConnection(conn);
        }

        return false;
    }
}
