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
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ShopOwnerDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "SAAccountManaController", urlPatterns = {"/sa-accounts"})
public class SAAccountManaController extends HttpServlet {

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            try {
                UserDAO userDAO = new UserDAO();
                List<ShopOwnerDTO> shopOwners = userDAO.getShopOwners();

                req.setAttribute("shopOwners", shopOwners);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/account-manage.jsp").forward(req, resp);
            } catch (SQLException ex) {
                Logger.getLogger(SAHomeController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

}
