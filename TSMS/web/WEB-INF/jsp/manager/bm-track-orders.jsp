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
                    <a href="bm-overview" class="nav-item active">
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
                            <a href="request-stock" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-incoming-orders" class="dropdown-item">Theo dõi đơn nhập hàng</a>
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
            <form action="bm-track-orders" method="get" class="filter-form">
                <fieldset>
                    <legend>Bộ lọc</legend>

                    <div class="filter-item">
                        <label for="fromDate">Từ ngày:</label>
                        <input type="date" id="fromDate" name="fromDate" class="form-input">
                    </div>

                    <div class="filter-item">
                        <label for="toDate">Đến ngày:</label>
                        <input type="date" id="toDate" name="toDate" class="form-input">
                    </div>

                    <div class="filter-item">
                        <label>Trạng thái:</label>
                        <div class="form-radio-group">
                            <label>
                                <input type="radio" name="status" value="" checked>
                                Tất cả
                            </label>
                            <label>
                                <input type="radio" name="status" value="pending">
                                Chờ xử lý
                            </label>
                            <label>
                                <input type="radio" name="status" value="processing">
                                Đang xử lý
                            </label>
                            <label>
                                <input type="radio" name="status" value="transfer">
                                Đang vận chuyển
                            </label>
                            <label>
                                <input type="radio" name="status" value="completed">
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

            <!-- Export Orders Table -->
            <div class="table-container">
                <table class="invoices-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã đơn xuất</th>
                            <th>Nguồn</th>
                            <th>Đích</th>
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
                                <td>${loop.index + 1}</td>
                                <td><strong>#${req.movementID}</strong></td>
                                <td>${req.fromBranchName}</td>
                                <td>
                                    <c:set var="noteAndTo" value="${fn:split(req.note, '|TO:')}" />
                                    ${noteAndTo[1]}
                                </td>
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
                                            <c:otherwise>
                                                <button class="btn-action view" onclick="viewOrder('${req.movementID}')" 
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
