/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
import dao.ShopOwnerDAO;
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

/**
 *
 * @author admin
 */
@WebServlet(name = "SOInformationController", urlPatterns = {"/so-information"})
public class SOInformationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            //Check active status
            if ((Integer) session.getAttribute("isActive") == 0) {
                resp.sendRedirect(req.getContextPath() + "/subscription");
                return;
            }

            int roleId = Integer.parseInt(roleIdObj.toString());
            if (roleId != 0) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();

            User u = UserDAO.getUserById(1, dbName);
            ShopOwnerDTO so = UserDAO.getShopOwnerByEmail(u.getEmail());
            int countBranches = BranchDAO.countBranches(dbName);
            req.setAttribute("user", so);
            req.setAttribute("countBranches", countBranches);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-information.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SOInformationController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
