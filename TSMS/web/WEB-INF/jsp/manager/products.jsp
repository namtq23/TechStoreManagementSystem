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
                    <a href="bm-overview" class="logo">
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

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Đơn hàng</a>
                            <a href="#" class="dropdown-item">Nhập hàng</a>
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
                            <a href="bm-customer" class="dropdown-item">Khách hàng</a>
                            <a href="bm-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-staff" class="dropdown-item">Danh sách nhân viên</a>
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

                    <a href="bm-cart" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
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
        </header>

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="bm-products" method="get">
                    <!-- Category Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Nhóm hàng</h3>
                        </div>
                        <div class="filter-content">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" id="searchInput" placeholder="Tìm kiếm nhóm hàng">
                            </div>
                            <div class="category-tree">
                                <div class="category-item">
                                    <input type="checkbox" id="all-categories" name="categories" value="all">
                                    <label for="all-categories" class="category-label">
                                        <span>Tất cả</span>
                                    </label>
                                </div>
                                <c:forEach var="category" items="${categories}">
                                    <div class="category-item">
                                        <input type="checkbox" name="categories" value="${category.categoryID}">
                                        <label class="category-label">
                                            <span>${category.categoryName}</span>
                                        </label>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Inventory Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Tồn kho</h3>
                        </div>
                        <div class="filter-content">
                            <label class="radio-item">
                                <input type="radio" name="inventory" value="all" checked>
                                <span class="radio-mark"></span>
                                <span class="status-indicator all"></span>
                                Tất cả
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

                    <!-- Price Range Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Khoảng giá</h3>
                        </div>
                        <div class="filter-content">
                            <div class="price-range">
                                <input type="number" name="minPrice" placeholder="Giá từ" min="0" class="price-input">
                                <input type="number" name="maxPrice" placeholder="Giá đến" min="0" class="price-input">
                            </div>
                        </div>
                    </div>

                    <!-- Status Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Trạng thái</h3>
                        </div>
                        <div class="filter-content">
                            <label class="radio-item">
                                <input type="radio" name="status" value="all" checked>
                                <span class="radio-mark"></span>
                                Tất cả
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="status" value="active">
                                <span class="radio-mark"></span>
                                Đang bán
                            </label>
                            <label class="radio-item">
                                <input type="radio" name="status" value="inactive">
                                <span class="radio-mark"></span>
                                Ngừng bán
                            </label>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="filter-actions">
                        <a href="bm-products?page=1" class="btn-clear">
                            <i class="fas fa-eraser"></i>
                            Xóa bộ lọc
                        </a>
                        <button type="submit" class="btn-apply">
                            <i class="fas fa-filter"></i>
                            Áp dụng lọc
                        </button>
                    </div>
                </form>

            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Hàng hóa</h1>
                    <div class="header-actions">
                        <form action="bm-products" method="get" class="search-form" style="display: flex; align-items: center; gap: 8px;">
                            <div style="position: relative; flex: 1;">
                                <i class="fas fa-search" style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #aaa;"></i>
                                <input type="text" name="search" placeholder="Theo tên hàng"
                                       style="padding: 10px 10px 10px 35px; width: 100%; border: 1px solid #ccc; border-radius: 15px;">
                            </div>
                            <button type="submit" class="btn btn-success" style="padding: 10px 18px;">Tìm Kiếm</button>
                        </form>
                    </div>
                </div>

                <!-- Products Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th class="image-col"></th>
                                <th>Mã hàng</th>
                                <th>Tên hàng</th>
                                <th>Giá bán</th>
                                <th>Tồn kho</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");

                            for (ProductDTO product : products) { %>
                            <tr class="product-row">
                                <td><img src="<%= product.getImgUrl() %>" alt="product-img"/></td>
                                <td style="padding-left: 32px;"><%= product.getProductDetailId() %></td>
                                <td><%= product.getDescription() %></td>
                                <%
                                    double retailPrice = Double.parseDouble(product.getRetailPrice());
                                    double discount = product.getDiscountPercent();
                                    double priceAfterDiscount = retailPrice * (1 - (discount / 100.0));
                                %>
                                <td><%= Validate.formatCostPriceToVND(priceAfterDiscount) %></td>
                                <td><%= product.getQuantity() %></td>
                                <td>
                                    <% if (product.getQuantity() == 0) { %>
                                    <span class="status-badge inactive">Hết hàng</span>
                                    <% } else if ("Ngừng bán".equals(product.getIsActive())) { %>
                                    <span class="status-badge inactive">Ngừng bán</span>
                                    <% } else { %>
                                    <span class="status-badge active"><%= product.getIsActive() %></span>
                                    <% } %>
                                </td>
                            </tr>
                            <tr class="detail-row">
                                <td colspan="9" style="background:#f0f0f0">
                                    <div class="product-detail-container">
                                        <div class="left-section">
                                            <h2><%= product.getProductName() %></h2>
                                            <div class="product-images">
                                                <img src="<%= product.getImgUrl() %>" alt="product-img" />
                                            </div>
                                        </div>

                                        <div class="middle-section">
                                            <table>
                                                <tr><td><strong>Mã hàng:</strong></td><td><%= product.getProductCode() %></td></tr>
                                                <tr><td><strong>Nhóm hàng:</strong></td><td><%= product.getCategory() %></td></tr>
                                                <tr><td><strong>Thương hiệu:</strong></td><td><%= product.getBrand() %></td></tr>
                                                <tr><td><strong>Thời gian tạo:</strong></td><td><%= Validate.formatDateTime(product.getCreatedAt()) %></td></tr>
                                                <tr><td><strong>Giá vốn:</strong></td><td><%= Validate.formatCostPriceToVND(product.getCostPrice())%></td></tr>
                                                <tr><td><strong>Giá bán thực:</strong></td><td><%= Validate.formatCostPriceToVND(product.getRetailPrice())%></td></tr>
                                                <tr><td><strong>Phần trăm giảm(nếu có)</strong></td><td><%= product.getDiscountPercent() %>%</td></tr>
                                            </table>
                                        </div>

                                        <div class="right-section">
                                            <div><strong>Mô tả</strong><br><div class="input-line"><%= product.getDescription() %></div></div>
                                            <div><strong>Nhà cung cấp</strong><br><div class="input-line"><%= product.getSupplier() %></div></div>
                                        </div>

                                        <!--                                        <div class="actions">
                                                                                    <button class="btn green">✅ Cập nhật</button>
                                                                                    <button class="btn red">🗑️ Xoá</button>
                                                                                </div>-->
                                    </div>
                                </td>
                            </tr>

                            <%}%>
                        </tbody>
                    </table>
                    <%
                    if (products.size() == 0){
                    %>
                    <div>
                        KHÔNG CÓ SẢN PHẨM NÀO.
                    </div>
                    <%
                        }
                    %>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startProduct} - ${endProduct} / Tổng số ${totalProducts} hàng hóa
                    </div>
                    <div class="pagination">
                        <a href="${pagingUrl}1" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="${pagingUrl}${currentPage - 1}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pagingUrl}${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="${pagingUrl}${currentPage + 1}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="${pagingUrl}${totalPages}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
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
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.product-row').forEach(function (row) {
                row.addEventListener('click', function () {
                    const detailRow = row.nextElementSibling;
                    if (detailRow && detailRow.classList.contains('detail-row')) {
                        // Toggle display: table-row <=> none
                        if (detailRow.style.display === 'table-row') {
                            detailRow.style.display = 'none';
                        } else {
                            detailRow.style.display = 'table-row';
                        }
                    }
                });
            });

            // Ẩn tất cả detail-row lúc ban đầu
            document.querySelectorAll('.detail-row').forEach(function (row) {
                row.style.display = 'none';
            });
        });
    </script>

</html>
