/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.AnnouncementDTO;
import dao.AnnouncementDAO;
import dao.CashFlowDAO;
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
 *
 * @author TRIEU NAM
 */
@WebServlet(name = "BrandOwnerTongQuanController", urlPatterns = {"/so-overview"})
public class SOOverallController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);

        //Check active status
        if ((Integer) session.getAttribute("isActive") == 0) {
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

        List<ProductSaleDTO> topProducts = new ArrayList<>();
        Map<String, Object> Revenue = new HashMap<>();
        String dbName = (String) request.getSession().getAttribute("dbName");
        System.out.println(">>> DEBUG dbName = " + dbName);

        CashFlowDAO cashFlowDAO = new CashFlowDAO();
        try {
            BigDecimal incomeTotalToDay = cashFlowDAO.getTodayIncome(dbName);

            if ("this_month".equals(period)) {
                switch (filterType) {
                    case "day":
                        Revenue = cashFlowDAO.getMonthlyRevenueByDay(dbName);
                        break;
                    case "weekday":
                        Revenue = cashFlowDAO.getMonthlyRevenueByWeekday(dbName);
                        break;
                    case "hour":
                        Revenue = cashFlowDAO.getMonthlyRevenueByHour(dbName);
                        break;
                    default:
                        Revenue = cashFlowDAO.getMonthlyRevenueByDay(dbName);
                        break;
                }
            } else if ("last_month".equals(period)) {
                switch (filterType) {
                    case "day":
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByDay(dbName);
                        break;
                    case "weekday":
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByWeekday(dbName);
                        break;
                    case "hour":
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByHour(dbName);
                        break;
                    default:
                        Revenue = cashFlowDAO.getPreviousMonthRevenueByDay(dbName);
                        break;
                }

            }

            if ("last_month".equals(topPeriod)) {
                if ("quantity".equals(sortBy)) {
                    topProducts = cashFlowDAO.getTop5ProductSalesLastMonthByQuantity(dbName);
                } else {
                    topProducts = cashFlowDAO.getTop5ProductSalesLastMonthByRevenue(dbName);
                }
            } else {
                if ("quantity".equals(sortBy)) {
                    topProducts = cashFlowDAO.getTop5ProductSalesThisMonthByQuantity(dbName);
                } else {
                    topProducts = cashFlowDAO.getTop5ProductSalesThisMonthByRevenue(dbName);
                }
            }

            System.out.println("=== DEBUG TOP PRODUCTS ===");
            System.out.println("TopProducts size: " + topProducts.size());
            for (int i = 0; i < topProducts.size(); i++) {
                ProductSaleDTO product = topProducts.get(i);
                System.out.println("Product " + (i + 1) + ": " + product.getProductName()
                          + " - Quantity: " + product.getTotalQuantity()
                          + " - Revenue: " + product.getRevenue());
            }
            System.out.println("========================");

            // Debug dữ liệu trước khi gửi tới JSP
            System.out.println("Final Revenue Data:");
            System.out.println("Labels: " + Revenue.get("labels"));
            System.out.println("Data: " + Revenue.get("data"));
            System.out.println("Chart Title: " + Revenue.get("chartTitle"));

            int invoiceToDay = cashFlowDAO.getTodayInvoiceCount(dbName);

            BigDecimal yesterdayIncome = cashFlowDAO.getYesterdayIncome(dbName);

            LocalDate sameDayLastMonth = Validate.getSameDayPreviousMonthSafe(1); // hôm nay của tháng trước

            BigDecimal sameDayLastMonthIncome = cashFlowDAO.getSameDayLastMonthIncome(dbName, sameDayLastMonth);

            double percentageChange = Validate.calculatePercentageChange(incomeTotalToDay, yesterdayIncome);

            double monthlyChange = Validate.calculatePercentageChange(incomeTotalToDay, sameDayLastMonthIncome);
            // Đặt vào request để render ra JSP

            //Phần doang thu
            request.setAttribute("currentPeriod", period);
            request.setAttribute("currentFilter", filterType);
            request.setAttribute("percentageChange", percentageChange);
            request.setAttribute("invoiceToDay", invoiceToDay);
            request.setAttribute("incomeTotal", Validate.formatCurrency(incomeTotalToDay));
            request.setAttribute("monthlyChange", monthlyChange);

            //Phân doanh thu theo filter
            request.setAttribute("revenueData", Revenue);
            //Phần top sản phẩm
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("topProducts", topProducts);
            request.setAttribute("topPeriod", topPeriod);

            AnnouncementDAO announcementDAO = new AnnouncementDAO();
            try {
                List<AnnouncementDTO> recentAnnouncements = announcementDAO.getRecentAnnouncementsForShopOwner(dbName);
                request.setAttribute("recentAnnouncements", recentAnnouncements);

                // Lấy hoạt động gần đây
                List<AnnouncementDTO> activityLogs = announcementDAO.getRecentActivitiesForShopOwner(dbName);
                request.setAttribute("activityLogs", activityLogs);
            } catch (Exception e) {
                e.printStackTrace(); //
                request.setAttribute("error", "Lỗi lấy thông báo: " + e.getMessage());
            }
            request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/tongquan.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi
            request.setAttribute("error", "Lỗi khi lấy tổng thu nhập: " + e.getMessage());
        }

        // Forward sang JSP
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
              throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
