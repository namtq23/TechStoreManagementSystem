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
                    <input type="text" name="username" placeholder="Your mail" required>
                    <input type="password" name="password" placeholder="Your password" required>

                    <div class="options">
                        <label><input type="checkbox" name="remember"> Remember </label>
                        <a href="#">Forget your password?</a>
                    </div>

                    <div class="buttons">
                        <button type="submit" class="btn-manage">Begin</button>
                        <a href="register">Create your shop here!</a>
                    </div>
                    
                </form>
            </div>
        </div>


    </body>
</html>
