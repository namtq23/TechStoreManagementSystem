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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        try {
            ShopOwner user = UserDAO.getShopOwnwerByEmail(email);

            if (!UserDAO.isAccountTaken(email, null)) {
                request.setAttribute("error", "Có vẻ bạn không phải là chủ chuỗi cửa hàng!");
                request.getRequestDispatcher("/WEB-INF/jsp/common/forgot-password.jsp").forward(request, response);
            }

            if (user != null) {
                String token = TokenGenerator.generateToken();
                Timestamp expiry = new Timestamp(System.currentTimeMillis() + 2 * 60 * 1000);

                PasswordResetTokenDAO.saveToken(user.getOwnerId(), token, expiry);

                String resetLink = request.getRequestURL().toString()
                        .replace("forgot-password", "reset-password")
                        + "?token=" + token + "&email=" + email;

                String message = """
        <div style="font-family: Arial, sans-serif; font-size: 16px; color: #333;">
            <h2 style="color: #1976d2;">Yêu cầu đặt lại mật khẩu</h2>
            <p>Xin chào,</p>
            <p>Chúng tôi đã nhận được yêu cầu đặt lại mật khẩu cho tài khoản của bạn.</p>
            <p>Vui lòng nhấp vào nút bên dưới để thiết lập mật khẩu mới:</p>
            <p style="text-align: center; margin: 24px 0;">
                <a href="%s" style="background-color: #1976d2; color: #fff; text-decoration: none; padding: 12px 20px; border-radius: 6px;">Đặt lại mật khẩu</a>
            </p>
            <p>Nếu bạn không yêu cầu đặt lại mật khẩu, vui lòng bỏ qua email này. Mật khẩu của bạn sẽ không bị thay đổi.</p>
            <hr style="margin: 30px 0; border: none; border-top: 1px solid #eee;">
            <p style="font-size: 14px; color: #777;">TSMS - Hệ thống quản lý cửa hàng</p>
        </div>
        """.formatted(resetLink);

                EmailUtil.sendEmail(email, "Đặt lại mật khẩu - TSMS", message);

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
