package controller;

import dao.StockMovementsRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.StockMovementsRequest;

/**
 * Warehouse Export Controller with filter and pagination
 */
@WebServlet(name="WHExport", urlPatterns={"/wh-export"})
public class WHExport extends HttpServlet {
    
    private static final int PAGE_SIZE = 10;
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        String warehouseId = (String) request.getSession().getAttribute("warehouseId");
        
        if (dbName == null || warehouseId == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Get filter parameters
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String branchId = request.getParameter("branchId");
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
        String itemsPerPageParam = request.getParameter("recordsPerPage");
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
            StockMovementsRequestDAO reqDAO = new StockMovementsRequestDAO();
            
            // Get filtered and paginated data
            List<StockMovementsRequest> exportRequests = reqDAO.getExportRequestsWithFilter(
                dbName, warehouseId, fromDate, toDate, branchId, status, currentPage, itemsPerPage
            );
            
            // Get total count for pagination
            int totalItems = reqDAO.getExportRequestsCount(
                dbName, warehouseId, fromDate, toDate, branchId, status
            );
            
            // Calculate pagination info
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / itemsPerPage) : 1;
            
            // Validate current page
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                StringBuilder redirectUrl = new StringBuilder("wh-export?page=" + currentPage);
                if (fromDate != null && !fromDate.isEmpty()) {
                    redirectUrl.append("&fromDate=").append(fromDate);
                }
                if (toDate != null && !toDate.isEmpty()) {
                    redirectUrl.append("&toDate=").append(toDate);
                }
                if (branchId != null && !branchId.isEmpty()) {
                    redirectUrl.append("&branchId=").append(branchId);
                }
                if (status != null && !status.isEmpty()) {
                    redirectUrl.append("&status=").append(status);
                }
                redirectUrl.append("&recordsPerPage=").append(itemsPerPage);
                response.sendRedirect(redirectUrl.toString());
                return;
            }
            
            // Calculate display info
            int startItem = totalItems > 0 ? ((currentPage - 1) * itemsPerPage) + 1 : 0;
            int endItem = Math.min(currentPage * itemsPerPage, totalItems);
            
            // Set attributes
            request.setAttribute("exportRequests", exportRequests);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("branchId", branchId);
            request.setAttribute("status", status);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            
            // Debug log
            System.out.println("WH Export - Warehouse: " + warehouseId + 
                             ", Page: " + currentPage + "/" + totalPages + 
                             ", Items: " + exportRequests.size() + "/" + totalItems);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách đơn xuất hàng: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/export.jsp").forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Warehouse Export Controller with Filter and Pagination";
    }
}
