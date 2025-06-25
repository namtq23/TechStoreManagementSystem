/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.OrdersDAO;
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
import java.util.List;
import model.OrdersDTO;
import model.UserDTO;

/**
 *
 * @author Dell
 */
@WebServlet(name="BMOrderController", urlPatterns={"/bm-orders"})
public class BMOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null || branchIdObj == null || Integer.parseInt(roleIdObj.toString()) != 1) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int branchID = Integer.parseInt(branchIdObj.toString());
            int page = 1;
            int pageSize = 10;
            
            // Parse page parameter
            if (req.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            // Parse filter parameters
            String[] selectedCreators = req.getParameterValues("creatorIDs");
            String timeFilter = req.getParameter("timeFilter");
            String customDate = req.getParameter("customDate");
            String minPriceStr = req.getParameter("minPrice");
            String maxPriceStr = req.getParameter("maxPrice");
            
            // Parse search parameter
            String searchKeyword = req.getParameter("search");
            if (searchKeyword != null) {
                searchKeyword = searchKeyword.trim();
                if (searchKeyword.isEmpty()) {
                    searchKeyword = null;
                }
            }
            
            // Calculate start date based on time filter
            String calculatedStartDate = calculateStartDate(timeFilter, customDate);
            
            Double minPrice = null;
            Double maxPrice = null;
            
            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                try {
                    minPrice = Double.parseDouble(minPriceStr);
                } catch (NumberFormatException e) {
                    minPrice = null;
                }
            }
            
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                try {
                    maxPrice = Double.parseDouble(maxPriceStr);
                } catch (NumberFormatException e) {
                    maxPrice = null;
                }
            }

            OrdersDAO orderDAO = new OrdersDAO();
            UserDAO userDAO = new UserDAO();
            String action = req.getParameter("action");

            if ("view".equals(action)) {
                try {
                    int orderID = Integer.parseInt(req.getParameter("orderID"));
                    OrdersDTO order = orderDAO.getOrderById(dbName, orderID);
                    if (order != null && order.getBranchID() == branchID) {
                        req.setAttribute("order", order);
                        req.getRequestDispatcher("/WEB-INF/jsp/manager/edit-order.jsp").forward(req, resp);
                        return;
                    } else {
                        resp.sendRedirect("bm-orders?error=unauthorized");
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("bm-orders?error=view");
                    return;
                }
            }

            // Fetch creators for this branch only
            List<UserDTO> creatorsList = userDAO.getBranchCreators(dbName, branchID);
            
            // Fetch filtered orders for this branch
            List<OrdersDTO> ordersList = orderDAO.getBranchFilteredOrdersListByPage(
                dbName, branchID, page, pageSize, selectedCreators, 
                calculatedStartDate, null, minPrice, maxPrice, searchKeyword
            );
            
            int totalOrders = orderDAO.countBranchFilteredOrders(
                dbName, branchID, selectedCreators, 
                calculatedStartDate, null, minPrice, maxPrice, searchKeyword
            );
            
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
            int startOrder = (page - 1) * pageSize + 1;
            int endOrder = Math.min(page * pageSize, totalOrders);

            // Set attributes
            req.setAttribute("creatorsList", creatorsList);
            req.setAttribute("ordersList", ordersList);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("startOrder", startOrder);
            req.setAttribute("endOrder", endOrder);
            
            // Set filter parameters for maintaining state
            req.setAttribute("selectedCreators", selectedCreators);
            req.setAttribute("timeFilter", timeFilter);
            req.setAttribute("customDate", customDate);
            req.setAttribute("calculatedStartDate", calculatedStartDate);
            req.setAttribute("minPrice", minPrice);
            req.setAttribute("maxPrice", maxPrice);
            req.setAttribute("searchKeyword", searchKeyword);

            req.getRequestDispatcher("/WEB-INF/jsp/manager/order.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Something went wrong.");
        }
    }

    private String calculateStartDate(String timeFilter, String customDate) {
        java.time.LocalDate now = java.time.LocalDate.now();
        java.time.LocalDate startDate;
        
        if (timeFilter == null || timeFilter.isEmpty()) {
            timeFilter = "this-month";
        }
        
        switch (timeFilter) {
            case "today":
                startDate = now;
                break;
            case "this-week":
                startDate = now.with(java.time.DayOfWeek.MONDAY);
                break;
            case "this-month":
                startDate = now.withDayOfMonth(1);
                break;
            case "custom":
                if (customDate != null && !customDate.trim().isEmpty()) {
                    try {
                        startDate = java.time.LocalDate.parse(customDate);
                    } catch (Exception e) {
                        startDate = now.withDayOfMonth(1);
                    }
                } else {
                    startDate = now.withDayOfMonth(1);
                }
                break;
            default:
                startDate = now.withDayOfMonth(1);
                break;
        }
        
        return startDate.toString();
    }
}
