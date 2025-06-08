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
import model.Category;
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
            Object userIdObj = session.getAttribute("userId");
            Object roleIdObj = session.getAttribute("roleId");
            Object dbNameObj = session.getAttribute("dbName");
            if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
                resp.sendRedirect("login");
                return;
            }
            int userId = Integer.parseInt(userIdObj.toString());
            int roleId = Integer.parseInt(roleIdObj.toString());
            String dbName = dbNameObj.toString();
            int page = 1;
            int pageSize = 10;
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
            String search = req.getParameter("search");
            if (search == null) {
                search = "";
            }
            Integer categoryId = null;
            if (req.getParameter("categoryId") != null && !req.getParameter("categoryId").isEmpty()) {
                try {
                    categoryId = Integer.parseInt(req.getParameter("categoryId"));
                    System.out.println("Nhận được CategoryID: " + categoryId); // Log để kiểm tra
                } catch (NumberFormatException e) {
                    categoryId = null;
                    System.out.println("CategoryID không hợp lệ: " + req.getParameter("categoryId"));
                }
            } else {
                System.out.println("Không nhận được tham số categoryId");
            }
            String inventory = req.getParameter("inventory");
            if (inventory == null) {
                inventory = "all"; // Mặc định là "all"
            }
            // Kiểm tra action để hiển thị form thêm sản phẩm
            String action = req.getParameter("action");
            if ("showCreateForm".equals(action)) {
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                return;

            } else if ("view".equals(action)) {
                try {
                    int productDetailId = Integer.parseInt(req.getParameter("productDetailId"));
                    ProductDAO dao = new ProductDAO();
                    ProductDTO product = dao.getProductByDetailId(dbName, productDetailId);
                    req.setAttribute("product", product);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/edit-products.jsp").forward(req, resp);
                    return;
                } catch (Exception e) {
                    e.printStackTrace();
                    resp.sendRedirect("so-products?error=view");
                    return;
                }
            }

            // Hiển thị danh sách sản phẩm
            
            ProductDAO p = new ProductDAO();
//            List<ProductDTO> products = p.getWarehouseProductList(dbName, 1);
            List<ProductDTO> products = p.getWarehouseProductListByPageAndCategory(dbName, 1, page, pageSize,search,categoryId,inventory);
            int totalProducts = p.countProductsByWarehouseIdAndCategory(dbName, 1,search,categoryId,inventory);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            int startProduct = (page - 1) * pageSize + 1;
            int endProduct = Math.min(page * pageSize, totalProducts);
            List<Category> categories = p.getAllCategories(dbName);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalProducts", totalProducts);
            req.setAttribute("startProduct", startProduct);
            req.setAttribute("endProduct", endProduct);
            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.setAttribute("selectedCategoryId", categoryId);
            req.setAttribute("selectedInventory", inventory);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/products.jsp").forward(req, resp);
        } catch (ServletException | IOException | NumberFormatException e) {
            System.out.println("Error in doGet: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Object userIdObj = session.getAttribute("userId");
        Object roleIdObj = session.getAttribute("roleId");
        Object dbNameObj = session.getAttribute("dbName");
        if (userIdObj == null || roleIdObj == null || dbNameObj == null) {
            resp.sendRedirect("login");
            return;
        }
        int userId = Integer.parseInt(userIdObj.toString());
        int roleId = Integer.parseInt(roleIdObj.toString());
        String dbName = dbNameObj.toString();
        String action = req.getParameter("action");

        if ("showCreateForm".equals(action)) {
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
        } else if ("create".equals(action)) {
            // Xử lý thêm mới sản phẩm

        } else if ("update".equals(action)) {
            try {
                int productDetailId = Integer.parseInt(req.getParameter("productDetailId"));
                String productName = req.getParameter("productName");
                String costPrice = req.getParameter("costPrice");
                String retailPrice = req.getParameter("retailPrice");
                String isActive = req.getParameter("isActive");
                ProductDAO dao = new ProductDAO();
                dao.updateProductInfo(dbName, productDetailId, productName, costPrice, retailPrice, isActive);
                resp.sendRedirect("so-products");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("so-products?error=update");
            }
        } else if ("delete".equals(action)) {
            try {
                String productDetailIdParam = req.getParameter("productDetailId");
                System.out.println("productDetailId param = " + productDetailIdParam);
                int productDetailId = Integer.parseInt(productDetailIdParam);
                ProductDAO dao = new ProductDAO();
                dao.deleteProductAndDetail(dbName, productDetailId);
                resp.sendRedirect("so-products");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("so-products?error=delete");
            }
        }
    }

//    public static void main(String[] args) {
//        String dbName = "DTB_Kien"; // Tên database của bạn
//        Integer categoryId = 1; // Thay bằng categoryId bạn muốn test
//        
//        ProductDAO dao = new ProductDAO();
//
//        try {
//            List<ProductDTO> products = dao.getWarehouseProductListByPageAndCategory(dbName, 1, 1, 10, "", categoryId,inventory);
//            System.out.println("Kết quả lọc với categoryId: " + categoryId);
//            for (ProductDTO product : products) {
//                System.out.println("ProductDetailID: " + product.getProductDetailId() + ", Name: " + product.getProductName());
//            }
//            if (products.isEmpty()) {
//                System.out.println("Không tìm thấy sản phẩm nào với categoryId: " + categoryId);
//            }
//        } catch (Exception e) {
//            System.out.println("Lỗi khi lọc: " + e.getMessage());
//            e.printStackTrace();
//        }
//    }
}
