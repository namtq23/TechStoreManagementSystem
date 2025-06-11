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
import model.Category;
import model.ProductDTO;

/**
 *
 * @author admin
 */
@WebServlet(name = "BMProductController", urlPatterns = {"/bm-products"})
public class BMProductController extends HttpServlet {

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

            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int branchId = Integer.parseInt(branchIdObj.toString());
            int page = 1;
            int pageSize = 10;

            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            int offset = (page - 1) * pageSize;

            ProductDAO p = new ProductDAO();
            List<ProductDTO> products = p.getInventoryProductListByPageByBranchId(dbName, branchId, offset, pageSize);
            int totalProducts = p.countProductsByBranchId(dbName, branchId);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

            List<Category> categories = p.getAllCategories(dbName);
            req.setAttribute("categories", categories);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("startProduct", offset + 1);
            req.setAttribute("endProduct", Math.min(offset + pageSize, totalProducts));
            req.setAttribute("products", products);
            req.getRequestDispatcher("/WEB-INF/jsp/manager/products.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String[] filterCate = req.getParameterValues("categories");
        String stockStatus = req.getParameter("inventory");
        try {
            if (filterCate.length == 0 || filterCate[0].contains("all")) {
                if (stockStatus.contains("all")) {
                    //Hiển thị hết tất cả sản phẩm
                } else if (stockStatus.contains("in-stock")){
                    //Còn hàng
                } else {
                    //hét hàng
                }
            } 
        } catch (Exception e){
            System.out.println(e);
        }

    }

}
