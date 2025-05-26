/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AdminDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.Admin;

/**
 *
 * @author admin
 */
@WebServlet(name = "SALoginController", urlPatterns = {"/sa-login"})
public class SALoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("accountId") != null) {
            resp.sendRedirect(req.getContextPath() + "/sa-home");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/admin/sa-login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            req.setAttribute("error", "Username and password are required");
            req.getRequestDispatcher("/WEB-INF/jsp/admin/sa-login.jsp").forward(req, resp);
            return;
        }

        try {
            AdminDAO adminDAO = new AdminDAO();

            // Xác thực người dùng
            Admin admin = adminDAO.getAdmin(username);
            if (admin != null && admin.getPassword().equals(password)) {
                HttpSession session = req.getSession(true);
                System.out.println(admin.getEmail());
                session.setAttribute("adminId", admin.getAdminId());
                System.out.println("Session created: " + session.getId());
                System.out.println("adminId set: " + session.getAttribute("adminId"));

                session.setMaxInactiveInterval(1000 * 60 * 60 * 24);

                String redirectURL = req.getContextPath() + "/sa-home";

                String requestedURL = (String) session.getAttribute("requestedURL");
                if (requestedURL != null) {
                    session.removeAttribute("requestedURL");
                    resp.sendRedirect(requestedURL);
                } else {
                    resp.sendRedirect(redirectURL);
                }
            } else {
                req.setAttribute("error", "Invalid account");
                req.getRequestDispatcher("/WEB-INF/jsp/admin/sa-login.jsp").forward(req, resp);
            }
        } catch (ServletException | IOException | SQLException e) {
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/admin/sa-login.jsp").forward(req, resp);
        }
    }

}
