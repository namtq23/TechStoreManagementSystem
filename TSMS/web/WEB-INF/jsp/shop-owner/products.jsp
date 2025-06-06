<%-- 
    Document   : products.
    Created on : May 22, 2025, 11:19:37 AM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.ProductDTO" %>
<%@ page import="util.Validate" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Hàng hóa</title>
    <link rel="stylesheet" href="css/bm-products.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../common/header-so.jsp" />

    <div class="main-container">
        <!-- Sidebar -->
        <aside class="sidebar">
<!--             Product Type Filter 
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Loại hàng</h3>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <label class="checkbox-item">
                        <input type="checkbox" checked>
                        <span class="checkmark"></span>
                        Hàng hóa thường
                    </label>
                    <label class="checkbox-item">
                        <input type="checkbox">
                        <span class="checkmark"></span>
                        Hàng hóa - Serial/IMEI
                    </label>
                    <label class="checkbox-item">
                        <input type="checkbox">
                        <span class="checkmark"></span>
                        Dịch vụ
                    </label>
                    <label class="checkbox-item">
                        <input type="checkbox">
                        <span class="checkmark"></span>
                        Combo - Đóng gói
                    </label>
                </div>
            </div>-->

            <!-- Product Group Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Nhóm hàng</h3>
                    <i class="fas fa-question-circle"></i>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm nhóm hàng">
                    </div>
                    <div class="category-tree">
                        <div class="category-item">
                            <span class="category-label">Tất cả</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Điện thoại</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Đồng hồ thông minh</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Laptop</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Máy tính bảng</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Phụ kiện</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Inventory Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Tồn kho</h3>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="all" checked>
                        <span class="radio-mark"></span>
                        <span class="status-indicator all"></span>
                        Tất cả
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="below">
                        <span class="radio-mark"></span>
                        <span class="status-indicator below"></span>
                        Dưới định mức tồn
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="above">
                        <span class="radio-mark"></span>
                        <span class="status-indicator above"></span>
                        Vượt định mức tồn
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="in-stock">
                        <span class="radio-mark"></span>
                        <span class="status-indicator in-stock"></span>
                        Còn hàng trong kho
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="out-stock">
                        <span class="radio-mark"></span>
                        <span class="status-indicator out-stock"></span>
                        Hết hàng trong kho
                    </label>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1>Hàng hóa</h1>
                <div class="header-actions">
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Theo mã, tên hàng" class="search-input">
                    </div><button class="btn btn-success">
                        Tìm Kiếm
                    </button>

                        <input type="hidden" name="action" value="showCreateForm">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-plus"></i>
                            Thêm mới
                        </button>
                    <button class="btn btn-success">
                        <i class="fas fa-download"></i>
                        Import
                    </button>
                    <button class="btn btn-success">
                        <i class="fas fa-upload"></i>
                        Xuất file
                    </button>
                    <button class="btn btn-menu">
                        <i class="fas fa-bars"></i>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                </div>
            </div>

            <!-- Products Table -->
            <div class="table-container">
                <table class="products-table">
                    <thead>
                        <tr>
                            <th class="checkbox-col">
                                <input type="checkbox" id="selectAll">
                            </th>
                            <th></th>
                            <th>Mã hàng</th>
                            <th>Tên hàng</th>
                            <th>Giá bán</th>
                            <th>Giá vốn</th>
                            <th>Tồn kho</th>
                            <th>Thời gian tạo</th>
                            <th>Trạng thái</th>
                            <th style="justify-content: center;text-align: center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                            for (ProductDTO product : products) { %>
                        <tr>
                            <td><input type="checkbox" class="product-checkbox"></td>
                            <td><div class="product-image phone"></div></td>
                            <td><%= product.getProductDetailId() %></td>
                            <td><%= product.getProductName() %></td>
                            <td><%= Validate.formatCostPriceToVND(product.getRetailPrice()) %></td>
                            <td><%= Validate.formatCostPriceToVND(product.getCostPrice()) %></td>
                            <td><%= product.getQuantity() %></td>
                            <td><%= Validate.formatDateTime(product.getCreatedAt()) %></td>
                            <td><%= product.getIsActive() %></td>
                            <td style="justify-content: center;align-content: center; display: flex;gap: 5px">
                                <!-- Nút Chi Tiết -->
                                <a href="./so-products?action=view&productDetailId=<%= product.getProductDetailId() %>" 
                                   class="btn btn-success" 
                                   style="text-decoration: none; width: 79px;background:#2196F3">Chi tiết</a>
    
                           
                                <!-- Nút Xoá -->
                                <a href="./so-products?action=delete&productDetailId=<%= product.getProductDetailId() %>" 
                                   class="btn btn-success" style="text-decoration: none;background: #f44336;" onclick="return confirm('Bạn có chắc chắn muốn xoá sản phẩm này không?');">Xoá</a>
                                   
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startProduct} - ${endProduct} / Tổng số ${totalProducts} hàng hóa
                    </div>
                    <div class="pagination">
                        <a href="so-products?page=1" class="page-btn ${currentPage == 1 ? "disabled" : ""}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="so-products?page=${currentPage - 1}" class="page-btn ${currentPage == 1 ? "disabled" : ""}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="so-products?page=${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <a href="so-products?page=${currentPage + 1}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="so-products?page=${totalPages}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>

        </main>
    </div>
                    <script>
                document.getElementById('selectAll').addEventListener('change', function () {
                const checkboxes = document.querySelectorAll('.product-checkbox');
                checkboxes.forEach(cb => cb.checked = this.checked);
    });
                    </script>

    <!-- Support Chat Button -->
    <div class="support-chat">
        <i class="fas fa-headset"></i>
        <span>Hỗ trợ:1900 9999</span>
    </div>
</body>
</html>
