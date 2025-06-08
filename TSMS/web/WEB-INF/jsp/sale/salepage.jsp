<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.ProductDTO, model.SalesTransactionDTO, model.PromotionDTO, model.SalesStatisticsDTO" %>
<%@ page import="util.Validate" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
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
                <a href="#" class="nav-item ${curentSection == null || param.section == 'products' ? 'active' : ''}" data-section="products">
                    <i class="fas fa-box"></i>
                    <span>Hàng hóa</span>
                </a>
                <a href="#" class="nav-item ${curentSection == 'transactions' ? 'active' : ''}" data-section="transactions">
                    <i class="fas fa-exchange-alt"></i>
                    <span>Giao dịch</span>
                </a>
                <a href="#" class="nav-item ${curentSection == 'promotions' ? 'active' : ''}" data-section="promotions">
                    <i class="fas fa-tags"></i>
                    <span>Khuyến mãi</span>
                </a>
                <a href="#" class="nav-item ${curentSection == 'stats' ? 'active' : ''}" data-section="stats">
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

    <!-- Stats Cards - Sử dụng dữ liệu thực từ backend -->
    <div class="stats-container">
        <div class="stats-grid">
            <c:choose>
                <c:when test="${not empty salesStats}">
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Doanh số tháng này</h3>
                            <i class="fas fa-trending-up stat-icon green"></i>
                        </div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${salesStats.currentMonthSales}" type="number" pattern="#,##0"/> ₫
                        </div>
                        <div class="stat-subtitle">
                            Mục tiêu: <fmt:formatNumber value="${salesStats.salesTarget}" type="number" pattern="#,##0"/> ₫
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${salesStats.performancePercentage > 100 ? 100 : salesStats.performancePercentage}%"></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Đơn hàng đã bán</h3>
                            <i class="fas fa-shopping-cart stat-icon blue"></i>
                        </div>
                        <div class="stat-value">${salesStats.ordersCount}</div>
                        <div class="stat-subtitle">Tháng này</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Khách hàng phục vụ</h3>
                            <i class="fas fa-users stat-icon orange"></i>
                        </div>
                        <div class="stat-value">${salesStats.customersServed}</div>
                        <div class="stat-subtitle">Khách hàng</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Hiệu suất</h3>
                            <i class="fas fa-chart-bar stat-icon purple"></i>
                        </div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${salesStats.performancePercentage}" maxFractionDigits="1"/>%
                        </div>
                        <div class="stat-subtitle">So với mục tiêu</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Fallback data nếu không có thống kê -->
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Doanh số tháng này</h3>
                            <i class="fas fa-trending-up stat-icon green"></i>
                        </div>
                        <div class="stat-value">0 ₫</div>
                        <div class="stat-subtitle">Mục tiêu: 200.000.000 ₫</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: 0%"></div>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Đơn hàng đã bán</h3>
                            <i class="fas fa-shopping-cart stat-icon blue"></i>
                        </div>
                        <div class="stat-value">0</div>
                        <div class="stat-subtitle">Tháng này</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Khách hàng phục vụ</h3>
                            <i class="fas fa-users stat-icon orange"></i>
                        </div>
                        <div class="stat-value">0</div>
                        <div class="stat-subtitle">Khách hàng</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <h3>Hiệu suất</h3>
                            <i class="fas fa-chart-bar stat-icon purple"></i>
                        </div>
                        <div class="stat-value">0%</div>
                        <div class="stat-subtitle">So với mục tiêu</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Main Container -->
    <div class="main-container">
        <!-- Sidebar -->
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
                    </div>
                </div>
            </div>
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
            <!-- Products Section -->
            <div id="products-section" class="content-section" style="display: ${curentSection == null || param.section == 'products' ? 'block' : 'none'};">
                <div class="page-header">
                    <h1>Hàng hóa</h1>
                    <div class="header-actions">
                        <div class="search-container">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Theo mã, tên hàng" class="search-input">
                        </div>
                        <button class="btn search-click">
                            <i class="fas fa-search"></i>
                            Tìm kiếm
                        </button>
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
                                <c:set var="stockClass" value="stock-good"/>
                                <c:if test="${product.quantity <= 0}">
                                    <c:set var="stockClass" value="stock-out"/>
                                </c:if>
                                <c:if test="${product.quantity > 0 && product.quantity < 10}">
                                    <c:set var="stockClass" value="stock-low"/>
                                </c:if>
                                
                                <c:set var="productClass" value="phone"/>
                                <c:if test="${fn:containsIgnoreCase(product.categoryName, 'laptop')}">
                                    <c:set var="productClass" value="laptop"/>
                                </c:if>
                                <c:if test="${fn:containsIgnoreCase(product.categoryName, 'tablet') || fn:containsIgnoreCase(product.categoryName, 'máy tính bảng')}">
                                    <c:set var="productClass" value="tablet"/>
                                </c:if>
                                <c:if test="${fn:containsIgnoreCase(product.categoryName, 'phụ kiện')}">
                                    <c:set var="productClass" value="accessory"/>
                                </c:if>
                                
                                <tr>
                                    <td><input type="checkbox" class="checkbox-item"></td>
                                    <td><div class="product-image ${productClass}"></div></td>
                                    <td>${product.productId}</td>
                                    <td>
                                        <div class="product-info">
                                            <div class="product-name">${product.productName}</div>
                                            <div class="product-meta">${product.categoryName} • ${product.brandName}</div>
                                            <c:if test="${fn:containsIgnoreCase(product.productName, 'iPhone 15')}">
                                                <span class="promotion-badge">Giảm 10%</span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="price-cell">
                                        <fmt:formatNumber value="${product.retailPriceAsDouble}" type="number" pattern="#,##0"/> ₫
                                    </td>
                                    <td>
                                        <span class="stock-indicator ${stockClass}">${product.quantity}</span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${product.createdAt != null}">
                                                <fmt:formatDate value="${product.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="status-badge ${product.isActive == 'Đang kinh doanh' ? 'active' : 'inactive'}">
                                            ${product.isActive == 'Đang kinh doanh' ? 'Đang bán' : 'Ngừng bán'}
                                        </span>
                                    </td>
                                    <td>
                                        <button class="btn-detail" onclick="viewProductDetail('${product.productId}')">
                                            <i class="fas fa-eye"></i>
                                            Chi tiết
                                        </button>
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
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${fn:length(products)} sản phẩm
                    </div>
                </div>
            </div>

            <!-- Transactions Section - Sử dụng dữ liệu thực -->
            <div id="transactions-section" class="content-section" style="display: ${curentSection == 'transactions' ? 'block' : 'none'};">
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
                                <th class="checkbox-col"><input type="checkbox" id="selectAllTransactions"></th>
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
                            <c:forEach var="transaction" items="${transactions}">
                                <c:set var="statusClass" value="pending"/>
                                <c:set var="statusText" value="Chờ xử lý"/>
                                
                                <c:if test="${transaction.orderStatus == 'Completed'}">
                                    <c:set var="statusClass" value="completed"/>
                                    <c:set var="statusText" value="Hoàn thành"/>
                                </c:if>
                                <c:if test="${transaction.orderStatus == 'Processing'}">
                                    <c:set var="statusClass" value="processing"/>
                                    <c:set var="statusText" value="Đang xử lý"/>
                                </c:if>
                                <c:if test="${transaction.orderStatus == 'Cancelled'}">
                                    <c:set var="statusClass" value="cancelled"/>
                                    <c:set var="statusText" value="Đã hủy"/>
                                </c:if>
                                
                                <tr>
                                    <td><input type="checkbox" class="checkbox-item"></td>
                                    <td class="transaction-id">${transaction.transactionId}</td>
                                    <td>
                                        <div class="customer-info">
                                            <div class="customer-name">
                                                <c:choose>
                                                    <c:when test="${not empty transaction.customerName}">
                                                        ${transaction.customerName}
                                                    </c:when>
                                                    <c:otherwise>Khách lẻ</c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="customer-phone">
                                                <c:choose>
                                                    <c:when test="${not empty transaction.customerPhone}">
                                                        ${transaction.customerPhone}
                                                    </c:when>
                                                    <c:otherwise>--</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty transaction.productNames}">
                                                <c:choose>
                                                    <c:when test="${fn:length(transaction.productNames) > 50}">
                                                        ${fn:substring(transaction.productNames, 0, 50)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${transaction.productNames}
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="price-cell">
                                        <fmt:formatNumber value="${transaction.totalAmount}" type="number" pattern="#,##0"/> ₫
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${transaction.transactionDate != null}">
                                                <fmt:formatDate value="${transaction.transactionDate}" pattern="dd/MM/yyyy"/>
                                            </c:when>
                                            <c:otherwise>--</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="status-badge ${statusClass}">${statusText}</span>
                                    </td>
                                    <td>
                                        <button class="btn-detail" onclick="viewOrderDetail('${transaction.transactionId}')">
                                            <i class="fas fa-eye"></i>
                                            Chi tiết
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty transactions}">
                                <tr>
                                    <td colspan="8" style="text-align: center; padding: 2rem;">
                                        <c:choose>
                                            <c:when test="${not empty param.search}">
                                                <p>Không tìm thấy giao dịch nào với từ khóa "${param.search}"</p>
                                            </c:when>
                                            <c:otherwise>
                                                <p>Bạn chưa có giao dịch nào</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                <div class="pagination-container">
                    <div class="pagination-info">
                        <c:choose>
                            <c:when test="${not empty param.search}">
                                Tìm thấy ${fn:length(transactions)} giao dịch với từ khóa "${param.search}"
                            </c:when>
                            <c:otherwise>
                                Hiển thị ${fn:length(transactions)} giao dịch
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Promotions Section - Sử dụng dữ liệu thực -->
            <div id="promotions-section" class="content-section" style="display: ${curentSection == 'promotions' ? 'block' : 'none'};">
    <div class="page-header">
        <h1>Chương trình khuyến mãi</h1>
        <p class="page-description">Thông tin các chương trình khuyến mãi hiện tại để tư vấn khách hàng</p>
    </div>
    <div class="promotions-grid">
        <c:forEach var="promotion" items="${promotions}">
            <div class="promotion-card">
                <div class="promotion-header">
                    <h3>${promotion.promoName}</h3>
                    <span class="discount-badge">${promotion.displayBadge}</span>
                </div>
                <p class="promotion-description">
                    ${promotion.description}
                </p>
                <div class="promotion-footer">
                    <span class="promotion-validity">
                        Có hiệu lực: 
                        <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy"/> - 
                        <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy"/>
                    </span>
                    <span class="promotion-status ${promotion.statusClass}">
                        ${promotion.status}
                    </span>
                </div>
                <c:if test="${promotion.applyToAllBranches}">
                    <div class="promotion-scope">
                        <i class="fas fa-globe"></i> Áp dụng toàn hệ thống
                    </div>
                </c:if>
            </div>
        </c:forEach>
        <c:if test="${empty promotions}">
            <div class="promotion-card">
                <div class="promotion-header">
                    <h3>Không có khuyến mãi</h3>
                    <span class="discount-badge">0%</span>
                </div>
                <p class="promotion-description">
                    Hiện tại không có chương trình khuyến mãi nào đang áp dụng cho chi nhánh của bạn.
                </p>
                <div class="promotion-footer">
                    <span class="promotion-validity">Vui lòng kiểm tra lại sau</span>
                    <span class="promotion-status inactive">Không có</span>
                </div>
            </div>
        </c:if>
    </div>
</div>

            <!-- Stats Section - Thống kê chi tiết -->
            <div id="stats-section" class="content-section" style="display: ${curentSection == 'stats' ? 'block' : 'none'};">
                <div class="page-header">
                    <h1>Thống kê hiệu suất cá nhân</h1>
                    <p class="page-description">Báo cáo chi tiết về hiệu suất bán hàng của bạn</p>
                </div>
                <div class="stats-detail-grid">
                    <c:choose>
                        <c:when test="${not empty salesStats}">
                            <div class="stats-card">
                                <h3>Hiệu suất tháng này</h3>
                                <div class="stats-item">
                                    <span class="stats-label">Doanh số đạt được</span>
                                    <span class="stats-value">
                                        <fmt:formatNumber value="${salesStats.currentMonthSales}" type="number" pattern="#,##0"/> ₫
                                    </span>
                                </div>
                                <div class="stats-item">
                                    <span class="stats-label">Mục tiêu tháng</span>
                                    <span class="stats-value">
                                        <fmt:formatNumber value="${salesStats.salesTarget}" type="number" pattern="#,##0"/> ₫
                                    </span>
                                </div>
                                <div class="stats-item">
                                    <span class="stats-label">Tỷ lệ hoàn thành</span>
                                    <span class="stats-value highlight">
                                        <fmt:formatNumber value="${salesStats.performancePercentage}" maxFractionDigits="1"/>%
                                    </span>
                                </div>
                                <div class="progress-bar-large">
                                    <div class="progress-fill" style="width: ${salesStats.performancePercentage > 100 ? 100 : salesStats.performancePercentage}%"></div>
                                </div>
                            </div>
                            <div class="stats-card">
                                <h3>Thống kê chi tiết</h3>
                                <div class="stats-item">
                                    <span class="stats-label">Số đơn hàng</span>
                                    <span class="stats-value">${salesStats.ordersCount}</span>
                                </div>
                                <div class="stats-item">
                                    <span class="stats-label">Khách hàng phục vụ</span>
                                    <span class="stats-value">${salesStats.customersServed}</span>
                                </div>
                                <div class="stats-item">
                                    <span class="stats-label">Giá trị đơn trung bình</span>
                                    <span class="stats-value">
                                        <c:choose>
                                            <c:when test="${salesStats.ordersCount > 0}">
                                                <fmt:formatNumber value="${salesStats.currentMonthSales / salesStats.ordersCount}" type="number" pattern="#,##0"/> ₫
                                            </c:when>
                                            <c:otherwise>0 ₫</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="stats-item">
                                    <span class="stats-label">Hiệu suất</span>
                                    <c:set var="performanceClass" value="danger"/>
                                    <c:if test="${salesStats.performancePercentage >= 60}">
                                        <c:set var="performanceClass" value="warning"/>
                                    </c:if>
                                    <c:if test="${salesStats.performancePercentage >= 80}">
                                        <c:set var="performanceClass" value="success"/>
                                    </c:if>
                                    <span class="stats-value ${performanceClass}">
                                        <fmt:formatNumber value="${salesStats.performancePercentage}" maxFractionDigits="1"/>%
                                    </span>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="stats-card">
                                <h3>Chưa có dữ liệu</h3>
                                <p>Không có thống kê hiệu suất để hiển thị. Vui lòng kiểm tra lại sau khi có dữ liệu bán hàng.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <!-- Support Chat Button -->
    <div class="support-chat">
        <i class="fas fa-headset"></i>
        <span>Hỗ trợ: 1900 9999</span>
    </div>

    <!-- Error Message Display -->
    <c:if test="${not empty error}">
        <div class="error-message" style="position: fixed; top: 20px; right: 20px; background: #ff4444; color: white; padding: 15px; border-radius: 5px; z-index: 1000;">
            <i class="fas fa-exclamation-triangle"></i>
            ${error}
            <button onclick="this.parentElement.style.display='none'" style="background: none; border: none; color: white; margin-left: 10px; cursor: pointer;">×</button>
        </div>
    </c:if>

    <script>
        // JavaScript để xử lý chuyển tab và các chức năng
        document.addEventListener('DOMContentLoaded', function () {
            const urlParams = new URLSearchParams(window.location.search);
            const section = urlParams.get('section') || 'products';
            
            // Xử lý navigation
            document.querySelectorAll('.nav-item').forEach(item => {
                item.addEventListener('click', function (e) {
                    e.preventDefault();
                    const sectionId = this.getAttribute('data-section');
                    // Chuyển hướng với parameter section
                    window.location.href = 'salepage?section=' + sectionId;
                });
            });

            // Search functionality cho products (client-side filter)
            const productSearchInput = document.querySelector('#products-section .search-input');
            const productSearchButton = document.querySelector('#products-section .search-click');

            if (productSearchInput && productSearchButton) {
                productSearchButton.addEventListener('click', () => {
                    filterProductTable(productSearchInput.value);
                });

                productSearchInput.addEventListener('input', () => {
                    filterProductTable(productSearchInput.value);
                });

                productSearchInput.addEventListener('keypress', (e) => {
                    if (e.key === 'Enter') {
                        filterProductTable(productSearchInput.value);
                    }
                });
            }

            // Function to filter product table
            function filterProductTable(query) {
                const rows = document.querySelectorAll('.products-table tbody tr');
                const searchTerm = query.trim().toLowerCase();
                let visibleCount = 0;

                rows.forEach(row => {
                    const productId = row.querySelector('td:nth-child(3)')?.textContent.toLowerCase() || '';
                    const productName = row.querySelector('.product-name')?.textContent.toLowerCase() || '';
                    
                    const isVisible = searchTerm === '' || 
                                    productId.includes(searchTerm) || 
                                    productName.includes(searchTerm);
                    
                    row.style.display = isVisible ? '' : 'none';
                    if (isVisible) visibleCount++;
                });

                // Update pagination info
                const paginationInfo = document.querySelector('#products-section .pagination-info');
                if (paginationInfo) {
                    paginationInfo.textContent = `Hiển thị ${visibleCount} sản phẩm`;
                }
            }

            // Checkbox functionality
            const selectAllCheckbox = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('#products-section .checkbox-item');
            if (selectAllCheckbox) {
                selectAllCheckbox.addEventListener('change', function () {
                    checkboxes.forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });
            }

            const selectAllTransactionsCheckbox = document.getElementById('selectAllTransactions');
            const transactionCheckboxes = document.querySelectorAll('#transactions-section .checkbox-item');
            if (selectAllTransactionsCheckbox) {
                selectAllTransactionsCheckbox.addEventListener('change', function () {
                    transactionCheckboxes.forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });
            }

            // Category filter functionality
            document.querySelectorAll('.category-item').forEach(item => {
                item.addEventListener('click', function() {
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
                        if (isVisible) visibleCount++;
                    }
                });
                
                // Update pagination info
                const paginationInfo = document.querySelector('#products-section .pagination-info');
                if (paginationInfo) {
                    paginationInfo.textContent = `Hiển thị ${visibleCount} sản phẩm`;
                }
            }

            // Inventory filter functionality
            document.querySelectorAll('input[name="inventory"]').forEach(radio => {
                radio.addEventListener('change', function() {
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
                        
                        switch(status) {
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
                        if (show) visibleCount++;
                    }
                });
                
                // Update pagination info
                const paginationInfo = document.querySelector('#products-section .pagination-info');
                if (paginationInfo) {
                    paginationInfo.textContent = `Hiển thị ${visibleCount} sản phẩm`;
                }
            }

            // Expandable category items
            document.querySelectorAll('.category-item.expandable').forEach(item => {
                item.addEventListener('click', function() {
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
