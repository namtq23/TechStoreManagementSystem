/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopOwnerDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.ShopOwner;

/**
 *
 * @author admin
 */
@WebServlet(name = "SAApproveSubs", urlPatterns = {"/sa-approved-subs"})
public class SAApproveSubs extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ownerIdStr = request.getParameter("id");

        if (ownerIdStr != null) {
            try {
                int ownerId = Integer.parseInt(ownerIdStr);
                int methodId = Integer.parseInt(request.getParameter("methodId"));
                int subsMonth = Integer.parseInt(request.getParameter("subsMonth"));
                
                ShopOwner so = UserDAO.getShopOwnerById(ownerId);
                ShopOwnerDAO dao = new ShopOwnerDAO();
                dao.activateShopOwnerIfInactive(ownerId);
                UserDAO.activateUsersIfInactive(so.getDatabaseName());
                dao.markSubscriptionLogAsDone(ownerId, methodId);
                dao.updateUserServiceMethod(ownerId, methodId, subsMonth);

                response.sendRedirect("sa-subscriptions?&update=success");
            } catch (NumberFormatException | SQLException e) {
                response.sendRedirect("sa-subscriptions?update=error");
            }
        } else {
            response.sendRedirect("sa-subscriptions?update=error");
        }
    }

}
