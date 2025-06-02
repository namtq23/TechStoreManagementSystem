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
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.User;

/**
 *
 * @author admin
 */
@WebServlet(name="BMEmployeeController", urlPatterns={"/bm-staff"})
public class BMStaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object staffIdObj = session.getAttribute("staffId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (staffIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int staffId = Integer.parseInt(staffIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            UserDAO userDAO = new UserDAO();
            List<User> staffs = userDAO.getStaffsByBranchID(branchId, dbName);
            req.setAttribute("staffs", staffs);
            req.getRequestDispatcher("/WEB-INF/jsp/manager/staff.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException | SQLException e) {
            System.out.println(e);
        }
    }
    
    

}
