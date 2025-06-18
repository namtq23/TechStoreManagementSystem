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
import model.ProductDetailDTO;
import util.Validate;

@WebServlet(name = "BrandOwnerHangHoaController", urlPatterns = {"/so-products"})
public class SOProductController extends HttpServlet {

    ProductDAO p = new ProductDAO();

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

            String dbName = dbNameObj.toString();
            int totalProducts = ProductDAO.getTotalProduct(dbName);
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

            doPost(req, resp, offset, pageSize);

            List<Category> categories = p.getAllCategories(dbName);
            req.setAttribute("categories", categories);
            req.setAttribute("currentPage", page);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/products.jsp").forward(req, resp);
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

        String minPriceStr = req.getParameter("minPrice");
        String maxPriceStr = req.getParameter("maxPrice");
        String status = req.getParameter("status");

        Double minPrice = 0.0;
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            minPrice = Double.parseDouble(minPriceStr);
        }
        Double maxPrice = 1000000000000000.0;
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            maxPrice = Double.parseDouble(maxPriceStr);
        }

        String searchKey = "";
        if (searchKeyStr != null) {
            searchKey = Validate.standardizeName(searchKeyStr);
        }

        BMProductFilter filter = new BMProductFilter(filterCate, stockStatus, searchKey, minPrice, maxPrice, status);
        HttpSession session = req.getSession(true);
        Object dbNameObj = session.getAttribute("dbName");

        if (dbNameObj == null) {
            resp.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        List<ProductDetailDTO> products = ProductDAO.getAllProductDetailsByFilter(dbName, offset, limit, filter);
        int totalProducts = ProductDAO.getTotalProductDetailByFilter(dbName, filter);
        int totalPages = (int) Math.ceil((double) totalProducts / limit);

        String pagingURL = "";
        StringBuilder urlBuilder = new StringBuilder("so-products?");

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
        pagingURL = urlBuilder.toString();
        System.out.println(pagingURL);
        req.setAttribute("pagingUrl", pagingURL);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("startProduct", offset + 1);
        req.setAttribute("endProduct", Math.min(offset + 10, totalProducts));
        req.setAttribute("products", products);
    }

}
