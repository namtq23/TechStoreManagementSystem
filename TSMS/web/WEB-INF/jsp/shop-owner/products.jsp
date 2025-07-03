<%-- 
    Document   : products.
    Created on : May 22, 2025, 11:19:37 AM
    Author     : admin
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.ProductDetailDTO" %>
<%@ page import="util.Validate" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Hàng hóa</title>
        <link rel="stylesheet" href="css/so-products.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
                            <a href="so-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="so-products" method="get">
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Nhóm hàng</h3>
                        </div>
                        <div class="category-tree">
                            <c:forEach var="category" items="${categories}">
                                <div class="category-item">
                                    <c:set var="selectedCategories" value="${paramValues.categories}" />
                                    <input type="checkbox" name="categories" value="${category.categoryID}"
                                           <c:if test="${selectedCategories != null}">
                                               <c:forEach var="catId" items="${selectedCategories}">
                                                   <c:if test="${catId == category.categoryID}">checked</c:if>
                                               </c:forEach>
                                           </c:if>>
                                    <label class="category-label">
                                        <span>${category.categoryName}</span>
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Tồn kho</h3>
                        </div>
                        <div class="filter-content">
                            <label class="radio-item">
                                <input type="radio" name="inventory" value="all"
                                       <c:if test="${param.inventory == 'all' || param.inventory == null}">checked</c:if>>
                                       <span class="radio-mark"></span>
                                       <span class="status-indicator all"></span>
                                       Tất cả
                                </label>
                                <label class="radio-item">
                                    <input type="radio" name="inventory" value="in-stock"
                                    <c:if test="${param.inventory == 'in-stock'}">checked</c:if>>
                                    <span class="radio-mark"></span>
                                    <span class="status-indicator in-stock"></span>
                                    Còn hàng trong kho
                                </label>
                                <label class="radio-item">
                                    <input type="radio" name="inventory" value="out-stock"
                                    <c:if test="${param.inventory == 'out-stock'}">checked</c:if>>
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
                            <div class="price-range">
                                <input type="number" name="minPrice" placeholder="Giá từ" min="0" class="price-input" value="${param.minPrice}">
                            <input type="number" name="maxPrice" placeholder="Giá đến" min="0" class="price-input" value="${param.maxPrice}">
                        </div>
                    </div>

                    <!-- Status Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Trạng thái</h3>
                        </div>
                        <div class="filter-content">
                            <label class="radio-item">
                                <input type="radio" name="status" value="all" <c:if test="${param.status == 'all' || param.status == null}">checked</c:if>>
                                    <span class="radio-mark"></span>
                                    Tất cả
                                </label>
                                <label class="radio-item">
                                    <input type="radio" name="status" value="active" <c:if test="${param.status == 'active'}">checked</c:if>>
                                    <span class="radio-mark"></span>
                                    Đang bán
                                </label>
                                <label class="radio-item">
                                    <input type="radio" name="status" value="inactive" <c:if test="${param.status == 'inactive'}">checked</c:if>>
                                    <span class="radio-mark"></span>
                                    Ngừng bán
                                </label>
                            </div>
                        </div>

                        <div class="filter-actions">
                            <a href="so-products?page=1" class="btn-clear">
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
                            <form action="so-products" method="get" class="search-form" style="display: flex; align-items: center; gap: 8px;">
                                <div style="position: relative; flex: 1;">
                                    <i class="fas fa-search" style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #aaa;"></i>
                                    <input type="text" name="search" placeholder="Theo tên hàng" value="${param.search}"
                                       style="padding: 10px 10px 10px 35px; width: 100%; border: 1px solid #ccc; border-radius: 15px;">
                            </div>
                            <c:forEach var="catId" items="${paramValues.categories}">
                                <input type="hidden" name="categories" value="${catId}" />
                            </c:forEach>
                            <input type="hidden" name="inventory" value="${param.inventory}" />
                            <input type="hidden" name="minPrice" value="${param.minPrice}" />
                            <input type="hidden" name="maxPrice" value="${param.maxPrice}" />
                            <input type="hidden" name="status" value="${param.status}" />
                            <input type="hidden" name="recordsPerPage" value="${recordsPerPage}" />
                            <button type="submit" class="btn btn-success" style="padding: 10px 18px;">Tìm Kiếm</button>
                        </form>

                        <form action="so-add-product" method="get" style="display: inline; margin-left: 10px;">
                            <button type="submit" class="btn btn-success" 
                                    style="padding: 10px 18px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; display: flex; align-items: center; gap: 8px;">
                                <i class="fas fa-plus"></i> Thêm mới
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Products Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Mã hàng</th>
                                <th>Tên hàng</th>
                                <th>Giá nhập</th>
                                <th>Giá bán</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                List<ProductDetailDTO> products = (List<ProductDetailDTO>) request.getAttribute("products");
                                if (products != null) {
                                for (ProductDetailDTO product : products) {
                            %>
                            <tr class="product-row">
                                <td><img src="<%= product.getImageURL() %>" alt="product-img"/></td>
                                <td style="padding-left: 32px;"><%= product.getProductDetailID() %></td>
                                <td><%= product.getDescription() %></td>
                                <td><%= Validate.formatCostPriceToVND(product.getCostPrice()) %></td>
                                <td><%= Validate.formatCostPriceToVND(product.getRetailPrice()) %></td>
                                <td>
                                    <% if (!product.isIsActive()) { %>
                                    <span class="status-badge inactive">Ngừng bán</span>
                                    <% } else { %>
                                    <span class="status-badge active">Đang bán</span>
                                    <% } %>
                                </td>
                                <td style="justify-content: center;align-content: center; display: flex;gap: 5px">
                                    <form action="so-products" method="get" style="display:inline;">
                                        <input type="hidden" name="action" value="view">
                                        <input type="hidden" name="productDetailId" value="<%= product.getProductDetailID() %>">
                                        <button type="submit" class="btn btn-success" style="text-decoration: none; width: 79px;background:#2196F3">Chi tiết</button>
                                    </form>
                                    <form action="so-products" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xoá sản phẩm này không?');">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="productDetailId" value="<%= product.getProductDetailID() %>" />
                                        <button type="submit" class="btn btn-success" style="background: #f44336;">Xoá</button>
                                    </form>
                                </td>
                            </tr>
                            <% 
                                    } 
                                } else { 
                            %>
                            <tr><td colspan="7">Không có dữ liệu sản phẩm.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <form method="GET" action="so-products">
                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị ${startProduct} - ${endProduct} / Tổng số ${totalProducts} hàng hóa
                        </div>

                        <c:forEach var="catId" items="${paramValues.categories}">
                            <input type="hidden" name="categories" value="${catId}" />
                        </c:forEach>
                        <input type="hidden" name="inventory" value="${param.inventory}" />
                        <input type="hidden" name="minPrice" value="${param.minPrice}" />
                        <input type="hidden" name="maxPrice" value="${param.maxPrice}" />
                        <input type="hidden" name="status" value="${param.status}" />
                        <input type="hidden" name="search" value="${param.search}" />
                        <div class="records-per-page">
                            <label for="recordsPerPage">Hiển thị:</label>
                            <select id="recordsPerPage" name="recordsPerPage" class="records-select" onchange="this.form.submit()">
                                <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                <option value="25" ${recordsPerPage == 25 ? 'selected' : ''}>25</option>
                                <option value="50" ${recordsPerPage == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${recordsPerPage == 100 ? 'selected' : ''}>100</option>
                            </select>
                            <span>bản ghi/trang</span>
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
                </form>


            </main>
        </div>
    </body>
    <script>
        // User dropdown
        const userToggle = document.getElementById("dropdownToggle");
        const userMenu = document.getElementById("dropdownMenu");
        userToggle.addEventListener("click", function (e) {
            e.preventDefault();
            userMenu.style.display = userMenu.style.display === "block" ? "none" : "block";
        });
        document.addEventListener("click", function (e) {
            if (!userToggle.contains(e.target) && !userMenu.contains(e.target)) {
                userMenu.style.display = "none";
            }
        });

        // Menu dropdown  
        const menuToggle = document.getElementById("dropdown2Toggle");
        const menuDropdown = document.getElementById("dropdown2Menu");
        menuToggle.addEventListener("click", function (e) {
            e.preventDefault();
            console.log(menuDropdown);
            menuDropdown.style.display = menuDropdown.style.display === "block" ? "none" : "block";
        });
        document.addEventListener("click", function (e) {
            if (!menuToggle.contains(e.target) && !menuDropdown.contains(e.target)) {
                menuDropdown.style.display = "none";
            }
        });
    </script>
</html>
