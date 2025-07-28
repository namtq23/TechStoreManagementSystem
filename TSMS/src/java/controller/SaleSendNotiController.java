/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AnnouncementDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.Announcement;

/**
 *
 * @author admin
 */
@WebServlet(name = "SaleSendNotiController", urlPatterns = {"/sale-sendnoti"})
public class SaleSendNotiController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");
        Object branchIdObj = session.getAttribute("branchId");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
            response.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        int branchId = Integer.parseInt(branchIdObj.toString());
        int userId = Integer.parseInt(userIdObj.toString());

        try {
            List<Announcement> receivedList = AnnouncementDAO.getReceivedAnnouncements(dbName, branchId, userId);
            List<Announcement> sentList = AnnouncementDAO.getSentAnnouncements(dbName, userId);

            request.setAttribute("receivedList", receivedList);
            request.setAttribute("sentList", sentList);
            request.getRequestDispatcher("/WEB-INF/jsp/sale/sale-sendnoti.jsp").forward(request, response);
        } catch (ServletException | IOException | SQLException e) {
            response.sendError(500, "Lỗi khi lấy danh sách thông báo");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");
        Object branchIdObj = session.getAttribute("branchId");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
            response.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        int branchId = Integer.parseInt(branchIdObj.toString());
        int userId = Integer.parseInt(userIdObj.toString());

        String title = request.getParameter("title");
        String description = request.getParameter("description");

        try {
            AnnouncementDAO.insertAnnouncement(dbName, userId, branchId, title, description);
            session.setAttribute("successMessage", "Thông báo đã được gửi thành công!");
            response.sendRedirect("sale-sendnoti");
        } catch (SQLException e) {
            response.sendError(500, "Lỗi khi gửi thông báo");
        }
    }
}
