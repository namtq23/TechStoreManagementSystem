package controller;

import dao.PromotionDAO;
import model.PromotionDTO; 
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SOPromotionController", urlPatterns = {"/so-promotions", "/api/promotions"})
public class SOPromotionController extends HttpServlet {
    
    private PromotionDAO promotionDAO = new PromotionDAO();
    private Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // ✅ Lấy thông tin từ session
            HttpSession session = request.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            // ✅ Kiểm tra session đầy đủ
            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                response.sendRedirect("login");
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
        List<PromotionDTO> promotions = promotionDAO.getAllPromotions(dbName);
        
        // Tính toán thống kê
        int totalPromotions = promotions.size();
        int activePromotions = (int) promotions.stream().filter(p -> p.isActive()).count();
        int scheduledPromotions = (int) promotions.stream().filter(p -> p.isScheduled()).count();
        int expiredPromotions = (int) promotions.stream().filter(p -> p.isExpired()).count();
        
        // Set attributes cho JSP
        request.setAttribute("promotions", promotions);
        request.setAttribute("totalPromotions", totalPromotions);
        request.setAttribute("activePromotions", activePromotions);
        request.setAttribute("scheduledPromotions", scheduledPromotions);
        request.setAttribute("expiredPromotions", expiredPromotions);
        request.setAttribute("dbName", dbName);
        request.setAttribute("branchId", branchId);
        
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
            
            if ("create".equals(action)) {
                handleCreatePromotion(request, response, dbName);
            } else if ("update".equals(action)) {
                handleUpdatePromotion(request, response, dbName);
            } else if ("delete".equals(action)) {
                handleDeletePromotion(request, response, dbName);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
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
        // ❌ Loại bỏ applyToAllBranchesStr vì không có trong database
        
        // Validate dữ liệu
        if (promoName == null || promoName.trim().isEmpty() ||
            discountPercentStr == null || discountPercentStr.trim().isEmpty() ||
            startDateStr == null || startDateStr.trim().isEmpty() ||
            endDateStr == null || endDateStr.trim().isEmpty()) {
            
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            handlePageRequest(request, response, dbName, null);
            return;
        }
        
        try {
            // Parse dữ liệu
            double discountPercent = Double.parseDouble(discountPercentStr);
            java.sql.Date startDate = java.sql.Date.valueOf(startDateStr);
            java.sql.Date endDate = java.sql.Date.valueOf(endDateStr);
            // ❌ Loại bỏ applyToAllBranches
            
            // Validate business logic
            if (discountPercent < 0 || discountPercent > 100) {
                request.setAttribute("error", "Tỷ lệ giảm giá phải từ 0 đến 100%!");
                handlePageRequest(request, response, dbName, null);
                return;
            }
            
            if (startDate.after(endDate)) {
                request.setAttribute("error", "Ngày kết thúc phải sau ngày bắt đầu!");
                handlePageRequest(request, response, dbName, null);
                return;
            }
            
            // Tạo PromotionDTO object
            PromotionDTO promotion = new PromotionDTO();
            promotion.setPromoName(promoName);
            promotion.setDiscountPercent(discountPercent);
            promotion.setStartDate(startDate);
            promotion.setEndDate(endDate);
            // ❌ Loại bỏ setApplyToAllBranches
            
            // Lưu vào database
            boolean success = promotionDAO.createPromotion(dbName, promotion);
            
            if (success) {
                request.setAttribute("success", "Tạo khuyến mãi thành công!");
            } else {
                request.setAttribute("error", "Không thể tạo khuyến mãi!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Định dạng ngày không hợp lệ!");
        }
        
        // Redirect về trang danh sách
        handlePageRequest(request, response, dbName, null);
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
            
            // Cập nhật thông tin
            String promoName = request.getParameter("promoName");
            String discountPercentStr = request.getParameter("discountPercent");
            
            if (promoName != null && !promoName.trim().isEmpty()) {
                existingPromotion.setPromoName(promoName);
            }
            
            if (discountPercentStr != null && !discountPercentStr.trim().isEmpty()) {
                double discountPercent = Double.parseDouble(discountPercentStr);
                if (discountPercent >= 0 && discountPercent <= 100) {
                    existingPromotion.setDiscountPercent(discountPercent);
                }
            }
            
            // Lưu cập nhật
            boolean success = promotionDAO.updatePromotion(dbName, existingPromotion);
            
            if (success) {
                request.setAttribute("success", "Cập nhật khuyến mãi thành công!");
            } else {
                request.setAttribute("error", "Không thể cập nhật khuyến mãi!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
        }
        
        handlePageRequest(request, response, dbName, null);
    }
    
    private void handleDeletePromotion(HttpServletRequest request, HttpServletResponse response, String dbName) 
            throws SQLException, ServletException, IOException {
        
        String promotionIdStr = request.getParameter("promotionId");
        
        if (promotionIdStr == null || promotionIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
            handlePageRequest(request, response, dbName, null);
            return;
        }
        
        try {
            int promotionId = Integer.parseInt(promotionIdStr);
            
            // Xóa khuyến mãi
            boolean success = promotionDAO.deletePromotion(dbName, promotionId);
            
            if (success) {
                request.setAttribute("success", "Xóa khuyến mãi thành công!");
            } else {
                request.setAttribute("error", "Không thể xóa khuyến mãi!");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
        }
        
        handlePageRequest(request, response, dbName, null);
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
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public List<PromotionDTO> getData() { return data; }
        public void setData(List<PromotionDTO> data) { this.data = data; }
        
        public int getTotal() { return total; }
        public void setTotal(int total) { this.total = total; }
        
        public int getActive() { return active; }
        public void setActive(int active) { this.active = active; }
        
        public int getScheduled() { return scheduled; }
        public void setScheduled(int scheduled) { this.scheduled = scheduled; }
        
        public int getExpired() { return expired; }
        public void setExpired(int expired) { this.expired = expired; }
    }
    
    public static class ErrorResponse {
        private boolean success;
        private String message;
        
        public ErrorResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }
}
