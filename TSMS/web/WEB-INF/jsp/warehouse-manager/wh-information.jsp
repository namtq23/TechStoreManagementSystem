<%-- 
    Document   : wh-information
    Created on : Jul 6, 2025, 1:08:33 AM
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
        <title>Thông tin người dùng - TSMS</title>
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

            .edit-btn {
                padding: 8px 16px;
                background: #17a2b8;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .edit-btn:hover {
                background: #138496;
            }

            .profile-content {
                padding: 30px;
            }

            .profile-avatar {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid #e9ecef;
            }

            .avatar-image {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                background: #e9ecef;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 20px;
                position: relative;
                overflow: hidden;
            }

            .avatar-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .avatar-placeholder {
                font-size: 40px;
                color: #666;
            }

            .avatar-info h3 {
                margin: 0 0 8px 0;
                font-size: 24px;
                font-weight: 600;
                color: #333;
            }

            .user-role {
                display: inline-block;
                padding: 4px 12px;
                background: #e3f2fd;
                color: #1976d2;
                border-radius: 16px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
            }

            .status-badge {
                display: inline-block;
                padding: 4px 12px;
                border-radius: 16px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
                margin-left: 8px;
            }

            .status-active {
                background: #d4edda;
                color: #155724;
            }

            .status-inactive {
                background: #f8d7da;
                color: #721c24;
            }

            .info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 30px;
                margin-bottom: 30px;
            }

            .info-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
            }

            .info-section h4 {
                margin: 0 0 16px 0;
                font-size: 16px;
                font-weight: 600;
                color: #333;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .info-item {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 12px;
                padding-bottom: 8px;
                border-bottom: 1px solid #e9ecef;
            }

            .info-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
            }

            .info-label {
                font-weight: 500;
                color: #666;
                margin-right: 16px;
                flex-shrink: 0;
                min-width: 120px;
            }

            .info-value {
                color: #333;
                word-break: break-word;
                text-align: right;
                flex: 1;
            }

            .info-value.empty {
                color: #999;
                font-style: italic;
            }

            /* Form styles */
            .form-input {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                transition: border-color 0.3s ease;
                background-color: white;
            }

            .form-input:focus {
                outline: none;
                border-color: #1976d2;
                box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.1);
            }

            .form-input:disabled {
                background-color: #f8f9fa;
                color: #666;
            }

            .form-select {
                width: 100%;
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                transition: border-color 0.3s ease;
                background-color: white;
            }

            .form-select:focus {
                outline: none;
                border-color: #1976d2;
                box-shadow: 0 0 0 2px rgba(25, 118, 210, 0.1);
            }

            .form-select:disabled {
                background-color: #f8f9fa;
                color: #666;
            }

            .form-buttons {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 30px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }

            .btn-primary {
                background: #1976d2;
                color: white;
            }

            .btn-primary:hover {
                background: #1565c0;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
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

            .notification.success {
                background-color: #28a745;
            }

            .notification.error {
                background-color: #dc3545;
            }

            .notification.hide {
                opacity: 0;
                visibility: hidden;
                transition: opacity 0.5s ease;
            }

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

            .full-width {
                grid-column: 1 / -1;
            }

            .branch-count {
                background: #e8f5e8;
                color: #2d5a2d;
                padding: 2px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }

            .service-package {
                background: white;
                color: black;
                padding: 4px 12px;
                border-radius: 16px;
                border: 1px solid black;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .expiry-date {
                font-weight: 600;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 13px;
            }

            .expiry-warning {
                background: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }

            .expiry-danger {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f1b0b7;
            }

            .expiry-safe {
                background: #d4edda;
                color: #155724;
                border: 1px solid #b8dabc;
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                }

                .info-grid {
                    grid-template-columns: 1fr;
                }

                .profile-avatar {
                    flex-direction: column;
                    text-align: center;
                }

                .avatar-image {
                    margin-right: 0;
                    margin-bottom: 16px;
                }

                .form-buttons {
                    flex-direction: column;
                }
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
                animation: fadeOut 0.5s ease-in-out 4.5s forwards;
            }

            .flash-message.success {
                background-color: #4CAF50; /* xanh thành công */
            }

            .flash-message.error {
                background-color: #f44336; /* đỏ lỗi */
            }

            @keyframes fadeOut {
                to {
                    opacity: 0;
                    transform: translateY(-20px);
                    visibility: hidden;
                }
            }
        </style>
    </head>
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

                    <a href="wh-import" class="nav-item">
                        <i class="fa-solid fa-download"></i>
                        Nhập hàng
                    </a>

                    <a href="" class="nav-item">
                        <i class="fa-solid fa-upload"></i>
                        Xuất hàng
                    </a>

                    <a href="" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Tạo thông báo
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

        <!-- Main Content -->
        <main class="main-content">
            <%
                String updateStatus = request.getParameter("update");
                if ("success".equals(updateStatus)) {
            %>
            <div id="flash-message" class="flash-message success">
                Cập nhật thành công!
            </div>
            <%
                } else if ("error".equals(updateStatus)) {
            %>
            <div id="flash-message" class="flash-message error">
                Cập nhật thất bại. Vui lòng thử lại.
            </div>
            <%
                }
            %>

            <div class="container">
                <!-- Left Sidebar -->
                <div class="sidebar">
                    <h3>Cá nhân</h3>
                    <ul class="sidebar-menu">
                        <li><a href="staff-information"  class="active"><i class="fas fa-info-circle"></i> Thông tin cá nhân</a></li>
                        <li><a href="staff-change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                    </ul>
                </div>

                <!-- Profile Container -->
                <div class="profile-container">
                    <div class="profile-header">
                        <div class="profile-header-left">
                            <i class="fas fa-info-circle"></i>
                            <h2>Thông tin cá nhân</h2>
                        </div>
                    </div>

                    <div class="profile-content">
                        <form id="profileForm" action="staff-information-update" method="POST">
                            <!-- User Avatar and Basic Info -->
                            <div class="profile-avatar">
                                <div class="avatar-info">
                                    <h3>${user.fullName}</h3>
                                    <span class="user-role">
                                        Quản lý kho tổng
                                    </span>
                                </div>
                            </div>

                            <!-- Information Grid -->
                            <div class="info-grid">
                                <!-- Personal Information -->
                                <div class="info-section">
                                    <h4><i class="fas fa-id-card"></i> Thông tin cá nhân</h4>

                                    <div class="info-item">
                                        <span class="info-label">Mã người dùng:</span>
                                        <span class="info-value">#${user.userID}</span>
                                        <input type="number" name="userId" class="form-input" 
                                               value="${user.userID}" hidden="">
                                    </div>

                                    <div class="info-item">
                                        <span class="info-label">Họ và tên:</span>
                                        <div class="info-value">
                                            <input type="text" name="fullName" class="form-input" 
                                                   value="${user.fullName}" required>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <span class="info-label">Giới tính:</span>
                                        <div class="info-value">
                                            <select name="gender" class="form-select">
                                                <option value="">Chọn giới tính</option>
                                                <option value="1" ${user.gender == '1' ? 'selected' : ''}>Nam</option>
                                                <option value="0" ${user.gender == '0' ? 'selected' : ''}>Nữ</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <span class="info-label">Ngày sinh:</span>
                                        <div class="info-value">
                                            <input type="date" name="dob" class="form-input" 
                                                   value="${user.dob}">
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <span class="info-label">CCCD/Hộ chiếu:</span>
                                        <div class="info-value">
                                            <input type="text" name="identificationID" class="form-input" 
                                                   value="${user.identificationID}" maxlength="20">
                                        </div>
                                    </div>
                                </div>

                                <!-- Contact Information -->
                                <div class="info-section">
                                    <h4><i class="fas fa-address-book"></i> Thông tin liên hệ</h4>

                                    <div class="info-item">
                                        <span class="info-label">Email:</span>
                                        <div class="info-value">
                                            <input type="email" name="email" class="form-input" 
                                                   value="${user.email}" required>
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <span class="info-label">Số điện thoại:</span>
                                        <div class="info-value">
                                            <input type="tel" name="phone" class="form-input" 
                                                   value="${user.phone}" pattern="[0-9]{10,11}">
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <span class="info-label">Địa chỉ:</span>
                                        <div class="info-value">
                                            <input type="text" name="address" class="form-input" 
                                                   value="${user.address}">
                                        </div>
                                    </div>

                                </div>

                                <!-- Store Chain Information -->
                                <div class="info-section">
                                    <h4><i class="fas fa-store"></i> Thông tin chuỗi cửa hàng</h4>

                                    <div class="info-item">
                                        <span class="info-label">Tên cửa hàng:</span>
                                        <div class="info-value">
                                            <input type="text" name="shopName" class="form-input" 
                                                   value="${shop}" readonly="">
                                        </div>
                                    </div>

                                    <div class="info-item">
                                        <span class="info-label">Kho tổng đang công tác:</span>
                                        <span class="info-value">
                                            <span class="branch-count">${wh.wareHouseName}</span>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <!-- Form Buttons -->
                            <div class="form-buttons">
                                <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                    <i class="fas fa-undo"></i>
                                    Hủy bỏ
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save"></i>
                                    Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <!-- Notifications -->
        <c:if test="${not empty success}">
            <div class="notification success" id="notification">${success}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="notification error" id="notification">${error}</div>
        </c:if>

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
            // Auto-hide notifications
            const notification = document.getElementById('notification');
            if (notification) {
            setTimeout(() => {
            notification.classList.add('hide');
            }, 4000);
            }

            // Form handling functions
            function submitForm() {
            document.getElementById('profileForm').submit();
            }

            function resetForm() {
            if (confirm('Bạn có chắc chắn muốn hủy bỏ các thay đổi?')) {
            document.getElementById('profileForm').reset();
            }
            }

            // Form validation
            document.getElementById('profileForm').addEventListener('submit', function (e) {
            const fullName = document.getElementsByName('fullName')[0].value.trim();
            const email = document.getElementsByName('email')[0].value.trim();
            const shopName = document.getElementsByName('shopName')[0].value.trim();
            if (!fullName || !email || !shopName) {
            e.preventDefault();
            alert('Vui lòng điền đầy đủ thông tin bắt buộc (Họ tên, Email, Tên cửa hàng)');
            return false;
            }

            // Validate email format
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
            e.preventDefault();
            alert('Vui lòng nhập địa chỉ email hợp lệ');
            return false;
            }

            // Validate phone number if provided
            const phone = document.getElementsByName('phone')[0].value.trim();
            if (phone && !/^[0-9]{10,11}$/.test(phone)) {
            e.preventDefault();
            alert('Số điện thoại phải có 10-11 chữ số');
            return false;
            }

            return true;
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
