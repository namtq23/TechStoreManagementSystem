/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Branch;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOStaffController", urlPatterns = {"/so-staff"})
public class SOStaffController extends HttpServlet {

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

            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();

            List<Branch> branches = BranchDAO.getBranchList(dbName);
            req.setAttribute("branches", branches);

            req.getRequestDispatcher("WEB-INF/jsp/shop-owner/staff.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SOStaffController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");
            String genderId = req.getParameter("gender");
            String dob = req.getParameter("dob");
            String address = req.getParameter("address");
            String email = req.getParameter("email");
            String branchId = req.getParameter("branch");
            String whId = req.getParameter("wh");
            String roleId = req.getParameter("role");
            String password = req.getParameter("password");
            String confirmedPassword = req.getParameter("confirmPassword");

            HttpSession session = req.getSession(true);
            Object dbNameObj = session.getAttribute("dbName");

            if (!confirmedPassword.equals(password)) {
                req.setAttribute("error", "Mật khẩu không khớp!");
                req.getRequestDispatcher("WEB-INF/jsp/shop-owner/staff.jsp").forward(req, resp);
                return;
            }

            if (dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            if ((roleId.contains("1") || roleId.contains("2")) && branchId.isEmpty()) {
                req.setAttribute("error", "Hãy chọn chi nhánh!");
                req.getRequestDispatcher("WEB-INF/jsp/shop-owner/staff.jsp").forward(req, resp);
                return;
            }

            if (roleId.contains("3") && whId.isEmpty()) {
                req.setAttribute("error", "Hãy chọn kho hàng tổng!");
                req.getRequestDispatcher("WEB-INF/jsp/shop-owner/staff.jsp").forward(req, resp);
                return;
            }

            String dbName = dbNameObj.toString();
            System.out.println("SOStaffController: " + dbName);

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            switch (roleId) {
                case "1":
                    User bm = new User(0, hashedPassword, fullName, email, phone, branchId, null, genderId, null, 1, 1);
                    UserDAO.insertBranchManagerAndSaleIntoUser(dbName, bm);
                    break;
                case "2":
                    User sale = new User(0, hashedPassword, fullName, email, phone, branchId, null, genderId, null, 2, 1);
                    UserDAO.insertBranchManagerAndSaleIntoUser(dbName, sale);
                    break;
                case "3":
                    User wm = new User(0, hashedPassword, fullName, email, phone, null, whId, genderId, null, 3, 1);
                    UserDAO.insertBranchManagerAndSaleIntoUser(dbName, wm);
                    break;
            }

            req.setAttribute("success", "Tạo thành công !");
            req.getRequestDispatcher("WEB-INF/jsp/shop-owner/staff.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SOStaffController.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
