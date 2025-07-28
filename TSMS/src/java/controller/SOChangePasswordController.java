/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.PasswordResetTokenDAO;
import dao.ShopDAO;
import dao.ShopOwnerDAO;
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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ShopOwner;
import org.mindrot.jbcrypt.BCrypt;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOChangePasswordController", urlPatterns = {"/so-change-password"})
public class SOChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
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
            if (roleId != 0) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            String curPassword = req.getParameter("currentPassword");
            String newPassword = req.getParameter("newPassword");
            String confirm = req.getParameter("confirmPassword");
            String phone = ShopDAO.getSOPhone(dbName);
            int ownerId = ShopOwnerDAO.getOwnerIdByPhone(phone);
            ShopOwner so = UserDAO.getShopOwnerById(ownerId);
            System.out.println(dbName);

            if (!BCrypt.checkpw(curPassword, so.getPassword())) {
                req.setAttribute("error", "Mật khẩu hiện tại không chính xác!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
                return;
            }

            if (!newPassword.equals(confirm)) {
                req.setAttribute("error", "Mật khẩu mới không khớp!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
                return;
            }

            if (newPassword.equals(curPassword)) {
                req.setAttribute("error", "Mật khẩu mới không được trùng với mật khẩu hiện tại!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
                return;
            }

            if (!Validate.isValidPassword(newPassword)) {
                req.setAttribute("error", "Mật khẩu cần trên 8 chữ số và có ít nhất 1 chữ cái in hoa!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
                return;
            }

            try {
                if (ownerId != -1) {
                    String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    boolean updatedSO = UserDAO.updateSOPassword(ownerId, hashed);
                    boolean updatedUser = UserDAO.updateSOPasswordInTheirDTB(dbName, hashed);
                    System.out.println("update SO success: " + updatedSO);
                    System.out.println("update user success: " + updatedUser);
                    System.out.println("---------------");

                    req.setAttribute("success", "Đặt lại mật khẩu thành công!");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
                } else {
                    req.setAttribute("error", "Không tìm thấy tài khoản!");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
                }
            } catch (SQLException e) {
                req.setAttribute("error", e);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-change-password.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
