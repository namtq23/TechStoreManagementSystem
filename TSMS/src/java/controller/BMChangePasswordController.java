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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ShopOwner;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author admin
 */
@WebServlet(name = "BMChangePasswordController", urlPatterns = {"/bm-change-password"})
public class BMChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            //Check active status
            if ((Integer) session.getAttribute("isActive") == 0) {
                resp.sendRedirect(req.getContextPath() + "/subscription");
                return;
            }

            int roleId = Integer.parseInt(roleIdObj.toString());
            if (roleId != 1) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int userId = Integer.parseInt(userIdObj.toString());
            String curPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirm = req.getParameter("confirmPassword");
            User u = UserDAO.getUserById(userId, dbName);

            if (!BCrypt.checkpw(curPassword, u.getPassword())) {
                req.setAttribute("error", "Mật khẩu hiện tại không chính xác!");
                req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-change-password.jsp").forward(req, resp);
                return;
            }

            if (!newPassword.equals(confirm)) {
                req.setAttribute("error", "Mật khẩu mới không khớp!");
                req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-change-password.jsp").forward(req, resp);
                return;
            }

            if (newPassword.equals(curPassword)) {
                req.setAttribute("error", "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
                req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-change-password.jsp").forward(req, resp);
                return;
            }

            try {
                if (u.getUserID() != -1) {
                    String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    boolean updatedUser = UserDAO.updateUserPasswordInTheirDTB(dbName, hashed, userId);
                    System.out.println("update user success: " + updatedUser);
                    System.out.println("---------------");

                    req.setAttribute("success", "Đặt lại mật khẩu thành công!");
                    req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-change-password.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Không tìm thấy tài khoản!");
                    req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-change-password.jsp").forward(req, resp);
                }
            } catch (SQLException e) {
                req.setAttribute("error", e);
                req.getRequestDispatcher("/WEB-INF/jsp/manager/bm-change-password.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
