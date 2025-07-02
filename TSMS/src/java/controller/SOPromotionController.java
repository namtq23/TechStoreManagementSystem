package controller;

import dao.PromotionDAO;
import model.PromotionDTO;
import com.google.gson.Gson;
import dao.BranchDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import model.PromotionSearchCriteria;

@WebServlet(name = "SOPromotionController", urlPatterns = {"/so-promotions", "/api/promotions"})
public class SOPromotionController extends HttpServlet {

    private PromotionDAO promotionDAO = new PromotionDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

        try {
            // Lấy thông tin từ session
            HttpSession session = request.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            // Kiểm tra session đầy đủ
            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                response.sendRedirect("login");
                return;
            }
            
            //Check active status
            if ((Integer) session.getAttribute("isActive") == 0) {
                response.sendRedirect(request.getContextPath() + "/subscription?status=expired");
                return;
            }

            // Parse thông tin session
            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            Integer branchId = branchIdObj != null ? Integer.parseInt(branchIdObj.toString()) : null;

            String requestURI = request.getRequestURI();
            // Phân biệt API endpoint và JSP page
            if (requestURI.contains("api/promotions")) {
                handleApiRequest(request, response, dbName, branchId);
            } else {
                handlePageRequest(request, response, dbName, branchId);
            }

            String success = (String) session.getAttribute("success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }

            String error = (String) session.getAttribute("error");
            if (error != null) {
                request.setAttribute("error", error);
                session.removeAttribute("error");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("login");
        } catch (SQLException ex) {
            Logger.getLogger(SOPromotionController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + ex.getMessage());
        }
    }

    private void handleApiRequest(HttpServletRequest request, HttpServletResponse response,
              String dbName, Integer branchId) throws IOException, SQLException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            List<PromotionDTO> promotions = promotionDAO.getAllPromotions(dbName);

            // Tạo response JSON với thống kê
            PromotionResponse promotionResponse = new PromotionResponse();
            promotionResponse.setSuccess(true);
            promotionResponse.setData(promotions);
            promotionResponse.setTotal(promotions.size());
            promotionResponse.setActive((int) promotions.stream().filter(p -> p.isActive()).count());
            promotionResponse.setScheduled((int) promotions.stream().filter(p -> p.isScheduled()).count());
            promotionResponse.setExpired((int) promotions.stream().filter(p -> p.isExpired()).count());

            String jsonResponse = gson.toJson(promotionResponse);
            out.print(jsonResponse);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            ErrorResponse errorResponse = new ErrorResponse(false, "Lỗi khi tải dữ liệu: " + e.getMessage());
            out.print(gson.toJson(errorResponse));
        }
    }

    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response,
              String dbName, Integer branchId) throws ServletException, IOException, SQLException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("view".equals(action)) {
            String promotionIdStr = request.getParameter("promotionId");
            if (promotionIdStr != null && !promotionIdStr.trim().isEmpty()) {
                try {
                    int promotionId = Integer.parseInt(promotionIdStr);
                    PromotionDTO promotion = promotionDAO.getPromotionById(dbName, promotionId);
                    if (promotion != null) {
                        request.setAttribute("action", "update");
                        request.setAttribute("promotion", promotion);
                        // Định dạng ngày cho input date
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        promotion.setStartDateFormatted(sdf.format(promotion.getStartDate()));
                        promotion.setEndDateFormatted(sdf.format(promotion.getEndDate()));
                        // Lấy tất cả chi nhánh và sản phẩm
                        request.setAttribute("branches", BranchDAO.getBranchList(dbName));
                        request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName)); // Lấy tất cả sản phẩm
                        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("error", "Không tìm thấy khuyến mãi!");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
                }
            }
        } else if ("create".equals(action)) {
            // Lấy tất cả chi nhánh và sản phẩm cho form tạo mới
            request.setAttribute("branches", BranchDAO.getBranchList(dbName));
            request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName)); // Lấy tất cả sản phẩm
            request.setAttribute("action", "create");
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
            return;
        }
        List<PromotionDTO> promotions = promotionDAO.getAllPromotions(dbName);

        // Đọc search parameters từ request
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String discount = request.getParameter("discount");
        String categoryIdStr = request.getParameter("categoryId");
        String pageStr = request.getParameter("page");

        //  Tạo search criteria object
        PromotionSearchCriteria criteria = new PromotionSearchCriteria();
        criteria.setSearchTerm(search);
        criteria.setStatusFilter(status);
        criteria.setDiscountFilter(discount);

        // Parse page number
        int currentPage = 1;
        if (pageStr != null && !pageStr.trim().isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageStr);

                if (currentPage < 1) {
                    currentPage = 1;
                }
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        criteria.setPage(currentPage);
        criteria.setPageSize(10); // 10 items per page

        // Parse category ID
        Integer categoryId = null;
        if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdStr);
            } catch (NumberFormatException e) {
                // Ignore invalid category ID
            }
        }
        //Gọi DAO với search criteria
        int totalPromotions;

        promotions = promotionDAO.searchPromotions(dbName, criteria, categoryId);
        totalPromotions = promotionDAO.countPromotions(dbName, criteria, categoryId);

        // Tính toán thống kê
        int activePromotions = (int) promotions.stream().filter(p -> p.isActive()).count();
        int scheduledPromotions = (int) promotions.stream().filter(p -> p.isScheduled()).count();
        int expiredPromotions = (int) promotions.stream().filter(p -> p.isExpired()).count();

        // Tính toán pagination
        int totalPages = (int) Math.ceil((double) totalPromotions / criteria.getPageSize());
        int startPromotion = (currentPage - 1) * criteria.getPageSize() + 1;
        int endPromotion = Math.min(currentPage * criteria.getPageSize(), totalPromotions);

        // Set attributes cho JSP
        request.setAttribute("promotions", promotions);
        request.setAttribute("totalPromotions", totalPromotions);
        request.setAttribute("activePromotions", activePromotions);
        request.setAttribute("scheduledPromotions", scheduledPromotions);
        request.setAttribute("expiredPromotions", expiredPromotions);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("startPromotion", startPromotion);
        request.setAttribute("endPromotion", endPromotion);
        request.setAttribute("dbName", dbName);
        request.setAttribute("branchId", branchId);

        // Preserve search parameters
        request.setAttribute("searchTerm", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("selectedDiscount", discount);
        request.setAttribute("selectedCategoryId", categoryId);

        // Forward đến JSP
        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-promotions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

        try {
            // Lấy thông tin từ session
            HttpSession session = request.getSession(true);
            Object dbNameObj = session.getAttribute("dbName");

            if (dbNameObj == null) {
                response.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            String action = request.getParameter("action");

            switch (action != null ? action : "") {
                case "create":
                    handleCreatePromotion(request, response, dbName);
                    break;
                case "update":
                    handleUpdatePromotion(request, response, dbName);
                    break;
                case "delete":
                    handleDeletePromotion(request, response, dbName);
                    break;
                case "deleteSelected":
                    handleDeleteSelectedPromotions(request, response, dbName);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hành động không hợp lệ");
            }

        } catch (SQLException ex) {
            Logger.getLogger(SOPromotionController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + ex.getMessage());
        }
    }

    private void handleCreatePromotion(HttpServletRequest request, HttpServletResponse response, String dbName)
              throws SQLException, ServletException, IOException {

        // Lấy dữ liệu từ form
        String promoName = request.getParameter("promoName");
        String discountPercentStr = request.getParameter("discountPercent");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String[] branchIds = request.getParameterValues("branchIds"); // Lấy mảng branchIds
        String[] productDetailIds = request.getParameterValues("productDetailIds"); // Lấy mảng productDetailIds

        // Validate dữ liệu
        if (promoName == null || promoName.trim().isEmpty()
                  || discountPercentStr == null || discountPercentStr.trim().isEmpty()
                  || startDateStr == null || startDateStr.trim().isEmpty()
                  || endDateStr == null || endDateStr.trim().isEmpty()
                  || branchIds == null || branchIds.length == 0
                  || productDetailIds == null || productDetailIds.length == 0) {

            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.setAttribute("branches", BranchDAO.getBranchList(dbName)); // Sử dụng BranchDAO
            request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
            return;
        }

        try {
            // Parse dữ liệu
            double discountPercent = Double.parseDouble(discountPercentStr);
            java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
            java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);

            // Validate business logic
            if (discountPercent < 0 || discountPercent > 100) {
                request.setAttribute("error", "Tỷ lệ giảm giá phải từ 0 đến 100%!");
                request.setAttribute("branches", BranchDAO.getBranchList(dbName));
                request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
                request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
                return;
            }

            if (startDate.after(endDate)) {
                request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
                request.setAttribute("branches", BranchDAO.getBranchList(dbName));
                request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
                request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
                return;
            }

            // Tạo PromotionDTO object
            PromotionDTO promotion = new PromotionDTO();
            promotion.setPromoName(promoName);
            promotion.setDiscountPercent(discountPercent);
            promotion.setStartDate(startDate);
            promotion.setEndDate(endDate);

            // Lưu vào database
            boolean success = promotionDAO.createPromotion(dbName, promotion, branchIds, productDetailIds);

            if (success) {
                response.sendRedirect("so-promotions?success=" + URLEncoder.encode("Tạo khuyến mãi thành công!", "UTF-8"));
            } else {
                request.setAttribute("error", "Không thể tạo khuyến mãi!");
                request.setAttribute("branches", BranchDAO.getBranchList(dbName));
                request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
                request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            request.setAttribute("branches", BranchDAO.getBranchList(dbName));
            request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng ngày không hợp lệ!");
            request.setAttribute("branches", BranchDAO.getBranchList(dbName));
            request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
        }
    }

    private void handleUpdatePromotion(HttpServletRequest request, HttpServletResponse response, String dbName)
              throws SQLException, ServletException, IOException {

        String promotionIdStr = request.getParameter("promotionId");

        if (promotionIdStr == null || promotionIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
            handlePageRequest(request, response, dbName, null);
            return;
        }

        try {
            int promotionId = Integer.parseInt(promotionIdStr);

            // Lấy thông tin promotion hiện tại
            PromotionDTO existingPromotion = promotionDAO.getPromotionById(dbName, promotionId);
            if (existingPromotion == null) {
                request.setAttribute("error", "Không tìm thấy khuyến mãi!");
                handlePageRequest(request, response, dbName, null);
                return;
            }

            // Lấy dữ liệu từ form
            String promoName = request.getParameter("promoName");
            String discountPercentStr = request.getParameter("discountPercent");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String[] branchIds = request.getParameterValues("branchIds"); // Lấy mảng branchIds
            String[] productDetailIds = request.getParameterValues("productDetailIds"); // Lấy mảng productDetailIds

            // Validate dữ liệu
            if (promoName == null || promoName.trim().isEmpty()
                      || discountPercentStr == null || discountPercentStr.trim().isEmpty()
                      || startDateStr == null || startDateStr.trim().isEmpty()
                      || endDateStr == null || endDateStr.trim().isEmpty()
                      || branchIds == null || branchIds.length == 0
                      || productDetailIds == null || productDetailIds.length == 0) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
                request.setAttribute("promotion", existingPromotion);
                request.setAttribute("branches", BranchDAO.getBranchList(dbName)); // Sử dụng BranchDAO
                request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
                request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
                return;
            }

            // Cập nhật thông tin
            if (promoName != null && !promoName.trim().isEmpty()) {
                existingPromotion.setPromoName(promoName);
            }

            if (discountPercentStr != null && !discountPercentStr.trim().isEmpty()) {
                double discountPercent = Double.parseDouble(discountPercentStr);
                if (discountPercent >= 0 && discountPercent <= 100) {
                    existingPromotion.setDiscountPercent(discountPercent);
                } else {
                    request.setAttribute("error", "Tỷ lệ giảm giá phải từ 0 đến 100%!");
                    request.setAttribute("promotion", existingPromotion);
                    request.setAttribute("branches", BranchDAO.getBranchList(dbName));
                    request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
                    request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
                    return;
                }
            }

            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
                existingPromotion.setStartDate(startDate);
            }

            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
                if (existingPromotion.getStartDate().after(endDate)) {
                    request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
                    request.setAttribute("promotion", existingPromotion);
                    request.setAttribute("branches", BranchDAO.getBranchList(dbName));
                    request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
                    request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
                    return;
                }
                existingPromotion.setEndDate(endDate);
            }

            // Lưu cập nhật
            boolean success = promotionDAO.updatePromotion(dbName, existingPromotion, branchIds, productDetailIds);

            if (success) {
                response.sendRedirect("so-promotions?success=" + URLEncoder.encode("Cập nhật khuyến mãi thành công!", "UTF-8"));
            } else {
                request.setAttribute("error", "Không thể cập nhật khuyến mãi!");
                request.setAttribute("promotion", existingPromotion);
                request.setAttribute("branches", BranchDAO.getBranchList(dbName));
                request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
                request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            request.setAttribute("promotion", promotionDAO.getPromotionById(dbName, Integer.parseInt(promotionIdStr)));
            request.setAttribute("branches", BranchDAO.getBranchList(dbName));
            request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng ngày không hợp lệ!");
            request.setAttribute("promotion", promotionDAO.getPromotionById(dbName, Integer.parseInt(promotionIdStr)));
            request.setAttribute("branches", BranchDAO.getBranchList(dbName));
            request.setAttribute("productDetails", promotionDAO.getAllProductDetails(dbName));
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/modal.jsp").forward(request, response);
        }
    }

    private void handleDeletePromotion(HttpServletRequest request, HttpServletResponse response, String dbName)
              throws SQLException, ServletException, IOException {

        String promotionIdStr = request.getParameter("promotionId");
        HttpSession session = request.getSession();

        if (promotionIdStr == null || promotionIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
            response.sendRedirect("so-promotions");
            return;
        }

        try {
            int promotionId = Integer.parseInt(promotionIdStr);

            // Xóa khuyến mãi
            boolean success = promotionDAO.deletePromotion(dbName, promotionId);

            if (success) {
                session.setAttribute("success", "Xóa khuyến mãi thành công!");
            } else {
                session.setAttribute("error", "Không thể xóa khuyến mãi!");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
        }

        response.sendRedirect("so-promotions");
    }

    private void handleDeleteSelectedPromotions(HttpServletRequest request, HttpServletResponse response, String dbName)
              throws SQLException, ServletException, IOException {
        HttpSession session = request.getSession();

        String[] promotionIds = request.getParameterValues("promotionIds");
        if (promotionIds == null || promotionIds.length == 0) {
            session.setAttribute("error", "Không có khuyến mãi nào được chọn!");
            response.sendRedirect("so-promotions");
            return;
        }

        List<Integer> ids;
        try {
            ids = Arrays.stream(promotionIds).map(Integer::parseInt).collect(Collectors.toList());
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
            response.sendRedirect("so-promotions");
            return;
        }

        boolean success = promotionDAO.deleteSelectedPromotions(dbName, ids);
        if (success) {
            session.setAttribute("success", "Xóa khuyến mãi thành công!");
        } else {
            session.setAttribute("error", "Không thể xóa khuyến mãi!");
        }
        response.sendRedirect("so-promotions");
    }
// Dynamic page size calculation based on total records

    private int calculateDynamicPageSize(int totalRecords) {
        if (totalRecords <= 10) {
            return totalRecords; // Hiển thị tất cả trên 1 trang
        } else if (totalRecords <= 50) {
            return 5; // 5 records per page
        } else if (totalRecords <= 100) {
            return 10; // 10 records per page
        } else if (totalRecords <= 500) {
            return 20; // 20 records per page
        } else {
            return 50; // 50 records per page for large datasets
        }
    }

// Dynamic pagination info calculation
    private PaginationInfo calculateDynamicPagination(int totalRecords, int currentPage) {
        int dynamicPageSize = calculateDynamicPageSize(totalRecords);
        int totalPages = (int) Math.ceil((double) totalRecords / dynamicPageSize);

        // Ensure current page is valid
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        if (currentPage < 1) {
            currentPage = 1;
        }

        int startRecord = (currentPage - 1) * dynamicPageSize + 1;
        int endRecord = Math.min(currentPage * dynamicPageSize, totalRecords);

        return new PaginationInfo(dynamicPageSize, totalPages, currentPage, startRecord, endRecord);
    }

// Helper class for pagination info
    public static class PaginationInfo {

        private int pageSize;
        private int totalPages;
        private int currentPage;
        private int startRecord;
        private int endRecord;

        public PaginationInfo(int pageSize, int totalPages, int currentPage, int startRecord, int endRecord) {
            this.pageSize = pageSize;
            this.totalPages = totalPages;
            this.currentPage = currentPage;
            this.startRecord = startRecord;
            this.endRecord = endRecord;
        }

        // Getters
        public int getPageSize() {
            return pageSize;
        }

        public int getTotalPages() {
            return totalPages;
        }

        public int getCurrentPage() {
            return currentPage;
        }

        public int getStartRecord() {
            return startRecord;
        }

        public int getEndRecord() {
            return endRecord;
        }
    }

    // Response classes
    public static class PromotionResponse {

        private boolean success;
        private List<PromotionDTO> data;
        private int total;
        private int active;
        private int scheduled;
        private int expired;

        // Getters and setters
        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public List<PromotionDTO> getData() {
            return data;
        }

        public void setData(List<PromotionDTO> data) {
            this.data = data;
        }

        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public int getActive() {
            return active;
        }

        public void setActive(int active) {
            this.active = active;
        }

        public int getScheduled() {
            return scheduled;
        }

        public void setScheduled(int scheduled) {
            this.scheduled = scheduled;
        }

        public int getExpired() {
            return expired;
        }

        public void setExpired(int expired) {
            this.expired = expired;
        }
    }

    public static class ErrorResponse {

        private boolean success;
        private String message;

        public ErrorResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
