<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Đăng nhập KiotViet</title>
        <style>
            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;
                padding: 0;
                font-family: Arial, sans-serif;
                background: url("images/background.jpg") no-repeat center center fixed;
                background-size: cover;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                position: relative;
            }
            body::before {
                content: "";
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5); /* Độ mờ */
                z-index: -1;
            }

            .login-box {
                background-color: white;
                width: 400px;
                padding: 30px 40px;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
                text-align: center;
            }

            .login-box img {
                width: 100px;
                margin-bottom: 15px;
            }

            .login-box h2 {
                margin-bottom: 20px;
            }

            .login-box input[type="text"],
            .login-box input[type="password"] {
                width: 100%;
                padding: 12px;
                margin: 8px 0;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 14px;
            }

            .login-box .options {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-top: 10px;
                font-size: 14px;
            }

            .login-box .options a {
                text-decoration: none;
                color: blue;
            }

            .login-box button {
                width: 100%;
                background-color: #007bff;
                color: white;
                border: none;
                padding: 12px;
                border-radius: 8px;
                margin-top: 20px;
                font-size: 16px;
                cursor: pointer;
            }

            .login-box button:hover {
                background-color: #0056b3;
            }
            .footer {
                position: fixed;
                bottom: 10px;
                width: 100%;
                text-align: center;
                font-size: 14px;
                color: #666;
            }
            x

        </style>
    </head>
    <body>
        <div class="login-box">
            <img src="https://go.kiotviet.vn/hubfs/Logo-KiotViet.png" alt="KiotViet Logo">
            <form method="post" action="LoginServlet">
                <input type="text" name="username" placeholder="Tên đăng nhập" required>
                <input type="password" name="password" placeholder="Mật khẩu" required>

                <div class="options">
                    <label><input type="checkbox" name="remember"> Nhớ mật khẩu</label>
                    <a href="#">Quên mật khẩu?</a>
                </div>

                <button type="submit">Đăng Nhập</button>
            </form>
        </div>

        <div class="footer">
            ☎ Hỗ trợ: 0373 137 175 |
            <img src="https://flagcdn.com/w20/vn.png" alt=" VN Flag "> Tiếng Việt
        </div>
    </body>
</html>
