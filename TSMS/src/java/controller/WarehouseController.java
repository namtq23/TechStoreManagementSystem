/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import model.BMProductFilter;
import model.ProductDTO;
import util.Validate;

@WebServlet(name = "Quanlykhotong", urlPatterns = {"/wh-products"}) //wh-products
public class WarehouseController extends HttpServlet {

    ProductDAO p = new ProductDAO();
    CategoryDAO c = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object warehouseIdObj = session.getAttribute("warehouseId");

            if (userIdObj == null || warehouseIdObj == null || dbNameObj == null || roleIdObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int roleId = Integer.parseInt(roleIdObj.toString());
            if (roleId != 3) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int warehouseId = Integer.parseInt(warehouseIdObj.toString());

            int page = 1;
            int pageSize = 10;

            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }

            String recordsParam = req.getParameter("recordsPerPage");
            if (recordsParam != null && !recordsParam.isEmpty()) {
                pageSize = Integer.parseInt(recordsParam);
            }

            int offset = (page - 1) * pageSize;

            String[] filterCate = req.getParameterValues("categories");
            String stockStatus = req.getParameter("inventory");
            String searchKeyStr = req.getParameter("search");
            String minPriceStr = req.getParameter("minPrice");
            String maxPriceStr = req.getParameter("maxPrice");
            String status = req.getParameter("status");

            Double minPrice = 0.0;
            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                minPrice = Double.parseDouble(minPriceStr);
            }

            Double maxPrice = 1_000_000_000_000.0;
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceStr);
            }

            String searchKey = "";
            if (searchKeyStr != null) {
                searchKey = Validate.standardizeName(searchKeyStr);
            }

            BMProductFilter filter = new BMProductFilter(filterCate, stockStatus, searchKey, minPrice, maxPrice, status);

            List<ProductDTO> products = p.getWareHouseProductsByFilter(dbName, warehouseId, offset, pageSize, filter);
            int totalProducts = p.getTotalWarehouseProductsByFilter(dbName, warehouseId, filter);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            StringBuilder urlBuilder = new StringBuilder("wh-products?");
            if (filterCate != null) {
                for (String cateId : filterCate) {
                    urlBuilder.append("categories=").append(cateId).append("&");
                }
            }

            if (stockStatus != null && !stockStatus.isEmpty()) {
                urlBuilder.append("inventory=").append(stockStatus).append("&");
            }

            if (searchKeyStr != null && !searchKeyStr.isEmpty()) {
                urlBuilder.append("search=").append(searchKeyStr).append("&");
            }

            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                urlBuilder.append("minPrice=").append(minPriceStr.trim()).append("&");
            }

            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                urlBuilder.append("maxPrice=").append(maxPriceStr.trim()).append("&");
            }

            if (status != null && !status.trim().isEmpty()) {
                urlBuilder.append("status=").append(status.trim()).append("&");
            }

            urlBuilder.append("page=");
            String pagingURL = urlBuilder.toString();

            req.setAttribute("pagingUrl", pagingURL);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("startProduct", offset + 1);
            req.setAttribute("endProduct", Math.min(offset + pageSize, totalProducts));
            req.setAttribute("products", products);

            req.setAttribute("categories", c.getAllCategories(dbName));
            req.setAttribute("recordsPerPage", pageSize);
            req.setAttribute("currentPage", page);

            req.setAttribute("filter", filter);

            req.getRequestDispatcher("/WEB-INF/jsp/warehouse-manager/products.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException | SQLException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Something went wrong.");
        }
    }
}
