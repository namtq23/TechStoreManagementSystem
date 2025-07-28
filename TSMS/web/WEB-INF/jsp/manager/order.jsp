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
            /* Custom styles for date range inputs */
            .date-range-container {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .date-input-wrapper {
                flex: 1;
                position: relative;
            }

            .date-input-wrapper label {
                display: block;
                font-size: 12px;
                color: #666;
                margin-bottom: 5px;
                font-weight: 500;
            }

            .date-input-wrapper input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .date-input-wrapper input:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
                outline: none;
            }

            /* Dropdown styles for branch filter */
            .branch-dropdown {
                position: relative;
                width: 100%;
            }

            .branch-select {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                background: white;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .branch-select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 2px rgba(102, 126, 234, 0.1);
                outline: none;
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
                border-radius: 12px;
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

                .date-range-container {
                    flex-direction: column;
                    gap: 8px;
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
                display: flex;
                gap: 8px; /* Khoảng cách giữa nút */
            }

            .action-buttons .btn {
                text-align: center;
                justify-content: center;
            }
            .btn-detail{
                background-color: #2196F3;
                color: white;
            }

            .btn-detail:hover{
                background-color: #1976D2;
            }

        </style>            
    </head>
    <body>
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="bm-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="bm-overview" class="nav-item ">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item ">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown active">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="request-stock" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-incoming-orders" class="dropdown-item">Theo dõi nhập hàng</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-customer" class="dropdown-item">Khách hàng</a>
                            <a href="bm-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>

                    <a href="bm-staff" class="nav-item">
                        <i class="fas fa-users"></i>
                        Nhân viên
                    </a>

                    <a href="bm-promotions" class="nav-item">
                        <i class="fas fa-ticket"></i>
                        Khuyến mãi
                    </a>

                    <div class="nav-item dropdown ">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-invoices" class="dropdown-item">Báo cáo thu thuần</a>
                            <a href="bm-outcome" class="dropdown-item">Báo cáo chi</a>
                        </div>
                    </div>

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
                <!-- Sidebar -->
                <aside class="sidebar">
                    <div class="filter-section time-filter-section">
                        <div class="filter-header">
                            <h3>Thời gian</h3>
                        </div>
                        <div class="filter-content">
                            <div class="date-range-container">
                                <div class="date-input-wrapper">
                                    <label for="startDate">Từ ngày:</label>
                                    <input type="date" name="startDate" id="startDate" 
                                           value="${param.startDate}" class="custom-date-input">
                                </div>
                                <div class="date-input-wrapper">
                                    <label for="endDate">Đến ngày:</label>
                                    <input type="date" name="endDate" id="endDate" 
                                           value="${param.endDate}" class="custom-date-input">
                                </div>
                            </div>
                        </div>
                    </div>

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
                <div class="page-header">
                    <h1>Trang đơn hàng</h1>
                    <div class="header-actions">
                        <form class="search-form" method="get" action="bm-orders">
                            <c:if test="${not empty selectedBranch}">
                                <input type="hidden" name="branchID" value="${selectedBranch}">
                            </c:if>
                            <c:if test="${not empty selectedCreators}">
                                <c:forEach var="creatorID" items="${selectedCreators}">
                                    <input type="hidden" name="creatorIDs" value="${creatorID}">
                                </c:forEach>
                            </c:if>
                            <c:if test="${not empty param.startDate}">
                                <input type="hidden" name="startDate" value="${param.startDate}">
                            </c:if>
                            <c:if test="${not empty param.endDate}">
                                <input type="hidden" name="endDate" value="${param.endDate}">   
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
                                <input type="text" name="search" placeholder="Tìm theo tên sản phẩm và khách hàng"
                                       class="search-input" value="${searchKeyword}">
                                <c:if test="${not empty searchKeyword}">
                                    <a href="bm-orders?page=1" class="clear-search" title="Xóa tìm kiếm">
                                        <i class="fas fa-times"></i>
                                    </a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Orders Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Mã</th>
                                <th>Chi nhánh</th>
                                <th>Khách hàng</th>
                                <th>Nhân viên tạo</th>
                                <th>Trạng thái đơn</th>
                                <th>Tổng tiền</th>
                                <th>Thao tác</th>
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
                                <td>
                                    <div class="branch-info">
                                        <%=order.getBranchName() != null ? order.getBranchName() : "N/A"%>
                                    </div>
                                </td>
                                <td>
                                    <div class="customer-info">
                                        <%=order.getCustomerName() != null ? order.getCustomerName() : "N/A"%>
                                    </div>
                                </td>
                                <td>
                                    <div class="creator-info">
                                        <%=order.getCreatedByName() != null ? order.getCreatedByName() : "N/A"%>
                                    </div>
                                </td>
                                <td>
                                    <div class="date-info">
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
                                        <form action="bm-orders" method="get" style="display:inline;">
                                            <input type="hidden" name="action" value="view"/>
                                            <input type="hidden" name="orderID" value="<%=order.getOrderID()%>"/>
                                            <button type="submit" class="btn btn-primary btn-detail">
                                                <i class="fas fa-info-circle"></i>
                                            </button>
                                        </form>
                                        <form action="bm-orders" method="post" style="display:inline;" 
                                              onsubmit="return confirm('Bạn có chắc chắn muốn xoá đơn hàng #<%=order.getOrderID()%> không?');">
                                            <input type="hidden" name="action" value="delete"/>
                                            <input type="hidden" name="orderID" value="<%=order.getOrderID()%>"/>
                                            <button type="submit" class="btn btn-danger">
                                                <i class="fas fa-trash-alt"></i>
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
                            StringBuilder filterParams = new StringBuilder();

                            String selectedBranch = (String) request.getAttribute("selectedBranch");
                            String[] selectedCreators = (String[]) request.getAttribute("selectedCreators");
                            String startDate = (String) request.getAttribute("startDate");
                            String endDate = (String) request.getAttribute("endDate");
                            Double minPrice = (Double) request.getAttribute("minPrice");
                            Double maxPrice = (Double) request.getAttribute("maxPrice");
                            String searchKeyword = (String) request.getAttribute("searchKeyword");

                            if (selectedBranch != null && !selectedBranch.trim().isEmpty()) {
                                filterParams.append("&branchID=").append(selectedBranch);
                            }

                            if (selectedCreators != null) {
                                for (String creatorID : selectedCreators) {
                                    filterParams.append("&creatorIDs=").append(creatorID);
                                }
                            }

                            if (startDate != null && !startDate.trim().isEmpty()) {
                                filterParams.append("&startDate=").append(startDate);
                            }
                            if (endDate != null && !endDate.trim().isEmpty()) {
                                filterParams.append("&endDate=").append(endDate);
                            }

                            if (minPrice != null) {
                                filterParams.append("&minPrice=").append(minPrice);
                            }

                            if (maxPrice != null) {
                                filterParams.append("&maxPrice=").append(maxPrice);
                            }

                            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                                filterParams.append("&search=").append(searchKeyword);
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
