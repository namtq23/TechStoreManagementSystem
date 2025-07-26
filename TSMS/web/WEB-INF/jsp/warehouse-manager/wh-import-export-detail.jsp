<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Chi tiết hoạt động kho - TSMS</title>
        <link rel="stylesheet" href="css/track-movements.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
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
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="wh-products?page=1" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="wh-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <a href="wh-import" class="nav-item  <c:choose>
                           <c:when test="${movementType eq 'export'}"></c:when>
                           <c:otherwise> active </c:otherwise>
                       </c:choose> ">
                        <i class="fa-solid fa-download"></i>
                        Nhập hàng
                    </a>
                    <a href="wh-export" class="nav-item <c:choose>
                           <c:when test="${movementType eq 'export'}"> active </c:when>
                           <c:otherwise></c:otherwise>
                       </c:choose> ">
                        <i class="fa-solid fa-upload"></i>
                        Xuất hàng
                    </a>
                   <a href="wh-import-request" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Yêu cầu nhập hàng                 
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
            <!-- Sidebar Filter -->
            <!-- Sidebar Filter -->
            <aside class="sidebar">
                <form method="GET" action="wh-import-export-detail" class="filter-form">
                    <input type="hidden" name="id" value="${movementID}">

                    <fieldset>
                        <legend>Bộ lọc chi tiết</legend>

                        <div class="filter-item">
                            <label for="productFilter">Sản phẩm:</label>
                            <select id="productFilter" name="productFilter" class="form-input">
                                <option value="">--Tất cả sản phẩm--</option>
                                <c:forEach var="product" items="${productList}">
                                    <option value="${product}" ${productFilter eq product ? 'selected' : ''}>${product}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-item">
                            <label>Trạng thái:</label>
                            <div class="form-radio-group">
                                <label>
                                    <input type="radio" name="status" value="" ${empty status ? 'checked' : ''}>
                                    Tất cả
                                </label>
                                <label>
                                    <input type="radio" name="status" value="completed" ${status eq 'completed' ? 'checked' : ''}>
                                    Hoàn thành
                                </label>
                                <label>
                                    <input type="radio" name="status" value="pending" ${status eq 'pending' ? 'checked' : ''}>
                                    Chờ xử lý
                                </label>
                                <label>
                                    <input type="radio" name="status" value="processing" ${status eq 'processing' ? 'checked' : ''}>
                                    Đang xử lý
                                </label>
                            </div>
                        </div>
                    </fieldset>

                    <!-- Filter Actions -->
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

                <!-- Page Header -->
                <div class="page-header">
                    <div>
                        <h1>Chi tiết đơn 
                            <c:choose>
                                <c:when test="${movementType eq 'export'}">xuất</c:when>
                                <c:otherwise>nhập</c:otherwise>
                            </c:choose>
                            hàng #${movementID}
                        </h1>
                        <p class="page-subtitle">Xem chi tiết các sản phẩm trong đơn hàng</p>
                    </div>

                    <div class="header-actions">
                        <button class="btn btn-secondary" onclick="window.location.href = 'wh-import'">
                            <i class="fas fa-arrow-left"></i>
                            Quay lại
                        </button>
                    </div>
                </div>

                <!-- Movement Info -->
                <div class="movement-info-card">




                    <div class="info-grid">
                        <div class="info-item">
                            <label>Loại hoạt động:</label>
                            <span class="movement-type-badge ${movementType}">
                                <c:choose>
                                    <c:when test="${movementType eq 'import'}">
                                        <i class="fas fa-arrow-down"></i> Nhập hàng
                                    </c:when>
                                    <c:when test="${movementType eq 'export'}">
                                        <i class="fas fa-arrow-up"></i> Xuất hàng
                                    </c:when>
                                    <c:otherwise>
                                        ${movementType}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="info-item">
                            <label>Ngày tạo:</label>
                            <span>${movement.formattedDate}</span>
                        </div>
                        <div class="info-item">
                            <label>Người tạo:</label>
                            <span>${movement.createdByName}</span>
                        </div>
                        <div class="info-item">
                            <label>Trạng thái xử lý:</label>
                            <span class="status-badge ${movement.responseStatus}">
                                <c:choose>
                                    <c:when test="${movement.responseStatus eq 'completed'}">
                                        <i class="fas fa-check-circle"></i> Đã hoàn thành
                                    </c:when>
                                    <c:when test="${movement.responseStatus eq 'processing'}">
                                        <i class="fas fa-clock"></i> Đang xử lý
                                    </c:when>
                                    <c:when test="${movement.responseStatus eq 'pending'}">
                                        <i class="fas fa-hourglass-half"></i> Chờ xử lý
                                    </c:when>
                                    <c:otherwise>
                                        ${movement.responseStatus}
                                    </c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <c:if test="${not empty movement.note}">
                        <div class="info-item full-width">
                            <label>Ghi chú:</label>
                            <span>${movement.note}</span>
                        </div>
                    </c:if>
                </div>

                <!-- Page Controls -->
                <div class="page-controls">
                    <div class="pagination-info">
                        Hiển thị ${startItem} - ${endItem} trong tổng số ${totalItems} sản phẩm
                        (Trang ${currentPage} / ${totalPages})
                    </div>

                    <div class="page-size-selector">
                        <label for="itemsPerPageSelect">Hiển thị:</label>
                        <select id="itemsPerPageSelect" onchange="changeItemsPerPage()">
                            <option value="10" ${itemsPerPage == 10 ? 'selected' : ''}>10</option>
                            <option value="25" ${itemsPerPage == 25 ? 'selected' : ''}>25</option>
                            <option value="50" ${itemsPerPage == 50 ? 'selected' : ''}>50</option>
                        </select>
                        <span>bản ghi/trang</span>
                    </div>
                </div>

                <!-- Details Table -->
                <div class="table-container">
                    <table class="invoices-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên sản phẩm</th>
                                <th>Mã sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Đã xử lý</th>
                                <th>Trạng thái</th>
                                <th>Serial Numbers</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="detail" items="${movementDetails}" varStatus="loop">
                                <tr class="${detail.quantity == detail.scanned ? 'row-completed' : ''}">
                                    <td>${(currentPage - 1) * itemsPerPage + loop.index + 1}</td>
                                    <td>
                                        <div><strong>${detail.productName}</strong></div>
                                        <div class="text-muted">Sản phẩm</div>
                                    </td>
                                    <td><code>${detail.productCode}</code></td>
                                    <td><strong>${detail.quantity}</strong></td>
                                    <td>
                                        <span class="${detail.scanned == detail.quantity ? 'text-success' : 'text-warning'}">
                                            ${detail.scanned}/${detail.quantity}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${detail.quantity == detail.scanned}">
                                                <span class="badge badge-success">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${detail.scanned > 0}">
                                                <span class="badge badge-warning">Đang xử lý</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-pending">Chờ xử lý</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="serials-container">
                                            <c:choose>
                                                <c:when test="${empty detail.serials}">
                                                    <span class="text-muted">
                                                        <c:choose>
                                                            <c:when test="${movement.responseStatus eq 'completed'}">
                                                                Đã hoàn thành
                                                            </c:when>
                                                            <c:otherwise>
                                                                Chưa có serial
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="serials-list">
                                                        <c:choose>
                                                            <c:when test="${empty detail.serials}">
                                                                <span class="text-muted">
                                                                    <c:choose>
                                                                        <c:when test="${movement.responseStatus eq 'completed'}">
                                                                            Đã hoàn thành
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Chưa có serial
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="serials-list">
                                                                    <c:forEach var="serial" items="${detail.serials}" varStatus="serialLoop">
                                                                        <c:choose>
                                                                            <c:when test="${serialLoop.index < 3}">
                                                                                <!-- Hiển thị 3 serial đầu tiên -->
                                                                                <span class="serial-badge">
                                                                                    ${serial.serialNumber}
                                                                                    <c:if test="${movement.responseStatus eq 'completed'}">
                                                                                        <i class="fas fa-check-circle text-success ml-1"></i>
                                                                                    </c:if>
                                                                                </span>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <!-- Ẩn các serial từ thứ 4 trở đi -->
                                                                                <span class="serial-badge hidden" style="display: none;">
                                                                                    ${serial.serialNumber}
                                                                                    <c:if test="${movement.responseStatus eq 'completed'}">
                                                                                        <i class="fas fa-check-circle text-success ml-1"></i>
                                                                                    </c:if>
                                                                                </span>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </c:forEach>

                                                                    <!-- Hiển thị nút "xem thêm" nếu có nhiều hơn 3 serial -->
                                                                    <c:if test="${fn:length(detail.serials) > 3}">
                                                                        <span class="serial-more" onclick="showMoreSerials(this)">
                                                                            +${fn:length(detail.serials) - 3} khác
                                                                        </span>
                                                                    </c:if>
                                                                </div>

                                                            </c:otherwise>
                                                        </c:choose>

                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>

                                </tr>
                            </c:forEach>

                            <c:if test="${empty movementDetails}">
                                <tr>
                                    <td colspan="7" class="no-data">
                                        <i class="fas fa-box-open"></i>
                                        <p>Không có sản phẩm nào trong đơn hàng này</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <!-- First page -->
                        <c:choose>
                            <c:when test="${currentPage > 1}">
                                <a href="wh-import-export-detail?id=${movementID}&productFilter=${productFilter}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=1" class="page-btn">
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
                                    <a href="wh-import-export-detail?id=${movementID}&productFilter=${productFilter}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${currentPage - 1}" class="page-btn">
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
                                            <a href="wh-import-export-detail?id=${movementID}&productFilter=${productFilter}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${i}" class="page-btn">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>

                                <!-- Next page -->
                                <c:choose>
                                    <c:when test="${currentPage < totalPages}">
                                        <a href="wh-import-export-detail?id=${movementID}&productFilter=${productFilter}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${currentPage + 1}" class="page-btn">
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
                                            <a href="wh-import-export-detail?id=${movementID}&productFilter=${productFilter}&fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${totalPages}" class="page-btn">
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
                                        function changeItemsPerPage() {
                                            const select = document.getElementById('itemsPerPageSelect');
                                            const itemsPerPage = select.value;
                                            const url = new URL(window.location);
                                            url.searchParams.set('itemsPerPage', itemsPerPage);
                                            url.searchParams.set('page', '1'); // Reset về trang 1

                                            window.location.href = url.toString();
                                        }

                                        function resetFilters() {
                                            window.location.href = 'wh-import-export-detail?id=${movementID}';
                                        }

                                        function showMoreSerials(element) {
                                            // Tìm container chứa các serial
                                            const serialsList = element.parentElement;

                                            // Tìm tất cả serial bị ẩn (có class 'hidden')
                                            const hiddenSerials = serialsList.querySelectorAll('.serial-badge.hidden');

                                            console.log('Tìm thấy', hiddenSerials.length, 'serial ẩn');

                                            if (hiddenSerials.length > 0) {
                                                // Hiển thị tất cả serial ẩn
                                                hiddenSerials.forEach(serial => {
                                                    serial.style.display = 'inline-block';
                                                    serial.classList.remove('hidden');
                                                });

                                                // Ẩn nút "xem thêm"
                                                element.style.display = 'none';

                                                console.log('Đã hiển thị thêm', hiddenSerials.length, 'serial numbers');
                                            } else {
                                                console.log('Không tìm thấy serial ẩn nào');
                                            }
                                        }

                                        // Chạy khi DOM đã load xong
                                        document.addEventListener('DOMContentLoaded', function () {
                                            // Dropdown toggle functionality
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
                                                    alert.style.opacity = '0';
                                                    setTimeout(function () {
                                                        alert.style.display = 'none';
                                                    }, 300);
                                                }, 5000);
                                            });

                                            // Show/hide more serials (backup cho trường hợp onclick không hoạt động)
                                            document.querySelectorAll('.serial-more').forEach(function (element) {
                                                element.addEventListener('click', function () {
                                                    const container = this.closest('.serials-list');
                                                    const hiddenSerials = container.querySelectorAll('.serial-badge.hidden');

                                                    hiddenSerials.forEach(function (serial) {
                                                        serial.style.display = 'inline-block';
                                                        serial.classList.remove('hidden');
                                                    });

                                                    this.style.display = 'none';
                                                });
                                            });
                                        });
                                    </script>




                                    <!-- Additional CSS for this page -->
                                    <style>
                                        .movement-info-card {
                                            background: #f8f9fa;
                                            padding: 20px;
                                            border-radius: 8px;
                                            margin-bottom: 20px;
                                            border: 1px solid #dee2e6;
                                        }

                                        .info-grid {
                                            display: grid;
                                            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                                            gap: 15px;
                                            margin-bottom: 10px;
                                        }

                                        .info-item {
                                            display: flex;
                                            flex-direction: column;
                                            gap: 5px;
                                        }

                                        .info-item.full-width {
                                            grid-column: 1 / -1;
                                        }

                                        .info-item label {
                                            font-weight: 600;
                                            color: #6c757d;
                                            font-size: 12px;
                                            text-transform: uppercase;
                                        }

                                        .row-completed {
                                            background-color: #f8fff8 !important;
                                        }

                                        .text-success {
                                            color: #28a745 !important;
                                            font-weight: 600;
                                        }

                                        .text-warning {
                                            color: #ffc107 !important;
                                            font-weight: 600;
                                        }

                                        .text-muted {
                                            color: #6c757d !important;
                                            font-size: 12px;
                                        }

                                        .badge {
                                            padding: 4px 8px;
                                            border-radius: 4px;
                                            font-size: 11px;
                                            font-weight: 600;
                                            text-transform: uppercase;
                                        }

                                        .badge-success {
                                            background-color: #d4edda;
                                            color: #155724;
                                        }

                                        .badge-warning {
                                            background-color: #fff3cd;
                                            color: #856404;
                                        }

                                        .badge-pending {
                                            background-color: #f8d7da;
                                            color: #721c24;
                                        }

                                        .serials-container {
                                            max-width: 200px;
                                        }

                                        .serials-list {
                                            display: flex;
                                            flex-wrap: wrap;
                                            gap: 4px;
                                        }

                                        .serial-badge {
                                            background-color: #e9ecef;
                                            color: #495057;
                                            padding: 2px 6px;
                                            border-radius: 3px;
                                            font-size: 10px;
                                            font-family: monospace;
                                        }

                                        .serial-badge.hidden {
                                            display: none;
                                        }

                                        .serial-more {
                                            background-color: #007bff;
                                            color: white;
                                            padding: 2px 6px;
                                            border-radius: 3px;
                                            font-size: 10px;
                                            cursor: pointer;
                                        }

                                        .serial-more:hover {
                                            background-color: #0056b3;
                                        }

                                        @media (max-width: 768px) {
                                            .info-grid {
                                                grid-template-columns: 1fr;
                                            }

                                            .serials-container {
                                                max-width: none;
                                            }
                                        }
                                        /* Movement Info Card */
                                        .movement-info-card {
                                            background: #f8f9fa;
                                            padding: 20px;
                                            border-radius: 8px;
                                            margin-bottom: 20px;
                                            border: 1px solid #dee2e6;
                                            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                                        }

                                        .info-grid {
                                            display: grid;
                                            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                                            gap: 15px;
                                            margin-bottom: 10px;
                                        }

                                        .info-item {
                                            display: flex;
                                            flex-direction: column;
                                            gap: 5px;
                                        }

                                        .info-item.full-width {
                                            grid-column: 1 / -1;
                                        }

                                        .info-item label {
                                            font-weight: 600;
                                            color: #6c757d;
                                            font-size: 12px;
                                            text-transform: uppercase;
                                            letter-spacing: 0.5px;
                                        }

                                        .info-item span {
                                            font-size: 14px;
                                            color: #495057;
                                            font-weight: 500;
                                        }

                                        /* Table Row States */
                                        .row-completed {
                                            background-color: #f8fff8 !important;
                                            border-left: 3px solid #28a745;
                                        }

                                        .row-completed:hover {
                                            background-color: #f0f8f0 !important;
                                        }

                                        /* Text Colors */
                                        .text-success {
                                            color: #28a745 !important;
                                            font-weight: 600;
                                        }

                                        .text-warning {
                                            color: #ffc107 !important;
                                            font-weight: 600;
                                        }

                                        .text-muted {
                                            color: #6c757d !important;
                                            font-size: 12px;
                                        }

                                        /* Status Badges */
                                        .badge {
                                            display: inline-block;
                                            padding: 4px 8px;
                                            border-radius: 4px;
                                            font-size: 11px;
                                            font-weight: 600;
                                            text-transform: uppercase;
                                            white-space: nowrap;
                                            text-align: center;
                                            min-width: 70px;
                                        }

                                        .badge-success {
                                            background-color: #d4edda;
                                            color: #155724;
                                            border: 1px solid #c3e6cb;
                                        }

                                        .badge-warning {
                                            background-color: #fff3cd;
                                            color: #856404;
                                            border: 1px solid #ffeaa7;
                                        }

                                        .badge-pending {
                                            background-color: #f8d7da;
                                            color: #721c24;
                                            border: 1px solid #f5c6cb;
                                        }

                                        /* Serial Numbers Container */
                                        .serials-container {
                                            max-width: 200px;
                                        }

                                        .serials-list {
                                            display: flex;
                                            flex-wrap: wrap;
                                            gap: 4px;
                                            align-items: center;
                                        }

                                        .serial-badge {
                                            background-color: #e9ecef;
                                            color: #495057;
                                            padding: 2px 6px;
                                            border-radius: 3px;
                                            font-size: 10px;
                                            font-family: 'Courier New', monospace;
                                            border: 1px solid #dee2e6;
                                            white-space: nowrap;
                                        }

                                        .serial-badge.hidden {
                                            display: none;
                                        }

                                        .serial-more {
                                            background-color: #007bff;
                                            color: white;
                                            padding: 2px 6px;
                                            border-radius: 3px;
                                            font-size: 10px;
                                            cursor: pointer;
                                            border: none;
                                            transition: background-color 0.3s ease;
                                        }

                                        .serial-more:hover {
                                            background-color: #0056b3;
                                        }

                                        /* Product Code Styling */
                                        code {
                                            background-color: #f8f9fa;
                                            color: #e83e8c;
                                            padding: 2px 4px;
                                            border-radius: 3px;
                                            font-size: 12px;
                                            font-family: 'Courier New', monospace;
                                        }

                                        /* Alert Messages */
                                        .alert {
                                            padding: 12px 16px;
                                            margin-bottom: 20px;
                                            border: 1px solid transparent;
                                            border-radius: 6px;
                                            display: flex;
                                            align-items: center;
                                            gap: 8px;
                                            font-size: 14px;
                                        }

                                        .alert-success {
                                            color: #155724;
                                            background-color: #d4edda;
                                            border-color: #c3e6cb;
                                        }

                                        .alert-error {
                                            color: #721c24;
                                            background-color: #f8d7da;
                                            border-color: #f5c6cb;
                                        }

                                        .alert i {
                                            font-size: 16px;
                                            flex-shrink: 0;
                                        }

                                        /* Responsive Adjustments */
                                        @media (max-width: 768px) {
                                            .info-grid {
                                                grid-template-columns: 1fr;
                                                gap: 10px;
                                            }

                                            .serials-container {
                                                max-width: none;
                                            }

                                            .serials-list {
                                                flex-direction: column;
                                                align-items: flex-start;
                                                gap: 2px;
                                            }

                                            .movement-info-card {
                                                padding: 15px;
                                            }

                                            .badge {
                                                min-width: 60px;
                                                font-size: 10px;
                                            }
                                        }

                                        /* Animation for expanding serials */
                                        @keyframes fadeIn {
                                            from {
                                                opacity: 0;
                                                transform: scale(0.9);
                                            }
                                            to {
                                                opacity: 1;
                                                transform: scale(1);
                                            }
                                        }

                                        .serial-badge:not(.hidden) {
                                            animation: fadeIn 0.3s ease-in-out;
                                        }

                                        /* Hover effects */
                                        .invoices-table tbody tr:hover .serial-badge {
                                            background-color: #e2e6ea;
                                            border-color: #adb5bd;
                                        }

                                        .invoices-table tbody tr:hover .badge {
                                            opacity: 0.9;
                                            transform: scale(1.02);
                                        }
                                        .serial-badge.hidden {
                                            display: none !important;
                                        }

                                        .serial-more {
                                            cursor: pointer;
                                            color: #007bff;
                                            font-weight: 500;
                                            padding: 2px 6px;
                                            border-radius: 3px;
                                            background: #f8f9fa;
                                            margin-left: 4px;
                                        }

                                        .serial-more:hover {
                                            background: #e9ecef;
                                            text-decoration: underline;
                                        }



                                    </style>
                                    </body>
                                    </html>
