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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <a href="login" class="logo">
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
                <a href="profile" class="user-icon gradient">
                    <i class="fas fa-user-circle fa-2x"></i>
                </a>
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
        <% } %>

        <!-- Main Content -->
        <main class="main-content">
            <!-- Products Section -->
            <% if ("products".equals(currentSection)) { %>
            <div class="content-section">
                <div class="page-header">
                    <h1>Hàng hóa</h1>
                    <div class="header-actions">
                        <form method="GET" action="salepage" style="display: flex; gap: 10px;">
                            <input type="hidden" name="section" value="products">
                            <div class="search-container">
                                <i class="fas fa-search"></i>
                                <input type="text" name="search" placeholder="Theo mã, tên hàng" 
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
                                        <button class="btn-detail">Chi tiết</button>
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
        document.addEventListener('DOMContentLoaded', function () {
            // Category filter functionality
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

                // Update pagination info
                const paginationInfo = document.querySelector('.pagination-info');
                if (paginationInfo) {
                    paginationInfo.textContent = `Hiển thị ${visibleCount} sản phẩm`;
                }
            }

            // Inventory filter functionality
            document.querySelectorAll('input[name="inventory"]').forEach(radio => {
                radio.addEventListener('change', function () {
                    const value = this.value;
                    filterProductsByInventory(value);
                });
            });

            function filterProductsByInventory(status) {
                const rows = document.querySelectorAll('.products-table tbody tr');
                let visibleCount = 0;

                rows.forEach(row => {
                    const stockElement = row.querySelector('.stock-indicator');
                    if (stockElement) {
                        const quantity = parseInt(stockElement.textContent);
                        let show = true;

                        switch (status) {
                            case 'below':
                                show = quantity > 0 && quantity < 10;
                                break;
                            case 'above':
                                show = quantity >= 20;
                                break;
                            case 'in-stock':
                                show = quantity > 0;
                                break;
                            case 'out-stock':
                                show = quantity <= 0;
                                break;
                            case 'all':
                            default:
                                show = true;
                        }

                        row.style.display = show ? '' : 'none';
                        if (show)
                            visibleCount++;
                    }
                });

                // Update pagination info
                const paginationInfo = document.querySelector('.pagination-info');
                if (paginationInfo) {
                    paginationInfo.textContent = `Hiển thị ${visibleCount} sản phẩm`;
                }
            }

            // Expandable category items
            document.querySelectorAll('.category-item.expandable').forEach(item => {
                item.addEventListener('click', function () {
                    const icon = this.querySelector('i');
                    if (icon.classList.contains('fa-plus')) {
                        icon.classList.remove('fa-plus');
                        icon.classList.add('fa-minus');
                    } else {
                        icon.classList.remove('fa-minus');
                        icon.classList.add('fa-plus');
                    }
                });
            });

            // Expandable filter sections
            document.querySelectorAll('.filter-header').forEach(header => {
                header.addEventListener('click', function() {
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

            // Auto-hide error messages after 5 seconds
            const errorMessage = document.querySelector('.error-message');
            if (errorMessage) {
                setTimeout(() => {
                    errorMessage.style.display = 'none';
                }, 5000);
            }
        });

        // Functions for detail views
        function viewProductDetail(productId) {
            alert('Xem chi tiết sản phẩm: ' + productId);
            // TODO: Implement product detail modal or redirect
        }

        function viewOrderDetail(orderId) {
            alert('Xem chi tiết đơn hàng: ' + orderId);
            // TODO: Implement order detail modal or redirect
        }
    </script>
</body>
</html>
