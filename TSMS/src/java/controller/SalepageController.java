package controller;

import dao.ProductDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ProductDTO;
import model.SalesStatisticsDTO;
import model.SalesTransactionDTO;
import model.PromotionDTO;

@WebServlet(name="Salepage", urlPatterns={"/salepage"})
public class SalepageController extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy thông tin session
            HttpSession session = request.getSession();
            String dbName = (String) session.getAttribute("dbName");
            Integer branchId = (Integer) session.getAttribute("branchId");
            Integer userId = (Integer) session.getAttribute("userId");
            
            // Giá trị mặc định cho test
            if (dbName == null) dbName = "DTB_ShopTemp";
            if (branchId == null) branchId = 1;
            if (userId == null) userId = 1; // Giả sử user có ID = 1 là nhân viên bán hàng
            
            // Lấy section từ parameter
            String section = request.getParameter("section");
            if (section == null) section = "products";
            
            // Tạo DAO instance duy nhất
            ProductDAO productDAO = new ProductDAO();
            
            // Xử lý theo section - GỌI TRỰC TIẾP CÁC METHOD MỚI
            switch (section) {
                case "products":
                    // Sử dụng method hiện có
                    List<ProductDTO> products = productDAO.getInventoryProductListByPageByBranchId(dbName, branchId, 0, 10);
                    request.setAttribute("products", products);
                    break;
                    
                case "transactions":
                    // Sử dụng methods mới
                    String searchKeyword = request.getParameter("search");
                    List<SalesTransactionDTO> transactions;
                    
                    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                        transactions = productDAO.searchTransactionsByUser(dbName, userId, searchKeyword);
                    } else {
                        transactions = productDAO.getTransactionsByUser(dbName, userId);
                    }
                    request.setAttribute("transactions", transactions);
                    break;
                    
                case "promotions":
                    // Sử dụng method mới
                    List<PromotionDTO> promotions = productDAO.getActivePromotionsByBranch(dbName, branchId);
                    request.setAttribute("promotions", promotions);
                    break;
                    
                case "stats":
                    // Sử dụng method mới cho thống kê chi tiết
                    SalesStatisticsDTO detailedStats = productDAO.getSalesStatisticsByUser(dbName, userId);
                    request.setAttribute("detailedStats", detailedStats);
                    break;
            }
            
            // LUÔN lấy thống kê dashboard cho header
            SalesStatisticsDTO stats = productDAO.getSalesStatisticsByUser(dbName, userId);
            request.setAttribute("salesStats", stats);
            
            // Forward đến JSP
            request.getRequestDispatcher("/WEB-INF/jsp/sale/salepage.jsp").forward(request, response);
            
        } catch (SQLException ex) {
            Logger.getLogger(SalepageController.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Không thể tải dữ liệu: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/sale/salepage.jsp").forward(request, response);
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
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Sales Page Controller - Simple DAO Version";
    }
}
