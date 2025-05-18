/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name = "ControllerServlet", urlPatterns = {"/admin-home", "/sale", "/admin-products"})
public class ControllerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Lay duong dan luu vao bien operation
        String operation = req.getServletPath();

        String contentJsp;
        switch (operation) {
            case "/admin-home":
                contentJsp = "/WEB-INF/jsp/admin/tongquan.jsp";
                break;

            case "/sale":
                contentJsp = "/WEB-INF/jsp/cashier/salepage.jsp";
                break;

            case "/admin-products":
                contentJsp = "/WEB-INF/jsp/admin/products.jsp";
                break;

                
            default:
                resp.sendRedirect(req.getContextPath() + "/home");
                return;
        }
        
        req.setAttribute("contentJsp", contentJsp);
        req.getRequestDispatcher(contentJsp).forward(req, resp);
    }

}
