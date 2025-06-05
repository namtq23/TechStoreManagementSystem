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
            // Redirect to product list after deletion attempt
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
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");

        if (roleIdObj == null || dbNameObj == null) {
            resp.sendRedirect("login");
            return;
        }

        int roleId = Integer.parseInt(roleIdObj.toString());
        String dbName = dbNameObj.toString();

        String action = req.getParameter("action");
        System.out.println("Action received: " + action); // Debug log

        if (action != null && action.equals("create")) {
            // Lấy thông tin từ form
            String productName = req.getParameter("productName");
            String brand = req.getParameter("brand");
            String category = req.getParameter("category");
            String supplier = req.getParameter("supplier");
            String costPrice = req.getParameter("costPrice");
            String retailPrice = req.getParameter("retailPrice");
            String imgUrl = req.getParameter("imgUrl");
            String isActive = req.getParameter("isActive");

            // Thông tin chi tiết sản phẩm
            String quantityStr = req.getParameter("quantity");
            String description = req.getParameter("description");
            String serialNum = req.getParameter("serialNum");
            String warrantyPeriod = req.getParameter("warrantyPeriod");

            System.out.println("Product data: " + productName + ", " + brand + ", " + quantityStr); // Debug log

            // Kiểm tra đầu vào cơ bản
            if (productName == null || productName.trim().isEmpty()
                    || quantityStr == null || quantityStr.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng nhập đầy đủ tên sản phẩm và số lượng.");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                return;
            }

            try {
                // Tạo đối tượng Product
                Product product = new Product();
                product.setProductName(productName);
                product.setBrand(brand != null ? brand : "");
                product.setCategory(category != null ? category : "");
                product.setSupplier(supplier != null ? supplier : "");
                product.setCostPrice(costPrice != null ? costPrice : "0");
                product.setRetailPrice(retailPrice != null ? retailPrice : "0");
                product.setImgUrl(imgUrl != null ? imgUrl : "");
                product.setIsActive(isActive != null ? isActive : "1");

                System.out.println("Creating product: " + product.toString()); // Debug log

                // Thêm vào bảng Products
                ProductDAO productDAO = new ProductDAO();
                product = productDAO.addProduct(dbName, product);

                if (product == null) {
                    req.setAttribute("error", "Không thể thêm sản phẩm vào database.");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }

                System.out.println("Product created with ID: " + product.getProductId()); // Debug log

                // Tạo đối tượng ProductDTO (ProductDetail)
                int quantity = Integer.parseInt(quantityStr);
                ProductDTO dto = new ProductDTO();
                dto.setProductId(product.getProductId());
                dto.setQuantity(quantity);
                dto.setDescription(description != null ? description : "");
                dto.setSerialNum(serialNum != null ? serialNum : "");
                dto.setWarrantyPeriod(warrantyPeriod != null ? warrantyPeriod : "");

                // Thêm vào bảng ProductDetails
                dto = productDAO.addProductDetail(dbName, dto);
                if (dto == null) {
                    req.setAttribute("error", "Đã thêm sản phẩm nhưng không thêm được chi tiết sản phẩm.");
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }

                System.out.println("ProductDetail created with ID: " + dto.getProductDetailId()); // Debug log

                // Thành công
                req.setAttribute("success", "Đã thêm sản phẩm thành công!");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);

            } catch (NumberFormatException e) {
                System.out.println("Number format error: " + e.getMessage());
                req.setAttribute("error", "Số lượng không hợp lệ.");
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            } catch (Exception e) {
                System.out.println("General error: " + e.getMessage());
                e.printStackTrace();
                req.setAttribute("error", "Lỗi: " + e.getMessage());
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("error", "Hành động không hợp lệ.");
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
        }
    }
}
