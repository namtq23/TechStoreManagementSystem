/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.CustomerDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "SaleCustomersController", urlPatterns = {"/sale-mycustomer"})
public class SaleCustomersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        // Check login & quyền Shop Owner
        if (session == null || session.getAttribute("userId") == null
                || session.getAttribute("roleId") == null || session.getAttribute("dbName") == null
                || (Integer) session.getAttribute("roleId") != 2) {
            resp.sendRedirect("login");
            return;
        }

        // Check active
        if ((Integer) session.getAttribute("isActive") == 0) {
            resp.sendRedirect(req.getContextPath() + "/subscription");
            return;
        }

        int createdBy = (Integer) session.getAttribute("userId");
        String dbName = session.getAttribute("dbName").toString();

        // Lấy filter
        String keyword = req.getParameter("keyword");
        String genderFilter = req.getParameter("gender");

        String minStr = req.getParameter("minGrandTotal");
        String maxStr = req.getParameter("maxGrandTotal");
        Double minGrandTotal = parseDoubleOrNull(minStr);
        Double maxGrandTotal = parseDoubleOrNull(maxStr);

        int page = parseIntOrDefault(req.getParameter("page"), 1);
        int pageSize = 10;
        int offset = (page - 1) * pageSize;

        try {
            CustomerDAO customerDAO = new CustomerDAO();
            List<CustomerDTO> customers;
            int totalCustomers;
            int totalPages;

            boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
            totalCustomers = customerDAO.countCustomersByCreatedBy(dbName, genderFilter, createdBy);
            totalPages = (int) Math.ceil((double) totalCustomers / pageSize);
            page = Math.min(page, totalPages == 0 ? 1 : totalPages);
            offset = (page - 1) * pageSize;

            customers = customerDAO.getCustomersByCreatedBy(dbName, offset, pageSize, genderFilter, createdBy);

            req.setAttribute("customers", customers);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalCustomers", totalCustomers);
            req.setAttribute("startCustomer", offset + 1);
            req.setAttribute("endCustomer", offset + customers.size());
            req.setAttribute("genderFilter", genderFilter);
            req.setAttribute("keyword", keyword);
            req.setAttribute("minGrandTotal", minGrandTotal);
            req.setAttribute("maxGrandTotal", maxGrandTotal);
            req.setAttribute("service", "active");

            req.getRequestDispatcher("/WEB-INF/jsp/sale/sale-mycustomer.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi truy xuất dữ liệu khách hàng.");
        }
    }

    private int parseIntOrDefault(String str, int defaultVal) {
        try {
            int value = Integer.parseInt(str);
            return (value > 0) ? value : defaultVal;
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private Double parseDoubleOrNull(String str) {
        try {
            return (str != null && !str.trim().isEmpty()) ? Double.parseDouble(str) : null;
        } catch (Exception e) {
            return null;
        }
    }

}
