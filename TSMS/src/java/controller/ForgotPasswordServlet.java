/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.PasswordResetTokenDAO;
import dao.UserDAO;
import jakarta.mail.MessagingException;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.sql.Timestamp;
import model.ShopOwner;
import util.EmailUtil;
import util.TokenGenerator;

/**
 *
 * @author admin
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("WEB-INF/jsp/common/forgot-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        try {
            ShopOwner user = UserDAO.getShopOwnwerByEmail(email);

            if (!UserDAO.isAccountTaken(email, null)) {
                request.setAttribute("error", "Email không tồn tại!");
                request.getRequestDispatcher("/WEB-INF/jsp/common/forgot-password.jsp").forward(request, response);
            }

            if (user != null) {
                String token = TokenGenerator.generateToken();
                Timestamp expiry = new Timestamp(System.currentTimeMillis() + 2 * 60 * 1000);

                PasswordResetTokenDAO.saveToken(user.getOwnerId(), token, expiry);

                String resetLink = request.getRequestURL().toString().replace("forgot-password", "reset-password") + "?token=" + token + "&email=" + email;
                String message = "Click vào đường dẫn sau để đặt lại mật khẩu:\n" + resetLink;

                EmailUtil.sendEmail(email, "Đặt lại mật khẩu", message);

                request.setAttribute("message", "Hãy kiểm tra email của bạn để đặt lại mật khẩu.");
                request.getRequestDispatcher("/WEB-INF/jsp/common/forgot-password.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Email không tồn tại!");
                request.getRequestDispatcher("/WEB-INF/jsp/common/forgot-password.jsp").forward(request, response);
            }
        } catch (MessagingException | ServletException | IOException | SQLException e) {
            request.setAttribute("error", "Lỗi gửi email: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/jsp/common/forgot-password.jsp").forward(request, response);
        }
    }
}
