package controller;

import dao.ProductDAO;
import dao.SalesDAO;
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

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SalepageController", urlPatterns = {"/salepage"})
public class SalepageController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SalepageController.class.getName());
    private final ProductDAO productDAO = new ProductDAO();
    private final SalesDAO salesDAO = new SalesDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("userId") == null) {
                response.sendRedirect("login");
                return;
            }

            // Validate and convert userId
            Integer userId = parseUserId(session.getAttribute("userId"));
            if (userId == null) {
                throw new SQLException("Invalid or null userId");
            }

            // Get database name and branch ID
            String dbName = (String) session.getAttribute("dbName");
            Integer branchId = (Integer) session.getAttribute("branchId");
            dbName = (dbName != null) ? dbName : "DTB_ShopTemp";
            branchId = (branchId != null) ? branchId : 1;

            // Get section parameter
            String section = request.getParameter("section");
            if (section == null || section.isEmpty()) {
                section = "products";
            }
            request.setAttribute("curentSection", section);

            // Fetch sales statistics for header
            SalesStatisticsDTO stats = salesDAO.getSalesStatistics(dbName, userId);
            request.setAttribute("salesStats", stats);

            // Handle different sections
            switch (section) {
                case "products":
                    handleProductsSection(request, dbName, branchId);
                    break;
                case "transactions":
                    handleTransactionsSection(request, dbName, userId);
                    break;
                case "promotions":
                    handlePromotionsSection(request, dbName, branchId);
                    break;
                case "stats":
                    // Stats are already fetched above
                    break;
                default:
                    throw new ServletException("Invalid section: " + section);
            }

            request.getRequestDispatcher("/WEB-INF/jsp/sale/salepage.jsp").forward(request, response);

        } catch (SQLException | ServletException ex) {
            LOGGER.log(Level.SEVERE, "Error processing request", ex);
            request.setAttribute("error", "Không thể tải dữ liệu: " + ex.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/sale/salepage.jsp").forward(request, response);
        }
    }

    private Integer parseUserId(Object userIdObj) throws SQLException {
        if (userIdObj instanceof String) {
            try {
                return Integer.valueOf((String) userIdObj);
            } catch (NumberFormatException e) {
                throw new SQLException("Invalid userId format: " + userIdObj);
            }
        } else if (userIdObj instanceof Integer) {
            return (Integer) userIdObj;
        }
        throw new SQLException("Unsupported userId type: " + (userIdObj != null ? userIdObj.getClass().getName() : "null"));
    }

    private void handleProductsSection(HttpServletRequest request, String dbName, int branchId) throws SQLException {
        String category = request.getParameter("category");
        String stockStatus = request.getParameter("stockStatus");
        String search = request.getParameter("search");
        int page = parseIntParameter(request.getParameter("page"), 1);
        int pageSize = 10;

        List<ProductDTO> products;
        if (search != null && !search.trim().isEmpty()) {
            products = productDAO.searchProducts(dbName, branchId, search);
        } else if (category != null && !category.trim().isEmpty()) {
            products = productDAO.getProductsByCategory(dbName, branchId, category);
        } else if (stockStatus != null && !stockStatus.trim().isEmpty()) {
            products = productDAO.getProductsByStockStatus(dbName, branchId, stockStatus);
        } else {
            products = productDAO.getInventoryProductListByPageByBranchId(dbName, branchId, (page - 1) * pageSize, pageSize);
        }

        request.setAttribute("products", products);
        request.setAttribute("totalProducts", productDAO.countProductsByBranchId(dbName, branchId));
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
    }

    private void handleTransactionsSection(HttpServletRequest request, String dbName, int userId) throws SQLException {
        String search = request.getParameter("search");
        List<SalesTransactionDTO> transactions;
        if (search != null && !search.trim().isEmpty()) {
            transactions = salesDAO.searchTransactions(dbName, userId, search);
        } else {
            transactions = salesDAO.getTransactionsBySalesperson(dbName, userId);
        }
        request.setAttribute("transactions", transactions);
    }

    private void handlePromotionsSection(HttpServletRequest request, String dbName, int branchId) throws SQLException {
        List<PromotionDTO> promotions = salesDAO.getActivePromotions(dbName, branchId);
        request.setAttribute("promotions", promotions);
    }

    private int parseIntParameter(String param, int defaultValue) {
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/salepage");
    }

    @Override
    public String getServletInfo() {
        return "Controller for sales staff to view products, transactions, promotions, and statistics.";
    }
}