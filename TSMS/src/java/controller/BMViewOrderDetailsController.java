package controller;

import dao.StockMovementDetailDAO;
import dao.StockMovementsRequestDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.StockMovementDetail;
import model.StockMovementsRequest;

/**
 * Controller để xem chi tiết đơn hàng cho Branch Manager (chế độ read-only)
 * BM có thể xem:
 * - Tất cả đơn export (bất kể status)
 * - Đơn completed/cancelled (bất kỳ loại nào)
 * @author TRIEU NAM
 */
@WebServlet("/view-order-details")
public class BMViewOrderDetailsController extends HttpServlet {
   
    private static final int PAGE_SIZE = 10;
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        System.out.println("=== DEBUG: BMViewOrderDetailsController.doGet() started ===");
       
        String dbName = (String) request.getSession().getAttribute("dbName");
        Object branchIdObj = request.getSession().getAttribute("branchId");
        Object roleIdObj = request.getSession().getAttribute("roleId");
        String movementIDStr = request.getParameter("id");
       
        System.out.println("DEBUG: dbName=" + dbName);
        System.out.println("DEBUG: branchIdObj=" + branchIdObj);
        System.out.println("DEBUG: roleIdObj=" + roleIdObj);
        System.out.println("DEBUG: movementIDStr=" + movementIDStr);
       
        // Kiểm tra session và quyền truy cập
        if (dbName == null || branchIdObj == null || roleIdObj == null || movementIDStr == null) {
            System.err.println("DEBUG: Session không hợp lệ hoặc thiếu movementID");
            response.sendRedirect("bm-incoming-orders");
            return;
        }
       
        // Kiểm tra quyền Branch Manager (roleId = 1)
        try {
            int roleId = Integer.parseInt(roleIdObj.toString());
            System.out.println("DEBUG: roleId parsed = " + roleId);
            if (roleId != 1) {
                System.err.println("DEBUG: Không có quyền truy cập, roleId = " + roleId);
                request.getSession().setAttribute("errorMessage", "Bạn không có quyền truy cập trang này.");
                response.sendRedirect("login");
                return;
            }
        } catch (NumberFormatException e) {
            System.err.println("DEBUG: Lỗi parse roleId: " + e.getMessage());
            response.sendRedirect("login");
            return;
        }
       
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
       
        // Get filter parameters
        String productFilter = request.getParameter("productFilter");
        String status = request.getParameter("status");
       
        try {
            int movementID = Integer.parseInt(movementIDStr);
            int branchId = Integer.parseInt(branchIdObj.toString());
           
            System.out.println("DEBUG: movementID parsed = " + movementID);
            System.out.println("DEBUG: branchId parsed = " + branchId);
           
            StockMovementDetailDAO detailDAO = new StockMovementDetailDAO();
            StockMovementsRequestDAO requestDAO = new StockMovementsRequestDAO();
           
            System.out.println("DEBUG: DAOs created successfully");
           
            // Lấy thông tin đơn hàng
            StockMovementsRequest orderInfo = requestDAO.getMovementById(dbName, movementID);
           
            System.out.println("DEBUG: orderInfo retrieved = " + (orderInfo != null ? "NOT NULL" : "NULL"));
            if (orderInfo != null) {
                System.out.println("DEBUG: orderInfo.getMovementType() = " + orderInfo.getMovementType());
                System.out.println("DEBUG: orderInfo.getFromBranchID() = " + orderInfo.getFromBranchID());
                System.out.println("DEBUG: orderInfo.getToBranchID() = " + orderInfo.getToBranchID());
                System.out.println("DEBUG: orderInfo.getFromWarehouseID() = " + orderInfo.getFromWarehouseID());
                System.out.println("DEBUG: orderInfo.getToWarehouseID() = " + orderInfo.getToWarehouseID());
                System.out.println("DEBUG: orderInfo.getResponseStatus() = " + orderInfo.getResponseStatus());
            }
           
            if (orderInfo == null) {
                System.err.println("DEBUG: orderInfo is NULL - redirecting to bm-incoming-orders");
                request.getSession().setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
                response.sendRedirect("bm-incoming-orders");
                return;
            }
           
            // *** KIỂM TRA QUYỀN TRUY CẬP ***
            String responseStatus = orderInfo.getResponseStatus();
            String movementType = orderInfo.getMovementType();
            boolean canView = false;
            String accessReason = "";

            // 1. Tất cả đơn export (bất kể status) - chỉ cần có FromBranchID và ToWarehouseID
            if ("export".equals(movementType) && 
                orderInfo.getFromBranchID() != null && 
                orderInfo.getToWarehouseID() != null) {
                canView = true;
                accessReason = "Export order with FromBranchID and ToWarehouseID";
            }
            // 2. Đơn completed/cancelled (bất kỳ loại nào)
            else if ("completed".equals(responseStatus) || "cancelled".equals(responseStatus)) {
                canView = true;
                accessReason = "Order is " + responseStatus;
            }

            if (!canView) {
                String errorMsg = "";
                if ("export".equals(movementType)) {
                    errorMsg = "Đơn export này chưa đủ điều kiện để xem (cần có FromBranchID và ToWarehouseID).";
                } else {
                    errorMsg = "Chỉ có thể xem chi tiết đơn xuất (export) hoặc đơn hàng đã hoàn thành/đã hủy.";
                }
                
                System.err.println("DEBUG: Access denied - MovementType: " + movementType + 
                                 ", Status: " + responseStatus + 
                                 ", FromBranchID: " + orderInfo.getFromBranchID() +
                                 ", ToWarehouseID: " + orderInfo.getToWarehouseID());
                request.getSession().setAttribute("errorMessage", errorMsg);
                response.sendRedirect("bm-incoming-orders");
                return;
            }

            System.out.println("DEBUG: Access granted (" + accessReason + "), proceeding to load details...");
           
            // Debug serial data trước khi load
            System.out.println("DEBUG: Debugging serial data for order...");
            detailDAO.debugSerialDataForView(dbName, movementID);
           
            // Lấy chi tiết sản phẩm với pagination và filter
            List<StockMovementDetail> orderDetails = detailDAO.getnewMovementDetailsWithFilters(
                dbName, movementID, productFilter, status, currentPage, PAGE_SIZE
            );
           
            System.out.println("DEBUG: orderDetails loaded, count = " + (orderDetails != null ? orderDetails.size() : "NULL"));
           
            // Update scanned count cho từng detail với method mới
            if (orderDetails != null) {
                for (StockMovementDetail detail : orderDetails) {
                    if (detail.getSerials() == null) {
                        // SỬ DỤNG METHOD MỚI cho view orders
                        detail.setSerials(detailDAO.getSerialsByDetailForView(dbName, detail.getDetailID()));
                    }
                    detail.setScanned(detail.getSerials() != null ? detail.getSerials().size() : 0);
                    
                    // Debug log cho từng detail
                    System.out.println("DEBUG: Detail " + detail.getDetailID() + 
                                     " (" + detail.getProductName() + "): " + 
                                     detail.getScanned() + " serials found");
                }
            }
           
            // Get total count for pagination
            int totalItems = detailDAO.getMovementDetailsCount(dbName, movementID, productFilter, status);
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / PAGE_SIZE) : 1;
           
            // Calculate display info
            int startItem = totalItems > 0 ? ((currentPage - 1) * PAGE_SIZE) + 1 : 0;
            int endItem = Math.min(currentPage * PAGE_SIZE, totalItems);
           
            // Get product list for filter
            List<String> productList = detailDAO.getProductListByMovement(dbName, movementID);
           
            // Set attributes để hiển thị
            request.setAttribute("orderInfo", orderInfo);
            request.setAttribute("orderDetails", orderDetails);
            request.setAttribute("movementID", movementID);
            request.setAttribute("movementType", orderInfo.getMovementType());
            request.setAttribute("productList", productList);
           
            // Filter parameters
            request.setAttribute("productFilter", productFilter);
            request.setAttribute("status", status);
           
            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("itemsPerPage", PAGE_SIZE);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);
           
            // Set additional info for JSP
            request.setAttribute("responseStatus", responseStatus);
            request.setAttribute("accessReason", accessReason);
            
            // Xác định read-only mode: export đang pending/processing có thể edit, còn lại read-only
            boolean isReadOnly = !("export".equals(movementType) && 
                                  ("pending".equals(responseStatus) || "processing".equals(responseStatus)));
            request.setAttribute("isReadOnly", isReadOnly);
           
            System.out.println("DEBUG: All attributes set, isReadOnly=" + isReadOnly + ", forwarding to JSP...");
           
            // Forward đến JSP
            request.getRequestDispatcher("/WEB-INF/jsp/manager/bm-view-order-details.jsp").forward(request, response);
           
        } catch (NumberFormatException e) {
            System.err.println("Lỗi format movementID: " + e.getMessage());
            request.getSession().setAttribute("errorMessage", "ID đơn hàng không hợp lệ.");
            response.sendRedirect("bm-incoming-orders");
        } catch (Exception e) {
            System.err.println("Lỗi không xác định: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("bm-incoming-orders");
        }
    }
   
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
   
    @Override
    public String getServletInfo() {
        return "Controller xem chi tiết đơn hàng cho Branch Manager";
    }
}
