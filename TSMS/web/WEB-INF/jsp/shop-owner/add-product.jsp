<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Brand, model.Category, model.Supplier, java.util.List" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Thêm mới sản phẩm</title>
    <link rel="stylesheet" href="css/so-products.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            background: #f5f7fa;
        }

        .main-container {
            padding: 30px;
            max-width: 900px;
            margin: auto;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-header h1 {
            font-size: 26px;
            color: #333;
        }

        .btn {
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .btn-success {
            background-color: #2196F3;
        }

        .btn-success:hover {
            background-color: #1976D2;
        }

        .btn-danger {
            background-color: #f44336;
        }

        .btn-danger:hover {
            background-color: #d32f2f;
        }

        .form-container {
            background: white;
            padding: 25px 30px;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 18px;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: 6px;
            color: #555;
        }

        .form-group input,
        .form-group textarea,
        .form-group select {
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 15px;
            background: #fafafa;
        }

        .form-group input:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            border-color: #2196F3;
            outline: none;
        }

        .form-group .input-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 30px;
        }

        textarea {
            resize: vertical;
        }

        .error {
            color: #f44336;
            font-size: 12px;
            margin-top: 4px;
            display: none;
        }

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
            background: white;
            padding: 25px;
            border-radius: 12px;
            width: 400px;
            max-width: 90%;
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.1);
        }

        .modal-content h2 {
            font-size: 20px;
            color: #333;
            margin-bottom: 15px;
        }

        .modal-content .form-group {
            margin-bottom: 15px;
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 20px;
            }

            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .form-group .input-group {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <jsp:include page="../common/header-so.jsp" />

    <div class="main-container">
        <main class="main-content">
            <div class="page-header">
                <h1>Thêm mới sản phẩm</h1>
                <a href="so-products" class="btn btn-success">← Quay lại</a>
            </div>

            <div class="form-container">
                <form action="so-products" method="post" class="product-form">
                    <input type="hidden" name="action" value="create">

                    <div class="form-group">
                        <label>Tên hàng: <span style="color: #f44336;">*</span></label>
                        <input type="text" name="productName" value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>" required>
                        <div class="error" id="productNameError"><%= request.getAttribute("productNameError") != null ? request.getAttribute("productNameError") : "" %></div>
                    </div>

                    <div class="form-group">
                        <label>Thương hiệu: <span style="color: #f44336;">*</span></label>
                        <div class="input-group">
                            <select name="brandId" required>
                                <option value="">Chọn thương hiệu</option>
                                <%
                                    List<Brand> brands = (List<Brand>) request.getAttribute("brands");
                                    String selectedBrandId = request.getParameter("brandId") != null ? request.getParameter("brandId") : "";
                                    if (brands != null) {
                                        for (Brand brand : brands) {
                                            String selected = selectedBrandId.equals(String.valueOf(brand.getBrandID())) ? "selected" : "";
                                %>
                                            <option value="<%= brand.getBrandID() %>" <%= selected %>><%= brand.getBrandName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <button type="button" class="btn btn-success" onclick="openModal('brandModal')">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        <div class="error" id="brandIdError"><%= request.getAttribute("brandIdError") != null ? request.getAttribute("brandIdError") : "" %></div>
                    </div>

                    <div class="form-group">
                        <label>Nhóm hàng: <span style="color: #f44336;">*</span></label>
                        <div class="input-group">
                            <select name="categoryId" required>
                                <option value="">Chọn nhóm hàng</option>
                                <%
                                    List<Category> categories = (List<Category>) request.getAttribute("categories");
                                    String selectedCategoryId = request.getParameter("categoryId") != null ? request.getParameter("categoryId") : "";
                                    if (categories != null) {
                                        for (Category category : categories) {
                                            String selected = selectedCategoryId.equals(String.valueOf(category.getCategoryID())) ? "selected" : "";
                                %>
                                            <option value="<%= category.getCategoryID() %>" <%= selected %>><%= category.getCategoryName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <button type="button" class="btn btn-success" onclick="openModal('categoryModal')">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        <div class="error" id="categoryIdError"><%= request.getAttribute("categoryIdError") != null ? request.getAttribute("categoryIdError") : "" %></div>
                    </div>

                    <div class="form-group">
                        <label>Nhà cung cấp: <span style="color: #f44336;">*</span></label>
                        <div class="input-group">
                            <select name="supplierId" required>
                                <option value="">Chọn nhà cung cấp</option>
                                <%
                                    List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
                                    String selectedSupplierId = request.getParameter("supplierId") != null ? request.getParameter("supplierId") : "";
                                    if (suppliers != null) {
                                        for (Supplier supplier : suppliers) {
                                            String selected = selectedSupplierId.equals(String.valueOf(supplier.getSupplierID())) ? "selected" : "";
                                %>
                                            <option value="<%= supplier.getSupplierID() %>" <%= selected %>><%= supplier.getSupplierName() %></option>
                                <%
                                        }
                                    }
                                %>
                            </select>
                            <button type="button" class="btn btn-success" onclick="openModal('supplierModal')">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        <div class="error" id="supplierIdError"><%= request.getAttribute("supplierIdError") != null ? request.getAttribute("supplierIdError") : "" %></div>
                    </div>

                    <div class="form-group">
                        <label>Giá vốn: <span style="color: #f44336;">*</span></label>
                        <input type="text" name="costPrice" value="<%= request.getParameter("costPrice") != null ? request.getParameter("costPrice") : "" %>" required>
                        <div class="error" id="costPriceError"><%= request.getAttribute("costPriceError") != null ? request.getAttribute("costPriceError") : "" %></div>
                    </div>

                    <div class="form-group">
                        <label>Giá bán: <span style="color: #f44336;">*</span></label>
                        <input type="text" name="retailPrice" value="<%= request.getParameter("retailPrice") != null ? request.getParameter("retailPrice") : "" %>" required>
                        <div class="error" id="retailPriceError"><%= request.getAttribute("retailPriceError") != null ? request.getAttribute("retailPriceError") : "" %></div>
                    </div>

                    <div class="form-group">
                        <label>Số lượng: <span style="color: #f44336;">*</span></label>
                        <input type="text" name="quantity" value="<%= request.getParameter("quantity") != null ? request.getParameter("quantity") : "" %>" required>
                        <div class="error" id="quantityError"><%= request.getAttribute("quantityError") != null ? request.getAttribute("quantityError") : "" %></div>
                    </div>

                    <div class="form-group">
                        <label>Số serial/IMEI:</label>
                        <input type="text" name="serialNumber" value="<%= request.getParameter("serialNumber") != null ? request.getParameter("serialNumber") : "" %>">
                    </div>

                    <div class="form-group">
                        <label>Thời hạn bảo hành:</label>
                        <input type="text" name="warrantyPeriod" value="<%= request.getParameter("warrantyPeriod") != null ? request.getParameter("warrantyPeriod") : "" %>" placeholder="Ví dụ: 12 tháng">
                    </div>

                    <div class="form-group">
                        <label>URL hình ảnh:</label>
                        <input type="text" name="imageURL" value="<%= request.getParameter("imageURL") != null ? request.getParameter("imageURL") : "" %>">
                    </div>

                    <div class="form-group">
                        <label>Mô tả:</label>
                        <textarea name="description" rows="4"><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label>Trạng thái: <span style="color: #f44336;">*</span></label>
                        <select name="isActive" required>
                            <option value="1" <%= "1".equals(request.getParameter("isActive")) ? "selected" : "" %>>Kích hoạt</option>
                            <option value="0" <%= "0".equals(request.getParameter("isActive")) ? "selected" : "" %>>Ngừng kinh doanh</option>
                        </select>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn btn-success">Lưu</button>
                        <a href="so-products" class="btn btn-danger">Hủy</a>
                    </div>
                </form>
            </div>

            <div id="brandModal" class="modal" style="display: <%= request.getAttribute("showBrandModal") != null && request.getAttribute("showBrandModal").equals("true") ? "flex" : "none" %>">
                <div class="modal-content">
                    <h2>Thêm thương hiệu</h2>
                    <form action="so-products" method="post">
                        <input type="hidden" name="action" value="addBrand">
                        <input type="hidden" name="productName" value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
                        <input type="hidden" name="brandId" value="<%= request.getParameter("brandId") != null ? request.getParameter("brandId") : "" %>">
                        <input type="hidden" name="categoryId" value="<%= request.getParameter("categoryId") != null ? request.getParameter("categoryId") : "" %>">
                        <input type="hidden" name="supplierId" value="<%= request.getParameter("supplierId") != null ? request.getParameter("supplierId") : "" %>">
                        <input type="hidden" name="costPrice" value="<%= request.getParameter("costPrice") != null ? request.getParameter("costPrice") : "" %>">
                        <input type="hidden" name="retailPrice" value="<%= request.getParameter("retailPrice") != null ? request.getParameter("retailPrice") : "" %>">
                        <input type="hidden" name="quantity" value="<%= request.getParameter("quantity") != null ? request.getParameter("quantity") : "" %>">
                        <input type="hidden" name="serialNumber" value="<%= request.getParameter("serialNumber") != null ? request.getParameter("serialNumber") : "" %>">
                        <input type="hidden" name="warrantyPeriod" value="<%= request.getParameter("warrantyPeriod") != null ? request.getParameter("warrantyPeriod") : "" %>">
                        <input type="hidden" name="imageURL" value="<%= request.getParameter("imageURL") != null ? request.getParameter("imageURL") : "" %>">
                        <input type="hidden" name="description" value="<%= request.getParameter("description") != null ? request.getParameter("description") : "" %>">
                        <input type="hidden" name="isActive" value="<%= request.getParameter("isActive") != null ? request.getParameter("isActive") : "" %>">
                        <div class="form-group">
                            <label>Tên thương hiệu: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="brandName" value="<%= request.getParameter("brandName") != null ? request.getParameter("brandName") : "" %>" required>
                            <div class="error" id="brandNameError"><%= request.getAttribute("brandNameError") != null ? request.getAttribute("brandNameError") : "" %></div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" class="btn btn-danger" onclick="closeModal('brandModal')">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <div id="categoryModal" class="modal" style="display: <%= request.getAttribute("showCategoryModal") != null && request.getAttribute("showCategoryModal").equals("true") ? "flex" : "none" %>">
                <div class="modal-content">
                    <h2>Thêm nhóm hàng</h2>
                    <form action="so-products" method="post">
                        <input type="hidden" name="action" value="addCategory">
                        <input type="hidden" name="productName" value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
                        <input type="hidden" name="brandId" value="<%= request.getParameter("brandId") != null ? request.getParameter("brandId") : "" %>">
                        <input type="hidden" name="categoryId" value="<%= request.getParameter("categoryId") != null ? request.getParameter("categoryId") : "" %>">
                        <input type="hidden" name="supplierId" value="<%= request.getParameter("supplierId") != null ? request.getParameter("supplierId") : "" %>">
                        <input type="hidden" name="costPrice" value="<%= request.getParameter("costPrice") != null ? request.getParameter("costPrice") : "" %>">
                        <input type="hidden" name="retailPrice" value="<%= request.getParameter("retailPrice") != null ? request.getParameter("retailPrice") : "" %>">
                        <input type="hidden" name="quantity" value="<%= request.getParameter("quantity") != null ? request.getParameter("quantity") : "" %>">
                        <input type="hidden" name="serialNumber" value="<%= request.getParameter("serialNumber") != null ? request.getParameter("serialNumber") : "" %>">
                        <input type="hidden" name="warrantyPeriod" value="<%= request.getParameter("warrantyPeriod") != null ? request.getParameter("warrantyPeriod") : "" %>">
                        <input type="hidden" name="imageURL" value="<%= request.getParameter("imageURL") != null ? request.getParameter("imageURL") : "" %>">
                        <input type="hidden" name="description" value="<%= request.getParameter("description") != null ? request.getParameter("description") : "" %>">
                        <input type="hidden" name="isActive" value="<%= request.getParameter("isActive") != null ? request.getParameter("isActive") : "" %>">
                        <div class="form-group">
                            <label>Tên nhóm hàng: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="categoryName" value="<%= request.getParameter("categoryName") != null ? request.getParameter("categoryName") : "" %>" required>
                            <div class="error" id="categoryNameError"><%= request.getAttribute("categoryNameError") != null ? request.getAttribute("categoryNameError") : "" %></div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" class="btn btn-danger" onclick="closeModal('categoryModal')">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <div id="supplierModal" class="modal" style="display: <%= request.getAttribute("showSupplierModal") != null && request.getAttribute("showSupplierModal").equals("true") ? "flex" : "none" %>">
                <div class="modal-content">
                    <h2>Thêm nhà cung cấp</h2>
                    <form action="so-products" method="post">
                        <input type="hidden" name="action" value="addSupplier">
                        <input type="hidden" name="productName" value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
                        <input type="hidden" name="brandId" value="<%= request.getParameter("brandId") != null ? request.getParameter("brandId") : "" %>">
                        <input type="hidden" name="categoryId" value="<%= request.getParameter("categoryId") != null ? request.getParameter("categoryId") : "" %>">
                        <input type="hidden" name="supplierId" value="<%= request.getParameter("supplierId") != null ? request.getParameter("supplierId") : "" %>">
                        <input type="hidden" name="costPrice" value="<%= request.getParameter("costPrice") != null ? request.getParameter("costPrice") : "" %>">
                        <input type="hidden" name="retailPrice" value="<%= request.getParameter("retailPrice") != null ? request.getParameter("retailPrice") : "" %>">
                        <input type="hidden" name="quantity" value="<%= request.getParameter("quantity") != null ? request.getParameter("quantity") : "" %>">
                        <input type="hidden" name="serialNumber" value="<%= request.getParameter("serialNumber") != null ? request.getParameter("serialNumber") : "" %>">
                        <input type="hidden" name="warrantyPeriod" value="<%= request.getParameter("warrantyPeriod") != null ? request.getParameter("warrantyPeriod") : "" %>">
                        <input type="hidden" name="imageURL" value="<%= request.getParameter("imageURL") != null ? request.getParameter("imageURL") : "" %>">
                        <input type="hidden" name="description" value="<%= request.getParameter("description") != null ? request.getParameter("description") : "" %>">
                        <input type="hidden" name="isActive" value="<%= request.getParameter("isActive") != null ? request.getParameter("isActive") : "" %>">
                        <div class="form-group">
                            <label>Tên nhà cung cấp: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="supplierName" value="<%= request.getParameter("supplierName") != null ? request.getParameter("supplierName") : "" %>" required>
                            <div class="error" id="supplierNameError"><%= request.getAttribute("supplierNameError") != null ? request.getAttribute("supplierNameError") : "" %></div>
                        </div>
                        <div class="form-group">
                            <label>Tên liên hệ:</label>
                            <input type="text" name="contactName" value="<%= request.getParameter("contactName") != null ? request.getParameter("contactName") : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="phone" value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>" required>
                            <div class="error" id="phoneError"><%= request.getAttribute("phoneError") != null ? request.getAttribute("phoneError") : "" %></div>
                        </div>
                        <div class="form-group">
                            <label>Email:</label>
                            <input type="email" name="email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                            <div class="error" id="emailError"><%= request.getAttribute("emailError") != null ? request.getAttribute("emailError") : "" %></div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" class="btn btn-danger" onclick="closeModal('supplierModal')">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <script>
        // Client-side form validation
        document.querySelector('.product-form').addEventListener('submit', function(e) {
            let isValid = true;

            const fields = [
                { input: 'productName', error: 'productNameError', message: 'Tên sản phẩm không được để trống.' },
                { input: 'brandId', error: 'brandIdError', message: 'Vui lòng chọn thương hiệu.' },
                { input: 'categoryId', error: 'categoryIdError', message: 'Vui lòng chọn nhóm hàng.' },
                { input: 'supplierId', error: 'supplierIdError', message: 'Vui lòng chọn nhà cung cấp.' },
                { input: 'costPrice', error: 'costPriceError', message: 'Giá vốn phải là số hợp lệ và lớn hơn 0.' },
                { input: 'retailPrice', error: 'retailPriceError', message: 'Giá bán phải là số hợp lệ và lớn hơn giá vốn.' },
                { input: 'quantity', error: 'quantityError', message: 'Số lượng phải là số nguyên dương.' }
            ];

            fields.forEach(field => {
                const input = document.querySelector(`[name="${field.input}"]`);
                const error = document.getElementById(field.error);
                const value = input.value.trim();

                if (!value) {
                    error.textContent = field.message;
                    error.style.display = 'block';
                    input.style.borderColor = '#f44336';
                    isValid = false;
                } else {
                    error.textContent = '';
                    error.style.display = 'none';
                    input.style.borderColor = '';
                }
            });

            const costPrice = parseFloat(document.querySelector('[name="costPrice"]').value);
            const retailPrice = parseFloat(document.querySelector('[name="retailPrice"]').value);
            const quantity = parseInt(document.querySelector('[name="quantity"]').value);

            if (isNaN(costPrice) || costPrice <= 0) {
                document.getElementById('costPriceError').textContent = 'Giá vốn phải là số hợp lệ và lớn hơn 0.';
                document.getElementById('costPriceError').style.display = 'block';
                document.querySelector('[name="costPrice"]').style.borderColor = '#f44336';
                isValid = false;
            }

            if (isNaN(retailPrice) || retailPrice <= 0 || retailPrice <= costPrice) {
                document.getElementById('retailPriceError').textContent = 'Giá bán phải là số hợp lệ và lớn hơn giá vốn.';
                document.getElementById('retailPriceError').style.display = 'block';
                document.querySelector('[name="retailPrice"]').style.borderColor = '#f44336';
                isValid = false;
            }

            if (isNaN(quantity) || quantity < 0) {
                document.getElementById('quantityError').textContent = 'Số lượng phải là số nguyên dương.';
                document.getElementById('quantityError').style.display = 'block';
                document.querySelector('[name="quantity"]').style.borderColor = '#f44336';
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
            }
        });

        // Restrict number inputs to valid numbers
        const numberInputs = document.querySelectorAll('input[name="costPrice"], input[name="retailPrice"], input[name="quantity"]');
        numberInputs.forEach(input => {
            input.addEventListener('input', function() {
                this.value = this.value.replace(/[^0-9.]/g, '');
                if (this.name === 'quantity') {
                    this.value = this.value.replace(/\./g, '');
                }
            });
        });

        // Modal functions
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        // Show server-side errors on page load
        <% if (request.getAttribute("productNameError") != null) { %>
            document.getElementById('productNameError').textContent = '<%= request.getAttribute("productNameError") %>';
            document.getElementById('productNameError').style.display = 'block';
            document.querySelector('[name="productName"]').style.borderColor = '#f44336';
        <% } %>
        <% if (request.getAttribute("brandIdError") != null) { %>
            document.getElementById('brandIdError').textContent = '<%= request.getAttribute("brandIdError") %>';
            document.getElementById('brandIdError').style.display = 'block';
            document.querySelector('[name="brandId"]').style.borderColor = '#f44336';
        <% } %>
        <% if (request.getAttribute("categoryIdError") != null) { %>
            document.getElementById('categoryIdError').textContent = '<%= request.getAttribute("categoryIdError") %>';
            document.getElementById('categoryIdError').style.display = 'block';
            document.querySelector('[name="categoryId"]').style.borderColor = '#f44336';
        <% } %>
        <% if (request.getAttribute("supplierIdError") != null) { %>
            document.getElementById('supplierIdError').textContent = '<%= request.getAttribute("supplierIdError") %>';
            document.getElementById('supplierIdError').style.display = 'block';
            document.querySelector('[name="supplierId"]').style.borderColor = '#f44336';
        <% } %>
        <% if (request.getAttribute("costPriceError") != null) { %>
            document.getElementById('costPriceError').textContent = '<%= request.getAttribute("costPriceError") %>';
            document.getElementById('costPriceError').style.display = 'block';
            document.querySelector('[name="costPrice"]').style.borderColor = '#f44336';
        <% } %>
        <% if (request.getAttribute("retailPriceError") != null) { %>
            document.getElementById('retailPriceError').textContent = '<%= request.getAttribute("retailPriceError") %>';
            document.getElementById('retailPriceError').style.display = 'block';
            document.querySelector('[name="retailPrice"]').style.borderColor = '#f44336';
        <% } %>
        <% if (request.getAttribute("quantityError") != null) { %>
            document.getElementById('quantityError').textContent = '<%= request.getAttribute("quantityError") %>';
            document.getElementById('quantityError').style.display = 'block';
            document.querySelector('[name="quantity"]').style.borderColor = '#f44336';
        <% } %>
        <% if (request.getAttribute("brandNameError") != null) { %>
            document.getElementById('brandNameError').textContent = '<%= request.getAttribute("brandNameError") %>';
            document.getElementById('brandNameError').style.display = 'block';
            document.querySelector('[name="brandName"]').style.borderColor = '#f44336';
            openModal('brandModal');
        <% } %>
        <% if (request.getAttribute("categoryNameError") != null) { %>
            document.getElementById('categoryNameError').textContent = '<%= request.getAttribute("categoryNameError") %>';
            document.getElementById('categoryNameError').style.display = 'block';
            document.querySelector('[name="categoryName"]').style.borderColor = '#f44336';
            openModal('categoryModal');
        <% } %>
        <% if (request.getAttribute("supplierNameError") != null) { %>
            document.getElementById('supplierNameError').textContent = '<%= request.getAttribute("supplierNameError") %>';
            document.getElementById('supplierNameError').style.display = 'block';
            document.querySelector('[name="supplierName"]').style.borderColor = '#f44336';
            openModal('supplierModal');
        <% } %>
        <% if (request.getAttribute("phoneError") != null) { %>
            document.getElementById('phoneError').textContent = '<%= request.getAttribute("phoneError") %>';
            document.getElementById('phoneError').style.display = 'block';
            document.querySelector('[name="phone"]').style.borderColor = '#f44336';
            openModal('supplierModal');
        <% } %>
        <% if (request.getAttribute("emailError") != null) { %>
            document.getElementById('emailError').textContent = '<%= request.getAttribute("emailError") %>';
            document.getElementById('emailError').style.display = 'block';
            document.querySelector('[name="email"]').style.borderColor = '#f44336';
            openModal('supplierModal');
        <% } %>
    </script>
</body>
</html>