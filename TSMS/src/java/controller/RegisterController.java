/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ShopDAO;
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
import util.DBUtil;
import util.DatabaseUtils;
import util.Validate;

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
        try {
            DBUtil.getConnection();
        } catch (SQLException ex) {
            Logger.getLogger(RegisterController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        String fullName = req.getParameter("fullName");
        String shopName = req.getParameter("shopName");
        String password = req.getParameter("password");
        String confirmedPassword = req.getParameter("confirmPassword");
        String email = req.getParameter("email");

        String newDbName = Validate.shopNameConverter(shopName);
        try {
            if (ShopDAO.isShopTaken(newDbName)){
                System.out.println("11111");
                req.setAttribute("error", "Tên shop đã tồn tại!");
                req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
                return;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RegisterController.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        System.out.println("2222");
        
        if (fullName == null || password == null || confirmedPassword == null
                || shopName.isEmpty() || password.isEmpty() || email.isEmpty()) {
            req.setAttribute("error", "Hãy điền đầy đủ thông tin!");
            req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
            return;
        }

        if (!confirmedPassword.equals(password)) {
            req.setAttribute("error", "Mật khẩu không khớp!");
            req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
            return;
        }
        
        if (!Validate.isValidName(fullName)){
            req.setAttribute("error", "Tên không hợp lệ!");
            req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
            return;
        }
        
        if (!Validate.isValidEmail(email)){
            req.setAttribute("error", "Email không hợp lệ!");
            req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
            return;
        }
        
        try {

            if (UserDAO.isAccountTaken(email)) {
                req.setAttribute("error", "Tài khoản đã tồn tại!");
                req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
                return;
            }
            // Tạo đối tượng ShopOwner để lưu vào AdminDB
            ShopOwner newOwner = new ShopOwner(0, password, fullName, shopName, newDbName, email, null, null, null, null, 1);

            // 1. Tạo bản sao TemplateDB thành ShopDB_{username}
            DatabaseUtils.createDatabaseWithSchema(newDbName);

            // 2. Thêm thông tin ShopOwner vào SuperAdminDB
            UserDAO.insertShopOwner(newOwner);
            UserDAO.insertUserMethod(email);

            // 3. Chuyển hướng sang trang thành công
            resp.sendRedirect(req.getContextPath() + "/login");
        } catch (SQLException e) {
            System.out.println("Đã xảy ra lỗi trong quá trình xử lý: " + e.getMessage());
            req.setAttribute("error", "Đã xảy ra lỗi trong quá trình xử lý: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/common/register.jsp").forward(req, resp);
        }
    }

}
