/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            Object branchIdObj = session.getAttribute("branchId");

            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());
            int totalProducts = p.countProductsByBranchId(dbName, branchId);
            int page = 1;
            int pageSize;

            if (totalProducts < 30) {
                pageSize = 15;
            } else if (totalProducts < 100) {
                pageSize = 40;
            } else {
                pageSize = totalProducts / 4;
            }

            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            int offset = (page - 1) * pageSize;

//            List<ProductDTO> products = p.getInventoryProductListByPageByBranchId(dbName, branchId, offset, pageSize);
//            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            doPost(req, resp, offset, pageSize);
            List<Category> categories = p.getAllCategories(dbName);
            req.setAttribute("categories", categories);
            req.setAttribute("currentPage", page);
//            req.setAttribute("totalPages", totalPages);
//            req.setAttribute("totalProducts", totalProducts);
//            req.setAttribute("startProduct", offset + 1);
//            req.setAttribute("endProduct", Math.min(offset + pageSize, totalProducts));
//            req.setAttribute("products", products);
            req.getRequestDispatcher("/WEB-INF/jsp/manager/products.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException e) {
            System.out.println(e.getMessage());
        } catch (SQLException ex) {
            Logger.getLogger(BMProductController.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp, int offset, int limit) throws ServletException, IOException, SQLException {
        String[] filterCate = req.getParameterValues("categories");
        String stockStatus = req.getParameter("inventory");
        String searchKeyStr = req.getParameter("search");
        String searchKey = "";
        if (searchKeyStr != null) {
            searchKey = Validate.standardizeName(searchKeyStr);
        }
        System.out.println("11" + filterCate);
        System.out.println("22" + stockStatus);
        System.out.println("33" + searchKey);

        BMProductFilter filter = new BMProductFilter(filterCate, stockStatus, searchKey);
        HttpSession session = req.getSession(true);

        Object dbNameObj = session.getAttribute("dbName");
        Object branchIdObj = session.getAttribute("branchId");

        if (dbNameObj == null || branchIdObj == null) {
            resp.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        int branchId = Integer.parseInt(branchIdObj.toString());
        List<ProductDTO> products = p.getProductsByFilter(dbName, branchId, offset, limit, filter);
        int totalProducts = p.getTotalProductsByFilter(dbName, branchId, filter);
        int totalPages = (int) Math.ceil((double) totalProducts / limit);

        String pagingURL = "";
        StringBuilder urlBuilder = new StringBuilder("bm-products?");

        if (filterCate != null) {
            for (String cateId : filter.getCategories()) {
                urlBuilder.append("categories=").append(cateId).append("&");
            }
        }

        if (stockStatus != null && !stockStatus.isEmpty()) {
            urlBuilder.append("inventory=").append(filter.getInventoryStatus()).append("&");
        }

        if (searchKey != null && !searchKey.isEmpty()) {
            urlBuilder.append("search=").append(filter.getSearchKeyword()).append("&");
        }

        urlBuilder.append("page=");

        pagingURL = urlBuilder.toString();
        req.setAttribute("pagingUrl", pagingURL);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("startProduct", offset + 1);
        req.setAttribute("endProduct", Math.min(offset + 10, totalProducts));
        req.setAttribute("products", products);
    }

}
