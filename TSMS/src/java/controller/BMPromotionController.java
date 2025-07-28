package controller;

import dao.PromotionDAO;
import dao.BranchDAO;
import model.PromotionDTO;
import model.PromotionSearchCriteria;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Branch;
import java.util.ArrayList;
import model.ProductDetails;

@WebServlet(name = "BMPromotionController", urlPatterns = {"/bm-promotions"})
public class BMPromotionController extends HttpServlet {

    private PromotionDAO promotionDAO = new PromotionDAO();

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
            if (userIdObj == null || roleIdObj == null || dbNameObj == null || branchIdObj == null) {
                response.sendRedirect("login");
                return;
            }

            // Parse thông tin session
            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            // Kiểm tra quyền Branch Manager (roleId = 1)
            if (roleId != 1) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập");
                return;
            }

            handlePageRequest(request, response, dbName, branchId);

            // Xử lý thông báo từ session
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
            Logger.getLogger(BMPromotionController.class.getName()).log(Level.SEVERE, null, ex);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + ex.getMessage());
        }
    }

    private void handlePageRequest(HttpServletRequest request, HttpServletResponse response,
            String dbName, int branchId) throws ServletException, IOException, SQLException {
        
        String action = request.getParameter("action");

        if ("view".equals(action)) {
            handleViewPromotion(request, response, dbName, branchId);
            return;
        }

        // Xử lý danh sách khuyến mãi
        handlePromotionList(request, response, dbName, branchId);
    }

    private void handleViewPromotion(HttpServletRequest request, HttpServletResponse response,
            String dbName, int branchId) throws ServletException, IOException, SQLException {
        
        String promotionIdStr = request.getParameter("promotionId");
        if (promotionIdStr != null && !promotionIdStr.trim().isEmpty()) {
            try {
                int promotionId = Integer.parseInt(promotionIdStr);
                
                // Kiểm tra xem promotion có áp dụng cho chi nhánh này không
                if (!promotionDAO.isPromotionApplicableToBranch(dbName, promotionId, branchId)) {
                    request.setAttribute("error", "Khuyến mãi không áp dụng cho chi nhánh của bạn!");
                    handlePromotionList(request, response, dbName, branchId);
                    return;
                }
                
                PromotionDTO promotion = promotionDAO.getPromotionById(dbName, promotionId);
                if (promotion != null) {
                    request.setAttribute("action", "view");
                    request.setAttribute("promotion", promotion);
                    
                    // Định dạng ngày cho hiển thị
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    promotion.setStartDateFormatted(sdf.format(promotion.getStartDate()));
                    promotion.setEndDateFormatted(sdf.format(promotion.getEndDate()));
                    
                    // Thay thế phần lấy chi nhánh và sản phẩm
                    // Lấy thông tin chi nhánh hiện tại
                    Branch currentBranch = promotionDAO.getBranchById(dbName, branchId);
                    List<Branch> branches = new ArrayList<>();
                    if (currentBranch != null) {
                        branches.add(currentBranch);
                    }

                    // Lấy sản phẩm áp dụng khuyến mãi có trong chi nhánh hiện tại
                    List<ProductDetails> productDetails = promotionDAO.getProductDetailsByPromotionAndBranch(dbName, promotionId, branchId);

                    System.out.println("DEBUG: Current branch: " + (currentBranch != null ? currentBranch.getBranchName() : "null"));
                    System.out.println("DEBUG: Products in current branch: " + (productDetails != null ? productDetails.size() : "null"));

                    request.setAttribute("branches", branches);
                    request.setAttribute("productDetails", productDetails);
                    
                    request.getRequestDispatcher("/WEB-INF/jsp/manager/bmmodalpromotion.jsp").forward(request, response);
                    return;
                } else {
                    request.setAttribute("error", "Không tìm thấy khuyến mãi!");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Mã khuyến mãi không hợp lệ!");
            }
        }
        
        // Nếu có lỗi, quay về danh sách
        handlePromotionList(request, response, dbName, branchId);
    }

    private void handlePromotionList(HttpServletRequest request, HttpServletResponse response,
            String dbName, int branchId) throws ServletException, IOException, SQLException {

        // Đọc search parameters từ request
        String search = request.getParameter("search");
        String status = request.getParameter("status");
        String discount = request.getParameter("discount");
        String pageStr = request.getParameter("page");

        // Tạo search criteria object
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

        // Lấy danh sách khuyến mãi của chi nhánh
        List<PromotionDTO> promotions = promotionDAO.searchPromotionsByBranch(dbName, criteria, branchId);
        int totalPromotions = promotionDAO.countPromotionsByBranch(dbName, criteria, branchId);

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

        // Forward đến JSP
        request.getRequestDispatcher("/WEB-INF/jsp/manager/bm-promotion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Branch Manager không có quyền POST (create, update, delete)
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Branch Manager chỉ có quyền xem khuyến mãi");
    }
}
