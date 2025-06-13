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
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import model.User;
import org.mindrot.jbcrypt.BCrypt;
import util.DBUtil;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        int role;
        if (session != null && (session.getAttribute("staffId") != null || session.getAttribute("ownerId") != null)) {
            // Nếu đã đăng nhập, chuyển hướng đến trang chính
            role = (Integer) session.getAttribute("roleId");
            switch (role) {
                case 0:
                    resp.sendRedirect(req.getContextPath() + "/so-overview");
                    break;
                case 1:
                    resp.sendRedirect(req.getContextPath() + "/bm-overview");
                    break;
                case 2:
                    resp.sendRedirect(req.getContextPath() + "/sale-product");
                    break;
                case 3:
                    resp.sendRedirect(req.getContextPath() + "/quanlykhotong");
                    break;
                default:
                    throw new AssertionError();
            }
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("email");
        String password = req.getParameter("password");
        String shopName = req.getParameter("shopname");
        String remember = req.getParameter("remember");

        System.out.println(username + password);

        if (username == null || password == null) {
            req.setAttribute("error", "Email hoặc mật khẩu không được để trống");
            req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            return;
        }

        if (shopName == null || shopName.trim().isEmpty()) {
            req.setAttribute("error", "Tên shop không được để trống");
            req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            return;
        }

        try {
            if (!ShopDAO.isShopTaken(shopName)) {
                req.setAttribute("error", "Tên shop không tồn tại!");
                req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
                return;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }

        try {
            String dbNameStaff = Validate.shopNameConverter(shopName);
            User user = userDAO.getUserByEmail(username, dbNameStaff);
            if (user != null && BCrypt.checkpw(password, user.getPassword())) {
                HttpSession session = req.getSession(true);
                System.out.println(user.getEmail());
                session.setAttribute("userId", user.getUserID());
                session.setAttribute("roleId", user.getRoleId());
                session.setAttribute("dbName", dbNameStaff);
                session.setAttribute("branchId", user.getBranchId());
                session.setAttribute("warehouseId", user.getWarehouseId());
                System.out.println("Session created: " + session.getId());
                System.out.println("userId set: " + session.getAttribute("userId"));
                System.out.println("roleId set: " + session.getAttribute("roleId"));
                System.out.println("dbName set: " + session.getAttribute("dbName"));

                session.setMaxInactiveInterval(1000 * 60 * 60 * 24);

                if ("on".equals(remember)) {
                    Cookie userIdCookie = new Cookie("rememberUser", String.valueOf(user.getUserID()));
                    userIdCookie.setMaxAge(7 * 24 * 60 * 60);
                    userIdCookie.setHttpOnly(true);
                    userIdCookie.setPath(req.getContextPath());
                    resp.addCookie(userIdCookie);

                    Cookie dbNameCookie = new Cookie("rememberDb", dbNameStaff);
                    dbNameCookie.setMaxAge(7 * 24 * 60 * 60);
                    dbNameCookie.setHttpOnly(true);
                    dbNameCookie.setPath(req.getContextPath());
                    resp.addCookie(dbNameCookie);
                }

                String redirectURL;

                switch (user.getRoleId()) {
                    case 0: //SO
                        redirectURL = req.getContextPath() + "/so-overview";
                        break;
                    case 1: //BM
                        redirectURL = req.getContextPath() + "/bm-overview";
                        break;
                    case 2: //SALE
                        redirectURL = req.getContextPath() + "/salepage";
                        break;
                    case 3: //WM
                        redirectURL = req.getContextPath() + "/quanlykhotong";
                        break;
                    default:
                        session.setAttribute("role", "Invalid");
                        req.setAttribute("error", "Invalid role. Please contact administrator.");
                        req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
                        return;
                }

                String requestedURL = (String) session.getAttribute("requestedURL");
                if (requestedURL != null) {
                    session.removeAttribute("requestedURL");
                    resp.sendRedirect(requestedURL);
                } else {
                    DBUtil.getConnectionTo(dbNameStaff);
                    resp.sendRedirect(redirectURL);
                }
            } else {
                req.setAttribute("error", "Các thông tin đăng nhập không chính xác!");
                req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            }

        } catch (ServletException | IOException | SQLException e) {
            if (!resp.isCommitted()) {
                req.setAttribute("error", "An error occurred: " + e.getMessage());
                req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            } else {
                System.out.println(e);
            }
        }
    }

}
