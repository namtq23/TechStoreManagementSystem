package dao;

import java.sql.*;
import java.util.*;
import model.StockMovementDetail;
import model.ProductDetailSerialNumber;
import util.DBUtil;

public class StockMovementDetailDAO {

    public List<StockMovementDetail> getDetailsByMovementID(String dbName, int movementID) {
        List<StockMovementDetail> list = new ArrayList<>();
        String query = """
        SELECT 
            d.MovementDetailID AS DetailID,
            d.MovementID,
            pd.ProductID,
            pd.ProductDetailID,
            p.ProductName,
            pd.ProductCode,
            d.Quantity,
            d.QuantityScanned,
            (
                SELECT COUNT(*) 
                FROM ProductDetailSerialNumber 
                WHERE ProductDetailID = d.ProductDetailID 
                  AND MovementDetailID = d.MovementDetailID
                  AND OrderID IS NULL 
                  AND BranchID IS NULL 
                  AND WarehouseID IS NULL
            ) AS Scanned
        FROM StockMovementDetail d
        JOIN ProductDetails pd ON d.ProductDetailID = pd.ProductDetailID
        JOIN Products p ON pd.ProductID = p.ProductID
        WHERE d.MovementID = ?
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, movementID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StockMovementDetail detail = new StockMovementDetail();
                    int detailID = rs.getInt("DetailID");
                    int productDetailID = rs.getInt("ProductDetailID");
                    detail.setProductDetailID(productDetailID);
                    detail.setDetailID(detailID);
                    detail.setRequestID(rs.getInt("MovementID"));
                    detail.setProductID(rs.getInt("ProductID"));
                    detail.setProductCode(rs.getString("ProductCode"));
                    detail.setProductName(rs.getString("ProductName"));
                    detail.setQuantity(rs.getInt("Quantity"));
                    detail.setQuantityScanned(rs.getInt("QuantityScanned"));  // Dữ liệu từ bảng
                    detail.setScanned(rs.getInt("Scanned"));                  // Subquery đếm tạm thời

                    // Lấy danh sách serial tạm thời theo cả 2 ID
                    List<ProductDetailSerialNumber> serials = getTempSerialsByDetail(dbName, detailID, productDetailID);
                    detail.setSerials(serials != null ? serials : new ArrayList<>());

                    list.add(detail);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ProductDetailSerialNumber> getTempSerialsByDetail(String dbName, int movementDetailID, int productDetailID) {
        List<ProductDetailSerialNumber> serials = new ArrayList<>();
        String sql = """
            SELECT 
                ProductDetailID, 
                MovementDetailID,
                SerialNumber, 
                Status, 
                OrderID, 
                BranchID, 
                WarehouseID 
            FROM ProductDetailSerialNumber 
            WHERE ProductDetailID = ? 
              AND MovementDetailID = ?
              AND OrderID IS NULL 
              AND BranchID IS NULL 
              AND WarehouseID IS NULL
        """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productDetailID);
            ps.setInt(2, movementDetailID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductDetailSerialNumber serial = new ProductDetailSerialNumber();
                    serial.setProductDetailID(rs.getInt("ProductDetailID"));
                    serial.setMovementDetailID(rs.getInt("MovementDetailID"));
                    serial.setSerialNumber(rs.getString("SerialNumber"));
                    serial.setStatus(rs.getString("Status"));
                    serial.setOrderID((Integer) rs.getObject("OrderID"));
                    serial.setBranchID((Integer) rs.getObject("BranchID"));
                    serial.setWarehouseID((Integer) rs.getObject("WarehouseID"));
                    serials.add(serial);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error loading serials: " + e.getMessage());
            e.printStackTrace();
        }

        return serials;
    }

    public void insertMovementDetail(
        String dbName,
        int movementId,
        int productDetailId,
        int quantity
) throws SQLException {
    String sql = """
        INSERT INTO StockMovementDetail (
            MovementID, ProductDetailID, Quantity, QuantityScanned
        ) VALUES (?, ?, ?, 0);
    """;

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, movementId);
        ps.setInt(2, productDetailId);
        ps.setInt(3, quantity);

        ps.executeUpdate();
    }
}
public List<StockMovementDetail> getRawDetailsByMovementID(String dbName, int movementID) throws SQLException {
    List<StockMovementDetail> list = new ArrayList<>();
    String sql = "SELECT d.MovementDetailID, d.MovementID, d.ProductDetailID, d.Quantity, d.QuantityScanned, " +
                 "pd.ProductCode, p.ProductName, pd.ProductID " +  // Thêm pd.ProductID
                 "FROM StockMovementDetail d " +
                 "JOIN ProductDetails pd ON d.ProductDetailID = pd.ProductDetailID " +
                 "JOIN Products p ON pd.ProductID = p.ProductID " +
                 "WHERE d.MovementID = ?";

    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, movementID);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            StockMovementDetail detail = new StockMovementDetail();
            detail.setDetailID(rs.getInt("MovementDetailID"));        // DetailID = MovementDetailID
            detail.setRequestID(rs.getInt("MovementID"));
            detail.setProductID(rs.getInt("ProductID"));              // ProductID từ Products
            detail.setProductDetailID(rs.getInt("ProductDetailID"));  // ProductDetailID từ ProductDetails
            detail.setQuantity(rs.getInt("Quantity"));
            detail.setQuantityScanned(rs.getInt("QuantityScanned"));
            detail.setProductCode(rs.getString("ProductCode"));
            detail.setProductName(rs.getString("ProductName"));
            list.add(detail);
        }
    }
    return list;
}



// 1. Hàm chính - Lấy chi tiết với filter và paging
public List<StockMovementDetail> getMovementDetailsWithFilters(String dbName, int movementID, 
                                                               String productFilter, String status, 
                                                               int page, int pageSize) {
    List<StockMovementDetail> details = new ArrayList<>();
    int offset = (page - 1) * pageSize;
    
    StringBuilder sql = new StringBuilder();
 // Trong StockMovementDetailDAO - sửa lại SQL query
sql.append("""
    SELECT 
        smd.MovementDetailID,
        smd.MovementID,
        smd.ProductDetailID,
        smd.Quantity,
        smd.QuantityScanned,
        pd.ProductCode,
        p.ProductID,
        p.ProductName,
        c.CategoryName,
        (SELECT COUNT(*) FROM ProductDetailSerialNumber psn 
         WHERE psn.MovementDetailID = smd.MovementDetailID 
            OR psn.MovementHistory = CAST(smd.MovementDetailID AS NVARCHAR)) AS SerialCount
    FROM StockMovementDetail smd
    INNER JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
    INNER JOIN Products p ON pd.ProductID = p.ProductID
    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE smd.MovementID = ?
""");

    
    List<Object> params = new ArrayList<>();
    params.add(movementID);
    
    // Filter by product name
    if (productFilter != null && !productFilter.trim().isEmpty()) {
        sql.append(" AND p.ProductName LIKE ?");
        params.add("%" + productFilter + "%");
    }
    
    // Filter by status (completion)
    if (status != null && !status.trim().isEmpty()) {
        switch (status) {
            case "completed":
                sql.append(" AND smd.QuantityScanned >= smd.Quantity");
                break;
            case "pending":
                sql.append(" AND smd.QuantityScanned = 0");
                break;
            case "processing":
                sql.append(" AND smd.QuantityScanned > 0 AND smd.QuantityScanned < smd.Quantity");
                break;
        }
    }
    
    sql.append(" ORDER BY p.ProductName OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    params.add(offset);
    params.add(pageSize);
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockMovementDetail detail = new StockMovementDetail();
                detail.setDetailID(rs.getInt("MovementDetailID"));
                detail.setRequestID(rs.getInt("MovementID"));
                detail.setProductDetailID(rs.getInt("ProductDetailID"));
                detail.setProductID(rs.getInt("ProductID"));
                detail.setProductCode(rs.getString("ProductCode"));
                detail.setProductName(rs.getString("ProductName"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setQuantityScanned(rs.getInt("QuantityScanned"));
                detail.setScanned(rs.getInt("SerialCount"));
                
                // Get serials if needed
                if (rs.getInt("SerialCount") > 0) {
                    detail.setSerials(getSerialsByMovementDetail(dbName, detail.getDetailID()));
                } else {
                    detail.setSerials(new ArrayList<>());
                }
                
                details.add(detail);
            }
        }
        
    } catch (SQLException e) {
        System.err.println("Error in getMovementDetailsWithFilters: " + e.getMessage());
        e.printStackTrace();
    }
    
    return details;
}

// 2. Hàm count cho pagination
public int getMovementDetailsCount(String dbName, int movementID, String productFilter, String status) {
    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT COUNT(*) 
        FROM StockMovementDetail smd
        INNER JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        INNER JOIN Products p ON pd.ProductID = p.ProductID
        WHERE smd.MovementID = ?
    """);
    
    List<Object> params = new ArrayList<>();
    params.add(movementID);
    
    // Same filters as main query
    if (productFilter != null && !productFilter.trim().isEmpty()) {
        sql.append(" AND p.ProductName LIKE ?");
        params.add("%" + productFilter + "%");
    }
    
    if (status != null && !status.trim().isEmpty()) {
        switch (status) {
            case "completed":
                sql.append(" AND smd.QuantityScanned >= smd.Quantity");
                break;
            case "pending":
                sql.append(" AND smd.QuantityScanned = 0");
                break;
            case "processing":
                sql.append(" AND smd.QuantityScanned > 0 AND smd.QuantityScanned < smd.Quantity");
                break;
        }
    }
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        
    } catch (SQLException e) {
        System.err.println("Error in getMovementDetailsCount: " + e.getMessage());
        e.printStackTrace();
    }
    
    return 0;
}

// 3. Hàm lấy danh sách products cho filter dropdown
public List<String> getProductListByMovement(String dbName, int movementID) {
    List<String> products = new ArrayList<>();
    
    String sql = """
        SELECT DISTINCT p.ProductName
        FROM StockMovementDetail smd
        INNER JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        INNER JOIN Products p ON pd.ProductID = p.ProductID
        WHERE smd.MovementID = ?
        ORDER BY p.ProductName
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, movementID);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                products.add(rs.getString("ProductName"));
            }
        }
        
    } catch (SQLException e) {
        System.err.println("Error in getProductListByMovement: " + e.getMessage());
        e.printStackTrace();
    }
    
    return products;
}

// 4. Hàm hỗ trợ lấy serials (private method)
private List<ProductDetailSerialNumber> getSerialsByMovementDetail(String dbName, int movementDetailID) {
    List<ProductDetailSerialNumber> serials = new ArrayList<>();
    
    String sql = "SELECT SerialNumber FROM ProductDetailSerialNumber WHERE MovementDetailID = ? ORDER BY SerialNumber";
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, movementDetailID);
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductDetailSerialNumber serial = new ProductDetailSerialNumber();
                serial.setSerialNumber(rs.getString("SerialNumber"));
                serials.add(serial);
            }
        }
        
    } catch (SQLException e) {
        System.err.println("Error in getSerialsByMovementDetail: " + e.getMessage());
        e.printStackTrace();
    }
    
    return serials;
}

// Trong StockMovementDetailDAO.java
public List<ProductDetailSerialNumber> getSerialsByDetail(String dbName, int detailID) {
    List<ProductDetailSerialNumber> serials = new ArrayList<>();
    
    String sql = """
        SELECT SerialNumber, MovementHistory
        FROM ProductDetailSerialNumber 
        WHERE MovementDetailID = ? 
           OR MovementHistory = ?
           OR MovementHistory LIKE '%,' + ? + ',%'
           OR MovementHistory LIKE ? + ',%'
           OR MovementHistory LIKE '%,' + ?
        ORDER BY SerialNumber
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        String detailStr = String.valueOf(detailID);
        ps.setInt(1, detailID);
        ps.setString(2, detailStr);    // Exact match
        ps.setString(3, detailStr);    // Middle
        ps.setString(4, detailStr);    // Start
        ps.setString(5, detailStr);    // End
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductDetailSerialNumber serial = new ProductDetailSerialNumber();
                serial.setSerialNumber(rs.getString("SerialNumber"));
                serial.setMovementHistory(rs.getString("MovementHistory"));
                serials.add(serial);
            }
        }
        
    } catch (SQLException e) {
        System.err.println("Error in getSerialsByDetail: " + e.getMessage());
        e.printStackTrace();
    }
    
    return serials;
}

// Method mới chuyên cho view-order-details
public List<ProductDetailSerialNumber> getSerialsByDetailForView(String dbName, int detailID) {
    List<ProductDetailSerialNumber> serials = new ArrayList<>();
    
    String sql = """
        SELECT 
            ProductDetailID,
            MovementDetailID,
            SerialNumber, 
            Status, 
            OrderID, 
            BranchID, 
            WarehouseID,
            MovementHistory
        FROM ProductDetailSerialNumber 
        WHERE MovementDetailID = ? 
           OR MovementHistory = CAST(? AS NVARCHAR)
           OR MovementHistory LIKE '%,' + CAST(? AS NVARCHAR) + ',%'
           OR MovementHistory LIKE CAST(? AS NVARCHAR) + ',%'
           OR MovementHistory LIKE '%,' + CAST(? AS NVARCHAR)
        ORDER BY SerialNumber
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, detailID);      // MovementDetailID exact match
        ps.setInt(2, detailID);      // MovementHistory exact match
        ps.setInt(3, detailID);      // Middle of comma-separated list
        ps.setInt(4, detailID);      // Start of comma-separated list
        ps.setInt(5, detailID);      // End of comma-separated list
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductDetailSerialNumber serial = new ProductDetailSerialNumber();
                serial.setProductDetailID(rs.getInt("ProductDetailID"));
                serial.setMovementDetailID(rs.getInt("MovementDetailID"));
                serial.setSerialNumber(rs.getString("SerialNumber"));
                serial.setStatus(rs.getString("Status"));
                serial.setOrderID((Integer) rs.getObject("OrderID"));
                serial.setBranchID((Integer) rs.getObject("BranchID"));
                serial.setWarehouseID((Integer) rs.getObject("WarehouseID"));
                serial.setMovementHistory(rs.getString("MovementHistory"));
                serials.add(serial);
            }
        }
        
    } catch (SQLException e) {
        System.err.println("Error in getSerialsByDetailForView for detailID=" + detailID + ": " + e.getMessage());
        e.printStackTrace();
    }
    
    // Debug log
    System.out.println("DEBUG: getSerialsByDetailForView(" + detailID + ") returned " + serials.size() + " serials");
    
    return serials;
}

// Method debug để kiểm tra dữ liệu cho view
public void debugSerialDataForView(String dbName, int movementID) {
    String sql = """
        SELECT 
            smd.MovementDetailID,
            smd.ProductDetailID,
            pd.ProductCode,
            p.ProductName,
            smd.Quantity,
            smd.QuantityScanned,
            COUNT(psn.SerialNumber) as SerialCount,
            STRING_AGG(psn.SerialNumber, ', ') as SerialList
        FROM StockMovementDetail smd
        INNER JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID  
        INNER JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN ProductDetailSerialNumber psn ON (
            smd.MovementDetailID = psn.MovementDetailID 
            OR psn.MovementHistory LIKE '%' + CAST(smd.MovementDetailID AS NVARCHAR) + '%'
        )
        WHERE smd.MovementID = ?
        GROUP BY smd.MovementDetailID, smd.ProductDetailID, pd.ProductCode, p.ProductName, smd.Quantity, smd.QuantityScanned
        ORDER BY smd.MovementDetailID
    """;
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql)) {
        
        ps.setInt(1, movementID);
        
        try (ResultSet rs = ps.executeQuery()) {
            System.out.println("=== DEBUG SERIAL DATA FOR VIEW - MOVEMENT " + movementID + " ===");
            while (rs.next()) {
                System.out.println("MovementDetailID: " + rs.getInt("MovementDetailID"));
                System.out.println("ProductCode: " + rs.getString("ProductCode"));
                System.out.println("ProductName: " + rs.getString("ProductName"));
                System.out.println("Quantity: " + rs.getInt("Quantity"));
                System.out.println("QuantityScanned: " + rs.getInt("QuantityScanned"));
                System.out.println("Serial Count Found: " + rs.getInt("SerialCount"));
                System.out.println("Serials: " + rs.getString("SerialList"));
                System.out.println("---");
            }
            System.out.println("=== END DEBUG ===");
        }
        
    } catch (SQLException e) {
        System.err.println("Error in debugSerialDataForView: " + e.getMessage());
        e.printStackTrace();
    }
}

public List<StockMovementDetail> getnewMovementDetailsWithFilters(String dbName, int movementID, 
                                                               String productFilter, String status, 
                                                               int page, int pageSize) {
    List<StockMovementDetail> details = new ArrayList<>();
    int offset = (page - 1) * pageSize;
    
    StringBuilder sql = new StringBuilder();
    sql.append("""
        SELECT 
            smd.MovementDetailID,
            smd.MovementID,
            smd.ProductDetailID,
            smd.Quantity,
            smd.QuantityScanned,
            pd.ProductCode,
            p.ProductID,
            p.ProductName,
            c.CategoryName
        FROM StockMovementDetail smd
        INNER JOIN ProductDetails pd ON smd.ProductDetailID = pd.ProductDetailID
        INNER JOIN Products p ON pd.ProductID = p.ProductID
        LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
        WHERE smd.MovementID = ?
    """);

    List<Object> params = new ArrayList<>();
    params.add(movementID);
    
    // Filter by product name
    if (productFilter != null && !productFilter.trim().isEmpty()) {
        sql.append(" AND p.ProductName LIKE ?");
        params.add("%" + productFilter + "%");
    }
    
    // Filter by status (completion)
    if (status != null && !status.trim().isEmpty()) {
        switch (status) {
            case "completed":
                sql.append(" AND smd.QuantityScanned >= smd.Quantity");
                break;
            case "pending":
                sql.append(" AND smd.QuantityScanned = 0");
                break;
            case "processing":
                sql.append(" AND smd.QuantityScanned > 0 AND smd.QuantityScanned < smd.Quantity");
                break;
        }
    }
    
    sql.append(" ORDER BY p.ProductName OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
    params.add(offset);
    params.add(pageSize);
    
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement ps = conn.prepareStatement(sql.toString())) {
        
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                StockMovementDetail detail = new StockMovementDetail();
                detail.setDetailID(rs.getInt("MovementDetailID"));
                detail.setRequestID(rs.getInt("MovementID"));
                detail.setProductDetailID(rs.getInt("ProductDetailID"));
                detail.setProductID(rs.getInt("ProductID"));
                detail.setProductCode(rs.getString("ProductCode"));
                detail.setProductName(rs.getString("ProductName"));
                detail.setQuantity(rs.getInt("Quantity"));
                detail.setQuantityScanned(rs.getInt("QuantityScanned"));
                
                // SỬ DỤNG METHOD MỚI cho view-order-details
                List<ProductDetailSerialNumber> serials = getSerialsByDetailForView(dbName, detail.getDetailID());
                detail.setSerials(serials);
                detail.setScanned(serials.size());
                
                details.add(detail);
            }
        }
        
    } catch (SQLException e) {
        System.err.println("Error in getMovementDetailsWithFilters: " + e.getMessage());
        e.printStackTrace();
    }
    
    return details;
}




}
