<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.ProductDTO" %>
<%@ page import="util.Validate" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Hệ thống bán hàng</title>
        <link rel="stylesheet" href="css/bm-products.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Responsive CSS cho navbar */
            .hamburger-menu {
                display: none;
                flex-direction: column;
                cursor: pointer;
                padding: 10px;
                margin-left: auto;
            }

            .hamburger-menu span {
                width: 25px;
                height: 3px;
                background-color: white;
                margin: 3px 0;
                transition: 0.3s;
                border-radius: 2px;
            }

            .hamburger-menu.active span:nth-child(1) {
                transform: rotate(-45deg) translate(-5px, 6px);
            }

            .hamburger-menu.active span:nth-child(2) {
                opacity: 0;
            }

            .hamburger-menu.active span:nth-child(3) {
                transform: rotate(45deg) translate(-5px, -6px);
            }

            /* Mobile responsive styles */
            @media (max-width: 768px) {
                .hamburger-menu {
                    display: flex;
                }

                .main-nav {
                    position: fixed;
                    top: 70px; /* Chiều cao của header */
                    left: -100%;
                    width: 100%;
                    height: calc(100vh - 70px);
                    background-color: white;
                    flex-direction: column;
                    justify-content: flex-start;
                    align-items: stretch;
                    transition: left 0.3s ease;
                    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    z-index: 1000;
                    padding: 20px 0;
                }

                .main-nav.active {
                    left: 0;
                }

                .main-nav .nav-item {
                    width: 100%;
                    padding: 15px 20px;
                    border-bottom: 1px solid #eee;
                    justify-content: flex-start;
                    margin: 0;
                    color: black;
                }

                .main-nav .nav-item:hover {
                    background-color: #f5f5f5;
                }

                .main-nav .dropdown {
                    position: static;
                }

                .main-nav .dropdown-menu {
                    position: static;
                    display: none;
                    box-shadow: none;
                    border: none;
                    background-color: #f8f9fa;
                    padding-left: 20px;
                }

                .main-nav .dropdown.active .dropdown-menu {
                    display: block;
                }

                .header-container {
                    position: relative;
                }

                /* Overlay để đóng menu khi click bên ngoài */
                .mobile-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background-color: rgba(0, 0, 0, 0.5);
                    z-index: 999;
                    display: none;
                }

                .mobile-overlay.active {
                    display: block;
                }

                /* Đảm bảo main content không bị che khuất */
                .main-container {
                    margin-top: 0;
                }
            }

            /* Đảm bảo sidebar cũng responsive */
            @media (max-width: 768px) {
                .main-container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                    margin-bottom: 20px;
                }

                .main-content {
                    width: 100%;
                }
            }
        </style>
    </head>
    <body>
        <!-- Mobile Overlay -->
        <div class="mobile-overlay" id="mobileOverlay"></div>

        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="sale-products?page=1" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>

                <!-- Hamburger Menu -->
                <div class="hamburger-menu" id="hamburgerMenu">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>

                <nav class="main-nav" id="mainNav">
                    <a href="sale-products?page=1" class="nav-item active">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <a href="sale-sendnoti" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Gửi yêu cầu 
                    </a>

                    <a href="sale-mycustomer" class="nav-item">
                        <i class="fas fa-users"></i>
                        Khách hàng của tôi
                    </a>

                    <div class="nav-item dropdown" id="reportDropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="sale-mycommissions" class="dropdown-item">Hoa hồng</a>
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
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="sale-products" method="get">
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
                            <a href="sale-products?page=1" class="btn-clear">
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
                            <form action="sale-products" method="get" class="search-form" style="display: flex; align-items: center; gap: 8px;">
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
                <form method="GET" action="sale-products">
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

        <!-- Support Chat Button -->
        <div class="support-chat">
            <i class="fas fa-headset"></i>
            <span>Hỗ trợ:1900 9999</span>
        </div>

        <script>
            // User dropdown functionality
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

            // Mobile hamburger menu functionality
            const hamburgerMenu = document.getElementById("hamburgerMenu");
            const mainNav = document.getElementById("mainNav");
            const mobileOverlay = document.getElementById("mobileOverlay");
            const reportDropdown = document.getElementById("reportDropdown");

            // Toggle mobile menu
            hamburgerMenu.addEventListener("click", function () {
                hamburgerMenu.classList.toggle("active");
                mainNav.classList.toggle("active");
                mobileOverlay.classList.toggle("active");
                document.body.style.overflow = mainNav.classList.contains("active") ? "hidden" : "auto";
            });

            // Close mobile menu when clicking overlay
            mobileOverlay.addEventListener("click", function () {
                hamburgerMenu.classList.remove("active");
                mainNav.classList.remove("active");
                mobileOverlay.classList.remove("active");
                document.body.style.overflow = "auto";
            });

            // Handle dropdown in mobile menu
            reportDropdown.addEventListener("click", function (e) {
                if (window.innerWidth <= 768) {
                    e.preventDefault();
                    reportDropdown.classList.toggle("active");
                }
            });

            // Close mobile menu when window is resized to desktop
            window.addEventListener("resize", function () {
                if (window.innerWidth > 768) {
                    hamburgerMenu.classList.remove("active");
                    mainNav.classList.remove("active");
                    mobileOverlay.classList.remove("active");
                    reportDropdown.classList.remove("active");
                    document.body.style.overflow = "auto";
                }
            });

            // Product detail functionality
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
    </body>
</html>