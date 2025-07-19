package controller;

import dao.StockMovementsRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.ArrayList;
import model.StockMovementsRequest;

/**
 * Controller for Shop Owner (RoleID = 0) to track all stock movements
 * Simple and efficient version with dynamic page size options
 * @author YOUR_NAME
 */
@WebServlet("/so-track-movements")
public class SOTrackMovementsController extends HttpServlet {
    
    private static final int DEFAULT_PAGE_SIZE = 10; // Số record mặc định trên mỗi trang
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        Object userRoleObj = request.getSession().getAttribute("roleId");
        
        // Check if user is Shop Owner (RoleID = 0)
        if (dbName == null || userRoleObj == null) {
            System.err.println("Session không hợp lệ - dbName: " + dbName + ", roleId: " + userRoleObj);
            response.sendRedirect("login");
            return;
        }
        
        Integer roleId = null;
        try {
            if (userRoleObj instanceof String) {
                roleId = Integer.parseInt((String) userRoleObj);
            } else if (userRoleObj instanceof Integer) {
                roleId = (Integer) userRoleObj;
            }
            
            if (roleId == null || roleId != 0) {
                System.err.println("Unauthorized access - roleId: " + roleId + " (expected: 0 for Shop Owner)");
                request.getSession().setAttribute("errorMessage", "Bạn không có quyền truy cập trang này");
                response.sendRedirect("login");
                return;
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid roleId format: " + userRoleObj);
            response.sendRedirect("login");
            return;
        }
        
        // Get filter parameters
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String status = request.getParameter("status");
        String movementType = request.getParameter("movementType");
        
        // Get pagination parameters
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
        
        try {
            StockMovementsRequestDAO dao = new StockMovementsRequestDAO();
            
            long startTime = System.currentTimeMillis();
            
            // Đầu tiên lấy total records để tính page size options
            int totalRecords = dao.getMovementsCount(dbName, fromDate, toDate, status, movementType);
            
            // Tính toán page size options dựa trên total records
            List<Integer> pageSizeOptions = new ArrayList<>();
            if (totalRecords > 10) {
                // Chia tổng số records thành 4 levels: 10%, 25%, 50%, 75%, 100%
                int option10 = Math.max(10, (int) Math.ceil(totalRecords * 0.1));
                int option25 = Math.max(10, (int) Math.ceil(totalRecords * 0.25));
                int option50 = Math.max(10, (int) Math.ceil(totalRecords * 0.5));
                int option75 = Math.max(10, (int) Math.ceil(totalRecords * 0.75));
                int option100 = totalRecords;
                
                pageSizeOptions.add(option10);
                if (option25 > option10) pageSizeOptions.add(option25);
                if (option50 > option25) pageSizeOptions.add(option50);
                if (option75 > option50) pageSizeOptions.add(option75);
                if (option100 > option75) pageSizeOptions.add(option100);
            } else if (totalRecords > 0) {
                // Nếu <= 10 records, chỉ hiển thị tất cả
                pageSizeOptions.add(totalRecords);
            } else {
                pageSizeOptions.add(DEFAULT_PAGE_SIZE);
            }
            
            // Lấy page size từ parameter hoặc dùng default
            String pageSizeParam = request.getParameter("pageSize");
            int currentPageSize = DEFAULT_PAGE_SIZE;
            if (pageSizeParam != null && !pageSizeParam.trim().isEmpty()) {
                try {
                    currentPageSize = Integer.parseInt(pageSizeParam);
                } catch (NumberFormatException e) {
                    currentPageSize = DEFAULT_PAGE_SIZE;
                }
            } else if (!pageSizeOptions.isEmpty()) {
                // Nếu không có parameter, dùng option đầu tiên
                currentPageSize = pageSizeOptions.get(0);
            }
            
            // Lấy data cho trang hiện tại với currentPageSize
            List<StockMovementsRequest> allMovements = dao.getMovementsWithFilters(
                dbName, fromDate, toDate, status, movementType, currentPage, currentPageSize
            );
            
            long executionTime = System.currentTimeMillis() - startTime;
            
            // Calculate pagination info với currentPageSize
            int totalPages = totalRecords > 0 ? (int) Math.ceil((double) totalRecords / currentPageSize) : 1;
            
            // Ensure current page is valid
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                // Redirect to valid page
                StringBuilder redirectUrl = new StringBuilder("so-track-movements?page=" + currentPage);
                if (fromDate != null && !fromDate.isEmpty()) redirectUrl.append("&fromDate=").append(fromDate);
                if (toDate != null && !toDate.isEmpty()) redirectUrl.append("&toDate=").append(toDate);
                if (status != null && !status.isEmpty()) redirectUrl.append("&status=").append(status);
                if (movementType != null && !movementType.isEmpty()) redirectUrl.append("&movementType=").append(movementType);
                redirectUrl.append("&pageSize=").append(currentPageSize);
                response.sendRedirect(redirectUrl.toString());
                return;
            }
            
            // Tính toán statistics từ allMovements hiện tại (đơn giản)
            long totalCount = totalRecords;
            long completedCount = allMovements.stream()
                .filter(m -> "completed".equals(m.getResponseStatus()))
                .count();
            long processingCount = allMovements.stream()
                .filter(m -> "processing".equals(m.getResponseStatus()) || 
                            "transfer".equals(m.getResponseStatus()) ||
                            "pending".equals(m.getResponseStatus()))
                .count();
            long importCount = allMovements.stream()
                .filter(m -> "import".equals(m.getMovementType()))
                .count();
            long exportCount = allMovements.stream()
                .filter(m -> "export".equals(m.getMovementType()))
                .count();
            
            // Set request attributes
            request.setAttribute("allMovements", allMovements);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("status", status);
            request.setAttribute("movementType", movementType);
            
            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRecords", totalRecords);
            request.setAttribute("currentPageSize", currentPageSize);
            request.setAttribute("pageSizeOptions", pageSizeOptions);
            
            // Statistics attributes
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("completedCount", completedCount);
            request.setAttribute("processingCount", processingCount);
            request.setAttribute("importCount", importCount);
            request.setAttribute("exportCount", exportCount);
            
            // Debug info
            System.out.println("=== DYNAMIC PAGE SIZE VERSION ===");
            System.out.println("Found " + allMovements.size() + " movements on page " + currentPage);
            System.out.println("Total records: " + totalRecords + ", Total pages: " + totalPages);
            System.out.println("Page size: " + currentPageSize + ", Options: " + pageSizeOptions);
            System.out.println("Statistics - Total: " + totalCount + ", Completed: " + completedCount + 
                             ", Processing: " + processingCount + ", Import: " + importCount + ", Export: " + exportCount);
            System.out.println("Execution time: " + executionTime + "ms");
            
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-track-movements.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error loading movements: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách hoạt động");
            response.sendRedirect("so-overview");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Dynamic page size Controller for Shop Owner to track stock movements";
    }
}
