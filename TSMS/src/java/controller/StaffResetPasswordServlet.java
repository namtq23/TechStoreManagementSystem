/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.PasswordResetTokenDAO;
import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author admin
 */
@WebServlet(name="StaffResetPasswordServlet", urlPatterns={"/staff-reset-password"})
public class StaffResetPasswordServlet extends HttpServlet {
   
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("WEB-INF/jsp/common/staff-reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String token = request.getParameter("token");
            String email = request.getParameter("email");
            String dbName = request.getParameter("db");
            System.out.println(dbName);
            String newPassword = request.getParameter("newPassword");
            String confirm = request.getParameter("confirmPassword");

            if (!newPassword.equals(confirm)) {
                request.setAttribute("error", "Mật khẩu không khớp!");
                request.getRequestDispatcher("/WEB-INF/jsp/common/staff-reset-password.jsp").forward(request, response);
                return;
            }

            User u;
            u = UserDAO.getUserByEmail(email, dbName);

            if (BCrypt.checkpw(newPassword, u.getPassword())) {
                request.setAttribute("error", "Mật khẩu mới trùng với mật khẩu cũ!");
                request.getRequestDispatcher("/WEB-INF/jsp/common/staff-reset-password.jsp").forward(request, response);
                return;
            }

            try {
                int userId = PasswordResetTokenDAO.getUserIdByTokenInEachShop(token, dbName);
                if (userId != -1) {
                    String hashed = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                    boolean updatedUser = UserDAO.updateUserPasswordInTheirDTB(dbName, hashed, userId);
                    System.out.println("update user success: " + updatedUser);
                    PasswordResetTokenDAO.deleteTokenInEachShop(token, dbName);

                    System.out.println("---------------");

                    request.setAttribute("success", "Đặt lại mật khẩu thành công!");
                    request.getRequestDispatcher("/WEB-INF/jsp/common/staff-reset-password.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "Phiên đổi mật khẩu đã hết hạn, vui lòng thực hiện lại yêu cầu!");
                    request.getRequestDispatcher("/WEB-INF/jsp/common/staff-reset-password.jsp").forward(request, response);
                }
            } catch (SQLException e) {
                request.setAttribute("error", e);
                request.getRequestDispatcher("/WEB-INF/jsp/common/staff-reset-password.jsp").forward(request, response);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ResetPasswordServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
