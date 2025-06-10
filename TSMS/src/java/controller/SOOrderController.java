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
import java.util.List;
import model.OrdersDTO;

/**
 *
 * @author Dell
 */
@WebServlet(name="SOOrderController", urlPatterns={"/so-orders"})
public class SOOrderController extends HttpServlet {
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
            int page = 1;
            int pageSize = 10;
            if (req.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            String action = req.getParameter("action");
            if ("view".equals(action)) {
                try{
                int orderId = Integer.parseInt(req.getParameter("orderID"));
            OrdersDAO orderDAO = new OrdersDAO();
            OrdersDTO order = orderDAO.getOrderDetailByOrderId(dbName, orderId);
            List<OrdersDTO> orderDetails = orderDAO.getOrderDetailsByOrderId(dbName, orderId);
            req.setAttribute("orderDetails", orderDetails);
            req.setAttribute("order", order);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/edit-order.jsp").forward(req, resp);
            } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("so-orders?error=view");
                    return;
                }
            }

            OrdersDAO orderDAO = new OrdersDAO();
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
            System.out.println("Error in SOOrderController doGet: " + e.getMessage());
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi lấy danh sách đơn hàng!");
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
            int orderId = Integer.parseInt(req.getParameter("OrderID"));
            String orderStatus = req.getParameter("OrderStatus");
            String notes = req.getParameter("Notes");

            OrdersDAO orderDAO = new OrdersDAO();
            orderDAO.updateOrderStatusAndNotes(dbName, orderId, orderStatus, notes);

            resp.sendRedirect("so-orders");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi cập nhật đơn hàng!");
    }
}
}
