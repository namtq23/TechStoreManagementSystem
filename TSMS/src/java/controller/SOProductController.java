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
import model.ProductDetailDTO;
import util.Validate;

@WebServlet(name = "BrandOwnerHangHoaController", urlPatterns = {"/so-products"})
public class SOProductController extends HttpServlet {

    ProductDAO p = new ProductDAO();
    CategoryDAO c = new CategoryDAO();

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
            String action = req.getParameter("action");
            if ("view".equals(action)) {
                String productDetailIdStr = req.getParameter("productDetailId");
                if (productDetailIdStr != null && !productDetailIdStr.trim().isEmpty()) {
                    try {
                        int productDetailId = Integer.parseInt(productDetailIdStr);
                        ProductDetailDTO product = ProductDAO.getProductDetailById(dbName, productDetailId);
                            String brandName = ProductDAO.getBrandNameById(dbName, product.getBrandID());
                            String categoryName = ProductDAO.getCategoryNameById(dbName, product.getCategoryID());
                            String supplierName = ProductDAO.getSupplierNameById(dbName, product.getSupplierID());                           
                            req.setAttribute("product", product);
                            req.setAttribute("brandName", brandName);
                            req.setAttribute("categoryName", categoryName);
                            req.setAttribute("supplierName", supplierName);
                            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/product-detail.jsp").forward(req, resp);
                            return;
                    } catch (NumberFormatException e) {
                        resp.sendRedirect("so-products?page=1&error=invalid");
                        return;
                    }
                }
            }
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

            List<Category> categories = c.getAllCategories(dbName);
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        Object dbNameObj = session.getAttribute("dbName");

        if (dbNameObj == null) {
            resp.sendRedirect("login");
            return;
        }

        String dbName = dbNameObj.toString();
        String action = req.getParameter("action");
        String id = req.getParameter("productDetailId");
        int productDetailID = Integer.parseInt(id);
        if ("delete".equals(action)) {
            try {
                ProductDAO dat = new ProductDAO();
                dat.deleteProductAndDetail(dbName, productDetailID);
                resp.sendRedirect("so-products?page=1");
            } catch (SQLException ex) {
                Logger.getLogger(SOProductController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }else if ("update".equals(action)) {
            try {
                String description = req.getParameter("description");
                String costPriceStr = req.getParameter("costPrice");
                String retailPriceStr = req.getParameter("retailPrice");
                String isActiveStr = req.getParameter("isActive");
                StringBuilder errors = new StringBuilder();
                
                if (description == null || description.trim().isEmpty()) {
                    errors.append("Mô tả không được để trống. ");
                } else if (description.trim().length() < 10) {
                    errors.append("Mô tả phải có ít nhất 10 ký tự. ");
                } else if (description.trim().length() > 1000) {
                    errors.append("Mô tả không được vượt quá 1000 ký tự. ");
                }
                
                double costPrice = 0;
                double retailPrice = 0;
                description = description.trim();
                try {
                    if (costPriceStr == null || costPriceStr.trim().isEmpty()) {
                        errors.append("Giá vốn không được để trống. ");
                    } else {
                        costPrice = Double.parseDouble(costPriceStr.trim());
                        if (costPrice <= 0) {
                            errors.append("Giá vốn phải lớn hơn 0. ");
                        } else if (costPrice > 999999999) {
                            errors.append("Giá vốn không được vượt quá 999,999,999 VNĐ. ");
                        }
                    }
                } catch (NumberFormatException e) {
                    errors.append("Giá vốn không hợp lệ. ");
                }
                
                try {
                    if (retailPriceStr == null || retailPriceStr.trim().isEmpty()) {
                        errors.append("Giá bán không được để trống. ");
                    } else {
                        retailPrice = Double.parseDouble(retailPriceStr.trim());
                        if (retailPrice <= 0) {
                            errors.append("Giá bán phải lớn hơn 0. ");
                        } else if (retailPrice > 999999999) {
                            errors.append("Giá bán không được vượt quá 999,999,999 VNĐ. ");
                        }
                    }
                } catch (NumberFormatException e) {
                    errors.append("Giá bán không hợp lệ. ");
                }
                
                // Validate retail price > cost price
                if (costPrice > 0 && retailPrice > 0 && retailPrice <= costPrice) {
                    errors.append("Giá bán phải lớn hơn giá vốn. ");
                }
                
                // Validate status
                if (isActiveStr == null || (!isActiveStr.equals("0") && !isActiveStr.equals("1"))) {
                    errors.append("Trạng thái không hợp lệ. ");
                }
                
                if (errors.length() > 0) {
                    // Có lỗi validation - lưu lại dữ liệu và lỗi để hiển thị
                    req.setAttribute("errorMessage", errors.toString().trim());
                    req.setAttribute("inputDescription", description);
                    req.setAttribute("inputCostPrice", costPriceStr);
                    req.setAttribute("inputRetailPrice", retailPriceStr);
                    req.setAttribute("inputIsActive", isActiveStr);
                    
                    ProductDetailDTO product = ProductDAO.getProductDetailById(dbName, productDetailID);
                    String brandName = ProductDAO.getBrandNameById(dbName, product.getBrandID());
                    String categoryName = ProductDAO.getCategoryNameById(dbName, product.getCategoryID());
                    String supplierName = ProductDAO.getSupplierNameById(dbName, product.getSupplierID());
                    
                    req.setAttribute("product", product);
                    req.setAttribute("brandName", brandName);
                    req.setAttribute("categoryName", categoryName);
                    req.setAttribute("supplierName", supplierName);                    
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/product-detail.jsp").forward(req, resp);
                    return;
                }
                
                boolean isActive = "1".equals(isActiveStr);                
                ProductDAO dao = new ProductDAO();
                boolean success = dao.updateProductDetailLimited(dbName, productDetailID, description, 
                    costPrice, retailPrice, isActive);
                
                if (success) {
                    session.setAttribute("successMessage", "Cập nhật thông tin sản phẩm thành công!");
                    resp.sendRedirect("so-products?action=view&productDetailId=" + productDetailID);
                } else {
                    req.setAttribute("errorMessage", "Không thể cập nhật sản phẩm. Vui lòng thử lại!");
                    
                    ProductDetailDTO product = ProductDAO.getProductDetailById(dbName, productDetailID);
                    String brandName = ProductDAO.getBrandNameById(dbName, product.getBrandID());
                    String categoryName = ProductDAO.getCategoryNameById(dbName, product.getCategoryID());
                    String supplierName = ProductDAO.getSupplierNameById(dbName, product.getSupplierID());                    
                    req.setAttribute("product", product);
                    req.setAttribute("brandName", brandName);
                    req.setAttribute("categoryName", categoryName);
                    req.setAttribute("supplierName", supplierName);                    
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/product-detail.jsp").forward(req, resp);
                }
            } catch (SQLException ex) {
                Logger.getLogger(SOProductController.class.getName()).log(Level.SEVERE, null, ex);
                req.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật sản phẩm!");
            }
        }
    }
}
