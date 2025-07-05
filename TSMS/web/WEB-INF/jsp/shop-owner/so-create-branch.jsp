<%-- 
    Document   : so-create-branch
    Created on : Jul 4, 2025, 11:30:48 PM
    Author     : admin
--%>

<%@ page import="java.util.*, model.ShopOwnerDTO, util.Validate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tạo chi nhánh mới - TSMS</title>
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

            .profile-container {
                flex: 1;
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                overflow: hidden;
            }

            .profile-header {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .profile-header-left {
                display: flex;
                align-items: center;
            }

            .profile-header i {
                margin-right: 10px;
                color: #1976d2;
            }

            .profile-header h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 600;
                color: #333;
            }

            .profile-content {
                padding: 30px;
            }

            .form-section {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                margin-bottom: 20px;
            }

            .form-section h4 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #333;
            }

            .required {
                color: #dc3545;
            }

            .form-input {
                width: 100%;
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s ease;
                background-color: white;
            }

            .form-input:focus {
                outline: none;
                border-color: #1976d2;
                box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
            }

            .form-input:invalid {
                border-color: #dc3545;
            }

            .form-input:invalid:focus {
                border-color: #dc3545;
                box-shadow: 0 0 0 3px rgba(220, 53, 69, 0.1);
            }

            .form-buttons {
                display: flex;
                gap: 16px;
                justify-content: flex-end;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 8px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                min-width: 120px;
                justify-content: center;
            }

            .btn-primary {
                background: #1976d2;
                color: white;
            }

            .btn-primary:hover {
                background: #1565c0;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(25, 118, 210, 0.3);
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(108, 117, 125, 0.3);
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-success:hover {
                background: #218838;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
            }

            .flash-message {
                position: fixed;
                top: 20px;
                right: 30px;
                padding: 16px 24px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                color: white;
                z-index: 1000;
                font-size: 16px;
                animation: slideIn 0.3s ease-out, fadeOut 0.5s ease-in-out 4.5s forwards;
            }

            .flash-message.success {
                background-color: #4CAF50;
            }

            .flash-message.error {
                background-color: #f44336;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(100px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            @keyframes fadeOut {
                to {
                    opacity: 0;
                    transform: translateY(-20px);
                    visibility: hidden;
                }
            }

            .help-text {
                font-size: 12px;
                color: #666;
                margin-top: 5px;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .form-grid .form-group.full-width {
                grid-column: 1 / -1;
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                }

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .form-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }

            .error-message {
                color: red;
                margin-top: 15px;
                text-align: center;
            }

            .success-message {
                color: green;
                margin-top: 15px;
                text-align: center;
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

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Left Sidebar -->
                <div class="sidebar">
                    <h3>Gian hàng</h3>
                    <ul class="sidebar-menu">
                        <li><a href="so-information"><i class="fas fa-info-circle"></i> Thông tin gian hàng</a></li>
                        <li><a href="so-change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                        <li><a href="so-branches" class="active"><i class="fas fa-code-branch"></i> Quản lý chi nhánh</a></li>
                        <li><a href="so-warehouses"><i class="fas fa-warehouse"></i> Quản lý kho tổng</a></li>
                        <li><a href="subscription"><i class="fas fa-shopping-cart"></i> Gói dịch vụ</a></li>
                        <li><a href="subscription-logs"><i class="fas fa-history"></i> Lịch sử mua hàng</a></li>
                    </ul>
                </div>

                <!-- Create Branch Container -->
                <div class="profile-container">
                    <div class="profile-header">
                        <div class="profile-header-left">
                            <i class="fas fa-code-branch"></i>
                            <h2>Tạo chi nhánh mới</h2>
                        </div>
                    </div>

                    <div class="profile-content">
                        <form id="branchForm" action="so-create-branch" method="POST">
                            <!-- Branch Information -->
                            <div class="form-section">
                                <h4><i class="fas fa-store"></i> Thông tin chi nhánh</h4>

                                <div class="form-grid">
                                    <div class="form-group full-width">
                                        <label for="branchName">
                                            Tên chi nhánh <span class="required">*</span>
                                        </label>
                                        <input type="text" 
                                               id="branchName" 
                                               name="branchName" 
                                               class="form-input" 
                                               placeholder="Nhập tên chi nhánh"
                                               required 
                                               maxlength="100">
                                        <div class="help-text">Tên chi nhánh sẽ hiển thị trên hóa đơn và các tài liệu</div>
                                    </div>

                                    <div class="form-group full-width">
                                        <label for="branchAddress">
                                            Địa chỉ chi nhánh <span class="required">*</span>
                                        </label>
                                        <input type="text" 
                                               id="branchAddress" 
                                               name="branchAddress" 
                                               class="form-input" 
                                               placeholder="Nhập địa chỉ đầy đủ của chi nhánh"
                                               required 
                                               maxlength="200">
                                        <div class="help-text">Địa chỉ chi tiết bao gồm số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố</div>
                                    </div>

                                    <div class="form-group full-width">
                                        <label for="branchPhone">
                                            Số điện thoại <span class="required">*</span>
                                        </label>
                                        <input type="tel" 
                                               id="branchPhone" 
                                               name="branchPhone" 
                                               class="form-input" 
                                               placeholder="Nhập số điện thoại"
                                               required 
                                               pattern="[0-9]{10,11}" 
                                               maxlength="11">
                                        <div class="help-text">Số điện thoại gồm 10-11 chữ số</div>
                                    </div>

                                    <!--                                    <div class="form-group">
                                                                            <label for="branchEmail">
                                                                                Email chi nhánh
                                                                            </label>
                                                                            <input type="email" 
                                                                                   id="branchEmail" 
                                                                                   name="branchEmail" 
                                                                                   class="form-input" 
                                                                                   placeholder="Nhập email chi nhánh (tùy chọn)"
                                                                                   maxlength="100">
                                                                            <div class="help-text">Email liên hệ riêng cho chi nhánh này</div>
                                                                        </div>-->
                                </div>

                                <p class="error-message">${error}</p>
                                <p class="success-message">${success}</p>
                            </div>


                            <!-- Form Buttons -->
                            <div class="form-buttons">
                                <a href="so-branches" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i>
                                    Quay lại
                                </a>
                                <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                    <i class="fas fa-undo"></i>
                                    Đặt lại
                                </button>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-plus"></i>
                                    Tạo chi nhánh
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <script>
            // Handle dropdown menu
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");

            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            });

            // Close dropdown when clicking outside
            document.addEventListener("click", function (e) {
                if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                    menu.style.display = "none";
                }
            });

            // Form handling functions
            function resetForm() {
                if (confirm('Bạn có chắc chắn muốn đặt lại form?')) {
                    document.getElementById('branchForm').reset();
                }
            }

            // Form validation
            document.getElementById('branchForm').addEventListener('submit', function (e) {
                const branchName = document.getElementById('branchName').value.trim();
                const branchAddress = document.getElementById('branchAddress').value.trim();
                const branchPhone = document.getElementById('branchPhone').value.trim();

                // Check required fields
                if (!branchName || !branchAddress || !branchPhone) {
                    e.preventDefault();
                    alert('Vui lòng điền đầy đủ thông tin bắt buộc (Tên chi nhánh, Địa chỉ, Số điện thoại)');
                    return false;
                }

                // Validate phone number
                if (!/^[0-9]{10,11}$/.test(branchPhone)) {
                    e.preventDefault();
                    alert('Số điện thoại phải có 10-11 chữ số');
                    return false;
                }

                // Validate email if provided
                const branchEmail = document.getElementById('branchEmail').value.trim();
                if (branchEmail && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(branchEmail)) {
                    e.preventDefault();
                    alert('Vui lòng nhập địa chỉ email hợp lệ');
                    return false;
                }

            });

            // Phone number input formatting
            document.getElementById('branchPhone').addEventListener('input', function (e) {
                // Remove non-numeric characters
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        </script>
    </body>
</html>
