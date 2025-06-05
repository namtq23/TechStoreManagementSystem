/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CashFlowDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Map;
import util.Validate;

/**
 *
 * @author TRIEU NAM
 */
@WebServlet(name = "BrandOwnerTongQuanController", urlPatterns = {"/so-overview"})
public class SOOverallController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String filterType = request.getParameter("filterType");

        if ("day".equals(filterType)) {
            // xử lý theo ngày
        } else if ("hour".equals(filterType)) {
            // xử lý theo giờ
        } else if ("weekday".equals(filterType)) {
            // xử lý theo thứ
        }

        try {

            // Lấy tên CSDL từ session
            String dbName = (String) request.getSession().getAttribute("dbName");

            // Gọi DAO để lấy tổng thu nhập hôm nay
            CashFlowDAO cashFlowDAO = new CashFlowDAO();

            BigDecimal incomeTotalToDay = cashFlowDAO.getTodayIncome(dbName);

            Map<String, Object> MonthlyRevenueByDay = cashFlowDAO.getMonthlyRevenueByDay(dbName);

            int invoiceToDay = cashFlowDAO.getTodayInvoiceCount(dbName);

            BigDecimal yesterdayIncome = cashFlowDAO.getYesterdayIncome(dbName);

            LocalDate sameDayLastMonth = Validate.getSameDayPreviousMonthSafe(1); // hôm nay của tháng trước

            BigDecimal sameDayLastMonthIncome = cashFlowDAO.getSameDayLastMonthIncome(dbName, sameDayLastMonth);

            double percentageChange = Validate.calculatePercentageChange(incomeTotalToDay, yesterdayIncome);
            double monthlyChange = Validate.calculatePercentageChange(incomeTotalToDay, sameDayLastMonthIncome);
            // Đặt vào request để render ra JSP

            request.setAttribute("revenueData", MonthlyRevenueByDay);
            request.setAttribute("percentageChange", percentageChange);
            request.setAttribute("invoiceToDay", invoiceToDay);
            request.setAttribute("incomeTotal", Validate.formatCurrency(incomeTotalToDay));
            request.setAttribute("monthlyChange", monthlyChange);

        } catch (SQLException e) {
            e.printStackTrace(); // Log lỗi
            request.setAttribute("error", "Lỗi khi lấy tổng thu nhập: " + e.getMessage());
        }

        // Forward sang JSP
        request.getRequestDispatcher("/WEB-INF/jsp/shop-owner/tongquan.jsp").forward(request, response);
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
