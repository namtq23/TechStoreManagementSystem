package controller;

import dao.SerialNumberDAO;
import dao.StockMovementDetailDAO;
import dao.StockMovementsRequestDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ProductDetailSerialNumber;
import model.StockMovementDetail;
import model.StockMovementsRequest;

/**
 * Controller xử lý kiểm tra đơn hàng cho BM (Branch Manager)
 * Tương tự như WHStockSerialCheckController nhưng dành cho chi nhánh
 */
@WebServlet(name = "BMReceiveCheckController", urlPatterns = {"/bm-receive-check"})
public class BMReceiveCheckController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String dbName = (String) request.getSession().getAttribute("dbName");
        Object branchIdObj = request.getSession().getAttribute("branchId");
        Object roleIdObj = request.getSession().getAttribute("roleId");
       
        // Kiểm tra session và quyền truy cập
        if (dbName == null || dbName.isEmpty()) {
            response.sendRedirect("login");
            return;
        }

        // Kiểm tra quyền Branch Manager (roleId = 1)
        if (roleIdObj == null || Integer.parseInt(roleIdObj.toString()) != 1) {
            request.getSession().setAttribute("errorMessage", "Bạn không có quyền truy cập trang này.");
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null && request.getAttribute("id") != null) {
            idParam = request.getAttribute("id").toString();
        }

        if (idParam == null) {
            request.setAttribute("error", "Không tìm thấy mã đơn hàng.");
            response.sendRedirect("bm-incoming-orders");
            return;
        }

        int movementID = Integer.parseInt(idParam);

        // Get filter parameters
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");
        String productFilter = request.getParameter("productFilter");
        String status = request.getParameter("status");

        // Get pagination parameters
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) {
                    currentPage = 1;
                }
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
            StockMovementDetailDAO dao = new StockMovementDetailDAO();
            StockMovementsRequestDAO movementDAO = new StockMovementsRequestDAO();
           
            // Lấy thông tin movement và kiểm tra quyền truy cập
            StockMovementsRequest movement = movementDAO.getMovementById(dbName, movementID);
            if (movement == null) {
                request.setAttribute("error", "Không tìm thấy đơn hàng.");
                response.sendRedirect("bm-incoming-orders");
                return;
            }

            // Kiểm tra đơn hàng có phải dành cho chi nhánh này không
            String branchId = branchIdObj.toString();
            Integer userBranchId = null;
            
            // Parse branchId an toàn
            try {
                userBranchId = Integer.parseInt(branchId);
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMessage", "Lỗi định dạng branch ID.");
                response.sendRedirect("bm-incoming-orders");
                return;
            }
            
            boolean isBranchOrder = false;
            String movementType = movement.getMovementType();
            
            // Debug log
            System.out.println("🔍 DEBUG Movement #" + movementID);
            System.out.println("MovementType: " + movementType);
            System.out.println("FromBranchID: " + movement.getFromBranchID());
            System.out.println("ToBranchID: " + movement.getToBranchID());
            System.out.println("User BranchID: " + userBranchId);
           
            if ("export".equals(movementType)) {
                // Đơn xuất từ warehouse/supplier đến branch
                if (movement.getToBranchID() != null && 
                    movement.getToBranchID().equals(userBranchId)) {
                    isBranchOrder = true;
                    System.out.println("✅ Export order - ToBranchID matches user branch");
                }
            } else if ("import".equals(movementType)) {
                // Đơn nhập từ branch
                if (movement.getFromBranchID() != null && 
                    movement.getFromBranchID().equals(userBranchId)) {
                    isBranchOrder = true;
                    System.out.println("✅ Import order - FromBranchID matches user branch");
                }
            }
           
            if (!isBranchOrder) {
                System.out.println("❌ Order #" + movementID + " không thuộc branch " + userBranchId);
                request.getSession().setAttribute("errorMessage", "Đơn hàng không thuộc chi nhánh của bạn.");
                response.sendRedirect("bm-incoming-orders");
                return;
            }

            // Lấy chi tiết với filter và pagination
            List<StockMovementDetail> details = dao.getMovementDetailsWithFilters(
                    dbName, movementID, productFilter, status, currentPage, itemsPerPage
            );

            // Update scanned count based on actual serial numbers
            for (StockMovementDetail detail : details) {
                List<ProductDetailSerialNumber> serials = dao.getSerialsByDetail(dbName, detail.getDetailID());
                detail.setSerials(serials);
                detail.setScanned(serials != null ? serials.size() : 0);

                System.out.println("✔️ DetailID: " + detail.getDetailID()
                        + ", ProductDetailID: " + detail.getProductDetailID()
                        + ", Scanned: " + detail.getScanned() + "/" + detail.getQuantity());
            }

            // Get total count for pagination
            int totalItems = dao.getMovementDetailsCount(dbName, movementID, productFilter, status);

            // Calculate pagination info
            int totalPages = totalItems > 0 ? (int) Math.ceil((double) totalItems / itemsPerPage) : 1;

            // Validate current page
            if (currentPage > totalPages && totalPages > 0) {
                currentPage = totalPages;
                StringBuilder redirectUrl = new StringBuilder("bm-receive-check?id=" + movementID + "&page=" + currentPage);
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

            // Get product list for filter
            List<String> productList = dao.getProductListByMovement(dbName, movementID);

            // Check if all completed
            boolean allCompleted = true;
            for (StockMovementDetail item : details) {
                if (item.getScanned() < item.getQuantity()) {
                    allCompleted = false;
                    break;
                }
            }

            // Set attributes for JSP
            request.setAttribute("movementID", movementID);
            request.setAttribute("movementDetails", details);
            request.setAttribute("movementType", movementType);
            request.setAttribute("allCompleted", allCompleted);
            request.setAttribute("productList", productList);
            request.setAttribute("orderInfo", movement);

            // Filter parameters
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("productFilter", productFilter);
            request.setAttribute("status", status);

            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalItems", totalItems);
            request.setAttribute("itemsPerPage", itemsPerPage);
            request.setAttribute("startItem", startItem);
            request.setAttribute("endItem", endItem);

            System.out.println("📦 BM kiểm tra đơn #" + movementID
                    + " - Page: " + currentPage + "/" + totalPages
                    + ", Items: " + details.size() + "/" + totalItems);

            request.getRequestDispatcher("/WEB-INF/jsp/manager/bm-receive-check.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("Error in BMReceiveCheckController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            response.sendRedirect("bm-incoming-orders");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect POST requests to GET for this controller
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controller xử lý kiểm tra đơn hàng cho BM";
    }
}
