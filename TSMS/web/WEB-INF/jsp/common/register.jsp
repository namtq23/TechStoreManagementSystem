<%-- 
    Document   : register
    Created on : May 25, 2025, 8:14:03 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng Ký</title>
        <link rel="stylesheet" type="text/css" href="css/register.css">
    </head>
    <body>
        <div class="register-container">
            <div class="register-box">
                <h2 class="logo-text">TSMS</h2>
                <p class="subtitle">Tạo Cửa Hàng</p>
                <form action="register" method="post">
                    <div class="form-row">
                        <input type="text" name="fullname" placeholder="Họ và tên" required>
                    </div>

                    <div class="form-row">
                        <input type="text" name="shopname" placeholder="Tên cửa hàng" required>
                    </div>

                    <div class="form-row">
                        <input type="email" name="email" placeholder="Email" required>
                    </div>

                    <div class="form-row">
                        <input type="password" name="password" placeholder="Mật khẩu" required>
                    </div>

                    <div class="form-row">
                        <input type="password" name="confirmpassword" placeholder="Xác nhận mật khẩu" required>
                    </div>

                    <% if(request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" title="Error"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 14.667A6.667 6.667 0 1 0 8 1.333a6.667 6.667 0 0 0 0 13.334z" fill="#D00E17" stroke="#D00E17" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M8 4.583a.75.75 0 0 1 .75.75V8a.75.75 0 0 1-1.5 0V5.333a.75.75 0 0 1 .75-.75z" fill="#fff"></path><path d="M8.667 10.667a.667.667 0 1 1-1.334 0 .667.667 0 0 1 1.334 0z" fill="#fff"></path></svg>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                    <% } %>

                    <div class="checkbox-container">
                        <label class="checkbox-label">
                            <input type="checkbox" name="agree" required>
                            <span class="checkmark"></span>
                            Tôi đồng ý với <a href="#" class="terms-link">Điều khoản dịch vụ</a> và <a href="#" class="terms-link">Chính sách bảo mật</a>
                        </label>
                    </div>

                    <div class="buttons">
                        <button type="submit" class="btn-register">Tạo Cửa Hàng</button>
                        <div class="login-link">
                            Đã có cửa hàng? <a href="login">Đăng nhập</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Password confirmation validation
            document.querySelector('form').addEventListener('submit', function (e) {
                const password = document.querySelector('input[name="password"]').value;
                const confirmPassword = document.querySelector('input[name="confirmpassword"]').value;

                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match!');
                    return false;
                }
            });

            // Real-time password match indicator
            const passwordInput = document.querySelector('input[name="password"]');
            const confirmPasswordInput = document.querySelector('input[name="confirmpassword"]');

            function checkPasswordMatch() {
                if (confirmPasswordInput.value === '') {
                    confirmPasswordInput.style.borderColor = '#e1e8ed';
                    return;
                }

                if (passwordInput.value === confirmPasswordInput.value) {
                    confirmPasswordInput.style.borderColor = '#28a745';
                } else {
                    confirmPasswordInput.style.borderColor = '#dc3545';
                }
            }

            confirmPasswordInput.addEventListener('input', checkPasswordMatch);
            passwordInput.addEventListener('input', checkPasswordMatch);
        </script>
    </body>
</html>
