/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
import dao.RoleDAO;
import dao.UserDAO;
import dao.WareHouseDAO;
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
import model.UserDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "BMEmployeeController", urlPatterns = {"/bm-staff"})
public class BMStaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            if (roleId != 1) {
                resp.sendRedirect("login");
                return;
            }
            
            UserDAO userDAO = new UserDAO();
            
            int page = 1;
            int pageSize = 10;
            Integer status = null;
            Integer role = null;
            String search = req.getParameter("search");

            if (req.getParameter("page") != null) {
                try {
                    page = Integer.parseInt(req.getParameter("page"));
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            if (req.getParameter("status") != null && !req.getParameter("status").isEmpty()) {
                try {
                    status = Integer.parseInt(req.getParameter("status"));
                    if (status != 0 && status != 1) {
                        status = null;
                    }
                } catch (NumberFormatException e) {
                    status = null;
                }
            }

            if (req.getParameter("role") != null && !req.getParameter("role").isEmpty()) {
                try {
                    role = Integer.parseInt(req.getParameter("role"));
                    if (role < 1 || role > 3) {
                        role = null;
                    }
                } catch (NumberFormatException e) {
                    role = null;
                }
            }
            
            
            List<UserDTO> staffList = userDAO.getStaffListByPage(dbName, page, pageSize, status, 2, search);
            int totalStaff = userDAO.countStaff(dbName, status, 2, search);
            int totalPages = (int) Math.ceil((double) totalStaff / pageSize);
            System.out.println(totalPages + "----------------------");
            int startStaff = (page - 1) * pageSize + 1;
            int endStaff = Math.min(page * pageSize, totalStaff);

            req.setAttribute("staffList", staffList);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalStaff", totalStaff);
            req.setAttribute("startStaff", startStaff);
            req.setAttribute("endStaff", endStaff);
            req.setAttribute("selectedStatus", status);
            req.setAttribute("selectedRole", role);
            req.setAttribute("search", search);
            req.getRequestDispatcher("/WEB-INF/jsp/manager/staff.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException  e) {
            System.out.println(e);
        }
    }

}
