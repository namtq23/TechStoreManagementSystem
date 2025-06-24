/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import model.ShopOwnerDTO;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "SAUpdateSODetail", urlPatterns = {"/sa-soUpdate"})
public class SAUpdateSODetail extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        System.out.println(idParam);

        if (idParam == null) {
            response.sendRedirect("sa-home");
            return;
        }

        try {
            int ownerId = Integer.parseInt(idParam);
            ShopOwnerDTO shopOwner = UserDAO.getShopOwnerById(ownerId);

            request.setAttribute("shopOwner", shopOwner);
            request.getRequestDispatcher("/WEB-INF/jsp/admin/update-sodetail.jsp").forward(request, response);

        } catch (NumberFormatException | ServletException | IOException | SQLException e) {
            System.out.println("error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ownerIdStr = req.getParameter("ownerId");
        String fullName = req.getParameter("fullName");
        String shopName = req.getParameter("shopName");
        String subscriptionStr = req.getParameter("subscription");

        if (ownerIdStr == null || fullName == null || shopName == null || subscriptionStr == null
                || fullName.trim().isEmpty() || shopName.trim().isEmpty() || subscriptionStr.trim().isEmpty()) {

            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin.");

            try {
                int ownerId = Integer.parseInt(ownerIdStr);
                ShopOwnerDTO shopOwner = UserDAO.getShopOwnerById(ownerId);
                req.setAttribute("shopOwner", shopOwner);
            } catch (NumberFormatException | SQLException e) {
                e.printStackTrace();
            }

            req.getRequestDispatcher("/WEB-INF/jsp/admin/update-sodetail.jsp").forward(req, resp);
            return;
        }

        try {
            int ownerId = Integer.parseInt(ownerIdStr);
            int subscription = Integer.parseInt(subscriptionStr);

            String newDbName = Validate.shopNameConverter(shopName);
            String oldDbName = ShopDAO.getDatabaseNameByOwnerId(ownerId);

            ShopDAO.updateShopOwnerNameInAdminDB(ownerId, fullName);
            ShopDAO.updateShopOwnerNameInShopDB(oldDbName, fullName);

            if (!newDbName.equalsIgnoreCase(oldDbName)) {
                ShopDAO.updateShopInfo(ownerId, shopName, newDbName);
                ShopDAO.renameDatabase(oldDbName, newDbName);
            }

            switch (subscription) {
                case 1 ->
                    ShopDAO.updateSubscription(ownerId, 3);
                case 2 ->
                    ShopDAO.updateSubscription(ownerId, 6);
                case 3 ->
                    ShopDAO.updateSubscription(ownerId, 12);
                case 4 ->
                    ShopDAO.updateSubscription(ownerId, 24);
            }

            ShopOwnerDTO shopOwner = UserDAO.getShopOwnerById(ownerId);
            req.setAttribute("shopOwner", shopOwner);
            req.setAttribute("success", "Cập nhật thành công!");

        } catch (NumberFormatException | SQLException e) {
            req.setAttribute("error", "Có lỗi xảy ra khi cập nhật.");
        }
        
        req.getRequestDispatcher("/WEB-INF/jsp/admin/update-sodetail.jsp").forward(req, resp);
    }
}
