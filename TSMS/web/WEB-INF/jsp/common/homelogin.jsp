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
                <a href="starting" class="logo">
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

                        <div class="form-options">
                            <div class="remember-me">
                                <input type="checkbox" id="remember" name="remember">
                                <label for="remember">Nhớ mật khẩu</label>
                            </div>
                            <a href="forgot-password" class="forgot-password">Quên mật khẩu?</a>
                        </div>

                        <% if(request.getAttribute("error") != null) { %>
                        <div class="error-message">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" title="Error"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 14.667A6.667 6.667 0 1 0 8 1.333a6.667 6.667 0 0 0 0 13.334z" fill="#D00E17" stroke="#D00E17" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M8 4.583a.75.75 0 0 1 .75.75V8a.75.75 0 0 1-1.5 0V5.333a.75.75 0 0 1 .75-.75z" fill="#fff"></path><path d="M8.667 10.667a.667.667 0 1 1-1.334 0 .667.667 0 0 1 1.334 0z" fill="#fff"></path></svg>
                            <span><%= request.getAttribute("error") %></span>
                        </div>
                        <% } %>

                        <button type="submit" class="btn-login" id="loginButton">
                            <i class="fas fa-sign-in-alt"></i>
                            Đăng nhập
                        </button>

                        <div class="register-link">
                            Chưa có tài khoản? <a href="register">Đăng ký ngay</a>
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

