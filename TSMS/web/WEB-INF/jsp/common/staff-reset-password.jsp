<%-- 
    Document   : reset-password
    Created on : Jun 13, 2025, 8:57:24 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/login.css"/>
        <link rel="stylesheet" href="css/forget-password.css"/>
        <style>
            .reset-password-form {
                width: 100%;
                max-width: 400px;
                margin: 100px auto;
                padding: 30px 40px;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
                font-family: 'Segoe UI', sans-serif;
            }

            .reset-password-form h2 {
                text-align: center;
                margin-bottom: 20px;
                color: #0077cc;
            }

            .reset-password-form label {
                display: block;
                margin-top: 15px;
                font-weight: 600;
                color: #333;
            }

            .reset-password-form input[type="password"] {
                width: 100%;
                padding: 10px 12px;
                margin-top: 5px;
                border: 1px solid #ccc;
                border-radius: 6px;
                transition: border-color 0.3s ease;
            }

            .reset-password-form input[type="password"]:focus {
                border-color: #0077cc;
                outline: none;
            }

            .reset-password-form button[type="submit"] {
                margin-top: 20px;
                width: 100%;
                padding: 12px;
                background-color: #0077cc;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }

            .reset-password-form button[type="submit"]:hover {
                background-color: #005fa3;
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

            .back-to-login {
                display: block;
                text-align: center;
                margin-top: 20px;
                color: #0077cc;
                text-decoration: none;
                font-weight: 600;
            }

            .back-to-login:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header" id="header">
            <div class="header-content">
                <a href="login" class="logo">
                    <div class="logo-icon">T</div>
                    <span class="logo-text">TSMS</span>
                </a>
            </div>
        </header>

        <main class="main-content">
            <form class="reset-password-form" action="staff-reset-password" method="post">
                <input type="hidden" name="token" value="${param.token}" />
                <input type="hidden" name="email" value="${param.email}" />
                <input type="hidden" name="db" value="${param.db}" />

                <h2>Đặt lại mật khẩu</h2>

                <label for="newPassword">Mật khẩu mới:</label>
                <input type="password" name="newPassword" id="newPassword" required />

                <label for="confirmPassword">Nhập lại mật khẩu:</label>
                <input type="password" name="confirmPassword" id="confirmPassword" required />

                <button type="submit">Đặt lại mật khẩu</button>

                <p class="error-message">${error}</p>
                <p class="success-message">${success}</p>

                <% if (request.getAttribute("success") != null) { %>
                <a href="login" class="back-to-login">Về trang đăng nhập</a>
                <% } %>
            </form>

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
    </body>
</html>
