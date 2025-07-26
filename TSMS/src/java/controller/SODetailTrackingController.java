package controller;

import dao.StockMovementsRequestDAO;
import dao.StockMovementDetailDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.StockMovementDetail;
import model.StockMovementsRequest;
import model.ProductDetailSerialNumber;

/**
 * Controller for Shop Owner to view movement details
 * Fixed version to properly track serial numbers and scanned counts for completed movements
 */
@WebServlet("/so-detail-tracking")
public class SODetailTrackingController extends HttpServlet {
    
    private static final int PAGE_SIZE = 5;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        Object userRoleObj = request.getSession().getAttribute("roleId");
        
        // Check Shop Owner permission (RoleID = 0)
        if (dbName == null || userRoleObj == null) {
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
                request.getSession().setAttribute("errorMessage", "Bạn không có quyền truy cập trang này");
                response.sendRedirect("login");
                return;
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("login");
            return;
        }
        
        // Get movement ID parameter
        String movementIdParam = request.getParameter("id");
        if (movementIdParam == null || movementIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy ID hoạt động");
            response.sendRedirect("so-track-movements");
            return;
        }
        
        int movementID;
        try {
            movementID = Integer.parseInt(movementIdParam);
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "ID hoạt động không hợp lệ");
            response.sendRedirect("so-track-movements");
            return;
        }
        
        // Get filter parameters
        String productFilter = request.getParameter("productFilter");
        String status = request.getParameter("status");
        
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
        
        // Get items per page parameter
        String itemsPerPageParam = request.getParameter("itemsPerPage");
        int itemsPerPage = PAGE_SIZE;
        try {
            if (itemsPerPageParam != null && !itemsPerPageParam.trim().isEmpty()) {
                itemsPerPage = Integer.parseInt(itemsPerPageParam);
                if (itemsPerPage < 1) itemsPerPage = PAGE_SIZE;
            }
        } catch (NumberFormatException e) {
            itemsPerPage = PAGE_SIZE;
        }
        
        try {
            StockMovementsRequestDAO movementDAO = new StockMovementsRequestDAO();
            StockMovementDetailDAO detailDAO = new StockMovementDetailDAO();
            
            long startTime = System.currentTimeMillis();
            
            // Get movement basic info
            StockMovementsRequest movement = movementDAO.getMovementById(dbName, movementID);
            if (movement == null) {
                request.getSession().setAttribute("errorMessage", "Không tìm thấy hoạt động với ID: " + movementID);
                response.sendRedirect("so-track-movements");
                return;
            }
            
            // Get movement details with filters and pagination
            List<StockMovementDetail> movementDetails = detailDAO.getMovementDetailsWithFilters(
                dbName, movementID, productFilter, status, currentPage, itemsPerPage
            );
            
            // CẬP NHẬT: Tính toán lại scanned count dựa trên serial numbers thực tế
            for (StockMovementDetail detail : movementDetails) {
                // Load serials
                List<ProductDetailSerialNumber> serials = detailDAO.getSerialsByDetail(dbName, detail.getDetailID());
                detail.setSerials(serials);
                
                // Cập nhật scanned count dựa trên actual serials found
                detail.setScanned(serials != null ? serials.size() : 0);
                
                // Debug log
                System.out.println("DetailID " + detail.getDetailID() + 
                                  ": Quantity=" + detail.getQuantity() + 
                                  ", Scanned=" + detail.getScanned() + 
                                  ", Serials=" + (serials != null ? serials.size() : 0));
            }
            
            // Get total count for pagination
            int totalItems = detailDAO.getMovementDetailsCount(dbName, movementID, productFilter, status);
            
            // Calculate pagination info
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / itemsPerPage) : 1;
            
            // Validate current page
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                StringBuilder redirectUrl = new StringBuilder("so-detail-tracking?id=" + movementID + "&page=" + currentPage);
                if (productFilter != null && !productFilter.isEmpty()) {
                    redirectUrl.append("&productFilter=").append(productFilter);
                }
                if (status != null && !status.isEmpty()) {
                    redirectUrl.append("&status=").append(status);
                }
                redirectUrl.append("&itemsPerPage=").append(itemsPerPage);
                response.sendRedirect(redirectUrl.toString());
                return;
            }
            
            // Calculate display info
            int startItem = totalItems > 0 ? ((currentPage - 1) * itemsPerPage) + 1 : 0;
            int endItem = Math.min(currentPage * itemsPerPage, totalItems);
            
            // Get product list for filter dropdown
            List<String> productList = detailDAO.getProductListByMovement(dbName, movementID);
            
            long executionTime = System.currentTimeMillis() - startTime;
            
            // Set attributes for JSP
            request.setAttribute("movement", movement);
            request.setAttribute("movementID", movementID);
            request.setAttribute("movementType", movement.getMovementType());
            request.setAttribute("movementDetails", movementDetails);
            request.setAttribute("productList", productList);
            
            // Filter parameters
            request.setAttribute("productFilter", productFilter);
            request.setAttribute("status", status);
            
            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            
            // Enhanced debug info
            System.out.println("=== SO Detail Tracking - Serial Count Fixed ===");
            System.out.println("Movement ID: " + movementID + " (" + movement.getMovementType() + ")");
            System.out.println("Movement Status: " + movement.getResponseStatus());
            System.out.println("Page: " + currentPage + "/" + totalPages + ", Items per page: " + itemsPerPage);
            System.out.println("Total items: " + totalItems + ", Showing: " + movementDetails.size());
            System.out.println("Filters - Product: '" + productFilter + "', Status: '" + status + "'");
            
            // Serial tracking debug với thông tin chi tiết
            System.out.println("🔍 SERIAL TRACKING SUMMARY:");
            for (StockMovementDetail detail : movementDetails) {
                System.out.println("  - Product: " + detail.getProductName() + 
                                 ", DetailID: " + detail.getDetailID() + 
                                 ", Required: " + detail.getQuantity() + 
                                 ", Scanned: " + detail.getScanned() + 
                                 ", Status: " + (detail.getScanned() >= detail.getQuantity() ? "COMPLETED" : "PENDING"));
            }
            
            System.out.println("Execution time: " + executionTime + "ms");
            
            // Forward to JSP
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-detail-tracking.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in SODetailTrackingController: " + e.getMessage());
            e.printStackTrace();
            
            String errorMsg = "Có lỗi xảy ra khi tải chi tiết hoạt động";
            if (e.getMessage() != null) {
                errorMsg += ": " + e.getMessage();
            }
            
            request.getSession().setAttribute("errorMessage", errorMsg);
            response.sendRedirect("so-track-movements");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Shop Owner Detail Tracking Controller - Fixed for Serial Tracking and Scanned Count";
    }
}
