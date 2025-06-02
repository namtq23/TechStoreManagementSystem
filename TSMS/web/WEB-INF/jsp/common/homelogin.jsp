<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng Nhập</title>
        <link rel="stylesheet" type="text/css" href="css/login.css">
    </head>
    <body>
        <div class="login-container">
            <div class="login-box">
                <!--                <img src="images/logo.png" alt="KiotViet Logo" class="logo-img">-->
                <h2 class="logo-text">TSMS</h2>
                <form action="login" method="post">
                    <input type="text" name="username" placeholder="Email" required>
                    <input type="password" name="password" placeholder="Mật khẩu" required>

                    <% if(request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" title="Error"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 14.667A6.667 6.667 0 1 0 8 1.333a6.667 6.667 0 0 0 0 13.334z" fill="#D00E17" stroke="#D00E17" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M8 4.583a.75.75 0 0 1 .75.75V8a.75.75 0 0 1-1.5 0V5.333a.75.75 0 0 1 .75-.75z" fill="#fff"></path><path d="M8.667 10.667a.667.667 0 1 1-1.334 0 .667.667 0 0 1 1.334 0z" fill="#fff"></path></svg>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                    <% } %>

                    <div class="options">
                        <label><input type="checkbox" name="remember"> Ghi nhớ đăng nhập </label>
                        <a href="#">Quên mật khẩu?</a>
                    </div>

                    <div class="buttons">
                        <button type="submit" class="btn-manage">Bắt đầu</button>
                        <a href="register">Tạo shop mới!</a>
                    </div>

                </form>
            </div>
        </div>


    </body>
</html>
