<%-- 
    Document   : forgot-password
    Created on : Jun 13, 2025, 8:53:58 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quên mật khẩu</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/login.css"/>
        <link rel="stylesheet" href="css/forget-password.css"/>
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

        <main class="main-content">
            <div class="login-container">
                <div class="forget-form-container fade-in">
                    <div>
                        <div class="forget-header">
                            <h1>Quên mật khẩu</h1>
                            <p>Hãy chọn vai trò của bạn để tiếp tục</p>
                        </div>

                        <div>
                            <label>Bạn là: </label>
                            <select name="role" id="role">
                                <option disabled selected>Chọn vai trò</option>
                                <option value="1">Chủ chuỗi cửa hàng</option>
                                <option value="2">Nhân viên</option>
                            </select>
                        </div>
                    </div>
                </div>
                <form id="staffForm" action="req-reset-password" method="post" style="display: none;">
                    <div class="form-row">
                        <label>Nhập tên cửa hàng: </label>
                        <input type="text" name="shopName" required="">
                    </div>
                    <div class="form-row">
                        <label>Họ tên:</label>
                        <input type="text" name="fullName" required="">
                    </div>
                    <div class="form-row">
                        <label>Email:</label>
                        <input type="email" name="email" required="">
                    </div>
                    <div class="form-row">
                        <label>Số điện thoại:</label>
                        <input type="text" name="phone" required="">
                    </div>
                    <button type="submit">Gửi yêu cầu đặt lại mật khẩu</button>
                </form>

                <form id="ownerForm" action="forgot-password" method="post" style="display: none;">
                    <label>Email:</label>
                    <input type="email" name="email" required />
                    <button type="submit">Gửi liên kết đặt lại mật khẩu</button>
                </form>
            </div>
        </main>



        <p style="color:red;">${error}</p>
        <p style="color:green;">${message}</p>

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

    </body>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const roleSelect = document.getElementById("role");
            const ownerForm = document.getElementById("ownerForm");
            const staffForm = document.getElementById("staffForm");

            roleSelect.addEventListener("change", function () {
                const selectedRole = roleSelect.value;

                if (selectedRole === "1") {
                    ownerForm.style.display = "block";
                    staffForm.style.display = "none";
                } else if (selectedRole === "2") {
                    ownerForm.style.display = "none";
                    staffForm.style.display = "block";
                } else {
                    ownerForm.style.display = "none";
                    staffForm.style.display = "none";
                }
            });
        });
    </script>

</html>
