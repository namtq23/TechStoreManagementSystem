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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.ShopOwner;
import util.DatabaseUtils;

/**
 *
 * @author admin
 */
@WebServlet(name = "RegisterController", urlPatterns = {"/register"})
public class RegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Đảm bảo đọc dữ liệu Unicode

        String fullName = req.getParameter("fullname");
        String shopName = req.getParameter("shopname");
        String password = req.getParameter("password");
        String confirmedPassword = req.getParameter("confirmpassword");
        String email = req.getParameter("email");

        if (fullName == null || password == null || confirmedPassword == null
                || shopName.isEmpty() || password.isEmpty() || email.isEmpty()) {
            req.setAttribute("error", "Please enter full information!");
            req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
            return;
        }

        if (!confirmedPassword.equals(password)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
            return;
        }

        // Tạo tên database riêng cho Shop Owner mới
        String newDbName = "Store_" + shopName;
        try {

            if (UserDAO.isAccountTaken(email)) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
                return;
            }
            // Tạo đối tượng ShopOwner để lưu vào AdminDB
            ShopOwner newOwner = new ShopOwner(0, password, fullName, shopName, newDbName, email);

            // 1. Tạo bản sao TemplateDB thành ShopDB_{username}
            DatabaseUtils.createDatabaseWithSchema(newDbName);

            // 2. Thêm thông tin ShopOwner vào SuperAdminDB
            UserDAO.insertShopOwner(newOwner);

            // 3. Chuyển hướng sang trang thành công
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi ra console (cmd hoặc IDE)

            // Ghi thêm vào response để dễ debug từ trình duyệt (tuỳ chọn)
            resp.setContentType("text/plain");
            resp.getWriter().write("Đã xảy ra lỗi trong quá trình xử lý: " + e.getMessage());
        }
    }

}
