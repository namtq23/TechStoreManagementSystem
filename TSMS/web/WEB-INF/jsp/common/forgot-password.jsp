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
        <div>
            <label>Bạn là: </label>
            <select name="role" id="role">
                <option disabled selected>Chọn vai trò</option>
                <option value="1">Chủ chuỗi cửa hàng</option>
                <option value="2">Nhân viên</option>
            </select>
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



        <p style="color:red;">${error}</p>
        <p style="color:green;">${message}</p>

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
