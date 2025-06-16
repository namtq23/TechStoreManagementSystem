<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Brand" %>
<%@ page import="model.Category" %>
<%@ page import="model.Supplier" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Thêm mới sản phẩm</title>
    <link rel="stylesheet" href="css/so-products.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Modal styles to match edit-products.jsp */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .modal-content {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            max-width: 90%;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .modal-content h2 {
            margin: 0 0 15px;
            font-size: 1.5em;
            color: #333;
        }
        .modal-content input, .modal-content textarea, .modal-content select {
            width: 100%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
            box-sizing: border-box;
        }
        .modal-content input:focus, .modal-content textarea:focus, .modal-content select:focus {
            border-color: #4CAF50;
            outline: none;
        }
        .modal-content button {
            padding: 10px 20px;
            margin: 5px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            transition: background-color 0.2s;
        }
        .modal-content .btn-save {
            background-color: #4CAF50;
            color: white;
        }
        .modal-content .btn-save:hover {
            background-color: #45a049;
        }
        .modal-content .btn-cancel {
            background-color: #f44336;
            color: white;
        }
        .modal-content .btn-cancel:hover {
            background-color: #d32f2f;
        }
        /* Form styles to match edit-products.jsp */
        .add-product-form .form-group {
            margin-bottom: 20px;
        }
        .add-product-form label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
            color: #333;
        }
        .add-product-form input, .add-product-form textarea, .add-product-form select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
        }
        .add-product-form input:focus, .add-product-form textarea:focus, .add-product-form select:focus {
            border-color: #4CAF50;
            outline: none;
        }
        .add-product-form .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .error {
            color: #d32f2f;
            font-size: 0.85em;
            margin-top: 5px;
            display: none; /* Hidden by default, shown via JS */
        }
        /* Highlight invalid fields */
        .invalid {
            border-color: #d32f2f !important;
        }
        /* Ensure button consistency with so-products.css */
        .btn {
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .btn-success {
            background-color: #4CAF50;
            color: white;
        }
        .btn-success:hover {
            background-color: #45a049;
        }
        .btn-cancel {
            background-color: #f44336;
            color: white;
        }
        .btn-cancel:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header-so.jsp" />

    <div class="main-container">
        <main class="main-content">
            <div class="page-header">
                <h1>Thêm mới sản phẩm</h1>
            </div>

            <form id="productForm" action="so-products" method="post" class="add-product-form">
                <input type="hidden" name="action" value="create">

                <div class="form-group">
                    <label for="productName">Tên sản phẩm <span style="color: red;">*</span></label>
                    <input type="text" id="productName" name="productName" value="<%= request.getAttribute("productName") != null ? request.getAttribute("productName") : "" %>" required onblur="validateNotEmpty(this, 'productNameError', 'Tên sản phẩm không được bỏ trống')">
                    <div class="error" id="productNameError"><%= request.getAttribute("productNameError") != null ? request.getAttribute("productNameError") : "" %></div>
                </div>

                <div class="form-group">
                    <label for="brandId">Thương hiệu <span style="color: red;">*</span></label>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <select id="brandId" name="brandId" required onblur="validateNotEmpty(this, 'brandIdError', 'Vui lòng chọn thương hiệu')">
                            <option value="">Chọn thương hiệu</option>
                            <c:forEach var="brand" items="${brands}">
                                <option value="${brand.brandID}" <%= request.getAttribute("brandId") != null && request.getAttribute("brandId").equals(String.valueOf(((model.Brand)pageContext.getAttribute("brand")).getBrandID())) ? "selected" : "" %>>${brand.brandName}</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn btn-success" onclick="openModal('brandModal')">
                            <i class="fas fa-plus"></i> Thêm mới
                        </button>
                    </div>
                    <div class="error" id="brandIdError"></div>
                </div>

                <div class="form-group">
                    <label for="categoryId">Nhóm hàng <span style="color: red;">*</span></label>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <select id="categoryId" name="categoryId" required onblur="validateNotEmpty(this, 'categoryIdError', 'Vui lòng chọn nhóm hàng')">
                            <option value="">Chọn nhóm hàng</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryID}" <%= request.getAttribute("categoryId") != null && request.getAttribute("categoryId").equals(String.valueOf(((model.Category)pageContext.getAttribute("category")).getCategoryID())) ? "selected" : "" %>>${category.categoryName}</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn btn-success" onclick="openModal('categoryModal')">
                            <i class="fas fa-plus"></i> Thêm mới
                        </button>
                    </div>
                    <div class="error" id="categoryIdError"></div>
                </div>

                <div class="form-group">
                    <label for="supplierId">Nhà cung cấp <span style="color: red;">*</span></label>
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <select id="supplierId" name="supplierId" required onblur="validateNotEmpty(this, 'supplierIdError', 'Vui lòng chọn nhà cung cấp')">
                            <option value="">Chọn nhà cung cấp</option>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierID}" <%= request.getAttribute("supplierId") != null && request.getAttribute("supplierId").equals(String.valueOf(((model.Supplier)pageContext.getAttribute("supplier")).getSupplierID())) ? "selected" : "" %>>${supplier.supplierName}</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn btn-success" onclick="openModal('supplierModal')">
                            <i class="fas fa-plus"></i> Thêm mới
                        </button>
                    </div>
                    <div class="error" id="supplierIdError"></div>
                </div>

                <div class="form-group">
                    <label for="costPrice">Giá vốn <span style="color: red;">*</span></label>
                    <input type="number" id="costPrice" name="costPrice" step="0.01" value="<%= request.getAttribute("costPrice") != null ? request.getAttribute("costPrice") : "" %>" required onblur="validateNotEmpty(this, 'costPriceError', 'Giá vốn không được bỏ trống')">
                    <div class="error" id="costPriceError"><%= request.getAttribute("costPriceError") != null ? request.getAttribute("costPriceError") : "" %></div>
                </div>

                <div class="form-group">
                    <label for="retailPrice">Giá bán <span style="color: red;">*</span></label>
                    <input type="number" id="retailPrice" name="retailPrice" step="0.01" value="<%= request.getAttribute("retailPrice") != null ? request.getAttribute("retailPrice") : "" %>" required onblur="validateNotEmpty(this, 'retailPriceError', 'Giá bán không được bỏ trống')">
                    <div class="error" id="retailPriceError"><%= request.getAttribute("retailPriceError") != null ? request.getAttribute("retailPriceError") : "" %></div>
                </div>

                <div class="form-group">
                    <label for="imageURL">URL hình ảnh</label>
                    <input type="text" id="imageURL" name="imageURL" value="<%= request.getAttribute("imageURL") != null ? request.getAttribute("imageURL") : "" %>">
                </div>

                <div class="form-group">
                    <label for="description">Mô tả</label>
                    <textarea id="description" name="description" rows="4"><%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %></textarea>
                </div>

                <div class="form-group">
                    <label for="serialNumber">Số serial</label>
                    <input type="text" id="serialNumber" name="serialNumber" value="<%= request.getAttribute("serialNumber") != null ? request.getAttribute("serialNumber") : "" %>">
                </div>

                <div class="form-group">
                    <label for="warrantyPeriod">Thời gian bảo hành</label>
                    <input type="text" id="warrantyPeriod" name="warrantyPeriod" placeholder="Ví dụ: 1 năm, 6 tháng" value="<%= request.getAttribute("warrantyPeriod") != null ? request.getAttribute("warrantyPeriod") : "" %>">
                </div>

                <div class="form-group">
                    <label for="quantity">Số lượng <span style="color: red;">*</span></label>
                    <input type="number" id="quantity" name="quantity" value="<%= request.getAttribute("quantity") != null ? request.getAttribute("quantity") : "" %>" required onblur="validateNotEmpty(this, 'quantityError', 'Số lượng không được bỏ trống')">
                    <div class="error" id="quantityError"><%= request.getAttribute("quantityError") != null ? request.getAttribute("quantityError") : "" %></div>
                </div>

                <div class="form-group">
                    <label for="isActive">Trạng thái</label>
                    <select id="isActive" name="isActive">
                        <option value="1" <%= request.getAttribute("isActive") != null && request.getAttribute("isActive").equals("1") ? "selected" : "" %>>Đang kinh doanh</option>
                        <option value="0" <%= request.getAttribute("isActive") != null && request.getAttribute("isActive").equals("0") ? "selected" : "" %>>Không kinh doanh</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-success">Lưu</button>
                    <a href="so-products" class="btn btn-cancel">Hủy</a>
                </div>
            </form>

            <div id="brandModal" class="modal" style="display: <%= request.getAttribute("showBrandModal") != null && request.getAttribute("showBrandModal").equals("true") ? "flex" : "none" %>">
                <div class="modal-content">
                    <h2>Thêm mới thương hiệu</h2>
                    <form id="brandForm" action="so-products" method="post">
                        <input type="hidden" name="action" value="addBrand">
                        <input type="hidden" name="productName" value="<%= request.getAttribute("productName") != null ? request.getAttribute("productName") : "" %>">
                        <input type="hidden" name="brandId" value="<%= request.getAttribute("brandId") != null ? request.getAttribute("brandId") : "" %>">
                        <input type="hidden" name="categoryId" value="<%= request.getAttribute("categoryId") != null ? request.getAttribute("categoryId") : "" %>">
                        <input type="hidden" name="supplierId" value="<%= request.getAttribute("supplierId") != null ? request.getAttribute("supplierId") : "" %>">
                        <input type="hidden" name="costPrice" value="<%= request.getAttribute("costPrice") != null ? request.getAttribute("costPrice") : "" %>">
                        <input type="hidden" name="retailPrice" value="<%= request.getAttribute("retailPrice") != null ? request.getAttribute("retailPrice") : "" %>">
                        <input type="hidden" name="description" value="<%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %>">
                        <input type="hidden" name="quantity" value="<%= request.getAttribute("quantity") != null ? request.getAttribute("quantity") : "" %>">
                        <input type="text" id="brandName" name="brandName" placeholder="Tên thương hiệu" value="<%= request.getAttribute("brandName") != null ? request.getAttribute("brandName") : "" %>" required onblur="validateNotEmpty(this, 'brandNameError', 'Tên thương hiệu không được bỏ trống')">
                        <div class="error" id="brandNameError"><%= request.getAttribute("brandNameError") != null ? request.getAttribute("brandNameError") : "" %></div>
                        <button type="submit" class="btn-save">Lưu</button>
                        <button type="button" class="btn-cancel" onclick="closeModal('brandModal')">Hủy</button>
                    </form>
                </div>
            </div>

            <div id="categoryModal" class="modal" style="display: <%= request.getAttribute("showCategoryModal") != null && request.getAttribute("showCategoryModal").equals("true") ? "flex" : "none" %>">
                <div class="modal-content">
                    <h2>Thêm mới nhóm hàng</h2>
                    <form id="categoryForm" action="so-products" method="post">
                        <input type="hidden" name="action" value="addCategory">
                        <input type="hidden" name="productName" value="<%= request.getAttribute("productName") != null ? request.getAttribute("productName") : "" %>">
                        <input type="hidden" name="brandId" value="<%= request.getAttribute("brandId") != null ? request.getAttribute("brandId") : "" %>">
                        <input type="hidden" name="categoryId" value="<%= request.getAttribute("categoryId") != null ? request.getAttribute("categoryId") : "" %>">
                        <input type="hidden" name="supplierId" value="<%= request.getAttribute("supplierId") != null ? request.getAttribute("supplierId") : "" %>">
                        <input type="hidden" name="costPrice" value="<%= request.getAttribute("costPrice") != null ? request.getAttribute("costPrice") : "" %>">
                        <input type="hidden" name="retailPrice" value="<%= request.getAttribute("retailPrice") != null ? request.getAttribute("retailPrice") : "" %>">
                        <input type="hidden" name="description" value="<%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %>">
                        <input type="hidden" name="quantity" value="<%= request.getAttribute("quantity") != null ? request.getAttribute("quantity") : "" %>">
                        <input type="text" id="categoryName" name="categoryName" placeholder="Tên nhóm hàng" value="<%= request.getAttribute("categoryName") != null ? request.getAttribute("categoryName") : "" %>" required onblur="validateNotEmpty(this, 'categoryNameError', 'Tên nhóm hàng không được bỏ trống')">
                        <div class="error" id="categoryNameError"><%= request.getAttribute("categoryNameError") != null ? request.getAttribute("categoryNameError") : "" %></div>
                        <button type="submit" class="btn-save">Lưu</button>
                        <button type="button" class="btn-cancel" onclick="closeModal('categoryModal')">Hủy</button>
                    </form>
                </div>
            </div>

            <div id="supplierModal" class="modal" style="display: <%= request.getAttribute("showSupplierModal") != null && request.getAttribute("showSupplierModal").equals("true") ? "flex" : "none" %>">
                <div class="modal-content">
                    <h2>Thêm mới nhà cung cấp</h2>
                    <form id="supplierForm" action="so-products" method="post">
                        <input type="hidden" name="action" value="addSupplier">
                        <input type="hidden" name="productName" value="<%= request.getAttribute("productName") != null ? request.getAttribute("productName") : "" %>">
                        <input type="hidden" name="brandId" value="<%= request.getAttribute("brandId") != null ? request.getAttribute("brandId") : "" %>">
                        <input type="hidden" name="categoryId" value="<%= request.getAttribute("categoryId") != null ? request.getAttribute("categoryId") : "" %>">
                        <input type="hidden" name="supplierId" value="<%= request.getAttribute("supplierId") != null ? request.getAttribute("supplierId") : "" %>">
                        <input type="hidden" name="costPrice" value="<%= request.getAttribute("costPrice") != null ? request.getAttribute("costPrice") : "" %>">
                        <input type="hidden" name="retailPrice" value="<%= request.getAttribute("retailPrice") != null ? request.getAttribute("retailPrice") : "" %>">
                        <input type="hidden" name="description" value="<%= request.getAttribute("description") != null ? request.getAttribute("description") : "" %>">
                        <input type="hidden" name="quantity" value="<%= request.getAttribute("quantity") != null ? request.getAttribute("quantity") : "" %>">
                        <input type="text" id="supplierName" name="supplierName" placeholder="Tên nhà cung cấp" value="<%= request.getAttribute("supplierName") != null ? request.getAttribute("supplierName") : "" %>" required onblur="validateNotEmpty(this, 'supplierNameError', 'Tên nhà cung cấp không được bỏ trống')">
                        <div class="error" id="supplierNameError"><%= request.getAttribute("supplierNameError") != null ? request.getAttribute("supplierNameError") : "" %></div>
                        <input type="text" id="contactName" name="contactName" placeholder="Tên liên hệ" value="<%= request.getAttribute("contactName") != null ? request.getAttribute("contactName") : "" %>">
                        <input type="text" id="phone" name="phone" placeholder="Số điện thoại" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" onblur="validatePhone(this, 'phoneError')">
                        <div class="error" id="phoneError"><%= request.getAttribute("phoneError") != null ? request.getAttribute("phoneError") : "" %></div>
                        <input type="email" id="email" name="email" placeholder="Email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
                        <div class="error" id="emailError"><%= request.getAttribute("emailError") != null ? request.getAttribute("emailError") : "" %></div>
                        <button type="submit" class="btn-save">Lưu</button>
                        <button type="button" class="btn-cancel" onclick="closeModal('supplierModal')">Hủy</button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Simple validation for non-empty fields
        function validateNotEmpty(field, errorId, message) {
            var error = document.getElementById(errorId);
            if (field.value.trim() === "") {
                error.textContent = message;
                error.style.display = "block";
                field.classList.add("invalid");
            } else {
                error.textContent = "";
                error.style.display = "none";
                field.classList.remove("invalid");
            }
        }

        // Simple phone validation (empty or not 10 digits)
        function validatePhone(field, errorId) {
            var error = document.getElementById(errorId);
            var value = field.value.trim();
            if (value === "" || value.length !== 10) {
                error.textContent = "Số điện thoại không được bỏ trống và phải nhập 10 số nguyên";
                error.style.display = "block";
                field.classList.add("invalid");
            } else {
                error.textContent = "";
                error.style.display = "none";
                field.classList.remove("invalid");
            }
        }

        // Form submission validation (minimal, relies on server)
        document.getElementById("productForm").onsubmit = function() {
            var fields = [
                { id: "productName", errorId: "productNameError", message: "Tên sản phẩm không được bỏ trống" },
                { id: "brandId", errorId: "brandIdError", message: "Vui lòng chọn thương hiệu" },
                { id: "categoryId", errorId: "categoryIdError", message: "Vui lòng chọn nhóm hàng" },
                { id: "supplierId", errorId: "supplierIdError", message: "Vui lòng chọn nhà cung cấp" },
                { id: "costPrice", errorId: "costPriceError", message: "Giá vốn không được bỏ trống" },
                { id: "retailPrice", errorId: "retailPriceError", message: "Giá bán không được bỏ trống" },
                { id: "quantity", errorId: "quantityError", message: "Số lượng không được bỏ trống" }
            ];
            var isValid = true;
            for (var i = 0; i < fields.length; i++) {
                var field = document.getElementById(fields[i].id);
                var error = document.getElementById(fields[i].errorId);
                if (field.value.trim() === "") {
                    error.textContent = fields[i].message;
                    error.style.display = "block";
                    field.classList.add("invalid");
                    isValid = false;
                }
            }
            return isValid;
        };

        // Brand form submission
        document.getElementById("brandForm").onsubmit = function() {
            var field = document.getElementById("brandName");
            var error = document.getElementById("brandNameError");
            if (field.value.trim() === "") {
                error.textContent = "Tên thương hiệu không được bỏ trống";
                error.style.display = "block";
                field.classList.add("invalid");
                return false;
            }
            return true;
        };

        // Category form submission
        document.getElementById("categoryForm").onsubmit = function() {
            var field = document.getElementById("categoryName");
            var error = document.getElementById("categoryNameError");
            if (field.value.trim() === "") {
                error.textContent = "Tên nhóm hàng không được bỏ trống";
                error.style.display = "block";
                field.classList.add("invalid");
                return false;
            }
            return true;
        };

        // Supplier form submission
        document.getElementById("supplierForm").onsubmit = function() {
            var supplierName = document.getElementById("supplierName");
            var phone = document.getElementById("phone");
            var supplierNameError = document.getElementById("supplierNameError");
            var phoneError = document.getElementById("phoneError");
            var isValid = true;

            if (supplierName.value.trim() === "") {
                supplierNameError.textContent = "Tên nhà cung cấp không được bỏ trống";
                supplierNameError.style.display = "block";
                supplierName.classList.add("invalid");
                isValid = false;
            }
            if (phone.value.trim() === "" || phone.value.trim().length !== 10) {
                phoneError.textContent = "Số điện thoại không được bỏ trống và phải nhập 10 số nguyên";
                phoneError.style.display = "block";
                phone.classList.add("invalid");
                isValid = false;
            }
            return isValid;
        };

        // Modal open/close functions
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Show server-side errors on page load (minimal)
        <% if (request.getAttribute("productNameError") != null) { %>
            document.getElementById("productNameError").textContent = "<%= request.getAttribute("productNameError") %>";
            document.getElementById("productNameError").style.display = "block";
            document.getElementById("productName").classList.add("invalid");
        <% } %>
        <% if (request.getAttribute("costPriceError") != null) { %>
            document.getElementById("costPriceError").textContent = "<%= request.getAttribute("costPriceError") %>";
            document.getElementById("costPriceError").style.display = "block";
            document.getElementById("costPrice").classList.add("invalid");
        <% } %>
        <% if (request.getAttribute("retailPriceError") != null) { %>
            document.getElementById("retailPriceError").textContent = "<%= request.getAttribute("retailPriceError") %>";
            document.getElementById("retailPriceError").style.display = "block";
            document.getElementById("retailPrice").classList.add("invalid");
        <% } %>
        <% if (request.getAttribute("quantityError") != null) { %>
            document.getElementById("quantityError").textContent = "<%= request.getAttribute("quantityError") %>";
            document.getElementById("quantityError").style.display = "block";
            document.getElementById("quantity").classList.add("invalid");
        <% } %>
        <% if (request.getAttribute("brandNameError") != null) { %>
            document.getElementById("brandNameError").textContent = "<%= request.getAttribute("brandNameError") %>";
            document.getElementById("brandNameError").style.display = "block";
            document.getElementById("brandName").classList.add("invalid");
            openModal('brandModal');
        <% } %>
        <% if (request.getAttribute("categoryNameError") != null) { %>
            document.getElementById("categoryNameError").textContent = "<%= request.getAttribute("categoryNameError") %>";
            document.getElementById("categoryNameError").style.display = "block";
            document.getElementById("categoryName").classList.add("invalid");
            openModal('categoryModal');
        <% } %>
        <% if (request.getAttribute("supplierNameError") != null) { %>
            document.getElementById("supplierNameError").textContent = "<%= request.getAttribute("supplierNameError") %>";
            document.getElementById("supplierNameError").style.display = "block";
            document.getElementById("supplierName").classList.add("invalid");
            openModal('supplierModal');
        <% } %>
        <% if (request.getAttribute("phoneError") != null) { %>
            document.getElementById("phoneError").textContent = "<%= request.getAttribute("phoneError") %>";
            document.getElementById("phoneError").style.display = "block";
            document.getElementById("phone").classList.add("invalid");
            openModal('supplierModal');
        <% } %>
        <% if (request.getAttribute("emailError") != null) { %>
            document.getElementById("emailError").textContent = "<%= request.getAttribute("emailError") %>";
            document.getElementById("emailError").style.display = "block";
            document.getElementById("email").classList.add("invalid");
            openModal('supplierModal');
        <% } %>
    </script>
</body>
</html>