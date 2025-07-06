<%-- 
    Document   : payment-subs
    Created on : Jul 2, 2025, 1:35:53 PM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Thông tin thanh toán</title>
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

            .payment-box {
                background: #fff;
                border-radius: 8px;
                padding: 30px;
                max-width: 800px;
                margin: auto;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }

            .payment-header {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #333;
            }

            .payment-content {
                display: flex;
                gap: 24px;
                align-items: flex-start;
            }

            .qr-code {
                width: 240px;
                flex-shrink: 0;
            }

            .qr-code img {
                width: 100%;
                border: 1px solid #ddd;
                border-radius: 8px;
            }

            .info-table {
                flex: 1;
                font-size: 16px;
            }

            .info-table tr td {
                padding: 10px 8px;
                vertical-align: top;
            }

            .info-table tr td:first-child {
                font-weight: bold;
                color: #333;
                width: 160px;
            }

            .note-box {
                background-color: #fff3cd;
                color: #856404;
                padding: 12px 16px;
                border: 1px solid #ffeeba;
                border-radius: 6px;
                margin-top: 20px;
                font-size: 14px;
            }

            .confirmation-link {
                margin-top: 12px;
                font-size: 14px;
            }

            .confirmation-link a {
                color: #007bff;
                text-decoration: none;
            }

            .confirmation-link a:hover {
                text-decoration: underline;
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
            .btn-cancel {
                width: 100%;
                background-color: white;
                color: black;
                border: 1px solid black;
                padding: 10px 20px;
                border-radius: 6px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .btn-cancel:hover {
                background-color: #e0e0e0; /* hoặc gray, hoặc #ccc */
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
                            <a href="so-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <main class="main-content">
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

                <div class="main-form">
                    <div class="payment-box">
                        <div class="payment-header">Chuyển khoản thanh toán</div>

                        <div class="payment-content">
                            <!-- QR -->
                            <div class="qr-code">
                                <img src="${qrUrl}" alt="QR Code chuyển khoản" style="width: 240px; border-radius: 8px;">
                            </div>

                            <!-- Thông tin chuyển khoản -->
                            <table class="info-table">
                                <tr>
                                    <td>Ngân hàng</td>
                                    <td>Ngân hàng TMCP Quân đội (MB)</td>
                                </tr>
                                <tr>
                                    <td>Số tài khoản</td>
                                    <td>9529012005</td>
                                </tr>
                                <tr>
                                    <td>Số tiền chuyển khoản</td>
                                    <td><strong><fmt:formatNumber value="${amount}" type="number" groupingUsed="true"/>đ</strong></td>
                                </tr>
                                <tr>
                                    <td>Nội dung</td>
                                    <td><strong>${transferNote}</strong></td>
                                </tr>
                                <tr>
                                    <td>Chủ tài khoản</td>
                                    <td>NGUYEN DOAN PHUNG PHUONG</td>
                                </tr>
                                <tr>
                                    <td>Chi nhánh</td>
                                    <td>Chi nhánh Hai Bà Trưng, Hà Nội</td>
                                </tr>
                            </table>
                        </div>

                        <!-- Ghi chú -->
                        <div class="note-box">
                            📌 Vui lòng quét mã QR hoặc nhập đúng thông tin chuyển khoản để thanh toán được ghi nhận chính xác.
                        </div>
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

                    <div class="confirmation-link">
                        Nếu bạn đã thanh toán, bấm vào đây để xác nhận thanh toán và hoàn thành quy trình.
                    </div>

                    <form action="sa-subscriptions" method="post">
                        <div hidden="">
                            <input type="text" name="phone" value="${phone}">
                            <input type="text" name="plan" value="${planId}">
                        </div>
                        <a href="">
                            <button type="submit" class="btn-primary" style="margin-bottom: 10px;
                                    margin-top: 10px;">Xác nhận thanh toán</button>
                        </a>
                        <a href="subscription"><button type="button" class="btn-cancel">Huỷ</button></a> 
                    </form>
                </div>
            </div>
        </main>
    </body>
</html>

