<%-- 
    Document   : adhomepage
    Created on : May 26, 2025, 4:21:02 PM
    Author     : admin
--%>


<%@ page import="java.util.*, model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
<<<<<<< HEAD
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
=======
        <title>Trang Admin - TSMS</title>
        <link rel="stylesheet" type="text/css" href="css/sa-home.css">
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <div class="header">
                <div class="logo">
                    <a href="sa-home" style="text-decoration: none; color: #4285f4">TechStore Management System</a>
                </div>
                <!--<div class="user-avatar">👤</div>-->
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <button class="sidebar-item active">Quản lý người dùng</button>
                <button class="sidebar-item">Thông kê người dùng</button>
                <a href="sa-logout" style="text-decoration: none"><button class="sidebar-item" style="color: red">Đăng xuất</button></a>

            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="page-header">
                    <h1 class="page-title">Tài khoản</h1>
                    <div class="controls">
                        <div class="search-box">
                            <input type="text" class="search-input" placeholder="Tìm kiếm tài khoản...">
                        </div>
                        <select class="filter-select">
                            <option>Vai trò</option>
                            <option>Chủ Cửa Hàng</option>
                            <option>Quản Lý Chi Nhánh</option>
                            <option>Nhân viên bán hàng</option>
                        </select>
                        <select class="filter-select">
                            <option>Tất cả</option>
                            <option>Active</option>
                            <option>Inactive</option>
                        </select>

                        <button class="add-btn">Lọc</button>
                    </div>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th 
                                    class="id-column" style="
                                    padding-left: 24px;"
                                    >ID
                                </th>
                                <th class="name-column">Họ tên</th>
                                <th class="role-column">Vai trò</th>
                                <th class="shop-column">Cửa hàng</th>
                                <th class="status-column">Trạng thái</th>
                                <th class="action-column"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
                            for (UserDTO user : users) {
                                String roleName = "";
                                switch (user.getRole()) {
                                    case 1:
                                        roleName = "Chủ cửa hàng";
                                        break;
                                    case 2:
                                        roleName = "Quản lý chi nhánh";
                                        break;
                                    case 3:
                                        roleName = "Nhân viên bán hàng";
                                        break;
                                }

                                boolean isActive = user.getIsActive() == 1;
                                String statusText = isActive ? "Hoạt động" : "Không hoạt động";
                                String statusClass = isActive ? "status-active" : "status-inactive";
                                String buttonLabel = isActive ? "Chặn" : "Bỏ chặn";
                            %>
                            <tr>
                                <td class="id-column"><%= user.getAccountId() %></td>
                                <td class="name-column"><%= user.getFullName() %></td>
                                <td class="role-column"><%= roleName %></td>
                                <td class="shop-column"><%= user.getShopName() %></td>
                                <td class="status-column">
                                    <span class="<%= statusClass %>"><%= statusText %></span>
                                </td>
                                <td class="action-column">
                                    <form action="toggleUserStatus" method="post" style="display:inline;">
                                        <input type="hidden" name="email" value="<%= user.getEmail() %>"/>
                                        <input type="hidden" name="isActive" value="<%= user.getIsActive() %>"/>
                                        <button type="submit" class="edit-btn"><%= buttonLabel %></button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            // Sidebar navigation
            document.querySelectorAll('.sidebar-item').forEach(item => {
                item.addEventListener('click', function () {
                    document.querySelectorAll('.sidebar-item').forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Search functionality
            document.querySelector('.search-input').addEventListener('input', function () {
                const searchTerm = this.value.toLowerCase();
                const rows = document.querySelectorAll('.table tbody tr');

                rows.forEach(row => {
                    const name = row.querySelector('.name-column').textContent.toLowerCase();
                    if (name.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });

            // Filter functionality
            document.querySelectorAll('.filter-select').forEach(select => {
                select.addEventListener('change', function () {
                    console.log('Filter changed:', this.value);
                    // Implement filtering logic here
>>>>>>> develop
                });
            });
        </script>
    </body>
</html>
<<<<<<< HEAD

=======
>>>>>>> develop
