package controller;

import model.AnnouncementDTO;
import dao.AnnouncementDAO;
import dao.CashFlowDAO;
import dao.BrandDAO;
import model.Branch;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.ProductSaleDTO;
import util.Validate;

/**
 * Controller cho Branch Manager Overview
 * @author admin & TRIEU NAM
 */
@WebServlet(name="BMOverviewController", urlPatterns={"/bm-overview"})
public class BMDashboardController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        // Lấy thông tin từ session
        HttpSession session = request.getSession();
        Object userIdObj = session.getAttribute("userId");
        String dbName = (String) session.getAttribute("dbName");
        
        // ===== DEBUG SESSION INFO =====
        System.out.println("=== SESSION DEBUG INFO ===");
        System.out.println("Session ID: " + session.getId());
        System.out.println("userId from session: " + userIdObj);
        System.out.println("roleId from session: " + session.getAttribute("roleId"));
        System.out.println("dbName from session: " + dbName);
        System.out.println("warehouseId from session: " + session.getAttribute("warehouseId"));
        System.out.println("isActive from session: " + session.getAttribute("isActive"));
        
        // Lấy branchId từ session
        Object branchIdObj = session.getAttribute("branchId");
        System.out.println("branchId object from session: " + branchIdObj);
        System.out.println("branchId type: " + (branchIdObj != null ? branchIdObj.getClass().getName() : "null"));
        
        // Convert userId
        Integer userId = null;
        if (userIdObj != null) {
            try {
                userId = (Integer) userIdObj;
                System.out.println("✅ UserID successfully retrieved: " + userId);
            } catch (ClassCastException e) {
                System.out.println("❌ Error casting userId: " + e.getMessage());
                try {
                    userId = Integer.parseInt(userIdObj.toString());
                    System.out.println("✅ UserID parsed from string: " + userId);
                } catch (NumberFormatException ex) {
                    System.out.println("❌ Cannot parse userId from: " + userIdObj);
                }
            }
        } else {
            System.out.println("❌ UserId is NULL");
        }
        
        System.out.println("========================");
        
        // Kiểm tra branchId từ session
        Integer branchID = null;
        if (branchIdObj != null) {
            try {
                branchID = (Integer) branchIdObj;
                System.out.println("✅ BranchID successfully retrieved from session: " + branchID);
            } catch (ClassCastException e) {
                System.out.println("❌ Error casting branchId: " + e.getMessage());
                // Thử parse từ String nếu cần
                try {
                    branchID = Integer.parseInt(branchIdObj.toString());
                    System.out.println("✅ BranchID parsed from string: " + branchID);
                } catch (NumberFormatException ex) {
                    System.out.println("❌ Cannot parse branchId from: " + branchIdObj);
                }
            }
        }
        
        // ===== XỬ LÝ TRƯỜNG HỢP BRANCHID NULL =====
        if (branchID == null) {
            System.out.println("⚠️ BranchID is null, trying to get from roleId or set default");
            Object roleIdObj = session.getAttribute("roleId");
            if (roleIdObj != null) {
                Integer roleId = (Integer) roleIdObj;
                if (roleId == 1) { // Nếu là Branch Manager
                    // Set branchID mặc định hoặc lấy từ database
                    branchID = 1; // Temporary fix - nên lấy từ database thực tế
                    System.out.println("⚠️ Using default branchID for roleId 1: " + branchID);
                }
            }
        }
        
        // Kiểm tra userId và branchID
        if (userId == null || branchID == null) {
            System.out.println("❌ Missing userId or branchID - redirecting");
            System.out.println("UserId null: " + (userId == null));
            System.out.println("BranchID null: " + (branchID == null));
            request.setAttribute("error", "Không thể xác định thông tin người dùng hoặc chi nhánh. Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("/WEB-INF/jsp/manager/bm-dashboard.jsp").forward(request, response);
            return;
        }
        
        System.out.println("✅ Proceeding with UserID: " + userId + ", BranchID: " + branchID + ", dbName: " + dbName);

        // ===== LẤY THÔNG TIN CHI NHÁNH =====
        BrandDAO brandDAO = new BrandDAO();
        String branchName = null;
        Branch branchInfo = null;

        try {
            System.out.println("🏢 Getting branch information for ID: " + branchID);
            
            // Lấy tên chi nhánh
            branchName = brandDAO.getBranchNameById(dbName, branchID);
            
            // Lấy thông tin đầy đủ chi nhánh (tùy chọn)
            branchInfo = brandDAO.getBranchById(dbName, branchID);
            
            if (branchName != null) {
                System.out.println("✅ Branch name retrieved: " + branchName);
            } else {
                System.out.println("⚠️ Branch name not found for ID: " + branchID);
                branchName = "Chi nhánh " + branchID;
            }
            
        } catch (SQLException e) {
            System.out.println("❌ Error getting branch info: " + e.getMessage());
            e.printStackTrace();
            // Fallback - sử dụng ID nếu không lấy được tên
            branchName = "Chi nhánh " + branchID;
        }

        // Đảm bảo có giá trị mặc định
        if (branchName == null || branchName.trim().isEmpty()) {
            branchName = "Chi nhánh " + branchID;
        }

        // ===== PHẦN CODE MỚI CỦA TRIEU NAM - BẮT ĐẦU =====
        
        // Check active status
        Object isActiveObj = session.getAttribute("isActive");
        if (isActiveObj != null && (Integer) isActiveObj == 0) {
            System.out.println("❌ User not active - redirecting to subscription");
            response.sendRedirect(request.getContextPath() + "/subscription");
            return;
        }

        String sortBy = request.getParameter("sortBy");
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "quantity";
        }
        String topPeriod = request.getParameter("topPeriod");
        if (topPeriod == null || topPeriod.isEmpty()) {
            topPeriod = "this_month";
        }

        String period = request.getParameter("period");
        if (period == null || period.isEmpty()) {
            period = "this_month";
        }
        String filterType = request.getParameter("filterType");
        if (filterType == null || filterType.isEmpty()) {
            filterType = "day";
        }

        System.out.println("📊 Dashboard Parameters:");
        System.out.println("- sortBy: " + sortBy);
        System.out.println("- topPeriod: " + topPeriod);
        System.out.println("- period: " + period);
        System.out.println("- filterType: " + filterType);

        List<ProductSaleDTO> topProducts = new ArrayList<>();
        Map<String, Object> Revenue = new HashMap<>();

        CashFlowDAO cashFlowDAO = new CashFlowDAO();
        try {
            System.out.println("🔄 Starting data retrieval for branch: " + branchID);
            
            BigDecimal incomeTotalToDay = cashFlowDAO.getTodayIncomeByBranch(dbName, branchID);
            System.out.println("💰 Today income: " + incomeTotalToDay);

            if ("this_month".equals(period)) {
                switch (filterType) {
                    case "day":
                        Revenue = cashFlowDAO.getMonthlyRevenueByDayAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved monthly revenue by day");
                        break;
                    case "weekday":
                        Revenue = cashFlowDAO.getMonthlyRevenueByWeekdayAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved monthly revenue by weekday");
                        break;
                    case "hour":
                        Revenue = cashFlowDAO.getMonthlyRevenueByHourAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved monthly revenue by hour");
                        break;
                    default:
                        Revenue = cashFlowDAO.getMonthlyRevenueByDayAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved monthly revenue by day (default)");
                        break;
                }
            } else if ("last_month".equals(period)) {
                switch (filterType) {
                    case "day":
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByDayAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved previous month revenue by day");
                        break;
                    case "weekday":
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByWeekdayAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved previous month revenue by weekday");
                        break;
                    case "hour":
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByHourAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved previous month revenue by hour");
                        break;
                    default:
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByDayAndBranch(dbName, branchID);
                        System.out.println("📈 Retrieved previous month revenue by day (default)");
                        break;
                }
            }

            // Debug revenue data
            if (Revenue != null && !Revenue.isEmpty()) {
                System.out.println("📊 Revenue Data Debug:");
                System.out.println("- Labels: " + Revenue.get("labels"));
                System.out.println("- Data: " + Revenue.get("data"));
                System.out.println("- Chart Title: " + Revenue.get("chartTitle"));
            } else {
                System.out.println("❌ Revenue data is NULL or empty");
            }

            if ("last_month".equals(topPeriod)) {
                if ("quantity".equals(sortBy)) {
                    topProducts = cashFlowDAO.getTop5ProductSalesLastMonthByQuantityAndBranch(dbName, branchID);
                    System.out.println("🏆 Retrieved top products last month by quantity: " + topProducts.size());
                } else {
                    topProducts = cashFlowDAO.getTop5ProductSalesLastMonthByRevenueAndBranch(dbName, branchID);
                    System.out.println("🏆 Retrieved top products last month by revenue: " + topProducts.size());
                }
            } else {
                if ("quantity".equals(sortBy)) {
                    topProducts = cashFlowDAO.getTop5ProductSalesThisMonthByQuantityAndBranch(dbName, branchID);
                    System.out.println("🏆 Retrieved top products this month by quantity: " + topProducts.size());
                } else {
                    topProducts = cashFlowDAO.getTop5ProductSalesThisMonthByRevenueAndBranch(dbName, branchID);
                    System.out.println("🏆 Retrieved top products this month by revenue: " + topProducts.size());
                }
            }

            // Debug top products
            System.out.println("=== TOP PRODUCTS DEBUG ===");
            for (int i = 0; i < topProducts.size(); i++) {
                ProductSaleDTO product = topProducts.get(i);
                System.out.println("Product " + (i + 1) + ": " + product.getProductName()
                          + " - Quantity: " + product.getTotalQuantity()
                          + " - Revenue: " + product.getRevenue());
            }
            System.out.println("========================");

            int invoiceToDay = cashFlowDAO.getTodayInvoiceCountByBranch(dbName, branchID);
            System.out.println("📋 Today invoice count: " + invoiceToDay);

            BigDecimal yesterdayIncome = cashFlowDAO.getYesterdayIncomeByBranch(dbName, branchID);
            System.out.println("💰 Yesterday income: " + yesterdayIncome);

            LocalDate sameDayLastMonth = Validate.getSameDayPreviousMonthSafe(1);
            BigDecimal sameDayLastMonthIncome = cashFlowDAO.getSameDayLastMonthIncomeByBranch(dbName, branchID, sameDayLastMonth);
            System.out.println("💰 Same day last month income: " + sameDayLastMonthIncome);

            double percentageChange = Validate.calculatePercentageChange(incomeTotalToDay, yesterdayIncome);
            double monthlyChange = Validate.calculatePercentageChange(incomeTotalToDay, sameDayLastMonthIncome);
            
            System.out.println("📈 Percentage changes:");
            System.out.println("- Daily change: " + percentageChange + "%");
            System.out.println("- Monthly change: " + monthlyChange + "%");

            //Phần doanh thu
            request.setAttribute("currentPeriod", period);
            request.setAttribute("currentFilter", filterType);
            request.setAttribute("percentageChange", percentageChange);
            request.setAttribute("invoiceToDay", invoiceToDay);
            request.setAttribute("incomeTotal", Validate.formatCurrency(incomeTotalToDay));
            request.setAttribute("monthlyChange", monthlyChange);

            //Phần doanh thu theo filter
            request.setAttribute("revenueData", Revenue);
            //Phần top sản phẩm
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("topPeriod", topPeriod);
            
            System.out.println("✅ All dashboard data set successfully");

        } catch (SQLException e) {
            System.out.println("❌ SQL Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy dữ liệu từ database: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("❌ General Exception: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        
        // ===== PHẦN CODE MỚI CỦA TRIEU NAM - KẾT THÚC =====

        // ===== PHẦN CODE GỐC CỦA ĐỒNG NGHIỆP - BẮT ĐẦU =====
        
        // Lấy thông báo và hoạt động gần đây cho Branch Manager
        AnnouncementDAO announcementDAO = new AnnouncementDAO();
        try {
            System.out.println("🔔 Fetching announcements and activities...");
            
            List<AnnouncementDTO> recentAnnouncements = announcementDAO.getRecentAnnouncementsForBranchManager(dbName, branchID);
            request.setAttribute("recentAnnouncements", recentAnnouncements);

            List<AnnouncementDTO> activityLogs = announcementDAO.getRecentActivitiesForBranchManager(dbName, branchID);
            request.setAttribute("activityLogs", activityLogs);
            
            System.out.println("✅ Branch Manager - Loaded " + recentAnnouncements.size() + " announcements and " + activityLogs.size() + " activities for BranchID: " + branchID);
            
        } catch (Exception e) {
            System.out.println("❌ Error loading announcements: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("announcementError", "Lỗi lấy thông báo: " + e.getMessage());
        }

        // Set thông tin chi nhánh (đã cập nhật với tên chi nhánh)
        request.setAttribute("currentBranchID", branchID);
        request.setAttribute("currentBranchName", branchName);
        request.setAttribute("branchInfo", branchInfo); // Thông tin đầy đủ chi nhánh
        request.setAttribute("currentUserId", userId);
        
        // ===== PHẦN CODE GỐC CỦA ĐỒNG NGHIỆP - KẾT THÚC =====

        System.out.println("🚀 Forwarding to bm-dashboard.jsp with UserID: " + userId + ", BranchID: " + branchID + ", BranchName: " + branchName);
        
        // Forward tới JSP (sửa lại đường dẫn đúng)
        request.getRequestDispatcher("/WEB-INF/jsp/manager/bm-dashboard.jsp").forward(request, response);
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
        return "Branch Manager Overview Controller - Enhanced with dashboard features and branch name display";
    }
}
