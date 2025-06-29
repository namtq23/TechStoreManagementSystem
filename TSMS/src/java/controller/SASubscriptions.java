/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopOwnerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.ShopOwnerDTO;
import model.ShopOwnerSubsDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "SASubscriptions", urlPatterns = {"/sa-subscriptions"})
public class SASubscriptions extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ShopOwnerDAO soDao = new ShopOwnerDAO();

        String subscription = req.getParameter("subscription");
        String status = req.getParameter("status");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");
        String searchKeyStr = req.getParameter("search");
        String recordsPerPageStr = req.getParameter("recordsPerPage");

        int currentPage = 1;
        int recordsPerPage = 10;
        if (req.getParameter("page") != null) {
            currentPage = Integer.parseInt(req.getParameter("page"));
        }
        if (recordsPerPageStr != null && !recordsPerPageStr.equals("")) {
            recordsPerPage = Integer.parseInt(recordsPerPageStr);
        }

        int offset = (currentPage - 1) * recordsPerPage;

        try {
            List<ShopOwnerSubsDTO> shopOwners = soDao.getFilteredShopOwnersFromLogs(subscription, status, fromDate, toDate, searchKeyStr, offset, recordsPerPage);
            int totalRecords = soDao.countFilteredShopOwnersFromLogs(subscription, status, fromDate, toDate, searchKeyStr);
            int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

            StringBuilder urlBuilder = new StringBuilder("sa-accounts?");

            if (subscription != null && !subscription.isEmpty()) {
                urlBuilder.append("subscription=").append(subscription).append("&");
            }

            if (status != null && !status.isEmpty()) {
                urlBuilder.append("status=").append(status).append("&");
            }

            if (searchKeyStr != null && !searchKeyStr.isEmpty()) {
                urlBuilder.append("search=").append(searchKeyStr).append("&");
            }

            if (fromDate != null && !fromDate.isEmpty()) {
                urlBuilder.append("fromDate=").append(fromDate).append("&");
            }

            if (toDate != null && !toDate.isEmpty()) {
                urlBuilder.append("toDate=").append(toDate).append("&");
            }

            urlBuilder.append("page=");
            String pagingURL = urlBuilder.toString();

            req.setAttribute("pagingUrl", pagingURL);
            req.setAttribute("shopOwners", shopOwners);
            req.setAttribute("currentPage", currentPage);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("recordsPerPage", recordsPerPage);
            req.setAttribute("startUser", offset + 1);
            req.setAttribute("totalRecords", totalRecords);
            req.setAttribute("endUser", Math.min(offset + recordsPerPage, totalRecords));

            // Gửi lại các filter để giữ nguyên trong view
            req.setAttribute("subscription", subscription);
            req.setAttribute("status", status);
            req.setAttribute("fromDate", fromDate);
            req.setAttribute("toDate", toDate);

            req.getRequestDispatcher("/WEB-INF/jsp/admin/sa-subscriptions.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

}
