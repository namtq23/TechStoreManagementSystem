/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.User;

/**
 *
 * @author admin
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("accountId") != null) {
            
            switch ((int)session.getAttribute("accountId")) {
                    case 1:
                        resp.sendRedirect(req.getContextPath() + "/BrandOwnerTongQuan"); 
                        break;
                    case 2: 
                        resp.sendRedirect(req.getContextPath() + "/..."); 
                        break;
                    case 3: 
                        resp.sendRedirect(req.getContextPath() + "/..."); 
                        break;
                    case 4: 
                        resp.sendRedirect(req.getContextPath() + "/..."); 
                        break;
                }
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            req.setAttribute("error", "Username and password are required");
            req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();

            // Xác thực người dùng
            User user = userDAO.getUserByEmail(username);
            if (user != null && user.getPassword().equals(password)) {
                HttpSession session = req.getSession(true);
                System.out.println(user.getEmail());
                session.setAttribute("accountId", user.getAccountId());
                System.out.println("Session created: " + session.getId());
                System.out.println("accountId set: " + session.getAttribute("accountId"));

                session.setMaxInactiveInterval(1000 * 60 * 60 * 24); 

                String redirectURL;
                
                
                switch (user.getRole()) {
                    case 1: 
                        session.setAttribute("role", "Shop Owner");
                        redirectURL = req.getContextPath() + "/BrandOwnerTongQuan";
                        break;
                    case 2: 
                        session.setAttribute("role", "Branch Manager");
                        redirectURL = req.getContextPath() + "/...";
                        break;
                    case 3: 
                        session.setAttribute("role", "Sale");
                        redirectURL = req.getContextPath() + "/salepage";
                        break;
                    case 4: 
                        session.setAttribute("role", "Warehouse Manger");
                        redirectURL = req.getContextPath() + "/quanlykhotong";
                        break;
                    default:
                        session.setAttribute("role", "Invalid");
                        req.setAttribute("error", "Invalid role. Please contact administrator.");
                        req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
                        return;
                }

                String requestedURL = (String) session.getAttribute("requestedURL");
                if (requestedURL != null) {
                    session.removeAttribute("requestedURL");
                    resp.sendRedirect(requestedURL);
                } else {
                    resp.sendRedirect(redirectURL); 
                }
            } else {
                req.setAttribute("error", "Invalid account");
                req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            }
        } catch (ServletException | IOException | SQLException e) {
            req.setAttribute("error", "An error occurred: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
        }
    }

}
