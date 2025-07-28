<%-- 
    Document   : subscribe
    Created on : Jul 1, 2025, 8:41:44 AM
    Author     : admin
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mua Gói hỗ trợ - TSMS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/header.css"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                color: #333;
            }

            .main-content {
                min-height: calc(100vh - 160px);
                padding: 20px;
                background-color: #f5f5f5;
                display: flex;
                justify-content: center;
            }

            .container {
                width: 100%;
                max-width: 1400px;
                display: flex;
                gap: 24px;
                align-items: flex-start;
            }

            .sidebar {
                width: 280px;
                flex-shrink: 0;
            }

            .main-form {
                flex: 1;
                max-width: 800px;
            }

            .summary-card {
                width: 320px;
                flex-shrink: 0;
            }

            .sidebar {
                background: white;
                border-radius: 8px;
                padding: 20px;
                height: fit-content;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
            }

            .sidebar h3 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }

            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar-menu li {
                margin-bottom: 8px;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                padding: 12px 16px;
                text-decoration: none;
                color: #666;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .sidebar-menu a:hover,
            .sidebar-menu a.active {
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .sidebar-menu i {
                margin-right: 12px;
                width: 20px;
                font-size: 16px;
            }

            .main-form {
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                overflow: hidden;
            }

            .form-header {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
            }

            .form-header i {
                margin-right: 10px;
                color: #1976d2;
            }

            .form-header h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 600;
                color: #333;
            }

            .form-content {
                padding: 30px;
            }

            .plan-options {
                margin-bottom: 30px;
            }

            .plan-option {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 16px;
                border: 1px solid #d1ecf1;
                border-radius: 6px;
                margin-bottom: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                background-color: #f8f9fa;
            }

            .plan-option:hover {
                border-color: #17a2b8;
                background-color: #e3f2fd;
            }

            .plan-option.selected {
                border-color: #17a2b8;
                background-color: #d1ecf1;
                box-shadow: 0 0 0 1px #17a2b8;
            }

            .plan-option input[type="radio"] {
                margin-right: 12px;
            }

            .plan-duration {
                font-weight: 500;
                color: #333;
            }

            .plan-price {
                font-weight: 600;
                color: #17a2b8;
                font-size: 14px;
            }

            .form-tabs {
                display: flex;
                border-bottom: 2px solid #e9ecef;
                margin-bottom: 24px;
            }

            .tab-button {
                padding: 12px 24px;
                background: none;
                border: none;
                cursor: pointer;
                font-weight: 500;
                color: #666;
                border-bottom: 2px solid transparent;
                transition: all 0.3s ease;
            }

            .tab-button.active {
                color: #17a2b8;
                border-bottom-color: #17a2b8;
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group.full-width {
                grid-column: 1 / -1;
            }

            .form-group label {
                margin-bottom: 6px;
                font-weight: 500;
                color: #333;
            }

            .form-group label.required::after {
                content: "*";
                color: #e74c3c;
                margin-left: 4px;
            }

            .form-group input,
            .form-group select {
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                transition: border-color 0.3s ease;
            }

            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: #17a2b8;
                box-shadow: 0 0 0 2px rgba(23, 162, 184, 0.2);
            }

            .phone-input {
                display: flex;
                gap: 8px;
            }

            .phone-input select {
                width: 80px;
                flex-shrink: 0;
            }

            .gender-options {
                display: flex;
                gap: 20px;
                margin-top: 6px;
            }

            .gender-option {
                display: flex;
                align-items: center;
                gap: 6px;
            }

            .gender-option input[type="radio"] {
                margin: 0;
            }

            .summary-card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                height: fit-content;
            }

            .summary-card h3 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }

            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding-bottom: 12px;
                border-bottom: 1px solid #f0f0f0;
            }

            .summary-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
            }

            .summary-item.total {
                font-weight: 600;
                font-size: 16px;
                color: #17a2b8;
                border-top: 2px solid #e9ecef;
                padding-top: 12px;
                margin-top: 12px;
            }

            .summary-note {
                background: #f8f9fa;
                padding: 12px;
                border-radius: 6px;
                font-size: 12px;
                color: #666;
                margin-bottom: 20px;
            }

            .btn-primary {
                width: 100%;
                padding: 12px;
                background: #17a2b8;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .btn-primary:hover {
                background: #138496;
            }

            .sms-note {
                text-align: center;
                color: #666;
                font-size: 12px;
                margin-top: 12px;
            }

            .help-button {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 50px;
                height: 50px;
                background: #17a2b8;
                color: white;
                border: none;
                border-radius: 50%;
                font-size: 18px;
                cursor: pointer;
                box-shadow: 0 2px 12px rgba(0,0,0,0.15);
                transition: all 0.3s ease;
            }

            .help-button:hover {
                background: #138496;
                transform: scale(1.1);
            }
            .notification {
                position: fixed;
                bottom: 20px;
                right: 20px;
                padding: 15px 20px;
                border-radius: 8px;
                font-size: 16px;
                color: white;
                z-index: 9999;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
                animation: slideDown 0.4s ease;
            }

            /* Thành công: nền xanh lá */
            .notification.success {
                background-color: #28a745;
            }

            /* Lỗi: nền đỏ */
            .notification.error {
                background-color: #dc3545;
            }

            /* Ẩn sau 4s */
            .notification.hide {
                opacity: 0;
                visibility: hidden;
                transition: opacity 0.5s ease;
            }

            /* Animation xuất hiện */
            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Styles cho subscription info */
            .subscription-info {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                margin-bottom: 20px;
            }

            .subscription-info h4 {
                margin: 0 0 15px 0;
                font-size: 16px;
                font-weight: 600;
                color: #333;
            }

            .subscription-details {
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .subscription-detail-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 0;
                border-bottom: 1px solid #e9ecef;
            }

            .subscription-detail-item:last-child {
                border-bottom: none;
            }

            .subscription-detail-item label {
                font-weight: 500;
                color: #666;
            }

            .subscription-detail-item span {
                font-weight: 600;
                color: #333;
            }

            .status-active {
                color: #28a745;
                font-weight: 600;
            }

            .status-expired {
                color: #dc3545;
                font-weight: 600;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="so-overview" class="nav-item">
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

        <!-- Main Content -->
        <main class="main-content">
            <form action="subscription-payment" method="post">
                <div class="container">
                    <!-- Left Sidebar -->
                    <div class="sidebar">
                        <h3>Gian hàng</h3>
                        <ul class="sidebar-menu">
                            <li><a href="so-information"><i class="fas fa-info-circle"></i> Thông tin gian hàng</a></li>
                            <li><a href="so-change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                            <li><a href="so-branches"><i class="fas fa-code-branch"></i> Quản lý chi nhánh</a></li>
                            <li><a href="so-warehouses"><i class="fas fa-warehouse"></i> Quản lý kho tổng</a></li>
                            <li><a href="subscription"  class="active"><i class="fas fa-shopping-cart"></i> Gói dịch vụ</a></li>
                            <li><a href="subscription-logs"><i class="fas fa-history"></i> Lịch sử mua hàng</a></li>
                        </ul>
                    </div>

                    <!-- Main Form -->
                    <div class="main-form">
                        <div class="form-header">
                            <i class="fas fa-shopping-cart"></i>
                            <c:choose>
                                <c:when test="${status == 'TRIAL'}">
                                    <h2>Mua Gói hỗ trợ</h2>
                                </c:when>
                                <c:otherwise>
                                    <h2>Gia hạn Gói dịch vụ</h2>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="form-content">
                            <!-- Hiển thị thông tin subscription nếu khác TRIAL -->
                            <c:if test="${status != 'TRIAL'}">
                                <div class="subscription-info">
                                    <h4>Thông tin gói dịch vụ hiện tại</h4>
                                    <div class="subscription-details">
                                        <div class="subscription-detail-item">
                                            <label>Tên gói:</label>
                                            <span>${status}</span>
                                        </div>
                                        <div class="subscription-detail-item">
                                            <label>Trạng thái:</label>
                                            <span class="status-active">Đang hoạt động</span>
                                        </div>
                                        <div class="subscription-detail-item">
                                            <label>Ngày bắt đầu:</label>
                                            <span>${startDate}</span>
                                        </div>
                                        <div class="subscription-detail-item">
                                            <label>Ngày kết thúc:</label>
                                            <span>${endDate}</span>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Form gốc - luôn hiển thị -->
                            <form action="subscription-payment" method="post">
                                <!-- Plan Selection -->
                                <div class="plan-options">
                                    <div class="plan-option">
                                        <div style="display: flex; align-items: center;">
                                            <input type="radio" name="plan" value="1" id="plan1">
                                            <label for="plan1" class="plan-duration">3 tháng</label>
                                        </div>
                                        <div class="plan-price">700,000đ</div>
                                    </div>

                                    <div class="plan-option selected">
                                        <div style="display: flex; align-items: center;">
                                            <input type="radio" name="plan" value="2" id="plan2" checked>
                                            <label for="plan2" class="plan-duration">6 tháng</label>
                                        </div>
                                        <div class="plan-price">1,200,000đ</div>
                                    </div>

                                    <div class="plan-option">
                                        <div style="display: flex; align-items: center;">
                                            <input type="radio" name="plan" value="3" id="plan3">
                                            <label for="plan3" class="plan-duration">1 năm</label>
                                        </div>
                                        <div class="plan-price">2,000,000đ</div>
                                    </div>

                                    <div class="plan-option">
                                        <div style="display: flex; align-items: center;">
                                            <input type="radio" name="plan" value="4" id="plan4">
                                            <label for="plan4" class="plan-duration">2 năm</label>
                                        </div>
                                        <div class="plan-price">3,700,000đ</div>
                                    </div>
                                </div>

                                <div class="form-tabs">
                                    <button type="button" class="tab-button active">Thông tin người mua</button>
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="fullname" class="required">Họ và tên</label>
                                        <input type="text" id="fullname" name="fullname" value="${user.fullName}" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Giới tính</label>
                                        <div class="gender-options">
                                            <div class="gender-option">
                                                <input type="radio" name="gender" value="male" id="male"
                                                       <c:if test="${user.gender == '1'}">checked</c:if>>
                                                       <label for="male">Nam</label>
                                                </div>
                                                <div class="gender-option">
                                                    <input type="radio" name="gender" value="female" id="female"
                                                    <c:if test="${user.gender == '0'}">checked</c:if>>
                                                    <label for="female">Nữ</label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-row">
                                        <div class="form-group">
                                            <label for="phone" class="required">Số điện thoại</label>
                                            <div class="phone-input">
                                                <input type="number" id="phone" name="phone" value="${user.phone}" required style="width: 100%;">
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label for="email">Email</label>
                                        <input type="email" id="email" name="email" value="${user.email}">
                                    </div>
                                </div>

                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="cccd" class="required">CCCD/Hộ chiếu</label>
                                        <input type="text" id="cccd" name="cccd" value="${user.identificationID}" required>
                                    </div>

                                    <div class="form-group">
                                        <label for="address" class="required">Địa chỉ</label>
                                        <input type="text" id="address" name="address" value="${user.address}" required>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Right Summary -->
                    <div class="summary-card">
                        <h3>Chi tiết hóa đơn</h3>

                        <div class="summary-item">
                            <span>Gói 6 tháng</span>
                            <span>1,200,000đ</span>
                        </div>

                        <div class="summary-item total">
                            <span>Tổng tiền thanh toán</span>
                            <span>1,200,000đ</span>
                        </div>

                        <div class="summary-note">
                            Bằng cách tra chọn Tiếp tục thanh toán, bạn đã đồng ý với các <a href="#" style="color: #17a2b8;">Điều khoản dịch vụ</a> của KiotViet
                        </div>

                        <button type="submit" class="btn-primary">Tiếp tục thanh toán</button>
                    </div>
            </form>
        </main>

        <c:if test="${not empty success}">
            <div class="notification success" id="notification">${success}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="notification error" id="notification">${error}</div>
        </c:if>

        <c:if test="${not empty expired}">
            <div class="notification error" id="notification">Tài khoản của bạn đã hết hạn. Mua ngay để tiếp tục sử dụng.</div>
        </c:if>

        <script>
            // Handle plan selection
            document.querySelectorAll('.plan-option').forEach(option => {
                option.addEventListener('click', function () {
                    document.querySelectorAll('.plan-option').forEach(o => o.classList.remove('selected'));
                    this.classList.add('selected');
                    this.querySelector('input[type="radio"]').checked = true;

                    // Update price in summary
                    const price = this.querySelector('.plan-price').textContent;
                    const duration = this.querySelector('.plan-duration').textContent;
                    document.querySelector('.summary-item span:first-child').textContent = "Gói " + duration;
                    document.querySelector('.summary-item span:last-child').textContent = price;
                    document.querySelector('.summary-item.total span:last-child').textContent = price;
                });
            });

            // Handle tab switching
            document.querySelectorAll('.tab-button').forEach(tab => {
                tab.addEventListener('click', function () {
                    document.querySelectorAll('.tab-button').forEach(t => t.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        </script>
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