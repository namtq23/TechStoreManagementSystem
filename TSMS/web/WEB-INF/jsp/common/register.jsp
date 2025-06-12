<%-- 
    Document   : register
    Created on : May 25, 2025, 8:14:03 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Đăng ký Cửa Hàng</title>
        <link rel="stylesheet" href="css/register.css"/>
    </head>
    <body>
        <!-- Left Column - Welcome Section -->
        <div class="welcome-section slide-in-left">
            <div class="welcome-content">
                <h1 class="welcome-title">Chào mừng đến với TSMS!</h1>
                <p class="welcome-description">
                    Đăng ký để truy cập vào hệ thống quản lý bán hàng thông minh TSMS và tối ưu hóa kinh doanh của bạn.
                </p>

                <div class="features">
                    <div class="feature">
                        <div class="feature-icon">
                            <span class="icon-trending"></span>
                        </div>
                        <div class="feature-content">
                            <h3>Báo cáo thời gian thực</h3>
                            <p>Theo dõi doanh thu và hiệu suất kinh doanh mọi lúc mọi nơi với dashboard trực quan</p>
                        </div>
                    </div>

                    <div class="feature">
                        <div class="feature-icon">
                            <span class="icon-smartphone"></span>
                        </div>
                        <div class="feature-content">
                            <h3>Truy cập đa nền tảng</h3>
                            <p>Sử dụng TSMS trên máy tính, tablet và điện thoại di động một cách liền mạch</p>
                        </div>
                    </div>

                    <div class="feature">
                        <div class="feature-icon">
                            <span class="icon-shield"></span>
                        </div>
                        <div class="feature-content">
                            <h3>Bảo mật tuyệt đối</h3>
                            <p>Dữ liệu của bạn được bảo vệ</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column - Registration Form -->
        <div class="form-section">
            <div class="form-container fade-in">
                <!-- Header -->
                <div class="form-header">
                    <div class="logo">
                        <a href="starting" class="logo">
                            <div class="logo-icon">T</div>
                            <span class="logo-text">TSMS</span>
                        </a>
                    </div>
                    <h2 class="form-title">Đăng ký Cửa Hàng</h2>
                    <p class="form-subtitle">Nhập thông tin để tạo tài khoản mới cho cửa hàng của bạn</p>
                </div>

                <!-- Registration Form -->
                <form class="form" action="register" method="post" id="registerForm">
                    <div class="form-group">
                        <label for="fullName" class="form-label">Họ và tên *</label>
                        <input type="text" id="fullName" name="fullName" class="form-input" placeholder="Nhập họ và tên đầy đủ" required>
                    </div>

                    <div class="form-group">
                        <label for="storeName" class="form-label">Tên cửa hàng *</label>
                        <input type="text" id="storeName" name="shopName" class="form-input" placeholder="Nhập tên cửa hàng của bạn" required>
                    </div>

                    <div class="form-group">
                        <label for="email" class="form-label">Email *</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="Nhập địa chỉ email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone" class="form-label">Số điện thoại *</label>
                        <input type="phone" id="phone" name="phone" class="form-input" placeholder="Nhập số điện thoại" required>
                    </div>

                    <div class="form-group">
                        <label for="password" class="form-label">Mật khẩu *</label>
                        <input type="password" id="password" name="password" class="form-input" placeholder="Nhập mật khẩu (tối thiểu 6 ký tự)" required>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu *</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-input" placeholder="Nhập lại mật khẩu" required>
                    </div>

                    <div class="checkbox-group">
                        <input type="checkbox" id="terms" name="terms" class="checkbox" required>
                        <label for="terms" class="checkbox-label">
                            Tôi đồng ý với 
                            <a href="#" onclick="return false;">Điều khoản dịch vụ</a> 
                            và 
                            <a href="#" onclick="return false;">Chính sách bảo mật</a> của TSMS
                        </label>
                    </div>

                    <% if(request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" title="Error"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 14.667A6.667 6.667 0 1 0 8 1.333a6.667 6.667 0 0 0 0 13.334z" fill="#D00E17" stroke="#D00E17" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M8 4.583a.75.75 0 0 1 .75.75V8a.75.75 0 0 1-1.5 0V5.333a.75.75 0 0 1 .75-.75z" fill="#fff"></path><path d="M8.667 10.667a.667.667 0 1 1-1.334 0 .667.667 0 0 1 1.334 0z" fill="#fff"></path></svg>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                    <% } %>
                    
                    <button type="submit" class="submit-button" id="submitBtn">
                        Tạo Cửa Hàng
                    </button>
                </form>

                <!-- Login Link -->
                <div class="login-link">
                    <p>Đã có tài khoản? <a href="login">Đăng nhập ngay</a></p>
                </div>
            </div>
        </div>

        <script>
            document.getElementById('confirmPassword').addEventListener('input', function () {
                const password = document.getElementById('password').value;
                if (this.value && this.value !== password) {
                    showError(this, 'Mật khẩu xác nhận không khớp');
                } else {
                    this.classList.remove('error');
                    this.closest('.form-group').classList.remove('show-error');
                }
            });

            // Animation on load
            document.addEventListener('DOMContentLoaded', function () {
                // Add staggered animation to form elements
                const formElements = document.querySelectorAll('.form-group, .checkbox-group, .submit-button, .login-link');
                formElements.forEach((element, index) => {
                    element.style.opacity = '0';
                    element.style.transform = 'translateY(20px)';
                    element.style.transition = 'all 0.3s ease';

                    setTimeout(() => {
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }, 100 + index * 100);
                });
            });
        </script>
    </body>
</html>
