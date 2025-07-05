/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

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
import model.Warehouse;

/**
 *
 * @author admin
 */
@WebServlet(name = "SOWarehousesController", urlPatterns = {"/so-warehouses"})
public class SOWarehousesController extends HttpServlet {

    private WareHouseDAO warehouseDAO = new WareHouseDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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
            List<Warehouse> warehouses = WareHouseDAO.getWarehouseList(dbName);
            req.setAttribute("warehouses", warehouses);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-warehouses.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", "Lỗi tải danh sách kho tổng");
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-warehouses.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
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
                handleUpdate(req, resp, dbName);
            } else if ("delete".equalsIgnoreCase(action)) {
                handleDelete(req, resp, dbName);
            } else {
                resp.sendRedirect("so-warehouses");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, String dbName) throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(req.getParameter("warehouseId"));
        String name = req.getParameter("warehouseName");
        String address = req.getParameter("address");
        String phone = req.getParameter("phone");
        int isActive = 0;
        if ("true".equalsIgnoreCase(req.getParameter("isActive"))) {
            isActive = 1;
        }

        List<Warehouse> warehouses = WareHouseDAO.getWarehouseList(dbName);
        for (Warehouse warehouse : warehouses) {
            if (warehouse.getWareHouseId() != id) {

                if (warehouse.getWareHouseName().equalsIgnoreCase(name)) {
                    req.setAttribute("error", "Kho hàng này đã tồn tại trong hệ thống");
                    req.setAttribute("warehouses", warehouses);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-warehouses.jsp").forward(req, resp);
                    return;
                }

                if (warehouse.getPhone().equalsIgnoreCase(phone)) {
                    req.setAttribute("error", "Tồn tại kho hàng với số điện thoại này!");
                    req.setAttribute("warehouses", warehouses);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-warehouses.jsp").forward(req, resp);
                    return;
                }
            }
        }

        Warehouse w = new Warehouse();
        w.setWareHouseId(id);
        w.setWareHouseName(name);
        w.setWareHouseAddress(address);
        w.setPhone(phone);
        w.setIsActive(isActive);

        boolean success = warehouseDAO.updateWarehouse(w, dbName);
        UserDAO.updateUsersStatusByWHId(id, isActive, dbName);
        if (success) {
            req.getSession().setAttribute("success", "Cập nhật kho tổng thành công");
            resp.sendRedirect("so-warehouses");
        } else {
            req.setAttribute("error", "Cập nhật kho tổng thất bại");
            doGet(req, resp);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, String dbName) throws SQLException, IOException, ServletException {
        int id = Integer.parseInt(req.getParameter("warehouseId"));

        boolean success = warehouseDAO.deleteWarehouse(id, dbName);

        if (success) {
            req.getSession().setAttribute("success", "Xóa kho tổng thành công");
        } else {
            req.getSession().setAttribute("error", "Xóa kho tổng thất bại");
        }
        resp.sendRedirect("so-warehouses");
    }

}
