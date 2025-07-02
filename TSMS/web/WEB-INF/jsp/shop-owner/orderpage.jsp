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
        <link rel="stylesheet" href="css/so-products.css">
        <link rel="stylesheet" href="css/header.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Professional enhancements */
            .filter-section {
                border: 1px solid #e8ecef;
                transition: all 0.3s ease;
            }

            .filter-section:hover {
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                transform: translateY(-2px);
            }

            /* Loading state for date input */
            .custom-date-input.loading {
                background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
                background-size: 200% 100%;
                animation: loading 1.5s infinite;
            }

            @keyframes loading {
                0% {
                    background-position: 200% 0;
                }
                100% {
                    background-position: -200% 0;
                }
            }

            /* Success state for selected date */
            .custom-date-input.selected {
                border-color: #28a745;
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            }

            /* Tooltip for date input */
            .custom-date-container {
                position: relative;
            }

            .custom-date-container::after {
                position: absolute;
                bottom: -30px;
                left: 0;
                right: 0;
                background: rgba(0, 0, 0, 0.8);
                color: white;
                padding: 8px 12px;
                border-radius: 4px;
                font-size: 12px;
                opacity: 0;
                pointer-events: none;
                transition: opacity 0.3s ease;
                z-index: 1000;
            }

            .custom-date-container:hover::after {
                opacity: 1;
            }

            .date-label {
                color: #333;
            }

            /* Print styles */
            @media print {
                .filter-section {
                    box-shadow: none;
                    border: 1px solid #000;
                }

                .filter-header {
                    background: #000 !important;
                    color: #fff !important;
                }
            }
            /* Enhanced Search Form Styling */
            .search-form {
                display: flex;
                align-items: center;
                gap: 12px;
                background: white;
                padding: 8px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                border: 1px solid #e8ecef;
            }

            .search-input-container {
                position: relative;
                flex: 1;
                min-width: 300px;
            }

            .search-icon {
                position: absolute;
                top: 50%;
                left: 16px;
                transform: translateY(-50%);
                color: #667eea;
                font-size: 14px;
                z-index: 2;
            }

            .search-input {
                width: 100%;
                padding: 12px 16px 12px 45px;
                border: 2px solid #e1e5e9;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 500;
                color: #333;
                background: #fafbfc;
                transition: all 0.3s ease;
                outline: none;
            }

            .search-input:focus {
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-1px);
            }

            .search-input::placeholder {
                color: #999;
                font-weight: 400;
            }

            .clear-search {
                position: absolute;
                top: 50%;
                right: 12px;
                transform: translateY(-50%);
                color: #dc3545;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
                z-index: 2;
            }

            .clear-search:hover {
                color: #c82333;
                transform: translateY(-50%) scale(1.1);
            }

            .btn-search {
                background-color: #2196F3 ;
                border: none;
                color: #fff;
                border-radius: 8px;
                padding: 12px 20px;
                font-size: 14px;
                font-weight: bold;
                text-transform: none;
                transition: all 0.3s ease;
            }



            /* Search Results Info */
            .search-results-info {
                background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                border: 1px solid #90caf9;
                border-radius: 8px;
                padding: 12px 16px;
                margin: 16px 0;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .search-info-content {
                display: flex;
                align-items: center;
                gap: 12px;
                flex: 1;
            }

            .search-info-content i {
                color: #1976d2;
                font-size: 14px;
            }

            .search-info-content span {
                color: #1565c0;
                font-size: 14px;
                font-weight: 500;
            }

            .results-count {
                color: #1976d2 !important;
                font-weight: 600 !important;
            }

            .clear-all-search {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                background: #1976d2;
                color: white;
                text-decoration: none;
                border-radius: 6px;
                font-size: 12px;
                font-weight: 600;
                transition: all 0.3s ease;
            }

            .clear-all-search:hover {
                background: #1565c0;
                transform: translateY(-1px);
                box-shadow: 0 2px 8px rgba(25, 118, 210, 0.3);
            }

            .clear-all-search i {
                font-size: 11px;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .search-form {
                    flex-direction: column;
                    gap: 8px;
                }

                .search-input-container {
                    min-width: auto;
                    width: 100%;
                }

                .btn-search {
                    width: 100%;
                    justify-content: center;
                }

                .search-results-info {
                    flex-direction: column;
                    gap: 8px;
                    align-items: flex-start;
                }
            }

            /* Enhanced pagination info for search results */
            .pagination-info {
                font-size: 14px;
                color: #666;
                font-weight: 500;
            }

            .pagination-info strong {
                color: #667eea;
                font-weight: 600;
            }
            /* Style cho nút Chi tiết */
            .btn-primary.btn-sm {
                background-color: #2196F3 !important;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 6px 12px;
                font-size: 13px;
                transition: all 0.3s ease;
            }

            .btn-primary.btn-sm:hover {
                background-color: #333 !important;
                box-shadow: 0 2px 8px rgba(76, 175, 80, 0.3);
            }

            /* Style cho nút Xoá */
            .btn-danger.btn-sm {
                background-color: #f44336 !important;
                color: white;
                border: none;
                border-radius: 6px;
                padding: 6px 12px;
                font-size: 13px;
                transition: all 0.3s ease;
            }

            .btn-danger.btn-sm:hover {
                background-color: #d32f2f !important;
                box-shadow: 0 2px 8px rgba(244, 67, 54, 0.3);
            }
            /* Bố cục nút Chi tiết và Xoá đẹp hơn */
            .action-buttons {
                display: inline;
                gap: 100px; /* Khoảng cách giữa nút */
            }

            .action-buttons .btn {
                min-width: 90px; /* Đảm bảo độ rộng bằng nhau */
                text-align: center;
                justify-content: center;
            }

        </style>            
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
                    <a href="so-overview" class="nav-item active">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="so-products?page=1" class="nav-item">
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
                            <a href="so-outcome" class="dropdown-item">Khoảng chi</a>
                        </div>
                    </div>

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
            <!-- Filter Form -->
            <form id="filterForm" action="so-orders" method="get">
                <input type="hidden" name="page" value="1">
                <!-- Sidebar -->
                <aside class="sidebar">
                    <!-- Branch Filter - FIXED -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Chi nhánh</h3>
                            <i class="fas fa-question-circle"></i>
                            <i class="fas fa-chevron-up"></i>
                        </div>
                        <div class="filter-content">
                            <div class="checkbox-group">
                                <c:forEach var="branch" items="${branchesList}">
                                    <label class="checkbox-item">
                                        <input type="checkbox" name="branchIDs" value="${branch.branchId}"
                                               <c:forEach var="selectedBranch" items="${selectedBranches}">
                                                   <c:if test="${selectedBranch == branch.branchId}">checked</c:if>
                                               </c:forEach>>
                                        <span class="checkbox-mark"></span>
                                        ${branch.branchName}
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Time Filter -->
                    <div class="filter-section time-filter-section">
                        <div class="filter-header">
                            <h3><i class="fas fa-clock"></i> Thời gian</h3>
                            <i class="fas fa-chevron-up"></i>
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
                                    <i class="fas fa-calendar-check"></i> Chọn ngày
                                </label>
                                <input type="date" name="customDate" value="${param.customDate}"
                                       class="custom-date-input" id="customDateInput"
                                       placeholder="Chọn ngày...">
                            </div>
                        </div>
                    </div>
<!--                                       <div class="filter-section time-filter-section">
                        <div class="filter-header">
                            <h3><i class="fas fa-clock"></i> Thời gian</h3>
                            <i class="fas fa-chevron-up"></i>
                        </div>
                        <div class="filter-content">
                             ADDED: All time filter option 
                            <label class="radio-item">
                                <input type="radio" name="timeFilter" value="all"
                                       ${param.timeFilter == 'all' ? 'checked' : ''}>
                                <span class="radio-mark"></span>
                                <span><i class="fas fa-globe"></i> Tất cả</span>
                            </label>

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

                             MODIFIED: Changed custom date to include start and end date 
                            <div class="custom-date-container ${param.timeFilter == 'custom' ? 'show' : ''}" id="customDateContainer">
                                <label class="date-label">
                                    <i class="fas fa-calendar-check"></i> Chọn khoảng thời gian
                                </label>
                                <div class="date-input-group">
                                    <input type="date" name="startDate" value="${param.startDate}"
                                           class="custom-date-input" id="startDateInput"
                                           placeholder="Từ ngày...">
                                    <input type="date" name="endDate" value="${param.endDate}"
                                           class="custom-date-input" id="endDateInput"
                                           placeholder="Đến ngày...">
                                </div>
                            </div>
                        </div>
                    </div>-->

                    <!-- Creator Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Người tạo</h3>
                            <i class="fas fa-chevron-up"></i>
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
                                        ${creator.fullName}
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Price Range Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Khoảng giá</h3>
                        </div>
                        <div class="filter-content">
                            <div class="price-range">
                                <input type="number" name="minPrice" placeholder="Giá từ" min="0" 
                                       class="price-input" value="${minPrice}">
                                <input type="number" name="maxPrice" placeholder="Giá đến" min="0" 
                                       class="price-input" value="${maxPrice}">
                            </div>
                        </div>
                    </div>

                    <!-- Filter Actions -->
                    <div class="filter-actions">
                        <a href="so-orders?page=1" class="btn-clear">
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
                <div class="page-header">
                    <h1>Trang đơn hàng</h1>
                    <div class="header-actions">
                        <form class="search-form" method="get" action="so-orders">
                            <!-- Hidden inputs to maintain filter state -->
                            <c:if test="${not empty selectedBranches}">
                                <c:forEach var="branchID" items="${selectedBranches}">
                                    <input type="hidden" name="branchIDs" value="${branchID}">
                                </c:forEach>
                            </c:if>
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
                                <%--<c:if test="${not empty startDate}">
                                <input type="hidden" name="startDate" value="${startDate}">
                            </c:if>
                            <c:if test="${not empty endDate}">
                                <input type="hidden" name="endDate" value="${endDate}">
                            </c:if>--%>
                            <c:if test="${not empty minPrice}">
                                <input type="hidden" name="minPrice" value="${minPrice}">
                            </c:if>
                            <c:if test="${not empty maxPrice}">
                                <input type="hidden" name="maxPrice" value="${maxPrice}">
                            </c:if>
                            <input type="hidden" name="page" value="1">

                            <div class="search-input-container">
                                <i class="fas fa-search search-icon"></i>
                                <input type="text" name="search" placeholder="Tìm theo tên sản phẩm và khách hàng"
                                       class="search-input" value="${searchKeyword}">
                                <c:if test="${not empty searchKeyword}">
                                    <a href="so-orders?page=1" class="clear-search" title="Xóa tìm kiếm">
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

                <!-- Orders Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Mã đơn hàng</th>
                                <th>Tên sản phẩm</th>
                                <th>Chi nhánh</th>
                                <th>Khách hàng</th>
                                <th>Nhân viên tạo</th>
                                <th>Trạng thái đơn</th>
                                <th>Tổng tiền</th>
                                <th style="justify-content: center; text-align: center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<OrdersDTO> ordersList = (List<OrdersDTO>) request.getAttribute("ordersList");
                                Integer currentPage = (Integer) request.getAttribute("currentPage");
                                Integer pageSize = 10;
                                int startIndex = (currentPage - 1) * pageSize;
                
                                if (ordersList != null && !ordersList.isEmpty()) {
                                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
                                    java.text.NumberFormat currencyFormat = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
                    
                                    for (int i = 0; i < ordersList.size(); i++) {
                                        OrdersDTO order = ordersList.get(i);
                                        int stt = startIndex + i + 1;
                            %>
                            <tr>
                                <td> </td>
                                <td><strong>#<%=order.getOrderID()%></strong></td>
                                <td style="max-width: 250px; word-wrap: break-word;">
                                    <div class="product-details">
                                        <%
                                            String productDetails = order.getProductName();
                                            if (productDetails != null && !productDetails.trim().isEmpty() && !productDetails.equals("Không có sản phẩm")) {
                                                String[] products = productDetails.split(";");
                                                for (String product : products) {
                                                    if (product.trim().length() > 0) {
                                        %>
                                        <div class="product-item">
                                            <i class="fas fa-box"></i> <%=product.trim()%>
                                        </div>
                                        <%
                                                    }
                                                }
                                            } else {
                                        %>
                                        <div class="product-item no-product">
                                            <i class="fas fa-exclamation-triangle"></i> Không có sản phẩm
                                        </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                                <td>
                                    <div class="branch-info">
                                        <i class="fas fa-store"></i>
                                        <%=order.getBranchName() != null ? order.getBranchName() : "N/A"%>
                                    </div>
                                </td>
                                <td>
                                    <div class="customer-info">
                                        <i class="fas fa-user"></i>
                                        <%=order.getCustomerName() != null ? order.getCustomerName() : "N/A"%>
                                    </div>
                                </td>
                                <td>
                                    <div class="creator-info">
                                        <i class="fas fa-user-tie"></i>
                                        <%=order.getCreatedByName() != null ? order.getCreatedByName() : "N/A"%>
                                    </div>
                                </td>
                                <td>
                                    <div class="date-info">
                                        <i class="fas fa-calendar"></i>
                                        <%=order.getCreatedAt() != null ? sdf.format(order.getCreatedAt()) : "N/A"%>
                                    </div>
                                </td>
                                <td>
                                    <div class="price-info">
                                        <strong><%=currencyFormat.format(order.getGrandTotal())%></strong>
                                    </div>
                                </td>
                                <td class="actions-col">
                                    <div class="action-buttons">
                                        <form action="so-orders" method="get" style="display:inline;">
                                            <input type="hidden" name="action" value="view"/>
                                            <input type="hidden" name="orderID" value="<%=order.getOrderID()%>"/>
                                            <button type="submit" class="btn btn-primary btn-sm">
                                                <i class="fas fa-eye"></i> Chi tiết
                                            </button>
                                        </form>
                                        <form action="so-orders" method="post" style="display:inline;" 
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xoá đơn hàng #<%=order.getOrderID()%> không?');">
                                            <input type="hidden" name="action" value="delete"/>
                                            <input type="hidden" name="orderID" value="<%=order.getOrderID()%>"/>
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i> Xoá
                                            </button>
                                        </form>

                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="11" style="text-align:center; padding: 40px;">
                                    <div class="no-data">
                                        <i class="fas fa-inbox" style="font-size: 48px; color: #ccc; margin-bottom: 16px;"></i>
                                        <p style="color: #666; font-size: 16px;">Không tìm thấy đơn hàng nào!</p>
                                        <p style="color: #999; font-size: 14px;">Hãy thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
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
                            // Build filter parameters for pagination links including search
                            StringBuilder filterParams = new StringBuilder();
                            String[] selectedBranches = (String[]) request.getAttribute("selectedBranches");
                            String[] selectedCreators = (String[]) request.getAttribute("selectedCreators");
                            String timeFilter = (String) request.getAttribute("timeFilter");
                            String customDate = (String) request.getAttribute("customDate");
                            //String startDate = (String) request.getAttribute("startDate"); // MODIFIED: Changed from customDate to startDate
                            //String endDate = (String) request.getAttribute("endDate");
                            Double minPrice = (Double) request.getAttribute("minPrice");
                            Double maxPrice = (Double) request.getAttribute("maxPrice");
                            String searchKeyword = (String) request.getAttribute("searchKeyword");
            
                            if (selectedBranches != null) {
                                for (String branchID : selectedBranches) {
                                    filterParams.append("&branchIDs=").append(branchID);
                                }
                            }
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
//                            if (startDate != null && !startDate.trim().isEmpty()) { // MODIFIED: Changed from customDate to startDate
//                                filterParams.append("&startDate=").append(startDate);
//                            }
//                            if (endDate != null && !endDate.trim().isEmpty()) { // ADDED: Added endDate
//                                filterParams.append("&endDate=").append(endDate);
//                            }
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

                        <a href="so-orders?page=1${filterParams}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="so-orders?page=${currentPage - 1}${filterParams}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="so-orders?page=${i}${filterParams}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="so-orders?page=${currentPage + 1}${filterParams}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="so-orders?page=${totalPages}${filterParams}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
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

            // Show/hide custom date input based on radio selection
            document.querySelectorAll('input[name="timeFilter"]').forEach(radio => {
                radio.addEventListener('change', function () {
                    const customDateInput = document.getElementById('customDateInput');
                    if (this.value === 'custom') {
                        customDateInput.style.display = 'block';
                    } else {
                        customDateInput.style.display = 'none';
                    }
                });
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

                // Add ripple effect to radio items
                const radioItems = document.querySelectorAll('.radio-item');
                radioItems.forEach(item => {
                    item.addEventListener('click', function (e) {
                        const ripple = document.createElement('span');
                        const rect = this.getBoundingClientRect();
                        const size = Math.max(rect.width, rect.height);
                        const x = e.clientX - rect.left - size / 2;
                        const y = e.clientY - rect.top - size / 2;

                        ripple.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                left: ${x}px;
                top: ${y}px;
                background: rgba(102, 126, 234, 0.3);
                border-radius: 50%;
                transform: scale(0);
                animation: ripple 0.6s ease-out;
                pointer-events: none;
                z-index: 1;
            `;

                        this.style.position = 'relative';
                        this.appendChild(ripple);

                        setTimeout(() => {
                            ripple.remove();
                        }, 600);
                    });
                });

                // Set today as max date for custom input
                const today = new Date().toISOString().split('T')[0];
                customDateInput.setAttribute('max', today);
            });


            const style = document.createElement('style');
            style.textContent = `
    @keyframes ripple {
        to {
            transform: scale(2);
            opacity: 0;
        }
    }
`;
            document.head.appendChild(style);
        </script>
    </body>
</html>