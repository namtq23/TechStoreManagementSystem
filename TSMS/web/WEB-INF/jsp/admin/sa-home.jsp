<%-- 
    Document   : adhomepage
    Created on : May 26, 2025, 4:21:02 PM
    Author     : admin
--%>

<%@ page import="java.util.*, model.UserDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - TSMS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/login.css"/>
    </head>
    <body>
        <!-- Header -->
        <header class="header" id="header">
            <div class="header-content">
                <a href="index.jsp" class="logo">
                    <div class="logo-icon">T</div>
                    <span class="logo-text">TSMS</span>
                </a>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="login-container">
                <div class="login-visual slide-in-left">
                    <div class="login-visual-content">
                        <h2>Chào mừng trở lại!</h2>
                        <p>Đăng nhập để truy cập vào hệ thống quản lý bán hàng thông minh TSMS và tối ưu hóa kinh doanh của bạn.</p>

                        <ul class="login-features">
                            <li>
                                <div class="feature-icon">
                                    <i class="fas fa-chart-line"></i>
                                </div>
                                <div>
                                    <strong>Báo cáo thời gian thực</strong>
                                    <p>Theo dõi doanh thu và hiệu suất kinh doanh mọi lúc mọi nơi</p>
                                </div>
                            </li>
                            <li>
                                <div class="feature-icon">
                                    <i class="fas fa-mobile-alt"></i>
                                </div>
                                <div>
                                    <strong>Truy cập đa nền tảng</strong>
                                    <p>Sử dụng TSMS trên máy tính, tablet và điện thoại di động</p>
                                </div>
                            </li>
                            <li>
                                <div class="feature-icon">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div>
                                    <strong>Bảo mật tuyệt đối</strong>
                                    <p>Dữ liệu của bạn được bảo vệ</p>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="login-form-container fade-in">
                    <div class="login-header">
                        <h1>Đăng nhập</h1>
                        <p>Nhập thông tin đăng nhập của bạn để tiếp tục</p>
                    </div>

                    <form class="login-form" action="login" method="post" id="loginForm">

                        <div class="form-group">
                            <label for="shopname">Tên cửa hàng</label>
                            <div class="input-wrapper">
                                <i class="fas fa-store input-icon"></i>
                                <input type="text" id="shopname" name="shopname" class="form-control" placeholder="Nhập tên cửa hàng" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <div class="input-wrapper">
                                <i class="fas fa-envelope input-icon"></i>
                                <input type="text" id="email" name="email" class="form-control" placeholder="Nhập email" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <div class="input-wrapper">
                                <i class="fas fa-lock input-icon"></i>
                                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
                                <button type="button" class="toggle-password" onclick="togglePassword()">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="role">Vai trò</label>
                            <div class="input-wrapper">
                                <i class="fas fa-user input-icon"></i>
                                <select name="role" class="form-control" required>
                                    <option value="" disabled selected>Chọn vai trò</option>
                                    <option value="so">Chủ chuỗi cửa hàng</option>
                                    <option value="staff">Nhân viên</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-options">
                            <div class="remember-me">
                                <input type="checkbox" id="remember" name="remember">
                                <label for="remember">Nhớ mật khẩu</label>
                            </div>
                            <a href="forgot-password.jsp" class="forgot-password">Quên mật khẩu?</a>
                        </div>

                        <button type="submit" class="btn-login" id="loginButton">
                            <i class="fas fa-sign-in-alt"></i>
                            Đăng nhập
                        </button>

                        <div class="register-link">
                            Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
                        </div>
                    </form>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-copyright">
                    © 2024 TSMS. Tất cả quyền được bảo lưu.
                </div>
                <div class="footer-links">
                    <a href="#">Điều khoản sử dụng</a>
                    <a href="#">Chính sách bảo mật</a>
                    <a href="#">Trợ giúp</a>
                    <a href="#">Liên hệ</a>
                </div>
            </div>
        </footer>

        <script>
            // Toggle password visibility
            function togglePassword() {
                const passwordInput = document.getElementById('password');
                const toggleIcon = document.querySelector('.toggle-password i');

                if (passwordInput.type === 'password') {
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }

            // Form validation
            document.getElementById('loginForm').addEventListener('submit', function (e) {
                e.preventDefault();

                let isValid = true;
                const email = document.getElementById('email');
                const password = document.getElementById('password');

                // Reset previous errors
                email.parentElement.parentElement.classList.remove('error');
                password.parentElement.parentElement.classList.remove('error');

                // Validate email/username
                if (!email.value.trim()) {
                    email.parentElement.parentElement.classList.add('error');
                    isValid = false;
                }

                // Validate password
                if (!password.value.trim()) {
                    password.parentElement.parentElement.classList.add('error');
                    isValid = false;
                }

                if (isValid) {
                    // Show loading state
                    const loginButton = document.getElementById('loginButton');
                    const originalText = loginButton.innerHTML;
                    loginButton.innerHTML = '<div class="loading"></div>';
                    loginButton.disabled = true;

                    // Simulate API call
                    setTimeout(() => {
                        // For demo purposes, redirect to dashboard
                        window.location.href = 'dashboard.jsp';

                        // In case the redirect doesn't happen (for demo)
                        loginButton.innerHTML = originalText;
                        loginButton.disabled = false;
                    }, 2000);
                }
            });

            // Social login handlers
            document.querySelector('.social-btn.facebook').addEventListener('click', function () {
                alert('Đăng nhập bằng Facebook');
                // Implement Facebook login
            });

            document.querySelector('.social-btn.google').addEventListener('click', function () {
                alert('Đăng nhập bằng Google');
                // Implement Google login
            });

            // Animation delay for staggered effect
            document.addEventListener('DOMContentLoaded', function () {
                const fadeElements = document.querySelectorAll('.fade-in');
                fadeElements.forEach((element, index) => {
                    element.style.animationDelay = `${index * 0.2}s`;
                });
            });
        </script>
    </body>
</html>

