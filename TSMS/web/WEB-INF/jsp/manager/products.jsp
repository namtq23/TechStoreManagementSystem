<%-- 
    Document   : products.
    Created on : May 22, 2025, 11:19:37 AM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.ProductDTO" %>
<%@ page import="util.Validate" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Hàng hóa</title>
        <link rel="stylesheet" href="css/bm-products.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="#" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="bm-overview" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>
                    <a href="bm-products?page=1" class="nav-item active">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Giao dịch
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-handshake"></i>
                        Đối tác
                    </a>
                    <a href="bm-staff" class="nav-item">
                        <i class="fas fa-users"></i>
                        Nhân viên
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-wallet"></i>
                        Sổ quỹ
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-chart-bar"></i>
                        Báo cáo
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-shopping-cart"></i>
                        Bán Online
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
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
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <button class="btn btn-success">
                            <i class="fas fa-plus"></i>
                            Thêm mới
                            <i class="fas fa-chevron-down"></i>
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
                                    <input type="checkbox">
                                </th>
                                <th class="image-col"></th>
                                <th>Mã hàng</th>
                                <th>Tên hàng</th>
                                <th>Giá bán</th>
                                <th>Giá vốn</th>
                                <th>Tồn kho</th>
                                <th>Thời gian tạo</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                            for (ProductDTO product : products) { %>
                            <tr class="">
                                <td><input type="checkbox"></td>
                                <td><div class="product-image phone"></div></td>
                                <td><%= product.getProductDetailId() %></td>
                                <td><%= product.getProductName() %></td>
                                <td><%= Validate.formatCostPriceToVND(product.getRetailPrice())%></td>
                                <td><%= Validate.formatCostPriceToVND(product.getCostPrice())%></td>
                                <td><%= product.getQuantity() %></td>
                                <td><%= Validate.formatDateTime(product.getCreatedAt()) %></td>
                                <td><%= product.getIsActive() %></td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startProduct} - ${endProduct} / Tổng số ${totalProducts} hàng hóa
                    </div>
                    <div class="pagination">
                        <a href="bm-products?page=1" class="page-btn ${currentPage == 1 ? "disabled" : ""}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="bm-products?page=${currentPage - 1}" class="page-btn ${currentPage == 1 ? "disabled" : ""}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="bm-products?page=${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <a href="bm-products?page=${currentPage + 1}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="bm-products?page=${totalPages}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>


            </main>
        </div>

        <!-- Support Chat Button -->
        <div class="support-chat">
            <i class="fas fa-headset"></i>
            <span>Hỗ trợ:1900 9999</span>
        </div>
    </body>
    <script>
        const toggle = document.getElementById("dropdownToggle");
        const menu = document.getElementById("dropdownMenu");

        toggle.addEventListener("click", function (e) {
            e.preventDefault();
            menu.style.display = menu.style.display === "block" ? "none" : "block";
        });

        // Đóng dropdown nếu click ra ngoài
        document.addEventListener("click", function (e) {
            if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                menu.style.display = "none";
            }
        });
    </script>

</html>
