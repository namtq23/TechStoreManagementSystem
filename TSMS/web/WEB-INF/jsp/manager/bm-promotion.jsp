<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.PromotionDTO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Khuyến mãi chi nhánh</title>
        <link rel="stylesheet" href="css/so-promotion.css">
        <link rel="stylesheet" href="css/header.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Custom styles for Branch Manager */
            .page-header h1::before {
                margin-right: 8px;
            }

            .readonly-indicator {
                background: linear-gradient(45deg, #6c757d, #495057);
                color: white;
                padding: 4px 12px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: bold;
                margin-left: 10px;
            }

            .btn-detail {
                background-color: #2196F3;
                color: white;
                border: 2px solid #2196f3;
                padding: 8px 16px;
                border-radius: 10px;
                font-size: 12px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 4px;
                text-decoration: none;
                white-space: nowrap;
                box-shadow: 0 2px 8px rgba(33, 150, 243, 0.2);
            }

            .btn-detail:hover {
                background-color: #1976d2;
                transform: translateY(-2px);
                color: white;
                ;
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
                    <a href="bm-overview" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item">
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
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="bm-stockmovement?type=import" class="dropdown-item">Nhập hàng</a>
                            <a href="request-stock" class="dropdown-item">Yêu cầu nhập hàng</a>
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

                    <a href="bm-promotions" class="nav-item active">
                        <i class="fas fa-ticket" ></i>
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
            <!-- Sidebar -->
            <aside class="sidebar">
                <!-- Status Filter -->
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Trạng thái</h3>
                    </div>
                    <div class="filter-content">
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="all" ${selectedStatus == null || selectedStatus == 'all' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            Tất cả
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="active" ${selectedStatus == 'active' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            Đang hoạt động
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="scheduled" ${selectedStatus == 'scheduled' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            Đã lên lịch
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="expired" ${selectedStatus == 'expired' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            Đã hết hạn
                        </label>
                    </div>
                </div>

                <!-- Discount Filter -->
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Mức giảm giá</h3>
                    </div>
                    <div class="filter-content">
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="all" ${selectedDiscount == null || selectedDiscount == 'all' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            Tất cả
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="low" ${selectedDiscount == 'low' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            Dưới 15%
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="medium" ${selectedDiscount == 'medium' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            15% - 25%
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="high" ${selectedDiscount == 'high' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            Trên 25%
                        </label>
                    </div>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Header -->
                <div class="page-header">
                    <h1>Khuyến mãi chi nhánh
                    </h1>
                    <div class="header-actions">
                        <form action="bm-promotions" method="get" class="search-form">
                            <div class="search-input-wrapper">
                                <i class="fas fa-search"></i>
                                <input type="text" name="search" placeholder="Theo tên khuyến mãi" value="${searchTerm}">
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card total">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-percentage"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${totalPromotions}</div>
                                <div class="stat-label">Tổng khuyến mãi</div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card active">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-play-circle"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${activePromotions}</div>
                                <div class="stat-label">Đang hoạt động</div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card scheduled">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${scheduledPromotions}</div>
                                <div class="stat-label">Đã lên lịch</div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card expired">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-stop-circle"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${expiredPromotions}</div>
                                <div class="stat-label">Đã hết hạn</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Table Content -->
                <div class="table-container">
                    <table class="promotion-table">
                        <thead>
                            <tr>
                                <th></th>
                                <th>Mã khuyến mãi</th>
                                <th>Tên khuyến mãi</th>
                                <th>Giảm giá</th>
                                <th>Thời gian</th>
                                <th>Phạm vi</th>
                                <th>Trạng thái</th>
                                <th class="text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty promotions}">
                                    <tr>
                                        <td colspan="8" class="empty-state">
                                            <i class="fas fa-percentage"></i>
                                            <h5>Không tìm thấy khuyến mãi nào</h5>
                                            <p>Chi nhánh của bạn chưa có khuyến mãi nào được áp dụng!</p>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="promotion" items="${promotions}">
                                        <tr class="promotion-row" data-status="${promotion.status}">
                                            <td>
                                                <div class="fas fa-ticket" style = "color: #007bff; font-size: 30px"></div>
                                            </td>
                                            <td style="text-align: center;"><strong>${promotion.promotionID}</strong></td>
                                            <td>
                                                <div class="promotion-info">
                                                    <h6>${promotion.promoName}</h6>
                                                    <c:if test="${not empty promotion.description}">
                                                        <small>${promotion.description}</small>
                                                    </c:if>
                                                </div>
                                            </td>
                                            <td>
                                                <span class="discount-badge">
                                                    ${promotion.formattedDiscountPercent}
                                                </span>
                                            </td>
                                            <td>
                                                <small class="date-text">
                                                    <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy" />
                                                    <br>đến<br>
                                                    <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy" />
                                                </small>
                                            </td>
                                            <td>
                                                <br><small class="product-count" style="margin-bottom:25px">${promotion.productCount} sản phẩm</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${promotion.status == 'active'}">
                                                        <span class="status-badge status-active">
                                                            <i class="fas fa-play"></i> Đang hoạt động
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${promotion.status == 'scheduled'}">
                                                        <span class="status-badge status-scheduled">
                                                            <i class="fas fa-clock"></i> Đã lên lịch
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-inactive">
                                                            <i class="fas fa-stop"></i> Đã hết hạn
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <form action="bm-promotions" method="get" style="display:inline;">
                                                        <input type="hidden" name="action" value="view">
                                                        <input type="hidden" name="promotionId" value="${promotion.promotionID}">
                                                        <button type="submit" class="btn btn-detail">
                                                            <i class="fas fa-info-circle"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startPromotion} - ${endPromotion} / Tổng số ${totalPromotions} khuyến mãi
                    </div>
                    <div class="pagination">
                        <c:set var="baseUrl" value="bm-promotions?" />
                        <c:if test="${not empty searchTerm}">
                            <c:set var="baseUrl" value="${baseUrl}search=${searchTerm}&" />
                        </c:if>
                        <c:if test="${not empty selectedStatus and selectedStatus != 'all'}">
                            <c:set var="baseUrl" value="${baseUrl}status=${selectedStatus}&" />
                        </c:if>
                        <c:if test="${not empty selectedDiscount and selectedDiscount != 'all'}">
                            <c:set var="baseUrl" value="${baseUrl}discount=${selectedDiscount}&" />
                        </c:if>

                        <c:set var="prevPage" value="${currentPage > 1 ? currentPage - 1 : 1}" />
                        <c:set var="nextPage" value="${currentPage < totalPages ? currentPage + 1 : totalPages}" />

                        <!-- First Page -->
                        <a href="${baseUrl}page=1" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>

                        <!-- Previous Page -->
                        <a href="${baseUrl}page=${prevPage}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-left"></i>
                        </a>

                        <!-- Page Numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${baseUrl}page=${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <!-- Next Page -->
                        <a href="${baseUrl}page=${nextPage}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-right"></i>
                        </a>

                        <!-- Last Page -->
                        <a href="${baseUrl}page=${totalPages}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>
            </main>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
            // Filter functions
            function filterPromotions() {
                const mainSearchInput = document.querySelector('input[name="search"]');
                const search = mainSearchInput ? mainSearchInput.value : '';

                const statusFilter = document.querySelector('input[name="statusFilter"]:checked') ?
                        document.querySelector('input[name="statusFilter"]:checked').value : '';
                const discountFilter = document.querySelector('input[name="discountFilter"]:checked') ?
                        document.querySelector('input[name="discountFilter"]:checked').value : '';

                let url = 'bm-promotions?page=1';

                if (search && search.trim() !== '') {
                    url += '&search=' + encodeURIComponent(search.trim());
                }

                if (statusFilter && statusFilter !== 'all')
                    url += '&status=' + statusFilter;
                if (discountFilter && discountFilter !== 'all')
                    url += '&discount=' + discountFilter;

                window.location.href = url;
            }
        </script>
    </body>
</html>
