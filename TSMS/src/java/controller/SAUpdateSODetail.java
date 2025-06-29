/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopOwnerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "SAUpdateSODetail", urlPatterns = {"/sa-soUpdate"})
public class SAUpdateSODetail extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            String fullName = request.getParameter("fullName");
            String shopName = request.getParameter("shopName");
            String newDbName = Validate.shopNameConverter(shopName);
            String dbName = request.getParameter("databaseName");
            String status = request.getParameter("status");
            int isActive = "ACTIVE".equals(status) ? 1 : 0;

            ShopOwnerDAO soDao = new ShopOwnerDAO();
            soDao.updateShopOwnerInfo(ownerId, fullName, shopName, isActive);
            soDao.voidUpdateDTBShopName(dbName, newDbName);
            soDao.updateShopOwnerInfoInTheirDTB(newDbName, fullName, isActive);

            response.sendRedirect("sa-sodetails?id=" + ownerId + "&update=success");
        } catch (IOException | NumberFormatException | SQLException ex) {
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            response.sendRedirect("sa-sodetails?id=" + ownerId + "&update=error");
            System.out.println(ex);
        }
    }

}
