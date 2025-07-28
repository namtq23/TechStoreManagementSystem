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
 * Controller để hiển thị danh sách đơn hàng đang vận chuyển đến chi nhánh
 * Với filter và pagination
 */
@WebServlet("/bm-incoming-orders")
public class BMIncomingOrdersController extends HttpServlet {
    
    private static final int PAGE_SIZE = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String dbName = (String) request.getSession().getAttribute("dbName");
        Object branchIdObj = request.getSession().getAttribute("branchId");
        
        // Kiểm tra session
        if (dbName == null || branchIdObj == null) {
            System.err.println("Session không hợp lệ - dbName: " + dbName + ", branchId: " + branchIdObj);
            response.sendRedirect("login");
            return;
        }
        
        // Xử lý branchId
        Integer branchId = null;
        try {
            if (branchIdObj instanceof String) {
                String branchIdStr = (String) branchIdObj;
                if (branchIdStr.trim().isEmpty()) {
                    throw new IllegalArgumentException("branchId không được rỗng");
                }
                branchId = Integer.parseInt(branchIdStr.trim());
            } else if (branchIdObj instanceof Integer) {
                branchId = (Integer) branchIdObj;
            } else {
                throw new IllegalArgumentException("branchId phải là String hoặc Integer");
            }
            
            if (branchId <= 0) {
                throw new IllegalArgumentException("branchId phải là số dương");
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Lỗi format branchId: " + branchIdObj + " - " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID chi nhánh không đúng định dạng");
            response.sendRedirect("login");
            return;
        } catch (IllegalArgumentException e) {
            System.err.println("Lỗi branchId: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID chi nhánh không hợp lệ");
            response.sendRedirect("login");
            return;
        }
        
        // Lấy filter parameters
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
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
            StockMovementsRequestDAO dao = new StockMovementsRequestDAO();
            
            // Get filtered and paginated data
            List<StockMovementsRequest> exportRequests = dao.getExportRequestsByToBranchWithFilter(
                dbName, branchId.toString(), fromDate, toDate, status, currentPage, itemsPerPage
            );
            
            // Get total count for pagination
            int totalItems = dao.getExportRequestsByToBranchCount(
                dbName, branchId.toString(), fromDate, toDate, status
            );
            
            // Calculate pagination info
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / itemsPerPage) : 1;
            
            // Validate current page
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                StringBuilder redirectUrl = new StringBuilder("bm-incoming-orders?page=" + currentPage);
                if (fromDate != null && !fromDate.isEmpty()) {
                    redirectUrl.append("&fromDate=").append(fromDate);
                }
                if (toDate != null && !toDate.isEmpty()) {
                    redirectUrl.append("&toDate=").append(toDate);
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
            
            // Set attributes
            request.setAttribute("exportRequests", exportRequests);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("status", status);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
            
            // Debug log
            System.out.println("BM Incoming Orders - Branch: " + branchId + 
                             ", Page: " + currentPage + "/" + totalPages + 
                             ", Items: " + exportRequests.size() + "/" + totalItems);
            
            request.getRequestDispatcher("/WEB-INF/jsp/manager/bm-track-orders.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách đơn hàng cho chi nhánh " + branchId + ": " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách đơn hàng");
            response.sendRedirect("bm-overview");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Controller hiển thị danh sách đơn hàng với filter và pagination";
    }
}
