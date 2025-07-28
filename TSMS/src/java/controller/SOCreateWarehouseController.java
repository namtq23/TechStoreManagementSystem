/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.BranchDAO;
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
import model.Warehouse;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOCreateWarehouseController", urlPatterns = {"/so-create-warehouse"})
public class SOCreateWarehouseController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-warehouse.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            String warehouseName = req.getParameter("warehouseName");
            String warehouseAddress = req.getParameter("warehouseAddress");
            String warehousePhone = req.getParameter("warehousePhone");

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
            List<Warehouse> warehouses = WareHouseDAO.getWarehouseList(dbName);
            for (Warehouse wh : warehouses) {
                if (wh.getWareHouseName().equalsIgnoreCase(warehouseName)) {
                    req.setAttribute("error", "Kho tổng này đã tồn tại trong hệ thống");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-warehouse.jsp").forward(req, resp);
                    return;
                } else if (wh.getPhone().equalsIgnoreCase(warehousePhone)) {
                    req.setAttribute("error", "Tồn tại kho tổng với số điện thoại này!");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-warehouse.jsp").forward(req, resp);
                    return;
                }
            }

            Warehouse w = new Warehouse();
            w.setWareHouseName(warehouseName);
            w.setWareHouseAddress(warehouseAddress);
            w.setPhone(warehousePhone);
            w.setIsActive(1);

            boolean success = WareHouseDAO.createWarehouse(w, dbName);
            if (success) {
                req.setAttribute("success", "Tạo kho tổng mới thành công!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-warehouse.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Tạo ckho tổng mới thất bại!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-create-warehouse.jsp").forward(req, resp);
            }
        } catch (SQLException ex) {
            Logger.getLogger(SOCreateNewBranchController.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

}
