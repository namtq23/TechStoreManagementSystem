<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ProductDetailDTO, model.Brand, model.Category, model.Supplier, util.Validate, java.util.List, java.text.DecimalFormat" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Chi tiết hàng hóa</title>
        <link rel="stylesheet" href="css/so-products.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            * {
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', 'Segoe UI', sans-serif;
                margin: 0;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                color: #2d3748;
            }

            .main-container {
                padding: 2rem;
                max-width: 1000px;
                margin: 0 auto;
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 2rem;
                padding: 0 0.5rem;
            }

            .page-header h1 {
                font-size: 2rem;
                font-weight: 700;
                color: #1a202c;
                margin: 0;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                border: none;
                border-radius: 0.75rem;
                color: white;
                font-size: 0.875rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            }

            .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            }

            .btn-success {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .btn-success:hover {
                background: linear-gradient(135deg, #43a3f5 0%, #00d9fe 100%);
            }

            .btn-danger {
                background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            }

            .btn-danger:hover {
                background: linear-gradient(135deg, #f9658a 0%, #fed030 100%);
            }

            .btn-secondary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .btn-secondary:hover {
                background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            }

            .form-container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                padding: 2.5rem;
                border-radius: 1.5rem;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .form-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 1.5rem;
            }

            .form-group {
                display: flex;
                flex-direction: column;
                margin-bottom: 0;
                position: relative;
            }

            .form-group label {
                font-weight: 600;
                margin-bottom: 0.5rem;
                color: #4a5568;
                font-size: 0.875rem;
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .form-group input,
            .form-group textarea,
            .form-group select {
                padding: 0.875rem 1rem;
                border: 2px solid #e2e8f0;
                border-radius: 0.75rem;
                font-size: 1rem;
                background: #ffffff;
                transition: all 0.3s ease;
                font-family: inherit;
            }

            .form-group input:focus,
            .form-group textarea:focus,
            .form-group select:focus {
                outline: none;
                border-color: #4facfe;
                box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
                transform: translateY(-1px);
            }

            .form-group input[readonly] {
                background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
                color: #718096;
                cursor: not-allowed;
                border-color: #cbd5e0;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
            }

            /* Validation Styles */
            .form-group.error input,
            .form-group.error textarea,
            .form-group.error select {
                border-color: #f56565;
                box-shadow: 0 0 0 3px rgba(245, 101, 101, 0.1);
            }

            .form-group.success input,
            .form-group.success textarea,
            .form-group.success select {
                border-color: #48bb78;
                box-shadow: 0 0 0 3px rgba(72, 187, 120, 0.1);
            }

            .error-message {
                color: #f56565;
                font-size: 0.75rem;
                margin-top: 0.25rem;
                display: flex;
                align-items: center;
                gap: 0.25rem;
                opacity: 0;
                transform: translateY(-10px);
                transition: all 0.3s ease;
            }

            .error-message.show {
                opacity: 1;
                transform: translateY(0);
            }

            .success-message {
                color: #48bb78;
                font-size: 0.75rem;
                margin-top: 0.25rem;
                display: flex;
                align-items: center;
                gap: 0.25rem;
                opacity: 0;
                transform: translateY(-10px);
                transition: all 0.3s ease;
            }

            .success-message.show {
                opacity: 1;
                transform: translateY(0);
            }

            .form-actions {
                display: flex;
                gap: 1rem;
                justify-content: flex-end;
                margin-top: 2.5rem;
                padding-top: 2rem;
                border-top: 1px solid #e2e8f0;
            }

            /* Toast Notifications */
            .toast-container {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                max-width: 400px;
                pointer-events: none;
            }

            .toast {
                background: white;
                padding: 16px 20px;
                border-radius: 12px;
                margin-bottom: 12px;
                display: flex;
                align-items: center;
                gap: 12px;
                font-size: 14px;
                font-weight: 500;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
                border-left: 4px solid;
                animation: slideInRight 0.3s ease-out;
                cursor: pointer;
                transition: all 0.3s ease;
                pointer-events: auto;
                min-width: 300px;
            }

            .toast:hover {
                transform: translateX(-5px);
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            }

            .toast-success {
                border-left-color: #48bb78;
                background: linear-gradient(135deg, #f0fff4 0%, #c6f6d5 100%);
                color: #2f855a;
            }

            .toast-success .toast-icon {
                color: #48bb78;
            }

            .toast-error {
                border-left-color: #f56565;
                background: linear-gradient(135deg, #fed7d7 0%, #feb2b2 100%);
                color: #c53030;
            }

            .toast-error .toast-icon {
                color: #f56565;
            }

            .toast-close {
                margin-left: auto;
                cursor: pointer;
                opacity: 0.7;
                transition: opacity 0.2s;
                font-size: 16px;
            }

            .toast-close:hover {
                opacity: 1;
            }

            @keyframes slideInRight {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }

            @keyframes slideOutRight {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }

            .toast.slide-out {
                animation: slideOutRight 0.3s ease-in forwards;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .main-container {
                    padding: 1rem;
                }

                .form-container {
                    padding: 1.5rem;
                }

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .form-actions {
                    flex-direction: column;
                }

                .page-header {
                    flex-direction: column;
                    gap: 1rem;
                    text-align: center;
                }

                .toast-container {
                    top: 10px;
                    right: 10px;
                    left: 10px;
                    max-width: none;
                }

                .toast {
                    min-width: auto;
                }
            }

            /* Loading Animation */
            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
                transform: none !important;
            }

            .btn.loading::after {
                content: '';
                width: 16px;
                height: 16px;
                border: 2px solid transparent;
                border-top: 2px solid currentColor;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-left: 0.5rem;
            }

            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }
        </style>
    </head>
    <body>
        <!-- Toast Container -->
        <div class="toast-container" id="toastContainer"></div>

        <!-- Header -->
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
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Đơn hàng</a>
                            <a href="#" class="dropdown-item">Yêu cầu nhập hàng</a>
                        </div>
                    </div>
                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
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
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-staff" class="dropdown-item">Danh sách nhân viên</a>
                            <a href="#" class="dropdown-item">Hoa hồng</a>
                        </div>
                    </div>
                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Tài chính</a>
                            <a href="#" class="dropdown-item">Đật hàng</a>
                            <a href="#" class="dropdown-item">Hàng hoá</a>
                            <a href="#" class="dropdown-item">Khách hàng</a>
                        </div>
                    </div>
                </nav>
                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="" class="user-icon gradient" id="dropdownToggle">
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

        <div class="main-container">
            <main class="main-content">
                <div class="page-header">
                    <h1>Chi tiết hàng hóa</h1>
                    <a href="so-products?page=1" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                </div>

                <% 
                ProductDetailDTO product = (ProductDetailDTO) request.getAttribute("product");
                List<Brand> brands = (List<Brand>) request.getAttribute("brands");
                List<Category> categories = (List<Category>) request.getAttribute("categories");
                List<Supplier> suppliers = (List<Supplier>) request.getAttribute("suppliers");
                
                // Tạo DecimalFormat để format số
                DecimalFormat df = new DecimalFormat("#");
                df.setMaximumFractionDigits(0);
                %>

                <% if (product != null) { %>
                <div class="form-container">
                    <form action="so-products" method="post" class="product-form" id="productForm" novalidate>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="productDetailId" value="<%= product.getProductDetailID() %>">

                        <div class="form-grid">
                            <!-- Read-only Fields -->
                            <div class="form-group">
                                <label>Mã sản phẩm</label>
                                <input type="text" value="<%= product.getProductDetailID() %>" readonly>
                            </div>

                            <div class="form-group">
                                <label>Mã hàng</label>
                                <input type="text" value="<%= product.getProductCode() %>" readonly>
                            </div>

                            <!-- Editable Fields -->
                            <div class="form-group" id="productNameGroup">
                                <label>Tên sản phẩm</label>
                                <input type="text" name="productName" id="productName" value="<%
                                    String inputProductName = (String) request.getAttribute("inputProductName");
                                    if (inputProductName != null) {
                                        out.print(inputProductName);
                                    } else {
                                        out.print(product.getProductName() != null ? product.getProductName() : "");
                                    }
                                       %>" required>
                                <div class="error-message" id="productNameError">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span></span>
                                </div>
                            </div>

                            <div class="form-group" id="warrantyPeriodGroup">
                                <label>Thời gian bảo hành <span style="color: #f56565;">*</span></label>
                                <input type="text" name="warrantyPeriod" id="warrantyPeriod" value="<%
                                    String inputWarrantyPeriod = (String) request.getAttribute("inputWarrantyPeriod");
                                    if (inputWarrantyPeriod != null) {
                                        out.print(inputWarrantyPeriod);
                                    } else {
                                        out.print(product.getWarrantyPeriod() != null ? product.getWarrantyPeriod() : "");
                                    }
                                       %>" placeholder="Ví dụ: 12 tháng, 2 năm" required>
                                <div class="error-message" id="warrantyPeriodError">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span></span>
                                </div>
                                <div class="success-message" id="warrantyPeriodSuccess">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Thời gian bảo hành hợp lệ</span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Thương hiệu</label>
                                <select name="brandId" required>
                                    <option value="">-- Chọn thương hiệu --</option>
                                    <% 
                                    String inputBrandId = (String) request.getAttribute("inputBrandId");
                                    int selectedBrandId;
                                    if (inputBrandId != null) {
                                        try {
                                            selectedBrandId = Integer.parseInt(inputBrandId);
                                        } catch (NumberFormatException e) {
                                            selectedBrandId = product.getBrandID();
                                        }
                                    } else {
                                        selectedBrandId = product.getBrandID();
                                    }
                                    
                                    if (brands != null) {
                                        for (Brand brand : brands) {
                                    %>
                                    <option value="<%= brand.getBrandID() %>" <%= brand.getBrandID() == selectedBrandId ? "selected" : "" %>>
                                        <%= brand.getBrandName() %>
                                    </option>
                                    <% 
                                        }
                                    }
                                    %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Danh mục</label>
                                <select name="categoryId" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <% 
                                    String inputCategoryId = (String) request.getAttribute("inputCategoryId");
                                    int selectedCategoryId;
                                    if (inputCategoryId != null) {
                                        try {
                                            selectedCategoryId = Integer.parseInt(inputCategoryId);
                                        } catch (NumberFormatException e) {
                                            selectedCategoryId = product.getCategoryID();
                                        }
                                    } else {
                                        selectedCategoryId = product.getCategoryID();
                                    }
                                    
                                    if (categories != null) {
                                        for (Category category : categories) {
                                    %>
                                    <option value="<%= category.getCategoryID() %>" <%= category.getCategoryID() == selectedCategoryId ? "selected" : "" %>>
                                        <%= category.getCategoryName() %>
                                    </option>
                                    <% 
                                        }
                                    }
                                    %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Nhà cung cấp</label>
                                <select name="supplierId" required>
                                    <option value="">-- Chọn nhà cung cấp --</option>
                                    <% 
                                    String inputSupplierId = (String) request.getAttribute("inputSupplierId");
                                    int selectedSupplierId;
                                    if (inputSupplierId != null) {
                                        try {
                                            selectedSupplierId = Integer.parseInt(inputSupplierId);
                                        } catch (NumberFormatException e) {
                                            selectedSupplierId = product.getSupplierID();
                                        }
                                    } else {
                                        selectedSupplierId = product.getSupplierID();
                                    }
                                    
                                    if (suppliers != null) {
                                        for (Supplier supplier : suppliers) {
                                    %>
                                    <option value="<%= supplier.getSupplierID() %>" <%= supplier.getSupplierID() == selectedSupplierId ? "selected" : "" %>>
                                        <%= supplier.getSupplierName() %>
                                    </option>
                                    <% 
                                        }
                                    }
                                    %>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Trạng thái</label>
                                <select name="isActive" required>
                                    <%
                                        String inputIsActive = (String) request.getAttribute("inputIsActive");
                                        boolean selectedActive;
                                        if (inputIsActive != null) {
                                            selectedActive = "1".equals(inputIsActive);
                                        } else {
                                            selectedActive = product.isIsActive();
                                        }
                                    %>
                                    <option value="1" <%= selectedActive ? "selected" : "" %>>Đang bán</option>
                                    <option value="0" <%= !selectedActive ? "selected" : "" %>>Ngừng bán</option>
                                </select>
                            </div>

                            <div class="form-group" id="costPriceGroup">
                                <label>Giá vốn (VNĐ)</label>
                                <input type="text" name="costPrice" id="costPrice" value="<%
                                    String inputCostPrice = (String) request.getAttribute("inputCostPrice");
                                    if (inputCostPrice != null) {
                                        out.print(inputCostPrice);
                                    } else {
                                        out.print(df.format(product.getCostPrice()));
                                    }
                                       %>" required>
                                <div class="error-message" id="costPriceError">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span></span>
                                </div>
                                <div class="success-message" id="costPriceSuccess">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Giá vốn hợp lệ</span>
                                </div>
                            </div>

                            <div class="form-group" id="retailPriceGroup">
                                <label>Giá bán (VNĐ)</label>
                                <input type="text" name="retailPrice" id="retailPrice" value="<%
                                    String inputRetailPrice = (String) request.getAttribute("inputRetailPrice");
                                    if (inputRetailPrice != null) {
                                        out.print(inputRetailPrice);
                                    } else {
                                        out.print(df.format(product.getRetailPrice()));
                                    }
                                       %>" required>
                                <div class="error-message" id="retailPriceError">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span></span>
                                </div>
                                <div class="success-message" id="retailPriceSuccess">
                                    <i class="fas fa-check-circle"></i>
                                    <span>Giá bán hợp lệ</span>
                                </div>
                            </div>

                            <div class="form-group" id="vatGroup">
                                <label>VAT (%)</label>
                                <input type="text" name="vat" id="vat" value="<%
                                    String inputVat = (String) request.getAttribute("inputVat");
                                    if (inputVat != null) {
                                        out.print(inputVat);
                                    } else {
                                        DecimalFormat vatFormat = new DecimalFormat("#.##");
                                        out.print(vatFormat.format(product.getVat()));
                                    }
                                       %>" required>
                                <div class="error-message" id="vatError">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <span></span>
                                </div>
                                <div class="success-message" id="vatSuccess">
                                    <i class="fas fa-check-circle"></i>
                                    <span>VAT hợp lệ</span>
                                </div>
                            </div>
                        </div>

                        <div class="form-group" style="grid-column: 1 / -1; margin-top: 1.5rem;">
                            <label>Mô tả</label>
                            <textarea name="description" rows="4" required><%
                                String inputDescription = (String) request.getAttribute("inputDescription");
                                if (inputDescription != null) {
                                    out.print(inputDescription);
                                } else {
                                    out.print(product.getDescription() != null ? product.getDescription() : "");
                                }
                                %></textarea>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success" id="submitBtn">
                                <i class="fas fa-save"></i> Cập nhật
                            </button>
                            <a href="so-products?page=1" class="btn btn-danger">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                        </div>
                    </form>
                </div>

                <% } else { %>
                <div style="text-align: center; padding: 3rem; background: rgba(255, 255, 255, 0.95); border-radius: 1.5rem; backdrop-filter: blur(10px);">
                    <i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: #ed8936; margin-bottom: 1rem;"></i>
                    <h3 style="color: #2d3748; margin-bottom: 1rem;">Không tìm thấy thông tin sản phẩm!</h3>
                    <a href="so-products?page=1" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Quay lại danh sách
                    </a>
                </div>
                <% } %>
            </main>
        </div>

        <script>
            // Validation functions
            function showError(fieldId, message) {
                const group = document.getElementById(fieldId + 'Group');
                const errorElement = document.getElementById(fieldId + 'Error');
                const successElement = document.getElementById(fieldId + 'Success');

                if (group && errorElement) {
                    group.classList.remove('success');
                    group.classList.add('error');
                    errorElement.querySelector('span').textContent = message;
                    errorElement.classList.add('show');

                    if (successElement) {
                        successElement.classList.remove('show');
                    }
                }
            }

            function showSuccess(fieldId) {
                const group = document.getElementById(fieldId + 'Group');
                const errorElement = document.getElementById(fieldId + 'Error');
                const successElement = document.getElementById(fieldId + 'Success');

                if (group && successElement) {
                    group.classList.remove('error');
                    group.classList.add('success');
                    successElement.classList.add('show');

                    if (errorElement) {
                        errorElement.classList.remove('show');
                    }
                }
            }

            function clearValidation(fieldId) {
                const group = document.getElementById(fieldId + 'Group');
                const errorElement = document.getElementById(fieldId + 'Error');
                const successElement = document.getElementById(fieldId + 'Success');

                if (group) {
                    group.classList.remove('error', 'success');
                }
                if (errorElement) {
                    errorElement.classList.remove('show');
                }
                if (successElement) {
                    successElement.classList.remove('show');
                }
            }

            // Validate warranty period
            function validateWarrantyPeriod() {
                const warrantyPeriod = document.getElementById('warrantyPeriod');
                const value = warrantyPeriod.value.trim();

                if (value === '') {
                    showError('warrantyPeriod', 'Thời gian bảo hành không được để trống');
                    return false;
                } else if (value.length > 50) {
                    showError('warrantyPeriod', 'Thời gian bảo hành không được vượt quá 50 ký tự');
                    return false;
                } else {
                    showSuccess('warrantyPeriod');
                    return true;
                }
            }

            // Validate number input (only allow numbers and decimal point)
            function validateNumberInput(input, fieldId, fieldName, min = 0, max = 999999999) {
                const value = input.value.trim();

                // Remove any non-numeric characters except decimal point
                const cleanValue = value.replace(/[^0-9.]/g, '');

                // Check if value changed after cleaning
                if (cleanValue !== value) {
                    input.value = cleanValue;
                    showError(fieldId, fieldName + ' chỉ được nhập số');
                    return false;
                }

                if (cleanValue === '') {
                    showError(fieldId, fieldName + ' không được để trống');
                    return false;
                }

                // Check for multiple decimal points
                const decimalCount = (cleanValue.match(/\./g) || []).length;
                if (decimalCount > 1) {
                    showError(fieldId, fieldName + ' không hợp lệ');
                    return false;
                }

                const numValue = parseFloat(cleanValue);

                if (isNaN(numValue)) {
                    showError(fieldId, fieldName + ' không hợp lệ');
                    return false;
                }

                if (numValue <= min) {
                    showError(fieldId, fieldName + ' phải lớn hơn ' + min);
                    return false;
                }

                if (numValue > max) {
                    showError(fieldId, fieldName + ' không được vượt quá ' + max.toLocaleString());
                    return false;
                }

                showSuccess(fieldId);
                return true;
            }

            // Validate VAT (0-100%)
            function validateVAT() {
                const vatInput = document.getElementById('vat');
                const value = vatInput.value.trim();

                // Remove any non-numeric characters except decimal point
                const cleanValue = value.replace(/[^0-9.]/g, '');

                if (cleanValue !== value) {
                    vatInput.value = cleanValue;
                    showError('vat', 'VAT chỉ được nhập số');
                    return false;
                }

                if (cleanValue === '') {
                    showError('vat', 'VAT không được để trống');
                    return false;
                }

                const numValue = parseFloat(cleanValue);

                if (isNaN(numValue)) {
                    showError('vat', 'VAT không hợp lệ');
                    return false;
                }

                if (numValue < 0 || numValue > 100) {
                    showError('vat', 'VAT phải từ 0 đến 100%');
                    return false;
                }

                showSuccess('vat');
                return true;
            }

            // Validate price comparison (retail > cost)
            function validatePriceComparison() {
                const costPrice = parseFloat(document.getElementById('costPrice').value.replace(/[^0-9.]/g, ''));
                const retailPrice = parseFloat(document.getElementById('retailPrice').value.replace(/[^0-9.]/g, ''));

                if (!isNaN(costPrice) && !isNaN(retailPrice) && retailPrice <= costPrice) {
                    showError('retailPrice', 'Giá bán phải lớn hơn giá vốn');
                    return false;
                }

                return true;
            }

            // Toast notification system
            function showToast(message, type) {
                const toastContainer = document.getElementById('toastContainer');
                if (!toastContainer)
                    return;

                const toast = document.createElement('div');
                toast.className = 'toast toast-' + type;

                const icon = type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle';

                toast.innerHTML =
                        '<i class="toast-icon ' + icon + '"></i>' +
                        '<span>' + message + '</span>' +
                        '<i class="fas fa-times toast-close"></i>';

                toastContainer.appendChild(toast);

                const autoRemoveTimer = setTimeout(function () {
                    removeToast(toast);
                }, 5000);

                const closeBtn = toast.querySelector('.toast-close');
                if (closeBtn) {
                    closeBtn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        clearTimeout(autoRemoveTimer);
                        removeToast(toast);
                    });
                }

                toast.addEventListener('click', function () {
                    clearTimeout(autoRemoveTimer);
                    removeToast(toast);
                });
            }

            function removeToast(toast) {
                if (!toast || !toast.parentNode)
                    return;

                toast.classList.add('slide-out');
                setTimeout(function () {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 300);
            }

            // Initialize validation when page loads
            document.addEventListener('DOMContentLoaded', function () {
                // Show server messages
            <% 
                String successMessage = (String) session.getAttribute("successMessage");
                if (successMessage != null) {
                    session.removeAttribute("successMessage");
            %>
                showToast('<%= successMessage.replace("'", "\\'") %>', 'success');
            <% } %>

            <% 
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                showToast('<%= errorMessage.replace("'", "\\'") %>', 'error');
            <% } %>

                // Add event listeners for validation
                const warrantyPeriod = document.getElementById('warrantyPeriod');
                const costPrice = document.getElementById('costPrice');
                const retailPrice = document.getElementById('retailPrice');
                const vat = document.getElementById('vat');

                if (warrantyPeriod) {
                    warrantyPeriod.addEventListener('blur', validateWarrantyPeriod);
                    warrantyPeriod.addEventListener('input', function () {
                        if (this.value.trim() !== '') {
                            validateWarrantyPeriod();
                        } else {
                            clearValidation('warrantyPeriod');
                        }
                    });
                }

                if (costPrice) {
                    costPrice.addEventListener('input', function () {
                        validateNumberInput(this, 'costPrice', 'Giá vốn');
                        validatePriceComparison();
                    });
                    costPrice.addEventListener('blur', function () {
                        validateNumberInput(this, 'costPrice', 'Giá vốn');
                        validatePriceComparison();
                    });
                }

                if (retailPrice) {
                    retailPrice.addEventListener('input', function () {
                        validateNumberInput(this, 'retailPrice', 'Giá bán');
                        validatePriceComparison();
                    });
                    retailPrice.addEventListener('blur', function () {
                        validateNumberInput(this, 'retailPrice', 'Giá bán');
                        validatePriceComparison();
                    });
                }

                if (vat) {
                    vat.addEventListener('input', validateVAT);
                    vat.addEventListener('blur', validateVAT);
                }

                // Form submission validation
                const productForm = document.getElementById('productForm');
                if (productForm) {
                    productForm.addEventListener('submit', function (e) {
                        let isValid = true;

                        // Validate all fields
                        if (!validateWarrantyPeriod())
                            isValid = false;
                        if (!validateNumberInput(costPrice, 'costPrice', 'Giá vốn'))
                            isValid = false;
                        if (!validateNumberInput(retailPrice, 'retailPrice', 'Giá bán'))
                            isValid = false;
                        if (!validateVAT())
                            isValid = false;
                        if (!validatePriceComparison())
                            isValid = false;

                        if (!isValid) {
                            e.preventDefault();
                            showToast('Vui lòng kiểm tra lại thông tin đã nhập', 'error');
                            return false;
                        }

                        // Show loading state
                        const submitBtn = document.getElementById('submitBtn');
                        if (submitBtn) {
                            submitBtn.classList.add('loading');
                            submitBtn.disabled = true;
                        }
                    });
                }

                // Dropdown functionality
                const dropdownToggle = document.getElementById('dropdownToggle');
                const dropdownMenu = document.getElementById('dropdownMenu');

                if (dropdownToggle && dropdownMenu) {
                    dropdownToggle.addEventListener('click', function (e) {
                        e.preventDefault();
                        dropdownMenu.style.display = dropdownMenu.style.display === 'block' ? 'none' : 'block';
                    });

                    document.addEventListener('click', function (e) {
                        if (!dropdownToggle.contains(e.target) && !dropdownMenu.contains(e.target)) {
                            dropdownMenu.style.display = 'none';
                        }
                    });
                }
            });
        </script>
    </body>
</html>