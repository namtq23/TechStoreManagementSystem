/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SubscriptionsDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ShopOwnerDTO;
import model.SubscriptionLogDTO;
import model.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOSubscriptionLogsController", urlPatterns = {"/subscription-logs"})
public class SOSubscriptionLogsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();

            User u = UserDAO.getUserById(1, dbName);
            ShopOwnerDTO so = UserDAO.getShopOwnerByEmail(u.getEmail());
            int ownerId = so.getOwnerId();

            int page = 1;
            int pageSize = 10;

            String pageStr = req.getParameter("page");
            if (pageStr != null) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            String fromDateStr = req.getParameter("fromDate");
            String toDateStr = req.getParameter("toDate");

            LocalDate fromDate = fromDateStr != null && !fromDateStr.isEmpty() ? LocalDate.parse(fromDateStr) : LocalDate.now().minusMonths(1);
            LocalDate toDate = toDateStr != null && !toDateStr.isEmpty() ? LocalDate.parse(toDateStr) : LocalDate.now();
            int offset = (page - 1) * pageSize;

            SubscriptionsDAO dao = new SubscriptionsDAO();
            List<SubscriptionLogDTO> logs = dao.getSubscriptionLogsByOwnerId(ownerId, offset, pageSize, fromDate, toDate);
            int totalLogs = dao.countSubscriptionLogsByOwnerId(ownerId, fromDate, toDate);
            int totalPages = (int) Math.ceil((double) totalLogs / pageSize);

            req.setAttribute("logs", logs);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("fromDate", fromDateStr);
            req.setAttribute("toDate", toDateStr);

            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/subscription-logs.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SOSubscriptionLogsController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
