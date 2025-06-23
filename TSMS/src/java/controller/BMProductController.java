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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.BMProductFilter;
import model.Category;
import model.ProductDTO;
import util.Validate;

/**
 *
 * @author admin
 */
@WebServlet(name = "BMProductController", urlPatterns = {"/bm-products"})
public class BMProductController extends HttpServlet {

    ProductDAO p = new ProductDAO();
    CategoryDAO c = new CategoryDAO();

//    @Override
//    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        try {
//            HttpSession session = req.getSession(true);
//            Object userIdObj = session.getAttribute("userId");
//            Object roleIdObj = session.getAttribute("roleId");
//            Object dbNameObj = session.getAttribute("dbName");
//            Object branchIdObj = session.getAttribute("branchId");
//
//            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
//                resp.sendRedirect("login");
//                return;
//            }
//
//            int roleId = Integer.parseInt(roleIdObj.toString());
//            System.out.println("roleID-authen: " + roleId);
//            if (roleId != 1) {
//                resp.sendRedirect("login");
//                return;
//            }
//
//            String dbName = dbNameObj.toString();
//            
//            int page = 1;
//            int pageSize = 10;
//
//            if (req.getParameter("page") != null) {
//                page = Integer.parseInt(req.getParameter("page"));
//            }
//            
//            String recordsParam = req.getParameter("recordsPerPage");
//            if (recordsParam != null && !recordsParam.isEmpty()) {
//                pageSize = Integer.parseInt(recordsParam);
//            }
//            
//            int offset = (page - 1) * pageSize;
//            doPost(req, resp, offset, pageSize);
//
//            List<Category> categories = p.getAllCategories(dbName);
//            
//            req.setAttribute("categories", categories);
//            req.setAttribute("recordsPerPage", pageSize);
//            req.setAttribute("currentPage", page);
//            req.getRequestDispatcher("/WEB-INF/jsp/manager/products.jsp").forward(req, resp);
//        } catch (ServletException | IOException | NumberFormatException e) {
//            System.out.println(e.getMessage());
//        } catch (SQLException ex) {
//            Logger.getLogger(BMProductController.class.getName()).log(Level.SEVERE, null, ex);
//        }
//    }
//
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp, int offset, int limit) throws ServletException, IOException, SQLException {
//        String[] filterCate = req.getParameterValues("categories");
//        String stockStatus = req.getParameter("inventory");
//        String searchKeyStr = req.getParameter("search");
//
//        String minPriceStr = req.getParameter("minPrice");
//        String maxPriceStr = req.getParameter("maxPrice");
//        String status = req.getParameter("status");
//
//        Double minPrice = 0.0;
//        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
//            minPrice = Double.parseDouble(minPriceStr);
//        }
//        Double maxPrice = 1000000000000000.0;
//        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
//            maxPrice = Double.parseDouble(maxPriceStr);
//        }
//
//        String searchKey = "";
//        if (searchKeyStr != null) {
//            searchKey = Validate.standardizeName(searchKeyStr);
//        }
//
//        System.out.println("11" + filterCate);
//        System.out.println("22" + stockStatus);
//        System.out.println("33" + searchKey);
//        System.out.println("44" + minPriceStr);
//        System.out.println("55" + maxPriceStr);
//        System.out.println("66" + status);
//
//        BMProductFilter filter = new BMProductFilter(filterCate, stockStatus, searchKey, minPrice, maxPrice, status);
//        HttpSession session = req.getSession(true);
//
//        Object dbNameObj = session.getAttribute("dbName");
//        Object branchIdObj = session.getAttribute("branchId");
//
//        if (dbNameObj == null || branchIdObj == null) {
//            resp.sendRedirect("login");
//            return;
//        }
//
//        String dbName = dbNameObj.toString();
//        int branchId = Integer.parseInt(branchIdObj.toString());
//        List<ProductDTO> products = p.getProductsByFilter(dbName, branchId, offset, limit, filter);
//        int totalProducts = p.getTotalProductsByFilter(dbName, branchId, filter);
//        int totalPages = (int) Math.ceil((double) totalProducts / limit);
//
//        String pagingURL = "";
//        StringBuilder urlBuilder = new StringBuilder("bm-products?");
//
//        if (filterCate != null) {
//            for (String cateId : filter.getCategories()) {
//                urlBuilder.append("categories=").append(cateId).append("&");
//            }
//        }
//
//        if (stockStatus != null && !stockStatus.isEmpty()) {
//            urlBuilder.append("inventory=").append(filter.getInventoryStatus()).append("&");
//        }
//
//        if (searchKey != null && !searchKey.isEmpty()) {
//            urlBuilder.append("search=").append(filter.getSearchKeyword()).append("&");
//        }
//
//        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
//            urlBuilder.append("minPrice=").append(minPriceStr.trim()).append("&");
//        }
//
//        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
//            urlBuilder.append("maxPrice=").append(maxPriceStr.trim()).append("&");
//        }
//
//        if (status != null && !status.trim().isEmpty()) {
//            urlBuilder.append("status=").append(status.trim()).append("&");
//        }
//
//        urlBuilder.append("page=");
//        pagingURL = urlBuilder.toString();
//        System.out.println(pagingURL);
//        req.setAttribute("pagingUrl", pagingURL);
//        req.setAttribute("totalPages", totalPages);
//        req.setAttribute("totalProducts", totalProducts);
//        req.setAttribute("startProduct", offset + 1);
//        req.setAttribute("endProduct", Math.min(offset + 10, totalProducts));
//        req.setAttribute("products", products);
//    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null || branchIdObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int roleId = Integer.parseInt(roleIdObj.toString());
            if (roleId != 1) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());

            // --- Xử lý paging ---
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

            // --- Xử lý filter ---
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

            List<ProductDTO> products = p.getProductsByFilter(dbName, branchId, offset, pageSize, filter);
            int totalProducts = p.getTotalProductsByFilter(dbName, branchId, filter);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            // --- Build paging URL giữ lại filter ---
            StringBuilder urlBuilder = new StringBuilder("bm-products?");
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

            // --- Gửi data về JSP ---
            req.setAttribute("pagingUrl", pagingURL);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("startProduct", offset + 1);
            req.setAttribute("endProduct", Math.min(offset + pageSize, totalProducts));
            req.setAttribute("products", products);

            req.setAttribute("categories", c.getAllCategories(dbName));
            req.setAttribute("recordsPerPage", pageSize);
            req.setAttribute("currentPage", page);

            // Truyền filter lại để giữ giá trị input trong form
            req.setAttribute("filter", filter);

            req.getRequestDispatcher("/WEB-INF/jsp/manager/products.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Something went wrong.");
        }
    }

}
