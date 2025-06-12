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
                    <a href="#" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Giao dịch
                    </a>
                    <a href="bm-customer" class="nav-item">
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
                    <a href="bm-cart" class="nav-item">
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
                <form action="bm-products" method="get">
                    <!-- Category Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Nhóm hàng</h3>
                            <i class="fas fa-question-circle"></i>
                            <i class="fas fa-chevron-up"></i>
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
                            <i class="fas fa-chevron-up"></i>
                        </div>
                        <div class="filter-content">
                            <label class="radio-item">
                                <input type="radio" name="inventory" value="all>
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
                                       style="padding: 10px 10px 10px 60px; width: 100%; border: 1px solid #ccc; border-radius: 15px;">
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
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                            
                            if (products.size() == 0){
                            %>
                        <div>
                            KHÔNG CÓ SẢN PHẨM NÀO.
                        </div>
                        <%
                            }
                            
                        for (ProductDTO product : products) { %>
                        <tr class="">
                            <td><input type="checkbox"></td>
                            <td><div class="product-image phone"></div></td>
                            <td><%= product.getProductDetailId() %></td>
                            <td><%= product.getDescription() %></td>
                            <td><%= Validate.formatCostPriceToVND(product.getRetailPrice())%></td>
                            <td><%= Validate.formatCostPriceToVND(product.getCostPrice())%></td>
                            <td><%= product.getQuantity() %></td>
                            <td><%= Validate.formatDateTime(product.getCreatedAt()) %></td>
                            <td><%= product.getIsActive() %></td>
                            <td style="justify-content: center;align-content: center; display: flex;gap: 5px">
                                <!-- Nút Chi Tiết -->
                                <a href="./so-products?action=view&productDetailId=<%= product.getProductDetailId() %>" 
                                   class="btn btn-success" 
                                   style="text-decoration: none; width: 79px;background:#2196F3">Chi tiết</a>


                                <!-- Nút Xoá -->
                                <form action="so-products" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xoá sản phẩm này không?');">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="productDetailId" value="<%= product.getProductDetailId() %>" />
                                    <button type="submit" class="btn btn-success" style="background: #f44336;">Xoá</button>
                                </form>
                            </td>
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

</html>
