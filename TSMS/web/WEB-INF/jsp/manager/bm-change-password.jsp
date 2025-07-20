<%-- 
    Document   : bm-change-password
    Created on : Jul 5, 2025, 11:28:33 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đổi mật khẩu - TSMS</title>
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

            .change-password-container {
                flex: 1;
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                overflow: hidden;
            }

            .change-password-header {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .change-password-header h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 600;
                color: #333;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .change-password-header i {
                color: #1976d2;
            }

            .change-password-content {
                padding: 40px;
                display: flex;
                justify-content: center;
            }

            .password-form {
                width: 100%;
                max-width: 500px;
            }

            .security-notice {
                background: #e3f2fd;
                border: 1px solid #bbdefb;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 30px;
                display: flex;
                align-items: flex-start;
                gap: 12px;
            }

            .security-notice i {
                color: #1976d2;
                font-size: 20px;
                margin-top: 2px;
            }

            .security-notice-content h4 {
                margin: 0 0 8px 0;
                font-size: 16px;
                font-weight: 600;
                color: #1976d2;
            }

            .security-notice-content p {
                margin: 0;
                color: #666;
                font-size: 14px;
                line-height: 1.5;
            }

            .form-group {
                margin-bottom: 24px;
            }

            .form-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #333;
                font-size: 14px;
            }

            .form-label.required::after {
                content: " *";
                color: #dc3545;
            }

            .password-input-wrapper {
                position: relative;
            }

            .form-input {
                width: 100%;
                padding: 12px 16px;
                padding-right: 48px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 16px;
                transition: all 0.3s ease;
                background-color: white;
            }

            .form-input:focus {
                outline: none;
                border-color: #1976d2;
                box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
            }

            .form-input.error {
                border-color: #dc3545;
            }

            .form-input.success {
                border-color: #28a745;
            }

            .password-toggle {
                position: absolute;
                right: 16px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                color: #666;
                cursor: pointer;
                font-size: 16px;
                padding: 0;
                width: 20px;
                height: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .password-toggle:hover {
                color: #1976d2;
            }

            .form-help {
                margin-top: 6px;
                font-size: 12px;
                color: #666;
            }

            .form-error {
                margin-top: 6px;
                font-size: 12px;
                color: #dc3545;
                display: none;
            }

            .form-success {
                margin-top: 6px;
                font-size: 12px;
                color: #28a745;
                display: none;
            }

            .password-strength {
                margin-top: 8px;
            }

            .password-strength-label {
                font-size: 12px;
                color: #666;
                margin-bottom: 4px;
            }

            .password-strength-bar {
                height: 4px;
                background-color: #e9ecef;
                border-radius: 2px;
                overflow: hidden;
            }

            .password-strength-fill {
                height: 100%;
                width: 0%;
                transition: all 0.3s ease;
                border-radius: 2px;
            }

            .password-strength-fill.weak {
                background-color: #dc3545;
                width: 25%;
            }

            .password-strength-fill.medium {
                background-color: #ffc107;
                width: 50%;
            }

            .password-strength-fill.strong {
                background-color: #fd7e14;
                width: 75%;
            }

            .password-strength-fill.very-strong {
                background-color: #28a745;
                width: 100%;
            }

            .password-requirements {
                margin-top: 12px;
                background: #f8f9fa;
                border: 1px solid #e9ecef;
                border-radius: 6px;
                padding: 16px;
            }

            .requirements-title {
                font-size: 13px;
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }

            .requirement-item {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 6px;
                font-size: 12px;
            }

            .requirement-item:last-child {
                margin-bottom: 0;
            }

            .requirement-icon {
                width: 16px;
                height: 16px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 10px;
                color: white;
                background-color: #6c757d;
            }

            .requirement-icon.met {
                background-color: #28a745;
            }

            .requirement-text {
                color: #666;
            }

            .requirement-text.met {
                color: #28a745;
            }

            .form-buttons {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 40px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }

            .btn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .btn-primary {
                background: #1976d2;
                color: white;
            }

            .btn-primary:hover:not(:disabled) {
                background: #1565c0;
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover:not(:disabled) {
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
                animation: slideIn 0.4s ease;
            }

            .notification.success {
                background-color: #28a745;
            }

            .notification.error {
                background-color: #dc3545;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(100%);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                }

                .change-password-content {
                    padding: 20px;
                }

                .form-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    justify-content: center;
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

                    <a href="bm-staff" class="nav-item">
                        <i class="fas fa-users"></i>
                        Nhân viên
                    </a>

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
        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Left Sidebar -->
                <div class="sidebar">
                    <h3>Cá nhân</h3>
                    <ul class="sidebar-menu">
                        <li><a href="staff-information"><i class="fas fa-info-circle"></i> Thông tin cá nhân</a></li>
                        <li><a href="staff-change-password" class="active"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                    </ul>
                </div>

                <!-- Change Password Container -->
                <div class="change-password-container">
                    <div class="change-password-header">
                        <h2>
                            <i class="fas fa-lock"></i>
                            Đổi mật khẩu
                        </h2>
                    </div>

                    <div class="change-password-content">
                        <form id="changePasswordForm" action="staff-change-password" method="post" class="password-form">
                            <!-- Security Notice -->
                            <div class="security-notice">
                                <i class="fas fa-shield-alt"></i>
                                <div class="security-notice-content">
                                    <h4>Bảo mật tài khoản</h4>
                                    <p>Để đảm bảo an toàn cho tài khoản, vui lòng chọn mật khẩu mạnh và không chia sẻ với bất kỳ ai. Mật khẩu mới phải khác với mật khẩu hiện tại.</p>
                                </div>
                            </div>

                            <!-- Current Password -->
                            <div class="form-group">
                                <label for="currentPassword" class="form-label required">Mật khẩu hiện tại</label>
                                <div class="password-input-wrapper">
                                    <input type="password" id="currentPassword" name="currentPassword" class="form-input" required>
                                </div>
                                <div class="form-error" id="currentPasswordError"></div>
                            </div>

                            <!-- New Password -->
                            <div class="form-group">
                                <label for="newPassword" class="form-label required">Mật khẩu mới</label>
                                <div class="password-input-wrapper">
                                    <input type="password" id="newPassword" name="newPassword" class="form-input" required>
                                </div>
                                <div class="form-error" id="newPasswordError"></div>
                            </div>

                            <!-- Confirm Password -->
                            <div class="form-group">
                                <label for="confirmPassword" class="form-label required">Xác nhận mật khẩu mới</label>
                                <div class="password-input-wrapper">
                                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" required>
                                </div>
                                <div class="form-error" id="confirmPasswordError"></div>
                                <div class="form-success" id="confirmPasswordSuccess"></div>
                            </div>

                            <p class="error-message">${error}</p>
                            <p class="success-message">${success}</p>

                            <!-- Form Buttons -->
                            <div class="form-buttons">
                                <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                    <i class="fas fa-undo"></i>
                                    Hủy bỏ
                                </button>
                                <button type="submit" class="btn btn-primary" id="submitBtn">
                                    <i class="fas fa-key"></i>
                                    Đổi mật khẩu
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <script>
            // Form handling functions
            function resetForm() {
                if (confirm('Bạn có chắc chắn muốn đặt lại form?')) {
                    document.getElementById('changePasswordForm').reset();
                }
            }
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
