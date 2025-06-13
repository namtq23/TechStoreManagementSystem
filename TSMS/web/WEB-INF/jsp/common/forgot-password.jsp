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
        <title>JSP Page</title>
    </head>
    <body>
        <form action="forgot-password" method="post">
            <label>Email:</label>
            <input type="email" name="email" required />
            <button type="submit">Gửi liên kết đặt lại mật khẩu</button>
        </form>
        <p style="color:red;">${error}</p>
        <p style="color:green;">${message}</p>

    </body>
</html>
