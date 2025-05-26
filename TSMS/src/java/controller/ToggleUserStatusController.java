/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author admin
 */
@WebServlet(name = "ToggleUserStatusController", urlPatterns = {"/toggleUserStatus"})
public class ToggleUserStatusController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        int currentStatus = Integer.parseInt(request.getParameter("isActive"));
        int newStatus = (currentStatus == 1) ? 0 : 1;

        UserDAO dao = new UserDAO();
        try {
            dao.updateIsActiveByEmail(email, newStatus);
        } catch (SQLException ex) {
            Logger.getLogger(ToggleUserStatusController.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect("sa-home"); 
    }

}
