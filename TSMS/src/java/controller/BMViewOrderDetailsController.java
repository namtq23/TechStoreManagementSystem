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
           
            // Kiểm tra đơn hàng có phải dành cho chi nhánh này không
            boolean isBranchOrder = false;
            String movementType = orderInfo.getMovementType();
           
            if ("import".equals(movementType)) {
                // Đơn nhập: kiểm tra ToBranchID
                if (orderInfo.getToBranchID() != null && orderInfo.getToBranchID().equals(branchId)) {
                    isBranchOrder = true;
                }
            } else if ("export".equals(movementType)) {
                // Đơn xuất: kiểm tra FromBranchID  
                if (orderInfo.getFromBranchID() != null && orderInfo.getFromBranchID().equals(branchId)) {
                    isBranchOrder = true;
                }
            }
           
            System.out.println("DEBUG: Movement type = " + movementType + ", isBranchOrder = " + isBranchOrder);
           
            if (!isBranchOrder) {
                System.err.println("DEBUG: Branch check failed for movement type: " + movementType);
                System.err.println("DEBUG: Expected branchId: " + branchId);
                System.err.println("DEBUG: FromBranchID: " + orderInfo.getFromBranchID() + ", ToBranchID: " + orderInfo.getToBranchID());
                request.getSession().setAttribute("errorMessage", "Đơn hàng không thuộc chi nhánh của bạn.");
                response.sendRedirect("bm-incoming-orders");
                return;
            }
           
            System.out.println("DEBUG: Branch check passed, loading product details...");
           
            // Lấy chi tiết sản phẩm với pagination và filter
            List<StockMovementDetail> orderDetails = detailDAO.getMovementDetailsWithFilters(
                dbName, movementID, productFilter, status, currentPage, PAGE_SIZE
            );
           
            System.out.println("DEBUG: orderDetails loaded, count = " + (orderDetails != null ? orderDetails.size() : "NULL"));
           
            // Update scanned count cho từng detail
            for (StockMovementDetail detail : orderDetails) {
                if (detail.getSerials() == null) {
                    detail.setSerials(detailDAO.getSerialsByDetail(dbName, detail.getDetailID()));
                }
                detail.setScanned(detail.getSerials() != null ? detail.getSerials().size() : 0);
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
        // Chuyển hướng POST requests về GET
        doGet(request, response);
    }
   
    @Override
    public String getServletInfo() {
        return "Controller xem chi tiết đơn hàng cho Branch Manager";
    }
}




