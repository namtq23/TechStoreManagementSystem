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
    </head>
    <body>
        <form action="reset-password" method="post">
            <input type="hidden" name="token" value="${param.token}" />
            <input type="hidden" name="email" value="${param.email}" />
            <label>Mật khẩu mới:</label>
            <input type="password" name="newPassword" required />
            <label>Nhập lại:</label>
            <input type="password" name="confirmPassword" required />
            <button type="submit">Đặt lại mật khẩu</button>
            <p style="color:red;">${error}</p>
            <p style="color:green;">${success}</p>


            <% if (request.getAttribute("success") != null) { %>
            <br/>
            <a href="login"><button type="button">Về trang đăng nhập</button></a>
            <% } %>
        </form>

    </body>
</html>
