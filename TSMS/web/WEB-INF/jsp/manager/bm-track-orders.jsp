<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Theo dõi đơn hàng của chi nhánh</title>
        <link rel="stylesheet" href="css/import.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Styling cho button trạng thái hoàn thành và hủy */
            .pagination-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin: 20px 0;
                flex-wrap: wrap;
                gap: 15px;
            }

            .pagination-left {
                display: flex;
                align-items: center;
                gap: 20px;
                flex-wrap: wrap;
            }

            .pagination-info {
                font-size: 14px;
                color: #666;
            }

            .records-per-page {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                color: #666;
            }

            .records-select {
                padding: 4px 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                background: white;
                cursor: pointer;
            }

            .pagination {
                display: flex;
                gap: 5px;
            }

            .page-btn {
                text-decoration: none;
                color: black;
                width: 32px;
                height: 32px;
                border: 1px solid #ddd;
                background: white;
                border-radius: 4px;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 14px;
                transition: all 0.3s;
            }

            .page-btn:hover:not(.disabled) {
                background: #f0f0f0;
            }

            .page-btn.active {
                background: #2196f3;
                color: white;
                border-color: #2196f3;
            }

            .page-btn.disabled {
                pointer-events: none;
                color: #aaa;
                cursor: not-allowed;
            }

            .btn-action.completed {
                background-color: #28a745;
                color: white;
                cursor: not-allowed;
                opacity: 0.8;
            }

            .btn-action.cancelled {
                background-color: #dc3545;
                color: white;
                cursor: not-allowed;
                opacity: 0.8;
            }

            .btn-action.completed:hover,
            .btn-action.cancelled:hover {
                opacity: 0.8;
                transform: none;
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

                    <a href="bm-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item active dropdown">
                        <a href="" class="dropdown-toggle">
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
        </header>

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="bm-incoming-orders" method="get" class="filter-form">
                    <input type="hidden" name="page" value="1">
                    <fieldset>
                        <legend>Bộ lọc</legend>

                        <div class="filter-item">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" id="fromDate" name="fromDate" class="form-input" value="${fromDate}">
                        </div>

                        <div class="filter-item">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" id="toDate" name="toDate" class="form-input" value="${toDate}">
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
                    <h1>Theo dõi đơn hàng của chi nhánh</h1>
                    <p class="page-subtitle">Danh sách các đơn hàng được yêu cầu và đang xử lý cho chi nhánh</p>
                </div>

                <!-- Thông báo -->
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
                <div class="pagination-container">
                    <div class="pagination-left">
                        <div class="pagination-info">
                            Hiển thị ${startItem} - ${endItem} trong tổng số ${totalItems} đơn hàng
                            (Trang ${currentPage} / ${totalPages})
                        </div>

                        <div class="records-per-page">
                            <label>Hiển thị:</label>
                            <form method="GET" class="records-per-page-form">
                                <input type="hidden" name="fromDate" value="${fromDate}">
                                <input type="hidden" name="toDate" value="${toDate}">
                                <input type="hidden" name="status" value="${status}">
                                <select name="itemsPerPage" class="records-select" onchange="this.form.submit()">
                                    <option value="10" ${itemsPerPage == 10 ? 'selected' : ''}>10</option>
                                    <option value="25" ${itemsPerPage == 25 ? 'selected' : ''}>25</option>
                                    <option value="50" ${itemsPerPage == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </form>
                            <span>bản ghi/trang</span>
                        </div>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <!-- First page -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="bm-incoming-orders?fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=1" class="page-btn">⏮</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">⏮</span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Previous page -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="bm-incoming-orders?fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${currentPage - 1}" class="page-btn">◀</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">◀</span>
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
                                        <a href="bm-incoming-orders?fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${i}" class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Next page -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="bm-incoming-orders?fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${currentPage + 1}" class="page-btn">▶</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">▶</span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Last page -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="bm-incoming-orders?fromDate=${fromDate}&toDate=${toDate}&status=${status}&itemsPerPage=${itemsPerPage}&page=${totalPages}" class="page-btn">⏭</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">⏭</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                </div>
                <!-- Export Orders Table -->
                <div class="table-container">
                    <table class="invoices-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã đơn xuất</th>
                                <th>Nguồn</th>

                                <th>Trạng thái</th>
                                <th>Giá trị</th>
                                <th>Ngày tạo</th>
                                <th>Người tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>


                            <c:forEach var="req" items="${exportRequests}" varStatus="loop">
                                <tr>
                                    <td>${(currentPage - 1) * itemsPerPage + loop.index + 1}</td>
                                    <td><strong>#${req.movementID}</strong></td>
                                    <td>${req.fromBranchName}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${req.responseStatus eq 'pending'}">
                                                <span class="status-badge pending">Chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'processing'}">
                                                <span class="status-badge processing">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'transfer'}">
                                                <span class="status-badge transfer">Đang vận chuyển</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'completed'}">
                                                <span class="status-badge completed">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'cancelled'}">
                                                <span class="status-badge cancelled">Đã huỷ</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge unknown">Không rõ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>${req.formattedTotalAmount}</strong></td>
                                    <td>${req.formattedDate}</td>
                                    <td>${req.createdByName}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <c:choose>
                                                <c:when test="${req.responseStatus eq 'transfer'}">
                                                    <button class="btn-action receive" onclick="confirmReceive('${req.movementID}')" 
                                                            title="Xác nhận đã nhận hàng">
                                                        <i class="fas fa-check"></i>
                                                        Nhận hàng
                                                    </button>
                                                </c:when>
                                                <c:when test="${req.responseStatus eq 'completed'}">
                                                    <button class="btn-action completed" disabled
                                                            title="Đơn hàng đã hoàn thành">
                                                        <i class="fas fa-check-circle"></i>
                                                        Hoàn thành
                                                    </button>
                                                </c:when>
                                                <c:when test="${req.responseStatus eq 'cancelled'}">
                                                    <button class="btn-action cancelled" disabled
                                                            title="Đơn hàng đã bị hủy">
                                                        <i class="fas fa-times-circle"></i>
                                                        Đã hủy
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-action view" 
                                                            onclick="window.location.href = 'view-order-details?id=${req.movementID}'" 
                                                            title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                        Xem
                                                    </button>

                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty exportRequests}">
                                <tr>
                                    <td colspan="9" class="no-data">
                                        <i class="fas fa-box-open"></i>
                                        <p>Không có đơn hàng nào cho chi nhánh này</p>
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>

        <!-- Modal xác nhận nhận hàng -->
        <div id="receiveModal" class="modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Xác nhận nhận hàng</h3>
                    <span class="close" onclick="closeReceiveModal()">&times;</span>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xác nhận đã nhận hàng cho đơn <strong id="orderIdDisplay"></strong>?</p>
                    <p class="warning-text">
                        <i class="fas fa-exclamation-triangle"></i>
                        Sau khi xác nhận, hàng hóa sẽ được thêm vào tồn kho của chi nhánh và không thể hoàn tác.
                    </p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeReceiveModal()">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="processReceive()">Xác nhận nhận hàng</button>
                </div>
            </div>
        </div>

        <script>
            let currentOrderId = null;

            function viewOrder(orderId) {
                console.log('Xem chi tiết đơn hàng: ' + orderId);
                window.location.href = 'view-order-details?id=' + orderId;
            }

            function confirmReceive(orderId) {
                currentOrderId = orderId;
                document.getElementById('orderIdDisplay').textContent = '#' + orderId;
                document.getElementById('receiveModal').style.display = 'block';
            }

            function closeReceiveModal() {
                document.getElementById('receiveModal').style.display = 'none';
                currentOrderId = null;
            }

            function processReceive() {
                if (currentOrderId) {
                    // Tạo form hidden để submit
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'bm-receive-order';

                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'movementID';
                    input.value = currentOrderId;

                    form.appendChild(input);
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            function resetFilters() {
                window.location.href = 'bm-track-orders';
            }

            // Dropdown toggle
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");

            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            });

            document.addEventListener("click", function (e) {
                if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                    menu.style.display = "none";
                }
            });
        </script>
    </body>
</html>