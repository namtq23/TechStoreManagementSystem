/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.ProductDAO;
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
import model.Product;
import model.ProductDTO;

/**
 *
 * @author TRIEU NAM
 */
@WebServlet(name = "BrandOwnerHangHoaController", urlPatterns = {"/so-products"}) //so-products
public class SOProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(true);
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");


            if (roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }

            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();

            int page = 1;
            int pageSize = 10;

            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            int offset = (page - 1) * pageSize;


            // Kiểm tra action để hiển thị form thêm sản phẩm
            String action = req.getParameter("action");
            if ("showCreateForm".equals(action)) {
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                return;
            }else if ("delete".equals(action)) {
            // Handle delete action
            String productDetailIdStr = req.getParameter("productDetailId");
            if (productDetailIdStr == null || productDetailIdStr.trim().isEmpty()) {
                req.setAttribute("error", "Không tìm thấy ID chi tiết sản phẩm.");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/products.jsp").forward(req, resp);
                return;
            }

            try {
                int productDetailId = Integer.parseInt(productDetailIdStr);
                // Check for dependencies and delete
                ProductDAO p = new ProductDAO();
                boolean deleted = p.deleteProduct(dbName, productDetailId);
                if (deleted) {
                    req.setAttribute("success", "Xóa sản phẩm thành công!");
                } else {
                    req.setAttribute("error", "Không thể xóa sản phẩm do lỗi hoặc sản phẩm đang được sử dụng.");
                }
            } catch (NumberFormatException e) {
                req.setAttribute("error", "ID chi tiết sản phẩm không hợp lệ.");
            }
     
            

            // Hiển thị danh sách sản phẩm

            ProductDAO p = new ProductDAO();
            List<ProductDTO> products = p.getWarehouseProductList(dbName, 1);
            req.setAttribute("products", products);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/products.jsp").forward(req, resp);

            return;
        }

            // Hiển thị danh sách sản phẩm
            ProductDAO p = new ProductDAO();
            List<ProductDTO> products = p.getWarehouseProductList(dbName, 1);
//            List<ProductDTO> products = p.getWarehouseProductListByPage(dbName, 1, offset, pageSize);
//            int totalProducts = p.countProductsByWarehouseId(dbName, 1);
//            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
//
//            req.setAttribute("currentPage", page);
//            req.setAttribute("totalPages", totalPages);
//            req.setAttribute("totalProducts", totalProducts);
//            req.setAttribute("startProduct", offset + 1);
//            req.setAttribute("endProduct", Math.min(offset + pageSize, totalProducts));
            req.setAttribute("products", products);

            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/products.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException | SQLException  e) {
            System.out.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
        }
    }}


       
