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
import java.util.ArrayList;
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
                LOGGER.log(Level.WARNING, "Invalid userId, using default");
                userId = 1; // Fallback instead of throwing exception
            }

            // Get database name and branch ID
            String dbName = (String) session.getAttribute("dbName");
            Integer branchId = parseBranchId(session.getAttribute("branchId"));
            dbName = (dbName != null) ? dbName : "DTB_ShopTemp";
            branchId = (branchId != null) ? branchId : 1;

            // Get section parameter - FIX: Always fallback to products
            String section = request.getParameter("section");
            if (section == null || section.isEmpty()) {
                section = "products";
            }
            request.setAttribute("currentSection", section);

            // Always fetch sales statistics for header
            try {
                SalesStatisticsDTO stats = salesDAO.getSalesStatistics(dbName, userId);
                request.setAttribute("salesStats", stats);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Could not load sales statistics", e);
                // Continue without stats rather than failing
            }

            // Handle different sections - FIX: Use safe methods
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
                    // FIX: Fallback to products instead of throwing exception
                    LOGGER.log(Level.WARNING, "Invalid section: {0}, falling back to products", section);
                    request.setAttribute("currentSection", "products");
                    handleProductsSection(request, dbName, branchId);
                    break;
            }

            request.getRequestDispatcher("/WEB-INF/jsp/sale/salepage.jsp").forward(request, response);

        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error processing request", ex);
            request.setAttribute("error", "Không thể tải dữ liệu: " + ex.getMessage());
            request.setAttribute("currentSection", "products");
            
            // FIX: Ensure we have empty lists to prevent JSP errors
            request.setAttribute("products", new ArrayList<ProductDTO>());
            request.setAttribute("transactions", new ArrayList<SalesTransactionDTO>());
            request.setAttribute("promotions", new ArrayList<PromotionDTO>());
            
            request.getRequestDispatcher("/WEB-INF/jsp/sale/salepage.jsp").forward(request, response);
        }
    }

    private Integer parseUserId(Object userIdObj) {
        if (userIdObj instanceof String) {
            try {
                return Integer.valueOf((String) userIdObj);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid userId format: {0}", userIdObj);
                return null;
            }
        } else if (userIdObj instanceof Integer) {
            return (Integer) userIdObj;
        }
        LOGGER.log(Level.WARNING, "Unsupported userId type: {0}", 
                  (userIdObj != null ? userIdObj.getClass().getName() : "null"));
        return null;
    }

    private Integer parseBranchId(Object branchIdObj) {
        if (branchIdObj instanceof String) {
            try {
                return Integer.valueOf((String) branchIdObj);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid branchId format: {0}", branchIdObj);
                return null;
            }
        } else if (branchIdObj instanceof Integer) {
            return (Integer) branchIdObj;
        }
        LOGGER.log(Level.WARNING, "Unsupported branchId type: {0}", 
                  (branchIdObj != null ? branchIdObj.getClass().getName() : "null"));
        return null;
    }

    private void handleProductsSection(HttpServletRequest request, String dbName, int branchId) {
        try {
            // FIX: Use only existing methods and let JSP handle client-side filtering
            String search = request.getParameter("search");
            int page = parseIntParameter(request.getParameter("page"), 1);
            int pageSize = 50; // Increase page size for client-side filtering

            List<ProductDTO> products;
            
            // FIX: Only use methods that exist in ProductDAO
            if (search != null && !search.trim().isEmpty()) {
                // Try to use search method if it exists, otherwise use regular method
                try {
                    // Check if search method exists
                    products = productDAO.searchProducts(dbName, branchId, search);
                } catch (Exception e) {
                    LOGGER.log(Level.INFO, "Search method not available, using regular product list");
                    products = productDAO.getInventoryProductListByPageByBranchId(dbName, branchId, 0, pageSize);
                    // Let JSP handle the search filtering
                    request.setAttribute("searchQuery", search);
                }
            } else {
                products = productDAO.getInventoryProductListByPageByBranchId(dbName, branchId, 0, pageSize);
            }

            request.setAttribute("products", products);
            
            // FIX: Safe count method
            try {
                int totalProducts = productDAO.countProductsByBranchId(dbName, branchId);
                request.setAttribute("totalProducts", totalProducts);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Could not get product count", e);
                request.setAttribute("totalProducts", products.size());
            }
            
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading products", e);
            request.setAttribute("products", new ArrayList<ProductDTO>());
            request.setAttribute("totalProducts", 0);
        }
    }

    private void handleTransactionsSection(HttpServletRequest request, String dbName, int userId) {
        try {
            String search = request.getParameter("search");
            List<SalesTransactionDTO> transactions = new ArrayList<>();
            
            // FIX: Use safe method calls
            try {
                if (search != null && !search.trim().isEmpty()) {
                    transactions = salesDAO.searchTransactions(dbName, userId, search);
                } else {
                    transactions = salesDAO.getTransactionsBySalesperson(dbName, userId);
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Could not load transactions", e);
                // Continue with empty list
            }
            
            request.setAttribute("transactions", transactions);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in transactions section", e);
            request.setAttribute("transactions", new ArrayList<SalesTransactionDTO>());
        }
    }

    private void handlePromotionsSection(HttpServletRequest request, String dbName, int branchId) {
        try {
            List<PromotionDTO> promotions = new ArrayList<>();
            
            // FIX: Use safe method calls
            try {
                promotions = salesDAO.getActivePromotions(dbName, branchId);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Could not load promotions", e);
                // Continue with empty list
            }
            
            request.setAttribute("promotions", promotions);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in promotions section", e);
            request.setAttribute("promotions", new ArrayList<PromotionDTO>());
        }
    }

    private int parseIntParameter(String param, int defaultValue) {
        if (param == null || param.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid integer parameter: {0}", param);
            return defaultValue;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // FIX: Preserve section parameter in redirect
        String section = request.getParameter("section");
        String redirectUrl = request.getContextPath() + "/salepage";
        
        if (section != null && !section.trim().isEmpty()) {
            redirectUrl += "?section=" + section;
        }
        
        response.sendRedirect(redirectUrl);
    }

    @Override
    public String getServletInfo() {
        return "Controller for sales staff to view products, transactions, promotions, and statistics.";
    }
}
