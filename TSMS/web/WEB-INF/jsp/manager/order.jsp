<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.OrdersDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Đơn hàng</title>
        <!-- Add the new CSS file -->
        <link rel="stylesheet" href="css/bm-orders.css">
        <link rel="stylesheet" href="css/header.css">
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

                    <a href="bm-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown active">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="#" class="dropdown-item">Nhập hàng</a>
                            <a href="#" class="dropdown-item">Tạo yêu cầu nhập</a>
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

                    <a href="bm-promotions" class="nav-item">
                        <i class="fas fa-ticket"></i>
                        Khuyến mãi
                    </a>

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
                            <a href="staff-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <div class="main-container">
            <!-- Filter Form -->
            <form id="filterForm" action="bm-orders" method="get">
                <input type="hidden" name="page" value="1">

                <aside class="sidebar">
                    <!-- Time Filter -->
                    <div class="filter-section time-filter-section">
                        <div class="filter-header">
                            <h3><i class="fas fa-clock"></i> Thời gian</h3>
                            <div class="header-actions">
                                <i class="fas fa-question-circle" title="Chọn khoảng thời gian để lọc"></i>
                                <i class="fas fa-chevron-up"></i>
                            </div>
                        </div>
                        <div class="filter-content">
                            <label class="radio-item">
                                <input type="radio" name="timeFilter" value="this-month" 
                                       ${empty param.timeFilter || param.timeFilter == 'this-month' ? 'checked' : ''}>
                                <span class="radio-mark"></span>
                                <span><i class="fas fa-calendar-alt"></i> Tháng này</span>
                            </label>

                            <label class="radio-item">
                                <input type="radio" name="timeFilter" value="this-week"
                                       ${param.timeFilter == 'this-week' ? 'checked' : ''}>
                                <span class="radio-mark"></span>
                                <span><i class="fas fa-calendar-week"></i> Tuần này</span>
                            </label>

                            <label class="radio-item">
                                <input type="radio" name="timeFilter" value="today"
                                       ${param.timeFilter == 'today' ? 'checked' : ''}>
                                <span class="radio-mark"></span>
                                <span><i class="fas fa-calendar-day"></i> Ngày hôm nay</span>
                            </label>

                            <label class="radio-item">
                                <input type="radio" name="timeFilter" value="custom"
                                       ${param.timeFilter == 'custom' ? 'checked' : ''}>
                                <span class="radio-mark"></span>
                                <span><i class="fas fa-calendar-plus"></i> Lựa chọn khác</span>
                            </label>

                            <div class="custom-date-container ${param.timeFilter == 'custom' ? 'show' : ''}" id="customDateContainer">
                                <label class="date-label">
                                    <i class="fas fa-calendar-check"></i> Chọn ngày bắt đầu
                                </label>
                                <input type="date" name="customDate" value="${param.customDate}"
                                       class="custom-date-input" id="customDateInput"
                                       placeholder="Chọn ngày...">
                            </div>
                        </div>
                    </div>

                    <!-- Creator Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3><i class="fas fa-user-tie"></i> Người tạo</h3>
                            <div class="header-actions">
                                <i class="fas fa-question-circle" title="Chọn nhân viên tạo đơn hàng"></i>
                                <i class="fas fa-chevron-up"></i>
                            </div>
                        </div>
                        <div class="filter-content">
                            <div class="checkbox-group">
                                <c:forEach var="creator" items="${creatorsList}">
                                    <label class="checkbox-item">
                                        <input type="checkbox" name="creatorIDs" value="${creator.userID}"
                                               <c:forEach var="selectedCreator" items="${selectedCreators}">
                                                   <c:if test="${selectedCreator == creator.userID}">checked</c:if>
                                               </c:forEach>>
                                        <span class="checkbox-mark"></span>
                                        <span><i class="fas fa-user"></i> ${creator.fullName}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Price Range Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3><i class="fas fa-dollar-sign"></i> Khoảng giá</h3>
                            <div class="header-actions">
                                <i class="fas fa-question-circle" title="Nhập khoảng giá để lọc đơn hàng"></i>
                                <i class="fas fa-chevron-up"></i>
                            </div>
                        </div>
                        <div class="filter-content">
                            <div class="price-range">
                                <div class="price-input-group">
                                    <label class="price-label">
                                        <i class="fas fa-arrow-up"></i> Giá từ
                                    </label>
                                    <input type="number" name="minPrice" placeholder="Nhập giá tối thiểu" min="0" 
                                           class="price-input" value="${minPrice}">
                                </div>
                                <div class="price-input-group">
                                    <label class="price-label">
                                        <i class="fas fa-arrow-down"></i> Giá đến
                                    </label>
                                    <input type="number" name="maxPrice" placeholder="Nhập giá tối đa" min="0" 
                                           class="price-input" value="${maxPrice}">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Actions -->
                    <div class="filter-actions">
                        <a href="bm-orders?page=1" class="btn-clear">
                            <i class="fas fa-eraser"></i>
                            Xóa bộ lọc
                        </a>
                        <button type="submit" class="btn-apply">
                            <i class="fas fa-filter"></i>
                            Áp dụng lọc
                        </button>
                    </div>
                </aside>
            </form>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Enhanced Search Form -->
                <div class="page-header">
                    <h1> Trang Đơn hàng chi nhánh</h1>
                    <div class="header-actions">
                        <form class="search-form" method="get" action="bm-orders">
                            <!-- Hidden inputs to maintain filter state -->
                            <c:if test="${not empty selectedCreators}">
                                <c:forEach var="creatorID" items="${selectedCreators}">
                                    <input type="hidden" name="creatorIDs" value="${creatorID}">
                                </c:forEach>
                            </c:if>
                            <c:if test="${not empty timeFilter}">
                                <input type="hidden" name="timeFilter" value="${timeFilter}">
                            </c:if>
                            <c:if test="${not empty customDate}">
                                <input type="hidden" name="customDate" value="${customDate}">
                            </c:if>
                            <c:if test="${not empty minPrice}">
                                <input type="hidden" name="minPrice" value="${minPrice}">
                            </c:if>
                            <c:if test="${not empty maxPrice}">
                                <input type="hidden" name="maxPrice" value="${maxPrice}">
                            </c:if>
                            <input type="hidden" name="page" value="1">

                            <div class="search-input-container">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" name="search" placeholder="Tìm theo tên sản phẩm, khách hàng"
                                       class="search-input" value="${searchKeyword}">
                                <c:if test="${not empty searchKeyword}">
                                    <a href="bm-orders?page=1" class="clear-search" title="Xóa tìm kiếm">
                                        <i class="fas fa-times"></i>
                                    </a>
                                </c:if>
                            </div>
                            <button type="submit" class="btn-search">
                                <i class="fas fa-search"></i>
                                <span>Tìm kiếm</span>
                            </button>
                        </form>
                        <button class="btn btn-menu">
                            <i class="fas fa-bars"></i>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                </div>

                <!-- Search Results Info -->
                <c:if test="${not empty searchKeyword}">
                    <div class="search-results-info">
                        <div class="search-info-content">
                            <i class="fas fa-search"></i>
                            <span>Kết quả tìm kiếm cho: "<strong>${searchKeyword}</strong>"</span>
                            <span class="results-count">(${totalOrders} kết quả)</span>
                            <a href="bm-orders?page=1" class="clear-all-search">
                                <i class="fas fa-times-circle"></i>
                                Xóa tìm kiếm
                            </a>
                        </div>
                    </div>
                </c:if>

                <!-- Orders Table -->
                <div class="table-container">
                    <div class="table-wrapper">
                        <table class="orders-table">
                            <thead>
                                <tr>
                                    <th class="checkbox-col">
                                        <label class="checkbox-container">
                                            <input type="checkbox" id="selectAll">
                                            <span class="checkmark"></span>
                                        </label>
                                    </th>
                                    <th class="order-info-col">
                                        <i class="fas fa-receipt"></i>
                                        Thông tin đơn hàng
                                    </th>
                                    <th class="product-col">
                                        <i class="fas fa-box"></i>
                                        Sản phẩm
                                    </th>
                                    <th class="customer-col">
                                        <i class="fas fa-user"></i>
                                        Khách hàng
                                    </th>
                                    <th class="staff-col">
                                        <i class="fas fa-user-tie"></i>
                                        Nhân viên
                                    </th>
                                    <th class="datetime-col">
                                        <i class="fas fa-clock"></i>
                                        Thời gian
                                    </th>
                                    <th class="status-col">
                                        <i class="fas fa-info-circle"></i>
                                        Trạng thái
                                    </th>
                                    <th class="payment-col">
                                        <i class="fas fa-credit-card"></i>
                                        Thanh toán
                                    </th>
                                    <th class="actions-col">
                                        <i class="fas fa-cogs"></i>
                                        Thao tác
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    List<OrdersDTO> ordersList = (List<OrdersDTO>) request.getAttribute("ordersList");
                                    if (ordersList != null && !ordersList.isEmpty()) {
                                        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                                        java.text.NumberFormat currencyFormat = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
                                        for (OrdersDTO order : ordersList) {
                                %>
                                <tr class="order-row" data-order-id="<%=order.getOrderID()%>">
                                    <td class="checkbox-col">
                                        <label class="checkbox-container">
                                            <input type="checkbox" name="selectedOrders" value="<%=order.getOrderID()%>">
                                            <span class="checkmark"></span>
                                        </label>
                                    </td>

                                    <!-- Order Info Column -->
                                    <td class="order-info-col">
                                        <div class="order-info-card">
                                            <div class="order-id">
                                                <span class="label">Mã ĐH:</span>
                                                <span class="value">#<%=order.getOrderID()%></span>
                                            </div>
                                            <div class="order-total">
                                                <span class="total-amount"><%=currencyFormat.format(order.getGrandTotal())%></span>
                                            </div>
                                            <% if (order.getNotes() != null && !order.getNotes().trim().isEmpty()) { %>
                                            <div class="order-notes">
                                                <i class="fas fa-sticky-note"></i>
                                                <span class="notes-text"><%=order.getNotes()%></span>
                                            </div>
                                            <% } %>
                                        </div>
                                    </td>

                                    <!-- Product Column -->
                                    <td class="product-col">
                                        <div class="product-info-card">
                                            <div class="product-name">
                                                <i class="fas fa-tag"></i>
                                                <span class="product-title"><%=order.getProductName() != null ? order.getProductName() : "N/A"%></span>
                                            </div>
                                            <div class="product-quantity">
                                                <span class="quantity-badge">
                                                    <i class="fas fa-cubes"></i>
                                                    SL: <%=order.getQuantity()%>
                                                </span>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Customer Column -->
                                    <td class="customer-col">
                                        <div class="customer-info-card">
                                            <div class="customer-avatar">
                                                <i class="fas fa-user-circle"></i>
                                            </div>
                                            <div class="customer-details">
                                                <div class="customer-name"><%=order.getCustomerName()%></div>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Staff Column -->
                                    <td class="staff-col">
                                        <div class="staff-info-card">
                                            <div class="staff-avatar">
                                                <i class="fas fa-user-tie"></i>
                                            </div>
                                            <div class="staff-details">
                                                <div class="staff-name"><%=order.getCreatedByName()%></div>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- DateTime Column -->
                                    <td class="datetime-col">
                                        <div class="datetime-info-card">
                                            <div class="date-part">
                                                <i class="fas fa-calendar"></i>
                                                <span><%=sdf.format(order.getCreatedAt()).split(" ")[0]%></span>
                                            </div>
                                            <div class="time-part">
                                                <i class="fas fa-clock"></i>
                                                <span><%=sdf.format(order.getCreatedAt()).split(" ")[1]%></span>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Status Column -->
                                    <td class="status-col">
                                        <div class="status-badge status-<%=order.getOrderStatus().toLowerCase().replace(" ", "-")%>">
                                            <i class="fas fa-circle"></i>
                                            <span><%=order.getOrderStatus()%></span>
                                        </div>
                                    </td>

                                    <!-- Payment Column -->
                                    <td class="payment-col">
                                        <div class="payment-info-card">
                                            <div class="payment-method">
                                                <i class="fas fa-credit-card"></i>
                                                <span><%=order.getPaymentMethod()%></span>
                                            </div>
                                            <div class="payment-details">
                                                <div class="payment-row">
                                                    <span class="label">Khách trả:</span>
                                                    <span class="value"><%=currencyFormat.format(order.getCustomerPay())%></span>
                                                </div>
                                                <% if (order.getChange() > 0) { %>
                                                <div class="payment-row change">
                                                    <span class="label">Tiền thừa:</span>
                                                    <span class="value"><%=currencyFormat.format(order.getChange())%></span>
                                                </div>
                                                <% } %>
                                            </div>
                                        </div>
                                    </td>

                                    <!-- Actions Column -->
                                    <td class="actions-col">
                                        <div class="action-buttons">
                                            <form action="bm-orders" method="get" style="display:inline;">
                                                <input type="hidden" name="action" value="view"/>
                                                <input type="hidden" name="orderID" value="<%=order.getOrderID()%>"/>
                                                <button type="submit" class="btn btn-view" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                    <span>Chi tiết</span>
                                                </button>
                                            </form>
                                            <form action="bm-orders" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="orderID" value="<%=order.getOrderID()%>"/>
                                                <button type="submit" class="btn btn-delete" title="Xóa đơn hàng"
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa đơn hàng này?');">
                                                    <i class="fas fa-trash"></i>
                                                    <span>Xóa</span>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr class="empty-row">
                                    <td colspan="9" class="empty-state">
                                        <div class="empty-content">
                                            <i class="fas fa-inbox"></i>
                                            <h3>Không có đơn hàng nào!</h3>
                                            <p>Hiện tại không có đơn hàng nào phù hợp với bộ lọc của bạn.</p>
                                        </div>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        <c:choose>
                            <c:when test="${not empty searchKeyword}">
                                Hiển thị ${startOrder} - ${endOrder} / Tổng số ${totalOrders} kết quả tìm kiếm
                            </c:when>
                            <c:otherwise>
                                Hiển thị ${startOrder} - ${endOrder} / Tổng số ${totalOrders} đơn hàng
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="pagination">
                        <%
                            // Build filter parameters for pagination links
                            StringBuilder filterParams = new StringBuilder();
                            String[] selectedCreators = (String[]) request.getAttribute("selectedCreators");
                            String timeFilter = (String) request.getAttribute("timeFilter");
                            String customDate = (String) request.getAttribute("customDate");
                            Double minPrice = (Double) request.getAttribute("minPrice");
                            Double maxPrice = (Double) request.getAttribute("maxPrice");
                            String searchKeyword = (String) request.getAttribute("searchKeyword");
                        
                            if (selectedCreators != null) {
                                for (String creatorID : selectedCreators) {
                                    filterParams.append("&creatorIDs=").append(creatorID);
                                }
                            }
                            if (timeFilter != null && !timeFilter.trim().isEmpty()) {
                                filterParams.append("&timeFilter=").append(timeFilter);
                            }
                            if (customDate != null && !customDate.trim().isEmpty()) {
                                filterParams.append("&customDate=").append(customDate);
                            }
                            if (minPrice != null) {
                                filterParams.append("&minPrice=").append(minPrice);
                            }
                            if (maxPrice != null) {
                                filterParams.append("&maxPrice=").append(maxPrice);
                            }
                            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                                filterParams.append("&search=").append(java.net.URLEncoder.encode(searchKeyword, "UTF-8"));
                            }
                        
                            String filterParamsStr = filterParams.toString();
                            pageContext.setAttribute("filterParams", filterParamsStr);
                        %>

                        <a href="bm-orders?page=1${filterParams}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="bm-orders?page=${currentPage - 1}${filterParams}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="bm-orders?page=${i}${filterParams}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="bm-orders?page=${currentPage + 1}${filterParams}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="bm-orders?page=${totalPages}${filterParams}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>
            </main>
        </div>

        <script>
            document.getElementById('selectAll').addEventListener('change', function () {
                const checkboxes = document.querySelectorAll('input[name="selectedOrders"]');
                checkboxes.forEach(cb => cb.checked = this.checked);
            });

            // Enhanced JavaScript for smooth animations
            document.addEventListener('DOMContentLoaded', function () {
                const radioButtons = document.querySelectorAll('input[name="timeFilter"]');
                const customDateContainer = document.getElementById('customDateContainer');
                const customDateInput = document.getElementById('customDateInput');

                radioButtons.forEach(radio => {
                    radio.addEventListener('change', function () {
                        if (this.value === 'custom') {
                            customDateContainer.classList.add('show');
                            setTimeout(() => {
                                customDateInput.focus();
                            }, 300);
                        } else {
                            customDateContainer.classList.remove('show');
                        }
                    });
                });

                // Set today as max date for custom input
                const today = new Date().toISOString().split('T')[0];
                customDateInput.setAttribute('max', today);
            });
        </script>
    </body>
</html>
