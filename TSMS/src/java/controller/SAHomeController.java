/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopOwnerDAO;
import dao.SubscriptionsDAO;
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
import model.ShopOwner;
import model.ShopOwnerSADTO;
import model.SubscriptionLogDTO;
import model.SubscriptionsDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "SAHomeController", urlPatterns = {"/sa-home"})
public class SAHomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            ShopOwnerSADTO so = ShopOwnerDAO.getDashboardAboutSO();
            List<SubscriptionsDTO> subsList = SubscriptionsDAO.getAllSubscriptionSummaryByMethodId(1);
            List<SubscriptionLogDTO> logs = SubscriptionsDAO.getAllSubscriptionLogs();
            
            req.setAttribute("subscriptionLogs", logs);
            req.setAttribute("subsList", subsList);
            req.setAttribute("so", so);
            req.getRequestDispatcher("/WEB-INF/jsp/admin/sa-home.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SAHomeController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
