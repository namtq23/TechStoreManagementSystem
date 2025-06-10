<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.ProductDTO, model.SalesTransactionDTO, model.PromotionDTO, model.SalesStatisticsDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
String currentSection = (String) request.getAttribute("currentSection");
if (currentSection == null) currentSection = "products";
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Hệ thống bán hàng</title>
        <link rel="stylesheet" href="css/sale.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="salepage" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="salepage?section=products" class="nav-item <%= "products".equals(currentSection) ? "active" : "" %>">
                        <i class="fas fa-box"></i>
                        <span>Hàng hóa</span>
                    </a>
                    <a href="salepage?section=transactions" class="nav-item <%= "transactions".equals(currentSection) ? "active" : "" %>">
                        <i class="fas fa-exchange-alt"></i>
                        <span>Giao dịch</span>
                    </a>
                    <a href="salepage?section=promotions" class="nav-item <%= "promotions".equals(currentSection) ? "active" : "" %>">
                        <i class="fas fa-tags"></i>
                        <span>Khuyến mãi</span>
                    </a>
                    <a href="salepage?section=stats" class="nav-item <%= "stats".equals(currentSection) ? "active" : "" %>">
                        <i class="fas fa-chart-bar"></i>
                        <span>Thống kê</span>
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

        <!-- Stats Cards -->
        <div class="stats-container">
            <!-- Stats content -->
        </div>

        <!-- Main Container -->
        <div class="main-container">
            <!-- Sidebar - chỉ hiển thị cho products section -->
            <% if ("products".equals(currentSection)) { %>
            <aside class="sidebar">
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Nhóm hàng</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="categorySearch" placeholder="Tìm kiếm nhóm hàng">
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
                            <div class="category-item expandable">
                                <i class="fas fa-plus"></i>
                                <span class="category-label">Đồng hồ thông minh</span>
                            </div>
                            <div class="category-item expandable">
                                <i class="fas fa-plus"></i>
                                <span class="category-label">Tai nghe</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Trạng thái hàng hóa</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <label class="radio-item">
                            <input type="radio" name="inventory" value="all" ${param.inventory == 'all' || empty param.inventory ? 'checked' : ''}>
                            <span class="radio-mark"></span>
                            <span class="status-indicator all"></span>
                            Tất cả
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="inventory" value="below" ${param.inventory == 'below' ? 'checked' : ''}>
                            <span class="radio-mark"></span>
                            <span class="status-indicator below"></span>
                            Dưới định mức tồn
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="inventory" value="above" ${param.inventory == 'above' ? 'checked' : ''}>
                            <span class="radio-mark"></span>
                            <span class="status-indicator above"></span>
                            Vượt định mức tồn
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="inventory" value="in-stock" ${param.inventory == 'in-stock' ? 'checked' : ''}>
                            <span class="radio-mark"></span>
                            <span class="status-indicator in-stock"></span>
                            Còn hàng trong kho
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="inventory" value="out-stock" ${param.inventory == 'out-stock' ? 'checked' : ''}>
                            <span class="radio-mark"></span>
                            <span class="status-indicator out-stock"></span>
                            Hết hàng trong kho
                        </label>
                    </div>
                </div>
            </aside>
            <% } %>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Products Section -->
                <% if ("products".equals(currentSection)) { %>
                <div class="content-section">
                    <div class="page-header">
                        <h1>Hàng hóa</h1>
                        <div class="header-actions">
                            <form id="productSearchForm" method="GET" action="salepage" style="display: flex; gap: 10px;">
                                <input type="hidden" name="section" value="products">
                                <div class="search-container">
                                    <i class="fas fa-search"></i>
                                    <input id="productSearchInput" type="text" name="search" placeholder="Theo mã, tên hàng" 
                                           class="search-input" value="${param.search}">
                                </div>
                                <button type="submit" class="btn search-click">
                                    <i class="fas fa-search"></i>
                                    Tìm kiếm
                                </button>
                            </form>
                        </div>
                    </div>
                    <div class="table-container">
                        <table class="products-table">
                            <thead>
                                <tr>
                                    <th class="checkbox-col"><input type="checkbox" id="selectAll"></th>
                                    <th class="image-col"></th>
                                    <th>Mã hàng</th>
                                    <th>Tên hàng</th>
                                    <th>Giá bán</th>
                                    <th>Tồn kho</th>
                                    <th>Thời gian tạo</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${products}">
                                    <tr>
                                        <td><input type="checkbox" class="checkbox-item"></td>
                                        <td><div class="product-image"></div></td>
                                        <td>${product.productId}</td>
                                        <td>
                                            <div class="product-info">
                                                <div class="product-name">${product.productName}</div>
                                                <div class="product-meta">${product.categoryName}</div>
                                            </div>
                                        </td>
                                        <td class="price-cell">
                                            <c:choose>
                                                <c:when test="${not empty product.retailPrice}">
                                                    <fmt:formatNumber value="${product.retailPrice}" type="number" pattern="#,##0"/> ₫
                                                </c:when>
                                                <c:otherwise>--</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="stock-indicator">${product.quantity}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.createdAt != null}">
                                                    <fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy"/>
                                                </c:when>
                                                <c:otherwise>--</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="status-badge active">Đang bán</span>
                                        </td>
                                        <td>
                                            <button class="btn-detail" onclick="viewProductDetail('${product.productId}')">Chi tiết</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty products}">
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 2rem;">
                                            <p>Không có sản phẩm nào trong kho</p>
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                    <!-- Modal Chi tiết sản phẩm -->
                    <div id="productDetailModal" class="modal">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h2 id="modalProductName">Chi tiết sản phẩm</h2>
                                <span class="close">&times;</span>
                            </div>
                            <div class="modal-body">
                                <!-- Tabs -->
                                <div class="tabs">
                                    <button class="tab-button active" onclick="openTab(event, 'basicInfo')">Thông tin cơ bản</button>
                                    <button class="tab-button" onclick="openTab(event, 'inventoryInfo')">Tồn kho</button>
                                    <button class="tab-button" onclick="openTab(event, 'priceInfo')">Giá bán</button>
                                    <button class="tab-button" onclick="openTab(event, 'warrantyInfo')">Bảo hành</button>
                                    <button class="tab-button" onclick="openTab(event, 'promotionInfo')">Khuyến mãi</button>
                                </div>

                                <!-- Tab content -->
                                <div id="basicInfo" class="tab-content active">
                                    <div class="product-detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Mã sản phẩm:</span>
                                            <span id="productId" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Tên sản phẩm:</span>
                                            <span id="productName" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Danh mục:</span>
                                            <span id="categoryName" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Thương hiệu:</span>
                                            <span id="brandName" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Nhà cung cấp:</span>
                                            <span id="supplierName" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Ngày tạo:</span>
                                            <span id="createdAt" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item full-width">
                                            <span class="detail-label">Mô tả:</span>
                                            <span id="description" class="detail-value"></span>
                                        </div>
                                    </div>
                                </div>

                                <div id="inventoryInfo" class="tab-content">
                                    <div class="product-detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Tổng tồn kho:</span>
                                            <span id="totalQuantity" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Trạng thái:</span>
                                            <span id="stockStatus" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Serial Number:</span>
                                            <span id="serialNum" class="detail-value"></span>
                                        </div>
                                    </div>
                                    <div class="inventory-chart">
                                        <h4>Biểu đồ tồn kho</h4>
                                        <div class="chart-placeholder">
                                            <div class="progress-bar">
                                                <div id="inventoryProgressBar" class="progress-fill" style="width: 0%"></div>
                                            </div>
                                            <div class="chart-labels">
                                                <span>0</span>
                                                <span>50</span>
                                                <span>100</span>
                                                <span>150</span>
                                                <span>200+</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div id="priceInfo" class="tab-content">
                                    <div class="product-detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Giá nhập:</span>
                                            <span id="costPrice" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Giá bán lẻ:</span>
                                            <span id="retailPrice" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Lợi nhuận:</span>
                                            <span id="profit" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Tỷ suất lợi nhuận:</span>
                                            <span id="profitMargin" class="detail-value"></span>
                                        </div>
                                    </div>
                                </div>

                                <div id="warrantyInfo" class="tab-content">
                                    <div class="product-detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Thời hạn bảo hành:</span>
                                            <span id="warrantyPeriod" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Điều kiện bảo hành:</span>
                                            <span id="warrantyConditions" class="detail-value">Theo quy định của nhà sản xuất</span>
                                        </div>
                                    </div>
                                </div>

                                <div id="promotionInfo" class="tab-content">
                                    <div class="product-detail-grid">
                                        <div class="detail-item">
                                            <span class="detail-label">Chương trình khuyến mãi:</span>
                                            <span id="promoName" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Giảm giá:</span>
                                            <span id="discountPercent" class="detail-value"></span>
                                        </div>
                                        <div class="detail-item">
                                            <span class="detail-label">Thời gian áp dụng:</span>
                                            <span id="promoDateRange" class="detail-value"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button class="btn btn-secondary" onclick="closeProductModal()">Đóng</button>
                            </div>
                        </div>
                    </div>

                </div>
                <% } %>

                <!-- Transactions Section -->
                <% if ("transactions".equals(currentSection)) { %>
                <div class="content-section">
                    <div class="page-header">
                        <h1>Giao dịch của tôi</h1>
                        <div class="header-actions">
                            <form method="GET" action="salepage" style="display: flex; gap: 10px;">
                                <input type="hidden" name="section" value="transactions">
                                <div class="search-container">
                                    <i class="fas fa-search"></i>
                                    <input type="text" name="search" placeholder="Theo mã giao dịch, tên khách hàng" 
                                           class="search-input" value="${param.search}">
                                </div>
                                <button type="submit" class="btn search-click">
                                    <i class="fas fa-search"></i>
                                    Tìm kiếm
                                </button>
                            </form>
                        </div>
                    </div>
                    <div class="table-container">
                        <table class="transactions-table">
                            <thead>
                                <tr>
                                    <th>Mã giao dịch</th>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Tổng tiền</th>
                                    <th>Ngày giao dịch</th>
                                    <th>Trạng thái</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty transactions}">
                                        <c:forEach var="transaction" items="${transactions}">
                                            <tr>
                                                <td>${transaction.transactionId}</td>
                                                <td>${transaction.customerName}</td>
                                                <td>${transaction.productNames}</td>
                                                <td><fmt:formatNumber value="${transaction.totalAmount}" type="number" pattern="#,##0"/> ₫</td>
                                                <td><fmt:formatDate value="${transaction.transactionDate}" pattern="dd/MM/yyyy"/></td>
                                                <td><span class="status-badge completed">Hoàn thành</span></td>
                                                <td><button class="btn-detail">Chi tiết</button></td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="7" style="text-align: center; padding: 2rem;">
                                                <p>Bạn chưa có giao dịch nào</p>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                <% } %>

                <!-- Promotions Section -->
                <% if ("promotions".equals(currentSection)) { %>
                <div class="content-section">
                    <div class="page-header">
                        <h1>Chương trình khuyến mãi</h1>
                        <p class="page-description">Thông tin các chương trình khuyến mãi hiện tại</p>
                    </div>
                    <div class="promotions-grid">
                        <c:choose>
                            <c:when test="${not empty promotions}">
                                <c:forEach var="promotion" items="${promotions}">
                                    <div class="promotion-card">
                                        <h3>${promotion.promoName}</h3>
                                        <p>${promotion.description}</p>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="promotion-card">
                                    <h3>Không có khuyến mãi</h3>
                                    <p>Hiện tại không có chương trình khuyến mãi nào.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <% } %>

                <!-- Stats Section -->
                <% if ("stats".equals(currentSection)) { %>
                <div class="content-section">
                    <div class="page-header">
                        <h1>Thống kê hiệu suất cá nhân</h1>
                        <p class="page-description">Báo cáo chi tiết về hiệu suất bán hàng</p>
                    </div>
                    <div class="stats-detail-grid">
                        <c:choose>
                            <c:when test="${not empty salesStats}">
                                <div class="stats-card">
                                    <h3>Hiệu suất tháng này</h3>
                                    <p>Doanh số: <fmt:formatNumber value="${salesStats.currentMonthSales}" type="number" pattern="#,##0"/> ₫</p>
                                    <p>Đơn hàng: ${salesStats.ordersCount}</p>
                                    <p>Hiệu suất: <fmt:formatNumber value="${salesStats.performancePercentage}" maxFractionDigits="1"/>%</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="stats-card">
                                    <h3>Chưa có dữ liệu</h3>
                                    <p>Không có thống kê hiệu suất để hiển thị.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <% } %>
            </main>
        </div>

        <!-- Debug Info -->
        <div style="position: fixed; bottom: 10px; right: 10px; background: rgba(0,0,0,0.8); color: white; padding: 10px; border-radius: 5px; font-size: 12px;">
            Current Section: <%= currentSection %><br>
            URL Section: ${param.section}
        </div>

        <!-- JavaScript -->
        <script>
            function openTab(evt, tabName) {
                var i, tabcontent, tablinks;
                tabcontent = document.getElementsByClassName("tab-content");
                for (i = 0; i < tabcontent.length; i++) {
                    tabcontent[i].classList.remove("active");
                }
                tablinks = document.getElementsByClassName("tab-button");
                for (i = 0; i < tablinks.length; i++) {
                    tablinks[i].classList.remove("active");
                }
                document.getElementById(tabName).classList.add("active");
                evt.currentTarget.classList.add("active");
            }
        </script>
        <script>

            document.addEventListener('DOMContentLoaded', function () {
                // Kiểm tra tham số inventory trong URL
                const urlParams = new URLSearchParams(window.location.search);
                const inventoryFilter = urlParams.get('inventory') || 'all'; // Mặc định là 'all' nếu không có tham số
                const radio = document.querySelector(`input[name="inventory"][value="${inventoryFilter}"]`);
                if (radio) {
                    radio.checked = true; // Chọn radio button tương ứng
                }
            });
            document.addEventListener('DOMContentLoaded', function () {
                // Category search functionality
                const categorySearch = document.getElementById('categorySearch');
                if (categorySearch) {
                    categorySearch.addEventListener('input', function () {
                        const searchTerm = this.value.toLowerCase().trim();
                        document.querySelectorAll('.category-tree .category-item').forEach(item => {
                            const categoryName = item.querySelector('.category-label').textContent.toLowerCase();
                            if (categoryName.includes(searchTerm)) {
                                item.style.display = '';
                            } else {
                                item.style.display = 'none';
                            }
                        });
                    });
                }
                document.querySelectorAll('.category-item').forEach(item => {
                    item.addEventListener('click', function () {
                        document.querySelectorAll('.category-item').forEach(cat => {
                            cat.classList.remove('selected');
                        });
                        this.classList.add('selected');

                        const categoryName = this.querySelector('.category-label').textContent.trim().toLowerCase();
                        filterProductsByCategory(categoryName);
                    });
                });

                function filterProductsByCategory(category) {
                    const rows = document.querySelectorAll('.products-table tbody tr');
                    let visibleCount = 0;

                    rows.forEach(row => {
                        const productMeta = row.querySelector('.product-meta');
                        if (productMeta) {
                            const productCategory = productMeta.textContent.split('•')[0].trim().toLowerCase();
                            const isVisible = category === 'tất cả' || productCategory.includes(category);
                            row.style.display = isVisible ? '' : 'none';
                            if (isVisible)
                                visibleCount++;
                        }
                    });

                    const paginationInfo = document.querySelector('.pagination-info');
                    if (paginationInfo) {
                        paginationInfo.textContent = `Hiển thị ${visibleCount} sản phẩm`;
                    }
                }
                // Inventory filter functionality

                document.querySelectorAll('input[name="inventory"]').forEach(radio => {
                    radio.addEventListener('change', function () {
                        const value = this.value;
                        const url = new URL(window.location.href);
                        url.searchParams.set('inventory', value);
                        window.location.href = url.toString();
                    });
                });

                // Expandable filter sections
                document.querySelectorAll('.filter-header').forEach(header => {
                    header.addEventListener('click', function () {
                        const content = this.nextElementSibling;
                        const icon = this.querySelector('i');

                        if (content.style.display === 'none') {
                            content.style.display = 'block';
                            icon.classList.remove('fa-chevron-down');
                            icon.classList.add('fa-chevron-up');
                        } else {
                            content.style.display = 'none';
                            icon.classList.remove('fa-chevron-up');
                            icon.classList.add('fa-chevron-down');
                        }
                    });
                });

                // Select all checkbox
                const selectAllCheckbox = document.getElementById('selectAll');
                if (selectAllCheckbox) {
                    selectAllCheckbox.addEventListener('change', function () {
                        const isChecked = this.checked;
                        document.querySelectorAll('.checkbox-item').forEach(checkbox => {
                            checkbox.checked = isChecked;
                        });
                    });
                }

                // Auto-hide error messages after 5 seconds
                const errorMessage = document.querySelector('.error-message');
                if (errorMessage) {
                    setTimeout(() => {
                        errorMessage.style.display = 'none';
                    }, 5000);
                }

                // Sửa lỗi tìm kiếm sản phẩm
                const productSearchForm = document.getElementById("productSearchForm");
                const productSearchInput = document.getElementById("productSearchInput");

                if (productSearchForm && productSearchInput) {
                    productSearchInput.addEventListener("keypress", function (event) {
                        if (event.key === "Enter") {
                            event.preventDefault();
                            productSearchForm.submit();
                        }
                    });
                }
            });

            // Functions for detail views
            function viewProductDetail(productId) {
                // Hiển thị loading
                const modal = document.getElementById("productDetailModal");
                modal.style.display = "block";
                document.getElementById("modalProductName").textContent = "Đang tải...";

                // Gọi API để lấy chi tiết sản phẩm
                fetch('product-detail?productId=' + productId)
                        .then(response => response.json())
                        .then(data => {
                            if (data.success !== false) {
                                // Populate modal with product data
                                document.getElementById("modalProductName").textContent = data.productName || "Chi tiết sản phẩm";
                                document.getElementById("productId").textContent = data.productId || "--";
                                document.getElementById("productName").textContent = data.productName || "--";
                                document.getElementById("categoryName").textContent = data.categoryName || "--";
                                document.getElementById("brandName").textContent = data.brandName || "--";
                                document.getElementById("supplierName").textContent = data.supplierName || "--";
                                document.getElementById("createdAt").textContent = data.createdAt || "--";
                                document.getElementById("description").textContent = data.description || "Không có mô tả";
                                document.getElementById("totalQuantity").textContent = data.totalQuantity || "0";
                                document.getElementById("stockStatus").textContent = data.stockStatus || "--";
                                document.getElementById("serialNum").textContent = data.serialNum || "--";
                                document.getElementById("costPrice").textContent = data.costPrice || "--";
                                document.getElementById("retailPrice").textContent = data.retailPrice || "--";
                                document.getElementById("profit").textContent = data.profit || "--";
                                document.getElementById("profitMargin").textContent = data.profitMargin || "--";
                                document.getElementById("warrantyPeriod").textContent = data.warrantyPeriod || "--";
                                document.getElementById("promoName").textContent = data.promoName || "Không có";
                                document.getElementById("discountPercent").textContent = data.discountPercent || "0%";
                                document.getElementById("promoDateRange").textContent = data.promoDateRange || "--";

                                // Set inventory progress bar
                                const percentage = Math.min((data.totalQuantity || 0) / 2, 100);
                                document.getElementById("inventoryProgressBar").style.width = percentage + "%";

                                // Kích hoạt tab đầu tiên
                                openTab({currentTarget: document.querySelector(".tab-button")}, 'basicInfo');
                            } else {
                                document.getElementById("modalProductName").textContent = "Lỗi";
                                alert("Không thể tải thông tin sản phẩm: " + data.message);
                            }
                        })
                        .catch(error => {
                            console.error('Error fetching product details:', error);
                            document.getElementById("modalProductName").textContent = "Lỗi";
                            alert("Đã xảy ra lỗi khi tải thông tin sản phẩm");
                        });
            }
            function viewOrderDetail(orderId) {
                alert('Xem chi tiết đơn hàng: ' + orderId);
                // TODO: Implement order detail modal or redirect
            }

            // Close product detail modal
            function closeProductModal() {
                document.getElementById("productDetailModal").style.display = "none";
            }

            // Close modal when clicking outside
            window.onclick = function (event) {
                const modal = document.getElementById("productDetailModal");
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            }

            // Close modal when clicking X
            document.addEventListener('DOMContentLoaded', function () {
                const closeBtn = document.querySelector(".close");
                if (closeBtn) {
                    closeBtn.addEventListener("click", function () {
                        document.getElementById("productDetailModal").style.display = "none";
                    });
                }

                // Sửa lỗi tìm kiếm sản phẩm
                const productSearchForm = document.getElementById("productSearchForm");
                const productSearchInput = document.getElementById("productSearchInput");

                if (productSearchForm && productSearchInput) {
                    productSearchInput.addEventListener("keypress", function (event) {
                        if (event.key === "Enter") {
                            event.preventDefault();
                            productSearchForm.submit();
                        }
                    });
                }
            });
        </script>

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

    </body>
</html>
