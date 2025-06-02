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
import model.ShopOwner;
import model.User;
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
            role = Integer.parseInt((String) session.getAttribute("roleId"));
            switch (role) {
                case 0: 
                    resp.sendRedirect(req.getContextPath() + "/BrandOwnerTongQuan");
                    break;
                case 1: 
                    resp.sendRedirect(req.getContextPath() + "/...");
                    break;
                case 2: 
                    resp.sendRedirect(req.getContextPath() + "/...");
                    break;
                case 3: 
                    resp.sendRedirect(req.getContextPath() + "/...");
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
        String role = req.getParameter("role");
        String shopName = req.getParameter("shopname");

        System.out.println(username + password);

        if (username == null || password == null) {
            req.setAttribute("error", "Email hoặc mật khẩu không được để trống");
            req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            return;
        }

        if (role == null || role.trim().isEmpty()) {
            req.setAttribute("error", "Vai trò không được để trống");
            req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            return;
        }

        if (shopName == null || shopName.trim().isEmpty()) {
            req.setAttribute("error", "Tên shop không được để trống");
            req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            return;
        }

        try {
            switch (role) {
                case "so":
                    String dbName = Validate.shopNameConverter(shopName);
                    ShopOwner shopOwner;
                    shopOwner = UserDAO.getShopOwnwerByEmail(username);
                    
                    if (!shopOwner.getDatabaseName().equals(dbName)){
                        req.setAttribute("error", "Các thông tin đăng nhập không chính xác!");
                        req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
                        return;
                    }
                    
                    if (shopOwner != null && shopOwner.getPassword().equals(password)) {
                        HttpSession session = req.getSession(true);
                        System.out.println(shopOwner.getEmail());
                        session.setAttribute("ownerId", shopOwner.getOwnerId());
                        session.setAttribute("roleId", "0");
                        session.setAttribute("dbName", dbName);
                        System.out.println("Session created: " + session.getId());
                        System.out.println("ownerId set: " + session.getAttribute("ownerId"));
                        System.out.println("roleId set: " + session.getAttribute("roleId"));
                        System.out.println("dbName set: " + session.getAttribute("dbName"));

                        session.setMaxInactiveInterval(1000 * 60 * 60 * 24);

                        String redirectURL = req.getContextPath() + "/BrandOwnerTongQuan";

                        String requestedURL = (String) session.getAttribute("requestedURL");
                        if (requestedURL != null) {
                            session.removeAttribute("requestedURL");
                            resp.sendRedirect(requestedURL);
                        } else {
                            DBUtil.getConnectionTo(shopOwner.getDatabaseName());
                            resp.sendRedirect(redirectURL);
                        }
                    } else {
                        req.setAttribute("error", "Các thông tin đăng nhập không chính xác!");
                        req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
                    }
                    break;
                case "staff":
                    String dbNameStaff = Validate.shopNameConverter(shopName);
                    User user = userDAO.getUserByEmail(username, dbNameStaff);
                    if (user != null && user.getPassword().equals(password)) {
                        HttpSession session = req.getSession(true);
                        System.out.println(user.getEmail());
                        session.setAttribute("staffId", user.getUserID());
                        session.setAttribute("roleId", user.getRoleId());
                        session.setAttribute("dbName",dbNameStaff);
                        session.setAttribute("branchId",user.getBranchId());
                        System.out.println("Session created: " + session.getId());
                        System.out.println("staffId set: " + session.getAttribute("staffId"));
                        System.out.println("roleId set: " + session.getAttribute("roleId"));
                        System.out.println("dbName set: " + session.getAttribute("dbName"));

                        session.setMaxInactiveInterval(1000 * 60 * 60 * 24);

                        String redirectURL;
                        
                        switch (user.getRoleId()) {
                            case 1:
                                session.setAttribute("role", "Branch Manager");
                                redirectURL = req.getContextPath() + "/bm-overview";
                                break;
                            case 2:
                                session.setAttribute("role", "Sale");
                                redirectURL = req.getContextPath() + "/salepage";
                                break;
                            case 3:
                                session.setAttribute("role", "Warehouse Manger");
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
                    break;
                default:
                    throw new AssertionError();
            }

        } catch (ServletException | IOException | SQLException e) {
            if (!resp.isCommitted()) {
                req.setAttribute("error", "An error occurred: " + e.getMessage());
                req.getRequestDispatcher("/WEB-INF/jsp/common/homelogin.jsp").forward(req, resp);
            } else {
                e.printStackTrace();
            }
        }
    }

}
