/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopOwnerDAO;
import java.io.IOException;
import java.io.PrintWriter;
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
@WebServlet(name = "SOUpdateInformationController", urlPatterns = {"/so-information-update"})
public class SOUpdateInformationController extends HttpServlet {

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
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");
            java.sql.Date dob = null;

            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    dob = java.sql.Date.valueOf(dobStr); 
                } catch (IllegalArgumentException e) {
                    e.printStackTrace();
                }
            }
            
            String identificationID = request.getParameter("identificationID");
            String address = request.getParameter("address");
            String taxNumber = request.getParameter("taxNumber");
            String webURL = request.getParameter("webURL");

            ShopOwnerDAO soDao = new ShopOwnerDAO();
            soDao.updateShopOwnerInfo(ownerId, fullName, shopName, newDbName, email, identificationID, phone, address, ownerId, taxNumber, webURL, dob);
            soDao.updateShopOwnerInfoInTheirDTB(fullName, email, identificationID, phone, address, ownerId, taxNumber, webURL, dob, dbName);
            soDao.voidUpdateDTBShopName(dbName, newDbName);

            response.sendRedirect("so-information?id=" + ownerId + "&update=success");
        } catch (IOException | NumberFormatException | SQLException ex) {
            int ownerId = Integer.parseInt(request.getParameter("ownerId"));
            response.sendRedirect("so-information?id=" + ownerId + "&update=error");
            System.out.println(ex);
        }
    }

}
