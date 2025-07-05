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
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "BMUpdateInformationController", urlPatterns = {"/bm-information-update"})
public class BMUpdateInformationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            HttpSession session = request.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                response.sendRedirect("login");
                return;
            }

            int roleId = Integer.parseInt(roleIdObj.toString());
            if (roleId != 1) {
                response.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int userId = Integer.parseInt(request.getParameter("userId"));
            String fullName = request.getParameter("fullName");
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
            UserDAO.updateUser(userId, fullName, email, phone, gender, address, dob, identificationID, dbName);
            response.sendRedirect("bm-information?id=" + userId + "&update=success");
        } catch (IOException | NumberFormatException ex) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            response.sendRedirect("bm-information?id=" + userId + "&update=error");
            System.out.println(ex);
        } catch (SQLException ex) {
            Logger.getLogger(BMUpdateInformationController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
