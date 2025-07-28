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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ShopOwnerDTO;
import model.User;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOSubscriptionController", urlPatterns = {"/subscription"})
public class SOSubscriptionController extends HttpServlet {

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

            User user = UserDAO.getUserById(1, dbName);

            Integer status = (Integer) session.getAttribute("isActive");
            if (status != null && status == 0) {
                req.setAttribute("expired", "expired");
            }

            User u = UserDAO.getUserById(1, dbName);
            ShopOwnerDTO so = UserDAO.getShopOwnerByEmail(u.getEmail());
            req.setAttribute("status", so.getStatus());
            req.setAttribute("so", so);
            req.setAttribute("startDate", Validate.toInputDate(so.getSubscriptionStart()));
            req.setAttribute("endDate", Validate.toInputDate(so.getSubscriptionEnd()));

            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/subscribe.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SOSubscriptionController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
