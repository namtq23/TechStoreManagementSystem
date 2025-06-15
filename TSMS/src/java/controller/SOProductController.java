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
import java.util.regex.Pattern;
import model.Category;
import model.ProductDTO;

@WebServlet(name = "BrandOwnerHangHoaController", urlPatterns = {"/so-products"})
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
            } else {
                search = search.trim().replaceAll("\\s+", "");
            }
            Integer categoryId = null;
            if (req.getParameter("categoryId") != null && !req.getParameter("categoryId").isEmpty()) {
                try {
                    categoryId = Integer.parseInt(req.getParameter("categoryId"));
                    System.out.println("Nhận được CategoryID: " + categoryId);
                } catch (NumberFormatException e) {
                    categoryId = null;
                    System.out.println("CategoryID không hợp lệ: " + req.getParameter("categoryId"));
                }
            } else {
                System.out.println("Không nhận được tham số categoryId");
            }
            String inventory = req.getParameter("inventory");
            if (inventory == null) {
                inventory = "all";
            }
            String action = req.getParameter("action");
            ProductDAO dao = new ProductDAO();
            if ("showCreateForm".equals(action)) {
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                return;
            } else if ("view".equals(action)) {
                try {
                    int productDetailId = Integer.parseInt(req.getParameter("productDetailId"));
                    ProductDTO product = dao.getProductByDetailId(dbName, productDetailId);
                    if (product == null) {
                        resp.sendRedirect("so-products?error=notfound");
                        return;
                    }
                    req.setAttribute("product", product);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/edit-products.jsp").forward(req, resp);
                } catch (NumberFormatException e) {
                    resp.sendRedirect("so-products?error=invalid");
                }
                return;
            }

            List<ProductDTO> products = dao.getWarehouseProductListByPageAndCategory(dbName, 1, page, pageSize, search, categoryId, inventory);
            int totalProducts = dao.countProductsByWarehouseIdAndCategory(dbName, 1, search, categoryId, inventory);
            int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
            int startProduct = (page - 1) * pageSize + 1;
            int endProduct = Math.min(page * pageSize, totalProducts);
            List<Category> categories = dao.getAllCategories(dbName);
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
        ProductDAO dao = new ProductDAO();

        if ("showCreateForm".equals(action)) {
            loadFormData(req, dbName, dao);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
        } else if ("addBrand".equals(action)) {
            try {
                String brandName = req.getParameter("brandName").trim();
                setFormAttributes(req);
                req.setAttribute("brandName", brandName);

                // Validate brand name
                if (!NAME_PATTERN.matcher(brandName).matches()) {
                    req.setAttribute("brandNameError", "Tên thương hiệu chỉ được chứa chữ cái và khoảng trắng");
                    req.setAttribute("showBrandModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                if (dao.brandExists(dbName, brandName)) {
                    req.setAttribute("brandNameError", "Thương hiệu đã tồn tại");
                    req.setAttribute("showBrandModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                int brandId = dao.addBrand(dbName, brandName);
                req.setAttribute("brandId", String.valueOf(brandId));
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            } catch (SQLException e) {
                setFormAttributes(req);
                req.setAttribute("brandNameError", "Lỗi khi thêm thương hiệu: " + e.getMessage());
                req.setAttribute("showBrandModal", "true");
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            }
        } else if ("addCategory".equals(action)) {
            try {
                String categoryName = req.getParameter("categoryName").trim();
                setFormAttributes(req);
                req.setAttribute("categoryName", categoryName);

                // Validate category name
                if (!NAME_PATTERN.matcher(categoryName).matches()) {
                    req.setAttribute("categoryNameError", "Tên nhóm hàng chỉ được chứa chữ cái và khoảng trắng");
                    req.setAttribute("showCategoryModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                if (dao.categoryExists(dbName, categoryName)) {
                    req.setAttribute("categoryNameError", "Nhóm hàng đã tồn tại");
                    req.setAttribute("showCategoryModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                int categoryId = dao.addCategory(dbName, categoryName);
                req.setAttribute("categoryId", String.valueOf(categoryId));
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            } catch (SQLException e) {
                setFormAttributes(req);
                req.setAttribute("categoryNameError", "Lỗi khi thêm nhóm hàng: " + e.getMessage());
                req.setAttribute("showCategoryModal", "true");
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            }
        } else if ("addSupplier".equals(action)) {
            try {
                String supplierName = req.getParameter("supplierName").trim();
                String contactName = req.getParameter("contactName") != null ? req.getParameter("contactName").trim() : null;
                String phone = req.getParameter("phone") != null ? req.getParameter("phone").trim() : null;
                String email = req.getParameter("email") != null ? req.getParameter("email").trim() : null;
                setFormAttributes(req);
                req.setAttribute("supplierName", supplierName);
                req.setAttribute("contactName", contactName);
                req.setAttribute("phone", phone);
                req.setAttribute("email", email);

                // Validate supplier name
                if (!NAME_PATTERN.matcher(supplierName).matches()) {
                    req.setAttribute("supplierNameError", "Tên nhà cung cấp chỉ được chứa chữ cái và khoảng trắng");
                    req.setAttribute("showSupplierModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                // Validate phone
                if (phone != null && !phone.isEmpty() && !PHONE_PATTERN.matcher(phone).matches()) {
                    req.setAttribute("phoneError", "Số điện thoại phải chứa đúng 11 số nguyên");
                    req.setAttribute("showSupplierModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                // Validate email
                if (email != null && !email.isEmpty() && !EMAIL_PATTERN.matcher(email).matches()) {
                    req.setAttribute("emailError", "Định dạng email không hợp lệ");
                    req.setAttribute("showSupplierModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                if (dao.supplierExists(dbName, supplierName)) {
                    req.setAttribute("supplierNameError", "Nhà cung cấp đã tồn tại");
                    req.setAttribute("showSupplierModal", "true");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                int supplierId = dao.addSupplier(dbName, supplierName, contactName, phone, email);
                req.setAttribute("supplierId", String.valueOf(supplierId));
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            } catch (SQLException e) {
                setFormAttributes(req);
                req.setAttribute("supplierNameError", "Lỗi khi thêm nhà cung cấp: " + e.getMessage());
                req.setAttribute("showSupplierModal", "true");
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            }
        } else if ("create".equals(action)) {
            try {
                String productName = req.getParameter("productName").trim();
                String brandIdStr = req.getParameter("brandId");
                String categoryIdStr = req.getParameter("categoryId");
                String supplierIdStr = req.getParameter("supplierId");
                String costPriceStr = req.getParameter("costPrice").trim();
                String retailPriceStr = req.getParameter("retailPrice").trim();
                String imageURL = req.getParameter("imageURL");
                String description = req.getParameter("description");
                String serialNumber = req.getParameter("serialNumber");
                String warrantyPeriod = req.getParameter("warrantyPeriod");
                String quantityStr = req.getParameter("quantity").trim();
                boolean isActive = "1".equals(req.getParameter("isActive"));
                int warehouseId = 1; // Assuming fixed warehouseId

                setFormAttributes(req);

                // Validate product name
                if (dao.productNameExists(dbName, productName)) {
                    req.setAttribute("productNameError", "Tên sản phẩm đã tồn tại");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }

                // Validate prices
                if (!PRICE_PATTERN.matcher(costPriceStr).matches()) {
                    req.setAttribute("costPriceError", "Giá vốn phải là số dương với tối đa 2 chữ số thập phân");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                if (!PRICE_PATTERN.matcher(retailPriceStr).matches()) {
                    req.setAttribute("retailPriceError", "Giá bán phải là số dương với tối đa 2 chữ số thập phân");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                double costPrice = Double.parseDouble(costPriceStr);
                double retailPrice = Double.parseDouble(retailPriceStr);
                if (costPrice <= 0) {
                    req.setAttribute("costPriceError", "Giá vốn phải lớn hơn 0");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }
                if (retailPrice <= costPrice) {
                    req.setAttribute("retailPriceError", "Giá bán phải lớn hơn giá vốn");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }

                // Validate quantity
                int quantity;
                try {
                    quantity = Integer.parseInt(quantityStr);
                    if (quantity < 0) {
                        req.setAttribute("quantityError", "Số lượng phải là số không âm");
                        loadFormData(req, dbName, dao);
                        req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException e) {
                    req.setAttribute("quantityError", "Số lượng phải là số nguyên hợp lệ");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }

                // Validate IDs
                int brandId, categoryId, supplierId;
                try {
                    brandId = Integer.parseInt(brandIdStr);
                    categoryId = Integer.parseInt(categoryIdStr);
                    supplierId = Integer.parseInt(supplierIdStr);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "Dữ liệu không hợp lệ cho thương hiệu, nhóm hàng hoặc nhà cung cấp");
                    loadFormData(req, dbName, dao);
                    req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
                    return;
                }

                // Create product and product details
                int productId = dao.addProduct(dbName, productName, brandId, categoryId, supplierId, costPrice, retailPrice, imageURL, isActive);
                int productDetailId = dao.addProductDetail(dbName, productId, description, serialNumber, warrantyPeriod);
                dao.addWarehouseProduct(dbName, warehouseId, productDetailId, quantity);

                resp.sendRedirect("so-products?success=created");
            } catch (Exception e) {
                e.printStackTrace();
                setFormAttributes(req);
                req.setAttribute("error", "Lỗi khi tạo sản phẩm: " + e.getMessage());
                loadFormData(req, dbName, dao);
                req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/add-product.jsp").forward(req, resp);
            }
        } else if ("update".equals(action)) {
            try {
                int productDetailId = Integer.parseInt(req.getParameter("productDetailId"));
                int productId = Integer.parseInt(req.getParameter("productId"));
                String retailPrice = req.getParameter("retailPrice");
                String costPrice = req.getParameter("costPrice");
                String description = req.getParameter("description");
                String isActive = req.getParameter("isActive");

                ProductDTO existingProduct = dao.getProductByDetailId(dbName, productDetailId);
                if (existingProduct == null) {
                    resp.sendRedirect("so-products?error=notfound");
                    return;
                }

                existingProduct.setRetailPrice(retailPrice);
                existingProduct.setCostPrice(costPrice);
                existingProduct.setDescription(description);
                existingProduct.setIsActive(isActive);

                dao.updateProductDetails(dbName, existingProduct);
                resp.sendRedirect("so-products?success=updated");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("so-products?error=update");
            }
        } else if ("delete".equals(action)) {
            try {
                int productDetailId = Integer.parseInt(req.getParameter("productDetailId"));
                dao.deleteProductAndDetail(dbName, productDetailId);
                resp.sendRedirect("so-products");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("so-products?error=delete");
            }
        }
    }
        private static final Pattern PRICE_PATTERN = Pattern.compile("^\\d+(\\.\\d{1,2})?$");
    private static final Pattern NAME_PATTERN = Pattern.compile("^[a-zA-Z\\s]+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^\\d{10}$");
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private void setFormAttributes(HttpServletRequest req) {
        // Preserve form data
        String[] fields = {"productName", "brandId", "categoryId", "supplierId", "costPrice", "retailPrice", "imageURL", "description", "serialNumber", "warrantyPeriod", "quantity", "isActive"};
        for (String field : fields) {
            String value = req.getParameter(field);
            if (value != null) {
                req.setAttribute(field, value);
            }
        }
    }

    private void loadFormData(HttpServletRequest req, String dbName, ProductDAO dao) {
        // Load dropdown data
        req.setAttribute("brands", dao.getAllBrands(dbName));
        req.setAttribute("categories", dao.getAllCategory(dbName));
        req.setAttribute("suppliers", dao.getAllSuppliers(dbName));
    }

}