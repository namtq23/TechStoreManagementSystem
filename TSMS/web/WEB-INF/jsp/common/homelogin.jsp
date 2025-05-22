<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng Nhập</title>
        <link rel="stylesheet" type="text/css" href="../css/login.css">
    </head>
    <body>
        <div class="login-container">
            <div class="login-box">
                <img src="images/logo.png" alt="KiotViet Logo" class="logo-img">
                <h2 class="logo-text">TSMS</h2>
                <form action="LoginServlet" method="post">
                    <input type="text" name="username" placeholder="Tên đăng nhập" required>
                    <input type="password" name="password" placeholder="Mật khẩu" required>

                    <div class="options">
                        <label><input type="checkbox" name="remember"> Nhớ mật khẩu </label>
                        <a href="#">Quên mật khẩu?</a>
                    </div>

                    <div class="buttons">
                        <button type="submit" class="btn-manage">📊 Quản lý </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="footer">
            <div class="flag-select-container">
                ☎ Hỗ trợ: 1900 6522 |
                <img id="flagIcon" src="image/vn-flag.png" alt="vn-flag" class="flag-icon">
                <select id="languageSelect" onchange="changeLanguage()">
                    <option value="vi" data-flag="vn-flag.png">Tiếng Việt</option>
                    <option value="en" data-flag="us-flag.png">English</option>
                </select>
            </div>
        </div>


    </body>
</html>
