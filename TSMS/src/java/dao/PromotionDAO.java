package dao;

import model.PromotionDTO;
import model.PromotionSearchCriteria;
import util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
                Date currentDate = new Date(System.currentTimeMillis());
                if (currentDate.before(promotion.getStartDate())) {
                    promotion.setStatus("scheduled");
                } else if (currentDate.after(promotion.getEndDate())) {
                    promotion.setStatus("expired");
                } else {
                    promotion.setStatus("active");
                }
                
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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
                Date currentDate = new Date(System.currentTimeMillis());
                if (currentDate.before(promotion.getStartDate())) {
                    promotion.setStatus("scheduled");
                } else if (currentDate.after(promotion.getEndDate())) {
                    promotion.setStatus("expired");
                } else {
                    promotion.setStatus("active");
                }
            
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBUtil.closeConnection(conn);
        }
        
        return null;
    }
    
    // Tạo khuyến mãi mới
    public boolean createPromotion(String dbName, PromotionDTO promotion) throws SQLException {
        String sql = "INSERT INTO Promotions (PromoName, DiscountPercent, StartDate, EndDate) VALUES (?, ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBUtil.getConnectionTo(dbName);
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
                return true;
            }
            return false;
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBUtil.closeConnection(conn);
        }
    }
    
    // Cập nhật khuyến mãi
    public boolean updatePromotion(String dbName, PromotionDTO promotion) throws SQLException {
        String sql = "UPDATE Promotions SET PromoName = ?, DiscountPercent = ?, StartDate = ?, EndDate = ? WHERE PromotionID = ?";
        
        Connection conn = null;
        PreparedStatement stmt = null;
        
        try {
            conn = DBUtil.getConnectionTo(dbName);
            stmt = conn.prepareStatement(sql);
            
            stmt.setString(1, promotion.getPromoName());
            stmt.setDouble(2, promotion.getDiscountPercent());
            stmt.setDate(3, promotion.getStartDate());
            stmt.setDate(4, promotion.getEndDate());
            stmt.setInt(5, promotion.getPromotionID());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBUtil.closeConnection(conn);
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
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
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            DBUtil.closeConnection(conn);
        }
        
        return productDetailIds;
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
                try (PreparedStatement stmt = conn.prepareStatement(checkTableSQL);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    if (rs.next() && rs.getInt(1) > 0) {
                        System.out.println("✓ Promotions table exists");
                        
                        // Check data count
                        String countSQL = "SELECT COUNT(*) FROM Promotions";
                        try (PreparedStatement countStmt = conn.prepareStatement(countSQL);
                             ResultSet countRs = countStmt.executeQuery()) {
                            
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
