<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Theo dõi tất cả hoạt động kho</title>
        <link rel="stylesheet" href="css/track-movements.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Direction Info - Layout tối ưu */
            /* Direction Info - Cải thiện để hiển thị đầy đủ tên */
            .direction-info {
                display: flex;
                flex-direction: column;
                gap: 8px;
                min-height: 60px;
                padding: 6px 0;
            }

            .direction-from,
            .direction-to {
                display: flex;
                align-items: flex-start;
                gap: 6px;
                width: 100%;
                line-height: 1.3;
            }

            .direction-label {
                font-size: 11px;
                font-weight: 600;
                color: #6c757d;
                min-width: 28px;
                flex-shrink: 0;
                margin-top: 2px;
            }

            .location-badge {
                display: inline-flex;
                align-items: center;
                gap: 4px;
                background-color: #f8f9fa;
                padding: 5px 8px;
                border-radius: 4px;
                font-size: 11px;
                border: 1px solid #dee2e6;
                white-space: normal; /* Cho phép wrap text */
                word-wrap: break-word;
                overflow: visible; /* Bỏ hidden */
                flex: 1;
                max-width: none; /* Bỏ giới hạn width */
                min-height: 20px;
            }

            .location-badge i {
                font-size: 10px;
                flex-shrink: 0;
                width: 12px;
                text-align: center;
                margin-top: 1px;
            }

            /* Tăng width cột để chứa đủ text */
            .invoices-table th:nth-child(4),
            .invoices-table td:nth-child(4) {
                width: 200px;
                min-width: 200px;
                vertical-align: top;
                padding: 10px 8px;
            }

            /* Icon colors */
            .location-badge i.fa-truck {
                color: #28a745;
            }

            .location-badge i.fa-store {
                color: #007bff;
            }

            .location-badge i.fa-warehouse {
                color: #6f42c1;
            }

            .location-badge i.fa-question-circle {
                color: #dc3545;
            }
            @media (max-width: 768px) {
                .invoices-table th:nth-child(4),
                .invoices-table td:nth-child(4) {
                    width: auto;
                    min-width: 160px;
                }

                .location-badge {
                    font-size: 10px;
                    padding: 4px 6px;
                }

                .direction-label {
                    font-size: 10px;
                    min-width: 24px;
                }
            }


        </style>
    </head>
    <body>
        <!-- Header remains the same as previous version -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="so-overview" class="nav-item ">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="so-products?page=1" class="nav-item">
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
                            <a href="so-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="import-request" class="dropdown-item">Tạo đơn nhập hàng</a>
                            <a href="so-track-movements" class="dropdown-item">Theo dõi nhập/xuất</a>
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
                            <a href="so-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>
        <div class="main-container">
            <!-- Sidebar remains the same -->
            <aside class="sidebar">
                <form action="so-track-movements" method="get" class="filter-form">
                    <fieldset>
                        <legend>Bộ lọc hoạt động</legend>

                        <div class="filter-item">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" id="fromDate" name="fromDate" class="form-input" value="${fromDate}">
                        </div>

                        <div class="filter-item">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" id="toDate" name="toDate" class="form-input" value="${toDate}">
                        </div>

                        <div class="filter-item">
                            <label>Loại hoạt động:</label>
                            <div class="form-radio-group">
                                <label>
                                    <input type="radio" name="movementType" value="" ${empty movementType ? 'checked' : ''}>
                                    Tất cả
                                </label>
                                <label>
                                    <input type="radio" name="movementType" value="import" ${movementType eq 'import' ? 'checked' : ''}>
                                    Nhập hàng
                                </label>
                                <label>
                                    <input type="radio" name="movementType" value="export" ${movementType eq 'export' ? 'checked' : ''}>
                                    Xuất hàng
                                </label>
                            </div>
                        </div>

                        <div class="filter-item">
                            <label>Trạng thái:</label>
                            <div class="form-radio-group">
                                <label>
                                    <input type="radio" name="status" value="" ${empty status ? 'checked' : ''}>
                                    Tất cả
                                </label>
                                <label>
                                    <input type="radio" name="status" value="pending" ${status eq 'pending' ? 'checked' : ''}>
                                    Chờ xử lý
                                </label>
                                <label>
                                    <input type="radio" name="status" value="processing" ${status eq 'processing' ? 'checked' : ''}>
                                    Đang xử lý
                                </label>
                                <label>
                                    <input type="radio" name="status" value="transfer" ${status eq 'transfer' ? 'checked' : ''}>
                                    Đang vận chuyển
                                </label>
                                <label>
                                    <input type="radio" name="status" value="completed" ${status eq 'completed' ? 'checked' : ''}>
                                    Hoàn thành
                                </label>
                                <label>
                                    <input type="radio" name="status" value="cancelled" ${status eq 'cancelled' ? 'checked' : ''}>
                                    Đã hủy
                                </label>
                            </div>
                        </div>

                    </fieldset>

                    <!-- Action Buttons -->
                    <div class="filter-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter"></i>
                            Áp dụng lọc
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="resetFilters()">
                            <i class="fas fa-undo"></i>
                            Reset
                        </button>
                    </div>
                </form>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Theo dõi tất cả hoạt động kho</h1>
                    <p class="page-subtitle">Danh sách tất cả các hoạt động nhập/xuất hàng trong hệ thống</p>
                </div>

                <!-- Messages -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>

                <div class="page-controls" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                    <div class="pagination-info">
                        Hiển thị ${fn:length(allMovements)} trong tổng số ${totalRecords} hoạt động
                        (Trang ${currentPage} / ${totalPages})
                    </div>

                    <c:if test="${totalRecords > 10}">
                        <div class="page-size-selector" style="display: flex; align-items: center; gap: 0.5rem;">
                            <label for="pageSizeSelect" style="font-size: 14px; color: #6c757d;">Hiển thị:</label>
                            <select id="pageSizeSelect" onchange="changePageSize()" style="padding: 4px 8px; border: 1px solid #dee2e6; border-radius: 4px;">
                                <c:forEach var="option" items="${pageSizeOptions}">
                                    <option value="${option}" ${option == currentPageSize ? 'selected' : ''}>
                                        ${option} 
                                        <c:choose>
                                            <c:when test="${option == Math.round(totalRecords * 0.1)}">
                                                (10%)
                                            </c:when>
                                            <c:when test="${option == Math.round(totalRecords * 0.25)}">
                                                (25%)
                                            </c:when>
                                            <c:when test="${option == Math.round(totalRecords * 0.5)}">
                                                (50%)
                                            </c:when>
                                            <c:when test="${option == Math.round(totalRecords * 0.75)}">
                                                (75%)
                                            </c:when>
                                            <c:when test="${option == totalRecords}">
                                                (100%)
                                            </c:when>
                                            <c:otherwise>
                                                records
                                            </c:otherwise>
                                        </c:choose>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </c:if>
                </div>

                <!-- Movements Table -->
                <div class="table-container">
                    <table class="invoices-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã hoạt động</th>
                                <th>Loại</th>
                                <th>Hướng di chuyển</th>
                                <th>Trạng thái</th>
                                <th>Giá trị</th>
                                <th>Ngày tạo</th>
                                <th>Người tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="movement" items="${allMovements}" varStatus="loop">
                                <tr>
                                    <td>${(currentPage - 1) * pageSize + loop.index + 1}</td>
                                    <td><strong>#${movement.movementID}</strong></td>
                                    <td>
                                        <span class="movement-type-badge ${movement.movementType}">
                                            <c:choose>
                                                <c:when test="${movement.movementType eq 'import'}">
                                                    <i class="fas fa-arrow-down"></i> Nhập
                                                </c:when>
                                                <c:when test="${movement.movementType eq 'export'}">
                                                    <i class="fas fa-arrow-up"></i> Xuất
                                                </c:when>
                                                <c:otherwise>
                                                    ${movement.movementType}
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="direction-info">
                                            <div class="direction-from">
                                                <span class="direction-label">Từ:</span>
                                                <span class="location-badge">
                                                    <c:choose>
                                                        <c:when test="${not empty movement.fromSupplierName}">
                                                            <i class="fas fa-truck"></i>
                                                            ${movement.fromSupplierName}
                                                        </c:when>
                                                        <c:when test="${not empty movement.fromBranchName}">
                                                            <i class="fas fa-store"></i>
                                                            ${movement.fromBranchName}
                                                        </c:when>
                                                        <c:when test="${not empty movement.fromWarehouseName}">
                                                            <i class="fas fa-warehouse"></i>
                                                            ${movement.fromWarehouseName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-question-circle"></i>
                                                            Không xác định
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>

                                            <div class="direction-to">
                                                <span class="direction-label">Đến:</span>
                                                <span class="location-badge">
                                                    <c:choose>
                                                        <c:when test="${not empty movement.toBranchName}">
                                                            <i class="fas fa-store"></i>
                                                            ${movement.toBranchName}
                                                        </c:when>
                                                        <c:when test="${not empty movement.toWarehouseName}">
                                                            <i class="fas fa-warehouse"></i>
                                                            ${movement.toWarehouseName}
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="fas fa-question-circle"></i>
                                                            Không xác định
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${movement.responseStatus eq 'pending'}">
                                                <span class="status-badge pending">Chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${movement.responseStatus eq 'processing'}">
                                                <span class="status-badge processing">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${movement.responseStatus eq 'transfer'}">
                                                <span class="status-badge transfer">Đang vận chuyển</span>
                                            </c:when>
                                            <c:when test="${movement.responseStatus eq 'completed'}">
                                                <span class="status-badge completed">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${movement.responseStatus eq 'cancelled'}">
                                                <span class="status-badge cancelled">Đã huỷ</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge pending">Chưa rõ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>${movement.formattedTotalAmount}</strong></td>
                                    <td>${movement.formattedDate}</td>
                                    <td>${movement.createdByName}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn-action view" onclick="viewMovementDetails('${movement.movementID}')" 
                                                    title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                                Xem
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty allMovements}">
                                <tr>
                                    <td colspan="9" class="no-data">
                                        <i class="fas fa-box-open"></i>
                                        <p>Không có hoạt động nào trong hệ thống</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <!-- Cập nhật các pagination links -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <!-- First page -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="so-track-movements?fromDate=${fromDate}&toDate=${toDate}&status=${status}&movementType=${movementType}&pageSize=${currentPageSize}&page=1" class="page-btn">
                                    <i class="fas fa-angle-double-left"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-double-left"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Previous page -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="so-track-movements?fromDate=${fromDate}&toDate=${toDate}&status=${status}&movementType=${movementType}&pageSize=${currentPageSize}&page=${currentPage - 1}" class="page-btn">
                                    <i class="fas fa-angle-left"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-left"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page numbers -->
                        <c:forEach var="i" begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" 
                                   end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="page-btn active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="so-track-movements?fromDate=${fromDate}&toDate=${toDate}&status=${status}&movementType=${movementType}&pageSize=${currentPageSize}&page=${i}" class="page-btn">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <!-- Next page -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="so-track-movements?fromDate=${fromDate}&toDate=${toDate}&status=${status}&movementType=${movementType}&pageSize=${currentPageSize}&page=${currentPage + 1}" class="page-btn">
                                    <i class="fas fa-angle-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-right"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Last page -->
                        <c:choose>
                            <c:when test="${currentPage < totalPages}">
                                <a href="so-track-movements?fromDate=${fromDate}&toDate=${toDate}&status=${status}&movementType=${movementType}&pageSize=${currentPageSize}&page=${totalPages}" class="page-btn">
                                    <i class="fas fa-angle-double-right"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="page-btn disabled">
                                    <i class="fas fa-angle-double-right"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

            </main>
        </div>

        <script>
            function viewMovementDetails(movementId) {
                console.log('Xem chi tiết hoạt động: ' + movementId);
                window.location.href = 'so-detail-tracking?id=' + movementId;
            }

            function resetFilters() {
                window.location.href = 'so-track-movements';
            }

            // Dropdown toggle functionality
            document.addEventListener('DOMContentLoaded', function () {
                const toggle = document.getElementById("dropdownToggle");
                const menu = document.getElementById("dropdownMenu");

                if (toggle && menu) {
                    toggle.addEventListener("click", function (e) {
                        e.preventDefault();
                        menu.style.display = menu.style.display === "block" ? "none" : "block";
                    });

                    document.addEventListener("click", function (e) {
                        if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                            menu.style.display = "none";
                        }
                    });
                }

                // Auto-hide alerts after 5 seconds
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    setTimeout(function () {
                        alert.style.display = 'none';
                    }, 5000);
                });
            });

            function changePageSize() {
                const select = document.getElementById('pageSizeSelect');
                const newPageSize = select.value;

                // Tạo URL mới với pageSize parameter
                const urlParams = new URLSearchParams(window.location.search);
                urlParams.set('pageSize', newPageSize);
                urlParams.set('page', '1'); // Reset về trang 1 khi thay đổi page size

                // Redirect với parameters mới
                window.location.href = 'so-track-movements?' + urlParams.toString();
            }

        </script>
    </body>
</html>
