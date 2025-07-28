/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
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
@WebServlet(name = "SOCreateNewBranchController", urlPatterns = {"/so-create-branch"})
public class SOCreateNewBranchController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-branch.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            String branchName = req.getParameter("branchName");
            String branchAddress = req.getParameter("branchAddress");
            String branchPhone = req.getParameter("branchPhone");

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
            for (Branch branch : branches) {
                if (branch.getBranchName().equalsIgnoreCase(branchName)) {
                    req.setAttribute("error", "Chi nhánh này đã tồn tại trong hệ thống");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-branch.jsp").forward(req, resp);
                    return;
                } else if (branch.getPhone().equalsIgnoreCase(branchPhone)) {
                    req.setAttribute("error", "Tồn tại chi nhánh với số điện thoại này!");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-branch.jsp").forward(req, resp);
                    return;
                }
            }

            boolean rs = BranchDAO.insertBranch(dbName, branchName, branchAddress, branchPhone);
            BranchDAO.insertInventoryOfEachBranch(dbName);
            if (rs) {
                req.setAttribute("success", "Tạo chi nhánh mới thành công!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-branch.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Tạo chi nhánh mới thất bại!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-branch.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SOCreateNewBranchController.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
