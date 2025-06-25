/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
import dao.RoleDAO;
import dao.UserDAO;
import dao.WareHouseDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Branch;
import model.Branch;
import model.Role;
import model.User;
import model.UserDTO;
import model.Warehouse;
import org.mindrot.jbcrypt.BCrypt;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOStaffController", urlPatterns = {"/so-staff"})
public class SOStaffController extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    try {
        HttpSession session = req.getSession(false);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (userIdObj == null || roleIdObj == null || dbNameObj == null || Integer.parseInt(roleIdObj.toString()) != 0) {
            resp.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        String action = req.getParameter("action");

        if ("view".equals(action)) {
            String userID = req.getParameter("userID");
            UserDAO userDAO = new UserDAO();
            UserDTO user = userDAO.getStaffById(dbName, Integer.parseInt(userID));           
            BranchDAO branchDAO = new BranchDAO();
            WareHouseDAO warehouseDAO = new WareHouseDAO();
            List<Branch> branchesList = branchDAO.getAllBranches(dbName);
            List<Warehouse> warehousesList = warehouseDAO.getAllWarehouses(dbName);
            req.setAttribute("staff", user);
            req.setAttribute("branchesList", branchesList);
            req.setAttribute("warehousesList", warehousesList);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/edit-staff.jsp").forward(req, resp);
            return;
        }else if ("delete".equals(action)) {
            String userID = req.getParameter("userID");
            UserDAO userDAO = new UserDAO();
            boolean deleted = userDAO.deleteStaff(dbName, Integer.parseInt(userID));
            if (deleted) {
                session.setAttribute("success", "Sa thải nhân viên thành công!");
            } else {
                session.setAttribute("error", "Sa thải nhân viên thất bại!");
            }
            resp.sendRedirect("so-staff");
            return;
        }
        int page = 1;
        int pageSize = 10;
        Integer status = null;
        Integer role = null;
        String search = req.getParameter("search");

        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        if (req.getParameter("status") != null && !req.getParameter("status").isEmpty()) {
            try {
                status = Integer.parseInt(req.getParameter("status"));
                if (status != 0 && status != 1) {
                    status = null;
                }
            } catch (NumberFormatException e) {
                status = null;
            }
        }

        if (req.getParameter("role") != null && !req.getParameter("role").isEmpty()) {
            try {
                role = Integer.parseInt(req.getParameter("role"));
                if (role < 1 || role > 3) {
                    role = null;
                }
            } catch (NumberFormatException e) {
                role = null;
            }
        }

        UserDAO userDAO = new UserDAO();
        BranchDAO branchDAO = new BranchDAO();
        WareHouseDAO warehouseDAO = new WareHouseDAO();
        List<Branch> branchesList = branchDAO.getAllBranches(dbName);
        List<Warehouse> warehousesList = warehouseDAO.getAllWarehouses(dbName);
        List<UserDTO> staffList = userDAO.getStaffListByPage(dbName, page, pageSize, status, role, search);
        int totalStaff = userDAO.countStaff(dbName, status, role, search);
        int totalPages = (int) Math.ceil((double) totalStaff / pageSize);
        int startStaff = (page - 1) * pageSize + 1;
        int endStaff = Math.min(page * pageSize, totalStaff);

        req.setAttribute("branchesList", branchesList);
        req.setAttribute("warehousesList", warehousesList);
        req.setAttribute("staffList", staffList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalStaff", totalStaff);
        req.setAttribute("startStaff", startStaff);
        req.setAttribute("endStaff", endStaff);
        req.setAttribute("selectedStatus", status);
        req.setAttribute("selectedRole", role);
        req.setAttribute("search", search);

        req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/staff.jsp").forward(req, resp);
    } catch (Exception e) {
        e.printStackTrace();
    }
}


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");
            String genderId = req.getParameter("gender");
            String dob = req.getParameter("dob");
            String address = req.getParameter("address");
            String email = req.getParameter("email");
            String branchId = req.getParameter("branch");
            String whId = req.getParameter("wh");
            String roleId = req.getParameter("role");
            String password = req.getParameter("password");
            String confirmedPassword = req.getParameter("confirmPassword");
            
            HttpSession session = req.getSession(true);
            Object dbNameObj = session.getAttribute("dbName");

            if (!confirmedPassword.equals(password)) {
                session.setAttribute("error", "Mật khẩu không khớp!");
                resp.sendRedirect("so-staff");
                return;
            }

            if (dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }
            
            if (roleId == null){
                session.setAttribute("error", "Hãy chọn vai trò!");
                resp.sendRedirect("so-staff");
                return;
            }

            if ((roleId.contains("1") || roleId.contains("2")) && branchId == null) {
                session.setAttribute("error", "Hãy chọn chi nhánh!");
                resp.sendRedirect("so-staff");
                return;
            }

            if (roleId.contains("3") && whId == null) {
                session.setAttribute("error", "Hãy chọn kho hàng tổng!");
                resp.sendRedirect("so-staff");
                return;
            }
            
            if (!Validate.isValidName(fullName)){
                session.setAttribute("error", "Tên nhân viên không hợp lệ!");
                resp.sendRedirect("so-staff");
                return;
            }
            
            if (!Validate.isValidPhone(phone)){
                session.setAttribute("error", "Số điện thoại không hợp lệ!");
                resp.sendRedirect("so-staff");
                return;
            }
            
            if (!Validate.isValidEmail(email)){
                session.setAttribute("error", "Email không hợp lệ!");
                resp.sendRedirect("so-staff");
                return;
            }

            String dbName = dbNameObj.toString();
            System.out.println("SOStaffController: " + dbName);

            if (UserDAO.isUserAccountTaken(dbName, email, phone)) {
                session.setAttribute("error", "Email hoặc số điện thoại đã tồn tại trong hệ thống của hàng!");
                resp.sendRedirect("so-staff");
                return;
            }

            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            switch (roleId) {
                case "1":
                    User bm = new User(0, hashedPassword, fullName, email, phone, branchId, null, genderId, null, 1, 1, address);
                    UserDAO.insertBranchManagerAndSaleIntoUser(dbName, bm);
                    break;
                case "2":
                    User sale = new User(0, hashedPassword, fullName, email, phone, branchId, null, genderId, null, 2, 1, address);
                    UserDAO.insertBranchManagerAndSaleIntoUser(dbName, sale);
                    break;
                case "3":
                    User wm = new User(0, hashedPassword, fullName, email, phone, null, whId, genderId, null, 3, 1, address);
                    UserDAO.insertBranchManagerAndSaleIntoUser(dbName, wm);
                    break;
            }

            session.setAttribute("success", "Tạo thành công !");
            resp.sendRedirect("so-staff");
        } catch (SQLException ex) {
            Logger.getLogger(SOStaffController.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
