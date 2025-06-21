package controller;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Category;
import model.Supplier;
import model.Brand;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.regex.Pattern;
import java.util.UUID;

@WebServlet(name = "SOAddProductController", urlPatterns = {"/so-add-product"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 50) // 50MB
public class SOAddProductController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private static final String UPLOAD_DIR = "uploads";
    private static final String[] ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg"};

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
            List<Category> categories = productDAO.getAllCategories(dbName);
            List<Supplier> suppliers = productDAO.getAllSupplier(dbName);
            List<Brand> brands = productDAO.getAllBrands(dbName);

            req.setAttribute("categories", categories);
            req.setAttribute("suppliers", suppliers);
            req.setAttribute("brands", brands);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-add-product.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-add-product.jsp").forward(req, resp);
        }
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

        try {
            if ("addCategory".equals(action)) {
                handleAddCategory(req, resp, dbName);
            } else if ("addBrand".equals(action)) {
                handleAddBrand(req, resp, dbName);
            } else if ("addSupplier".equals(action)) {
                handleAddSupplier(req, resp, dbName);
            } else if ("addProduct".equals(action)) {
                handleAddProduct(req, resp, dbName);
            } else {
                req.setAttribute("errorMessage", "Hành động không hợp lệ.");
                forwardToForm(req, resp, dbName);
            }
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
            forwardToForm(req, resp, dbName);
        }
    }

    private void handleAddCategory(HttpServletRequest req, HttpServletResponse resp, String dbName) throws SQLException, ServletException, IOException {
        String categoryName = req.getParameter("categoryName");
        if (categoryName == null || categoryName.trim().isEmpty()) {
            req.setAttribute("categoryNameError", "Tên danh mục không được để trống.");
            req.setAttribute("showCategoryModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        categoryName = categoryName.trim();
        if (categoryName.length() > 100) {
            req.setAttribute("categoryNameError", "Tên danh mục không được vượt quá 100 ký tự.");
            req.setAttribute("showCategoryModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (productDAO.isCategoryNameExists(dbName, categoryName)) {
            req.setAttribute("categoryNameError", "Tên danh mục đã tồn tại.");
            req.setAttribute("showCategoryModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (productDAO.addCategory(dbName, categoryName)) {
            req.setAttribute("successMessage", "Thêm danh mục thành công.");
        } else {
            req.setAttribute("errorMessage", "Không thể thêm danh mục.");
        }
        forwardToForm(req, resp, dbName);
    }

    private void handleAddBrand(HttpServletRequest req, HttpServletResponse resp, String dbName) throws SQLException, ServletException, IOException {
        String brandName = req.getParameter("brandName");
        if (brandName == null || brandName.trim().isEmpty()) {
            req.setAttribute("brandNameError", "Tên thương hiệu không được để trống.");
            req.setAttribute("showBrandModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        brandName = brandName.trim();
        if (brandName.length() > 100) {
            req.setAttribute("brandNameError", "Tên thương hiệu không được vượt quá 100 ký tự.");
            req.setAttribute("showBrandModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (productDAO.isBrandNameExists(dbName, brandName)) {
            req.setAttribute("brandNameError", "Tên thương hiệu đã tồn tại.");
            req.setAttribute("showBrandModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (productDAO.addBrand(dbName, brandName)) {
            req.setAttribute("successMessage", "Thêm thương hiệu thành công.");
        } else {
            req.setAttribute("errorMessage", "Không thể thêm thương hiệu.");
        }
        forwardToForm(req, resp, dbName);
    }

    private void handleAddSupplier(HttpServletRequest req, HttpServletResponse resp, String dbName) throws SQLException, ServletException, IOException {
        String supplierName = req.getParameter("supplierName");
        String contactName = req.getParameter("contactName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");

        if (supplierName == null || supplierName.trim().isEmpty()) {
            req.setAttribute("supplierNameError", "Tên nhà cung cấp không được để trống.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        supplierName = supplierName.trim();
        if (supplierName.length() > 100) {
            req.setAttribute("supplierNameError", "Tên nhà cung cấp không được vượt quá 100 ký tự.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (productDAO.isSupplierNameExists(dbName, supplierName)) {
            req.setAttribute("supplierNameError", "Tên nhà cung cấp đã tồn tại.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (phone == null || phone.trim().isEmpty()) {
            req.setAttribute("phoneError", "Số điện thoại không được để trống.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        phone = phone.trim();
        if (!Pattern.matches("^\\+?[0-9]{10,15}$", phone)) {
            req.setAttribute("phoneError", "Số điện thoại không hợp lệ (10-15 chữ số).");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            req.setAttribute("emailError", "Email không được để trống.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        email = email.trim();
        if (!Pattern.matches("^[A-Za-z0-9+_.-]+@(.+)$", email)) {
            req.setAttribute("emailError", "Email không hợp lệ.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }
        if (email.length() > 100) {
            req.setAttribute("emailError", "Email không được vượt quá 100 ký tự.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (contactName == null || contactName.trim().isEmpty()) {
            req.setAttribute("contactNameError", "Tên liên hệ không được để trống.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }
        if (contactName.trim().length() > 100) {
            req.setAttribute("contactNameError", "Tên liên hệ không được vượt quá 100 ký tự.");
            req.setAttribute("showSupplierModal", "true");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (productDAO.addSupplier(dbName, supplierName, contactName, phone, email)) {
            req.setAttribute("successMessage", "Thêm nhà cung cấp thành công.");
        } else {
            req.setAttribute("errorMessage", "Không thể thêm nhà cung cấp.");
        }
        forwardToForm(req, resp, dbName);
    }

    private void handleAddProduct(HttpServletRequest req, HttpServletResponse resp, String dbName) throws SQLException, ServletException, IOException {
        String productName = req.getParameter("productName");
        String productCode = req.getParameter("productCode");
        String description = req.getParameter("description");
        String costPriceStr = req.getParameter("costPrice");
        String retailPriceStr = req.getParameter("retailPrice");
        String brandIdStr = req.getParameter("brandId");
        String categoryIdStr = req.getParameter("categoryId");
        String supplierIdStr = req.getParameter("supplierId");
        String warrantyPeriod = req.getParameter("warrantyPeriod");
        String vatStr = req.getParameter("vat");
        String isActiveStr = req.getParameter("isActive");
        String serialNumbers = req.getParameter("serialNumber");
        Part imagePart = req.getPart("image");


        if (productName == null || productName.trim().isEmpty()) {
            req.setAttribute("productNameError", "Tên sản phẩm không được để trống.");
            forwardToForm(req, resp, dbName);
            return;
        }
        productName = productName.trim();
        if (productName.length() > 255) {
            req.setAttribute("productNameError", "Tên sản phẩm không được vượt quá 255 ký tự.");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (productCode == null || productCode.trim().isEmpty()) {
            req.setAttribute("productCodeError", "Mã sản phẩm không được để trống.");
            forwardToForm(req, resp, dbName);
            return;
        }
        productCode = productCode.trim();
        if (productCode.length() > 255) {
            req.setAttribute("productCodeError", "Mã sản phẩm không được vượt quá 255 ký tự.");
            forwardToForm(req, resp, dbName);
            return;
        }
        if (productDAO.isProductCodeExists(dbName, productCode)) {
            req.setAttribute("productCodeError", "Mã sản phẩm đã tồn tại.");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (description == null || description.trim().isEmpty()) {
            req.setAttribute("descriptionError", "Mô tả không được để trống.");
            forwardToForm(req, resp, dbName);
            return;
        }

        double costPrice;
        try {
            costPrice = Double.parseDouble(costPriceStr);
            if (costPrice <= 0) {
                req.setAttribute("costPriceError", "Giá nhập phải lớn hơn 0.");
                forwardToForm(req, resp, dbName);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("costPriceError", "Giá nhập không hợp lệ.");
            forwardToForm(req, resp, dbName);
            return;
        }

        double retailPrice;
        try {
            retailPrice = Double.parseDouble(retailPriceStr);
            if (retailPrice <= 0) {
                req.setAttribute("retailPriceError", "Giá bán phải lớn hơn 0.");
                forwardToForm(req, resp, dbName);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("retailPriceError", "Giá bán không hợp lệ.");
            forwardToForm(req, resp, dbName);
            return;
        }

        int brandId;
        try {
            brandId = Integer.parseInt(brandIdStr);
            if (brandId <= 0) {
                req.setAttribute("brandIdError", "Vui lòng chọn thương hiệu.");
                forwardToForm(req, resp, dbName);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("brandIdError", "Thương hiệu không hợp lệ.");
            forwardToForm(req, resp, dbName);
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
            if (categoryId <= 0) {
                req.setAttribute("categoryIdError", "Vui lòng chọn danh mục.");
                forwardToForm(req, resp, dbName);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("categoryIdError", "Danh mục không hợp lệ.");
            forwardToForm(req, resp, dbName);
            return;
        }

        int supplierId;
        try {
            supplierId = Integer.parseInt(supplierIdStr);
            if (supplierId <= 0) {
                req.setAttribute("supplierIdError", "Vui lòng chọn nhà cung cấp.");
                forwardToForm(req, resp, dbName);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("supplierIdError", "Nhà cung cấp không hợp lệ.");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (warrantyPeriod == null || warrantyPeriod.trim().isEmpty()) {
            req.setAttribute("warrantyPeriodError", "Thời gian bảo hành không được để trống.");
            forwardToForm(req, resp, dbName);
            return;
        }
        if (warrantyPeriod.trim().length() > 50) {
            req.setAttribute("warrantyPeriodError", "Thời gian bảo hành không được vượt quá 50 ký tự.");
            forwardToForm(req, resp, dbName);
            return;
        }

        double vat;
        try {
            vat = Double.parseDouble(vatStr);
            if (vat < 0 || vat > 100) {
                req.setAttribute("vatError", "VAT phải từ 0 đến 100%.");
                forwardToForm(req, resp, dbName);
                return;
            }
        } catch (NumberFormatException e) {
            req.setAttribute("vatError", "VAT không hợp lệ.");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (isActiveStr == null || isActiveStr.trim().isEmpty()) {
            req.setAttribute("isActiveError", "Vui lòng chọn trạng thái.");
            forwardToForm(req, resp, dbName);
            return;
        }
        boolean isActive = "1".equals(isActiveStr);

        if (serialNumbers == null || serialNumbers.trim().isEmpty()) {
            req.setAttribute("serialNumberError", "Serial numbers không được để trống.");
            forwardToForm(req, resp, dbName);
            return;
        }
        String[] serialArray = serialNumbers.split(",");
        for (String serial : serialArray) {
            serial = serial.trim();
            if (serial.isEmpty()) {
                req.setAttribute("serialNumberError", "Danh sách serial numbers chứa giá trị trống.");
                forwardToForm(req, resp, dbName);
                return;
            }
            if (serial.length() > 255) {
                req.setAttribute("serialNumberError", "Serial number '" + serial + "' không được vượt quá 255 ký tự.");
                forwardToForm(req, resp, dbName);
                return;
            }
            if (productDAO.isSerialNumberExists(dbName, serial)) {
                req.setAttribute("serialNumberError", "Serial number '" + serial + "' đã tồn tại.");
                forwardToForm(req, resp, dbName);
                return;
            }
        }
        if (imagePart == null || imagePart.getSize() == 0) {
            req.setAttribute("imageError", "Ảnh sản phẩm không được để trống.");
            forwardToForm(req, resp, dbName);
            return;
        }

        String fileName = imagePart.getSubmittedFileName();
        String fileExtension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
        boolean validExtension = false;
        for (String ext : ALLOWED_EXTENSIONS) {
            if (ext.equals(fileExtension)) {
                validExtension = true;
                break;
            }
        }
        if (!validExtension) {
            req.setAttribute("imageError", "Chỉ chấp nhận file ảnh định dạng .png, .jpg, hoặc .jpeg.");
            forwardToForm(req, resp, dbName);
            return;
        }

        if (imagePart.getSize() > 1024 * 1024 * 5) {
            req.setAttribute("imageError", "Kích thước ảnh không được vượt quá 5MB.");
            forwardToForm(req, resp, dbName);
            return;
        }

        // Save the image
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        String filePath = uploadPath + File.separator + uniqueFileName;
        imagePart.write(filePath);
        String imageUrl = "/" + UPLOAD_DIR + "/" + uniqueFileName;

        if (productDAO.addProduct(dbName, productName, imageUrl, productCode, description, costPrice, retailPrice,
                brandId, categoryId, supplierId, warrantyPeriod, vat, isActive, serialNumbers)) {
            req.setAttribute("successMessage", "Thêm sản phẩm thành công.");
            req.setAttribute("imageUrl", imageUrl);
        } else {
            req.setAttribute("errorMessage", "Không thể thêm sản phẩm.");
            new File(filePath).delete();
        }
        forwardToForm(req, resp, dbName);
    }

    private void forwardToForm(HttpServletRequest req, HttpServletResponse resp, String dbName) throws ServletException, IOException {
        try {
            List<Category> categories = productDAO.getAllCategories(dbName);
            List<Supplier> suppliers = productDAO.getAllSupplier(dbName);
            List<Brand> brands = productDAO.getAllBrands(dbName);
            req.setAttribute("categories", categories);
            req.setAttribute("suppliers", suppliers);
            req.setAttribute("brands", brands);
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-add-product.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/shop-owner/so-add-product.jsp").forward(req, resp);
        }
    }
}