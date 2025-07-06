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
import java.util.Arrays;
import java.util.List;
import model.Branch;
import model.OrdersDTO;
import model.UserDTO;

/**
 *
 * @author Dell
 */
@WebServlet(name = "SOOrderController", urlPatterns = {"/so-orders"})
public class SOOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
                resp.sendRedirect("login");
                return;
            }

            //Check active status
            if ((Integer) session.getAttribute("isActive") == 0) {
                resp.sendRedirect(req.getContextPath() + "/subscription");
                return;
            }

            String dbName = dbNameObj.toString();

            OrdersDAO orderDAO = new OrdersDAO();
            String action = req.getParameter("action");
            if ("view".equals(action)) {
                try {
                    int orderID = Integer.parseInt(req.getParameter("orderID"));
                    OrdersDTO order = orderDAO.getOrderBasicInfo(dbName, orderID);
                    List<OrdersDTO> orderProducts = orderDAO.getOrderProductsById(dbName, orderID);
                    req.setAttribute("order", order);
                    req.setAttribute("orderProducts", orderProducts);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/edit-order.jsp").forward(req, resp);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("so-orders?error=view");
                    return;
                }
            }

            int page = 1;
            int pageSize = 10;
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            String selectedBranch = req.getParameter("branchID");
            String[] selectedCreators = req.getParameterValues("creatorIDs");
            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");
            String minPriceStr = req.getParameter("minPrice");
            String maxPriceStr = req.getParameter("maxPrice");

            Double minPrice = null;
            Double maxPrice = null;
            String searchKeyword = req.getParameter("search");

            if (searchKeyword != null) {
                searchKeyword = searchKeyword.trim();
                if (searchKeyword.isEmpty()) {
                    searchKeyword = null;
                }
            }

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

            UserDAO userDAO = new UserDAO();
            List<Branch> branchesList = orderDAO.getAllBranches(dbName);
            List<UserDTO> creatorsList = userDAO.getAllCreators(dbName);

            List<OrdersDTO> ordersList = orderDAO.getFilteredOrdersListByPage(
                    dbName, page, pageSize, selectedBranch, selectedCreators,
                    startDate, endDate, minPrice, maxPrice, searchKeyword
            );

            int totalOrders = orderDAO.countFilteredOrders(
                    dbName, selectedBranch, selectedCreators,
                    startDate, endDate, minPrice, maxPrice, searchKeyword
            );

            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
            int startOrder = (page - 1) * pageSize + 1;
            int endOrder = Math.min(page * pageSize, totalOrders);

            // Set attributes
            req.setAttribute("branchesList", branchesList);
            req.setAttribute("creatorsList", creatorsList);
            req.setAttribute("ordersList", ordersList);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("startOrder", startOrder);
            req.setAttribute("endOrder", endOrder);

            req.setAttribute("selectedBranch", selectedBranch);
            req.setAttribute("selectedCreators", selectedCreators);
            req.setAttribute("startDate", startDate);
            req.setAttribute("endDate", endDate);
            req.setAttribute("minPrice", minPrice);
            req.setAttribute("maxPrice", maxPrice);
            req.setAttribute("searchKeyword", searchKeyword);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/orderpage.jsp").forward(req, resp);
        } catch (Exception e) {
            System.out.println(e);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/orderpage.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            String action = req.getParameter("action");
            if ("update".equals(action)) {
                try {
                    int orderID = Integer.parseInt(req.getParameter("orderID"));
                    String orderStatus = req.getParameter("orderStatus");
                    String notes = req.getParameter("notes");
                    OrdersDAO orderDAO = new OrdersDAO();
                    OrdersDTO order = orderDAO.getOrderById(dbName, orderID);
                    order.setOrderStatus(orderStatus);
                    order.setNotes(notes);
                    orderDAO.updateOrderDetails(dbName, order);
                    resp.sendRedirect("so-orders?success=update");
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("so-orders?error=update");
                }
                return;
            } else if ("delete".equals(action)) {
                try {
                    String orderIdParam = req.getParameter("orderID");
                    int orderID = Integer.parseInt(orderIdParam);
                    OrdersDAO orderDAO = new OrdersDAO();
                    OrdersDTO order = orderDAO.getOrderById(dbName, orderID);
                    orderDAO.deleteOrder(dbName, orderID);
                    resp.sendRedirect("so-orders?success=delete");
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("so-orders?&error=delete");
                }
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
