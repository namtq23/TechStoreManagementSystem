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
import model.ShopOwnerDTO;

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

}
