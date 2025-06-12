/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrdersDAO;
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
import model.OrdersDTO;

/**
 *
 * @author Dell
 */
@WebServlet(name = "SOOrderController", urlPatterns = {"/so-orders"})
public class SOOrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false); // Use false to avoid creating a new session
            Object userIdObj = session != null ? session.getAttribute("userId") : null;
            Object roleIdObj = session != null ? session.getAttribute("roleId") : null;
            Object dbNameObj = session != null ? session.getAttribute("dbName") : null;

            if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int page = 1;
            int pageSize = 10;
            if (req.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            OrdersDAO orderDAO = new OrdersDAO();
            String action = req.getParameter("action");

            if ("view".equals(action)) {
                try {
                    int orderID = Integer.parseInt(req.getParameter("orderID"));
                    OrdersDTO order = orderDAO.getOrderById(dbName, orderID);
                    req.setAttribute("order", order);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/edit-order.jsp").forward(req, resp);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("so-orders?error=view");
                    return;
                }
            }

            List<OrdersDTO> ordersList = orderDAO.getOrdersListByPage(dbName, page, pageSize);
            int totalOrders = orderDAO.countOrderDetails(dbName);
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

            int startOrder = (page - 1) * pageSize + 1;
            int endOrder = Math.min(page * pageSize, totalOrders);

            req.setAttribute("ordersList", ordersList);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalOrders", totalOrders);
            req.setAttribute("startOrder", startOrder);
            req.setAttribute("endOrder", endOrder);

            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/orderpage.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
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
