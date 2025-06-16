/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.PasswordResetTokenDAO;
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
import model.ShopOwner;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author admin
 */
@WebServlet(name = "ResetPasswordServlet", urlPatterns = {"/reset-password"})
public class ResetPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("WEB-INF/jsp/common/reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String token = request.getParameter("token");
            String email = request.getParameter("email");
            String newPassword = request.getParameter("newPassword");
            String confirm = request.getParameter("confirmPassword");
            System.out.println("email lay lai mat khau: " + email);
            System.out.println(newPassword);

            if (!newPassword.equals(confirm)) {
                request.setAttribute("error", "Mật khẩu không khớp!");
                request.getRequestDispatcher("/WEB-INF/jsp/common/reset-password.jsp").forward(request, response);
                return;
            }

            ShopOwner so;
            so = UserDAO.getShopOwnwerByEmail(email);
            String dbName = so.getDatabaseName();
            System.out.println(dbName);

            if (BCrypt.checkpw(newPassword, so.getPassword())) {
                request.setAttribute("error", "Mật khẩu mới trùng với mật khẩu cũ!");
                request.getRequestDispatcher("/WEB-INF/jsp/common/reset-password.jsp").forward(request, response);
                return;
            }

            try {
                int ownerId = PasswordResetTokenDAO.getUserIdByToken(token);
                if (ownerId != -1) {
                    String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    boolean updatedSO = UserDAO.updateSOPassword(ownerId, hashed);
                    boolean updatedUser = UserDAO.updateSOPasswordInTheirDTB(dbName, hashed);
                    System.out.println("update SO success: " + updatedSO);
                    System.out.println("update user success: " + updatedUser);
                    PasswordResetTokenDAO.deleteToken(token);

                    System.out.println("---------------");

                    request.setAttribute("success", "Đặt lại mật khẩu thành công!");
                    request.getRequestDispatcher("/WEB-INF/jsp/common/reset-password.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Token không hợp lệ hoặc đã hết hạn.");
                    request.getRequestDispatcher("/WEB-INF/jsp/common/reset-password.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                request.setAttribute("error", e);
                request.getRequestDispatcher("/WEB-INF/jsp/common/reset-password.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
