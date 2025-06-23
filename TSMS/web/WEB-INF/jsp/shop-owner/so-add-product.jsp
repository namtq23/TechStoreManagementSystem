<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thêm sản phẩm mới</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="css/header.css"/>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding: 0;
            }
            .container {
                max-width: 800px;
                margin: 20px auto;
                padding: 20px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }
            h1 {
                text-align: center;
                color: #333;
            }
            .form-group {
                margin-bottom: 15px;
            }
            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            .form-group input, .form-group select, .form-group textarea {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .form-group textarea {
                resize: vertical;
            }
            .error {
                color: #f44336;
                font-size: 0.9em;
                margin-top: 5px;
            }
            .success {
                color: #28a745;
                font-size: 1.1em;
                margin-bottom: 15px;
                text-align: center;
                padding: 10px;
                background-color: #e8f5e9;
                border-radius: 4px;
            }
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                justify-content: center;
                align-items: center;
                z-index: 1000;
            }
            .modal-content {
                background: #fff;
                padding: 20px;
                border-radius: 8px;
                width: 400px;
                max-width: 90%;
            }
            .modal-content h2 {
                margin-top: 0;
            }
            .form-actions {
                display: flex;
                gap: 10px;
                justify-content: flex-end;
            }
            .btn {
                padding: 10px 15px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
            .btn-success {
                background: #28a745;
                color: white;
            }
            .btn-danger {
                background: #f44336;
                color: white;
            }
            .btn-add {
                background: #007bff;
                color: white;
                margin-left: 10px;
                padding: 8px 15px;
                height: 38px;
            }
            .dropdown-container {
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .dropdown-container select {
                flex: 1;
            }
            .image-preview {
                margin-top: 10px;
                max-width: 200px;
                max-height: 200px;
                display: none;
            }
            .image-url {
                margin-top: 10px;
                word-break: break-all;
            }
        </style>
        <script>
            function openModal(modalId) {
                document.getElementById(modalId).style.display = 'flex';
            }
            function closeModal(modalId) {
                document.getElementById(modalId).style.display = 'none';
            }
            function previewImage(event) {
                const file = event.target.files[0];
                const preview = document.getElementById('imagePreview');
                const imageUrl = document.getElementById('imageUrl');
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.style.display = 'block';
                        imageUrl.textContent = 'Tệp đã chọn: ' + file.name;
                    };
                    reader.readAsDataURL(file);
                } else {
                    preview.style.display = 'none';
                    imageUrl.textContent = '';
                }
            }
            // Redirect after success message
            <c:if test="${not empty successMessage}">
            setTimeout(function () {
                window.location.href = 'so-products';
            }, 1000);
            </c:if>
        </script>
    </head>
    <body>
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="so-overview" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="so-products?page=1" class="nav-item active">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="so-createimport" class="dropdown-item">Tạo đơn nhập hàng</a>
                            <a href="so-ienoti" class="dropdown-item">Thông báo nhập/xuất</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-customer" class="dropdown-item">Khách hàng</a>
                            <a href="so-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-staff" class="dropdown-item">Danh sách nhân viên</a>
                            <a href="so-commission" class="dropdown-item">Hoa hồng</a>
                        </div>
                    </div>

                    <a href="so-promotions" class="nav-item">
                        <i class="fas fa-gift"></i>
                        Khuyến mãi
                    </a>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-invoices?reportType=income" class="dropdown-item">Doanh Thu thuần</a>
                            <a href="so-invoices?reportType=outcome" class="dropdown-item">Khoảng chi</a>
                        </div>
                    </div>

                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="#" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="profile" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>
        
        <div class="container">
            <h1>Thêm sản phẩm mới</h1>
            <c:if test="${not empty successMessage}">
                <div class="success">${successMessage}</div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="error">${errorMessage}</div>
            </c:if>
            <form action="so-add-product" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="addProduct">
                <div class="form-group">
                    <label>Tên sản phẩm: <span style="color: #f44336;">*</span></label>
                    <input type="text" name="productName" value="${param.productName}" required>
                    <div class="error">${productNameError}</div>
                </div>
                <div class="form-group">
                    <label>Mã sản phẩm: <span style="color: #f44336;">*</span></label>
                    <input type="text" name="productCode" value="${param.productCode}" required>
                    <div class="error">${productCodeError}</div>
                </div>
                <div class="form-group">
                    <label>Mô tả: <span style="color: #f44336;">*</span></label>
                    <textarea name="description" rows="4" required>${param.description}</textarea>
                    <div class="error">${descriptionError}</div>
                </div>
                <div class="form-group">
                    <label>Giá nhập: <span style="color: #f44336;">*</span></label>
                    <input type="number" name="costPrice" step="0.01" value="${param.costPrice}" required>
                    <div class="error">${costPriceError}</div>
                </div>
                <div class="form-group">
                    <label>Giá bán: <span style="color: #f44336;">*</span></label>
                    <input type="number" name="retailPrice" step="0.01" value="${param.retailPrice}" required>
                    <div class="error">${retailPriceError}</div>
                </div>
                <div class="form-group">
                    <label>Thương hiệu: <span style="color: #f44336;">*</span></label>
                    <div class="dropdown-container">
                        <select name="brandId" required>
                            <option value="">Chọn thương hiệu</option>
                            <c:forEach var="brand" items="${brands}">
                                <option value="${brand.brandID}" ${param.brandId == brand.brandID ? 'selected' : ''}>${brand.brandName}</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn btn-add" onclick="openModal('brandModal')">Thêm mới</button>
                    </div>
                    <div class="error">${brandIdError}</div>
                </div>
                <div class="form-group">
                    <label>Danh mục: <span style="color: #f44336;">*</span></label>
                    <div class="dropdown-container">
                        <select name="categoryId" required>
                            <option value="">Chọn danh mục</option>
                            <c:forEach var="category" items="${categories}">
                                <option value="${category.categoryID}" ${param.categoryId == category.categoryID ? 'selected' : ''}>${category.categoryName}</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn btn-add" onclick="openModal('categoryModal')">Thêm mới</button>
                    </div>
                    <div class="error">${categoryIdError}</div>
                </div>
                <div class="form-group">
                    <label>Nhà cung cấp: <span style="color: #f44336;">*</span></label>
                    <div class="dropdown-container">
                        <select name="supplierId" required>
                            <option value="">Chọn nhà cung cấp</option>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierID}" ${param.supplierId == supplier.supplierID ? 'selected' : ''}>${supplier.supplierName}</option>
                            </c:forEach>
                        </select>
                        <button type="button" class="btn btn-add" onclick="openModal('supplierModal')">Thêm mới</button>
                    </div>
                    <div class="error">${supplierIdError}</div>
                </div>
                <div class="form-group">
                    <label>Thời gian bảo hành: <span style="color: #f44336;">*</span></label>
                    <input type="text" name="warrantyPeriod" value="${param.warrantyPeriod}" required>
                    <div class="error">${warrantyPeriodError}</div>
                </div>
                <div class="form-group">
                    <label>VAT (%): <span style="color: #f44336;">*</span></label>
                    <input type="number" name="vat" step="0.01" value="${param.vat}" required>
                    <div class="error">${vatError}</div>
                </div>
                <div class="form-group">
                    <label>Trạng thái: <span style="color: #f44336;">*</span></label>
                    <select name="isActive" required>
                        <option value="">Chọn trạng thái</option>
                        <option value="1" ${param.isActive == '1' ? 'selected' : ''}>Kích hoạt</option>
                        <option value="0" ${param.isActive == '0' ? 'selected' : ''}>Ngừng kinh doanh</option>
                    </select>
                    <div class="error">${isActiveError}</div>
                </div>
                <div class="form-group">
                    <label>Serial Numbers: <span style="color: #f44336;">*</span></label>
                    <textarea name="serialNumber" rows="3" placeholder="VD: P3-1,P3-2,P4-3" required>${param.serialNumber}</textarea>
                    <div class="error">${serialNumberError}</div>
                </div>
                <div class="form-group">
                    <label>Ảnh sản phẩm: <span style="color: #f44336;">*</span></label>
                    <input type="file" name="image" accept=".png,.jpg,.jpeg" required onchange="previewImage(event)">
                    <img id="imagePreview" class="image-preview" src="#" alt="Ảnh preview">
                    <div id="imageUrl" class="image-url">${imageUrl}</div>
                    <div class="error">${imageError}</div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-success">Lưu sản phẩm</button>
                    <a href="so-products" class="btn btn-danger">Hủy</a>
                </div>
            </form>

            <div id="brandModal" class="modal" style="display: ${showBrandModal == 'true' ? 'flex' : 'none'}">
                <div class="modal-content">
                    <h2>Thêm thương hiệu</h2>
                    <form action="so-add-product" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="addBrand">
                        <input type="hidden" name="productName" value="${param.productName}">
                        <input type="hidden" name="productCode" value="${param.productCode}">
                        <input type="hidden" name="description" value="${param.description}">
                        <input type="hidden" name="costPrice" value="${param.costPrice}">
                        <input type="hidden" name="retailPrice" value="${param.retailPrice}">
                        <input type="hidden" name="brandId" value="${param.brandId}">
                        <input type="hidden" name="categoryId" value="${param.categoryId}">
                        <input type="hidden" name="supplierId" value="${param.supplierId}">
                        <input type="hidden" name="warrantyPeriod" value="${param.warrantyPeriod}">
                        <input type="hidden" name="vat" value="${param.vat}">
                        <input type="hidden" name="isActive" value="${param.isActive}">
                        <input type="hidden" name="serialNumber" value="${param.serialNumber}">
                        <input type="hidden" name="image" value="${param.image}">
                        <div class="form-group">
                            <label>Tên thương hiệu: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="brandName" value="${param.brandName}" required>
                            <div class="error">${brandNameError}</div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" class="btn btn-danger" onclick="closeModal('brandModal')">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <div id="categoryModal" class="modal" style="display: ${showCategoryModal == 'true' ? 'flex' : 'none'}">
                <div class="modal-content">
                    <h2>Thêm danh mục</h2>
                    <form action="so-add-product" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="addCategory">
                        <input type="hidden" name="productName" value="${param.productName}">
                        <input type="hidden" name="productCode" value="${param.productCode}">
                        <input type="hidden" name="description" value="${param.description}">
                        <input type="hidden" name="costPrice" value="${param.costPrice}">
                        <input type="hidden" name="retailPrice" value="${param.retailPrice}">
                        <input type="hidden" name="brandId" value="${param.brandId}">
                        <input type="hidden" name="categoryId" value="${param.categoryId}">
                        <input type="hidden" name="supplierId" value="${param.supplierId}">
                        <input type="hidden" name="warrantyPeriod" value="${param.warrantyPeriod}">
                        <input type="hidden" name="vat" value="${param.vat}">
                        <input type="hidden" name="isActive" value="${param.isActive}">
                        <input type="hidden" name="serialNumber" value="${param.serialNumber}">
                        <input type="hidden" name="image" value="${param.image}">
                        <div class="form-group">
                            <label>Tên danh mục: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="categoryName" value="${param.categoryName}" required>
                            <div class="error">${categoryNameError}</div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" class="btn btn-danger" onclick="closeModal('categoryModal')">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>

            <div id="supplierModal" class="modal" style="display: ${showSupplierModal == 'true' ? 'flex' : 'none'}">
                <div class="modal-content">
                    <h2>Thêm nhà cung cấp</h2>
                    <form action="so-add-product" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" value="addSupplier">
                        <input type="hidden" name="productName" value="${param.productName}">
                        <input type="hidden" name="productCode" value="${param.productCode}">
                        <input type="hidden" name="description" value="${param.description}">
                        <input type="hidden" name="costPrice" value="${param.costPrice}">
                        <input type="hidden" name="retailPrice" value="${param.retailPrice}">
                        <input type="hidden" name="brandId" value="${param.brandId}">
                        <input type="hidden" name="categoryId" value="${param.categoryId}">
                        <input type="hidden" name="supplierId" value="${param.supplierId}">
                        <input type="hidden" name="warrantyPeriod" value="${param.warrantyPeriod}">
                        <input type="hidden" name="vat" value="${param.vat}">
                        <input type="hidden" name="isActive" value="${param.isActive}">
                        <input type="hidden" name="serialNumber" value="${param.serialNumber}">
                        <input type="hidden" name="image" value="${param.image}">
                        <div class="form-group">
                            <label>Tên nhà cung cấp: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="supplierName" value="${param.supplierName}" required>
                            <div class="error">${supplierNameError}</div>
                        </div>
                        <div class="form-group">
                            <label>Tên liên hệ: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="contactName" value="${param.contactName}" required>
                            <div class="error">${contactNameError}</div>
                        </div>
                        <div class="form-group">
                            <label>Số điện thoại: <span style="color: #f44336;">*</span></label>
                            <input type="text" name="phone" value="${param.phone}" required>
                            <div class="error">${phoneError}</div>
                        </div>
                        <div class="form-group">
                            <label>Email: <span style="color: #f44336;">*</span></label>
                            <input type="email" name="email" value="${param.email}" required>
                            <div class="error">${emailError}</div>
                        </div>
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" class="btn btn-danger" onclick="closeModal('supplierModal')">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>