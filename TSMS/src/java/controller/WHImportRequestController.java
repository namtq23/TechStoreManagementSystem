/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AnnouncementDAO;
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
import model.Announcement;

/**
 *
 * @author admin
 */
@WebServlet(name = "WHImportRequestController", urlPatterns = {"/wh-import-request"})
public class WHImportRequestController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(true);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");
        Object warehouseIdObj = session.getAttribute("warehouseId");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
            response.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        int warehouseId = Integer.parseInt(warehouseIdObj.toString());
        int userId = Integer.parseInt(userIdObj.toString());

        try {
            List<Announcement> receivedList = AnnouncementDAO.getReceivedAnnouncementsOfWarehouse(dbName, warehouseId, userId);
            List<Announcement> sentList = AnnouncementDAO.getSentAnnouncements(dbName, userId);

            request.setAttribute("receivedList", receivedList);
            request.setAttribute("sentList", sentList);
            request.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/wh-import-request.jsp").forward(request, response);
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
        Object warehouseIdObj = session.getAttribute("warehouseId");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
            response.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        int warehouseId = Integer.parseInt(warehouseIdObj.toString());
        int userId = Integer.parseInt(userIdObj.toString());

        String title = request.getParameter("title");
        String description = request.getParameter("description");

        try {
            AnnouncementDAO.insertAnnouncementOfWH(dbName, userId, warehouseId, title, description);
            session.setAttribute("successMessage", "Thông báo đã được gửi thành công!");
            response.sendRedirect("wh-import-request");
        } catch (SQLException e) {
            response.sendError(500, "Lỗi khi gửi thông báo");
        }
    }

}
