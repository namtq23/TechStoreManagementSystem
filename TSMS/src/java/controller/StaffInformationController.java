/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
import dao.UserDAO;
import dao.WareHouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Branch;
import model.ShopOwnerDTO;
import model.User;
import model.Warehouse;

/**
 *
 * @author admin
 */
@WebServlet(name = "StaffInformationController", urlPatterns = {"/staff-information"})
public class StaffInformationController extends HttpServlet {

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

            int roleId = Integer.parseInt(roleIdObj.toString());
            if (roleId != 1 && roleId != 2 && roleId != 3) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int userId = Integer.parseInt(userIdObj.toString());
            User u1 = UserDAO.getUserById(1, dbName);
            ShopOwnerDTO so = UserDAO.getShopOwnerByEmail(u1.getEmail());
            User u = UserDAO.getUserById(userId, dbName);
            Branch branch = BranchDAO.getBranchById(u.getBranchId(), dbName);
            Warehouse wh = WareHouseDAO.getWarehouseById(u.getWarehouseId(), dbName);

            req.setAttribute("user", u);
            req.setAttribute("branch", branch);
            req.setAttribute("shop", so.getShopName());
            req.setAttribute("wh", wh);
            switch (roleId) {
                case 1:
                    req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-information.jsp").forward(req, resp);
                    break;
                case 2:
                    req.getRequestDispatcher("/WEB-INF/jsp/sale/sale-information.jsp").forward(req, resp);
                    break;
                case 3:
                    req.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/wh-information.jsp").forward(req, resp);
                    break;
            }
        } catch (SQLException ex) {
            Logger.getLogger(SOInformationController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
