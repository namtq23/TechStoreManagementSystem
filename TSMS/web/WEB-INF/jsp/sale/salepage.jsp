<%-- 
        Document   : khachhang
        Created on : May 24, 2025, 10:19:08 AM
        Author     : phung
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Thông tin cá nhân - Sale</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/sale.css">

    </head>
    <body>
        <div class="header-bar">
            <div class="top-bar">
                <span class="logo-small">TSMS</span>
                <div class="header-icons">
                    <select class="lang-select">
                        <option>🌐 Tiếng Việt</option>
                        <option>English</option>
                    </select>
                    <span class="icon">🔔</span>
                    <span class="icon">👤</span>
                </div>
            </div>
            <div class="nav-bar">
                <span class="shop-name">🛒 Tên Shop</span>
                <a href="#">Thông tin cá nhân</a>
                <a href="#">Hàng hóa</a>
                <a href="#">Đơn hàng</a>
            </div>
        </div>

        <div class="container">
            <h2>Thông tin cá nhân</h2>
            <div class="actions">
                <button>+ khách hàng</button>
                <button>File</button>
                <button>lọc tt</button>
            </div>
            <div class="info-box">
                <div class="avatar">AVATAR CÁ NHÂN</div>
                <div class="info-grid">
                    <div><strong>Mã nhân viên:</strong><br>__________</div>
                    <div><strong>Tên nhân viên:</strong><br>__________</div>
                    <div><strong>Ngày sinh:</strong><br>__________</div>
                    <div><strong>Giới tính:</strong><br>__________</div>

                    <div><strong>Số CMND/CCCD:</strong><br>__________</div>
                    <div><strong>Ngày bắt đầu làm việc:</strong><br>__________</div>
                    <div><strong>Chi nhánh trả lương:</strong><br>__________</div>
                    <div><strong>Chi nhánh làm việc:</strong><br>__________</div>

                    <div><strong>Số điện thoại:</strong><br>__________</div>
                    <div><strong>Email:</strong><br>__________</div>
                    <div><strong>Facebook:</strong><br>__________</div>
                    <div><strong>Địa chỉ:</strong><br>__________</div>
                </div>
            </div>
        </div>
    </body>
</html>
