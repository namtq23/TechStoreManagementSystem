/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
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
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Branch;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOBranchesController", urlPatterns = {"/so-branches"})
public class SOBranchesController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

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

            List<Branch> branches = BranchDAO.getBranchList(dbName);
            req.setAttribute("branches", branches);

            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-branches.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SOBranchesController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            String message = "";
            boolean isError = false;

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

            try {
                if ("update".equalsIgnoreCase(action)) {
                    int branchId = Integer.parseInt(req.getParameter("branchId"));
                    String branchName = req.getParameter("branchName");
                    String address = req.getParameter("address");
                    String phone = req.getParameter("phone");
                    boolean isActive = "true".equalsIgnoreCase(req.getParameter("isActive"));

                    List<Branch> branches = BranchDAO.getBranchList(dbName);
                    for (Branch branch : branches) {
                        if (branch.getBranchId() != branchId) { 

                            if (branch.getBranchName().equalsIgnoreCase(branchName)) {
                                req.setAttribute("error", "Chi nhánh này đã tồn tại trong hệ thống");
                                req.setAttribute("branches", branches);
                                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-branches.jsp").forward(req, resp);
                                return;
                            }

                            if (branch.getPhone().equalsIgnoreCase(phone)) {
                                req.setAttribute("error", "Tồn tại chi nhánh với số điện thoại này!");
                                req.setAttribute("branches", branches);
                                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-branches.jsp").forward(req, resp);
                                return;
                            }
                        }
                    }

                    // Gọi DAO để cập nhật chi nhánh
                    BranchDAO.updateBranch(branchId, branchName, address, phone, isActive, dbName);
                    UserDAO.updateUsersStatusByBranchId(branchId, isActive, dbName);
                    message = "Cập nhật chi nhánh thành công!";

                } else if ("delete".equalsIgnoreCase(action)) {
                    int branchId = Integer.parseInt(req.getParameter("branchId"));

                    // Gọi DAO để xoá chi nhánh
                    BranchDAO.deleteBranch(branchId, dbName);
                    message = "Xóa chi nhánh thành công!";
                } else {
                    isError = true;
                    message = "Hành động không hợp lệ!";
                }
            } catch (NumberFormatException | SQLException ex) {
                isError = true;
                message = "Có lỗi xảy ra khi xử lý: " + ex.getMessage();
            }

            if (isError) {
                req.setAttribute("error", message);
            } else {
                req.setAttribute("success", message);
            }

            List<Branch> branches = BranchDAO.getBranchList(dbName);
            req.setAttribute("branches", branches);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-branches.jsp").forward(req, resp);
        } catch (SQLException ex) {
            Logger.getLogger(SOBranchesController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
