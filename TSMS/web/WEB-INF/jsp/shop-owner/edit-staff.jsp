<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css"> 
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/so-staff.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <title>Chi tiết nhân viên</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 0;
        }

        .staff-details-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        .staff-details-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 2px solid #2196F3;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        .staff-details-header h2 {
            margin: 0;
            color: #2196F3;
            font-size: 24px;
            font-weight: 600;
        }

        .staff-details {
            display: grid;
            grid-template-columns: repeat/auto-fit, minmax(300px, 1fr);
            gap: 20px;
        }

        .info-card {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
        }

        .info-card h3 {
            margin: 0 0 10px;
            font-size: 18px;
            color: #333;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .info-row label {
            font-weight: 500;
            color: #555;
            width: 40%;
        }

        .info-row span {
            width: 60%;
            color: #222;
        }

        .avatar-container {
            text-align: center;
            margin-bottom: 20px;
        }

        .avatar-container img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #2196F3;
            background-color: #e0e0e0;
        }

        .form-actions {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 20px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c82333;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
        }

        .btn-back {
            background-color: #6c757d;
            color: white;
        }

        .btn-back:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(108, 117, 125, 0.3);
        }

        .notification {
            position: fixed;
            top: 20px;
            right: 20px;
            padding: 15px;
            border-radius: 5px;
            color: white;
            z-index: 1000;
            transition: opacity 0.5s ease;
        }

        .notification.success {
            background-color: #28a745;
        }

        .notification.error {
            background-color: #dc3545;
        }

        .notification.hide {
            opacity: 0;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-container">
            <div class="logo">
                <a href="so-overview" class="logo">
                    <div class="logo-icon">T</div>
                    <span class="logo-text">TSMS</span>
                </a>
            </div>
            <nav class="main-nav">
                <a href="so-overview" class="nav-item">
                    <i class="fas fa-chart-line"></i>
                    Tổng quan
                </a>
                <a href="so-products?page=1" class="nav-item">
                    <i class="fas fa-box"></i>
                    Hàng hóa
                </a>
                <div class="nav-item dropdown">
                    <a href="#" class="dropdown-toggle">
                        <i class="fas fa-exchange-alt"></i>
                        Giao dịch
                        <i class="fas fa-caret-down"></i>
                    </a>
                    <div class="dropdown-menu">
                        <a href="so-orders" class="dropdown-item">Đơn hàng</a>
                        <a href="so-createimport" class="dropdown-item">Tạo đơn nhập hàng</a>
                        <a href="so-ienoti" class="dropdown-item">Thông báo nhập/xuất</a>
                    </div>
                </div>
                <div class="nav-item dropdown">
                    <a href="#" class="dropdown-toggle">
                        <i class="fas fa-handshake"></i>
                        Đối tác
                        <i class="fas fa-caret-down"></i>
                    </a>
                    <div class="dropdown-menu">
                        <a href="so-customer" class="dropdown-item">Khách hàng</a>
                        <a href="so-supplier" class="dropdown-item">Nhà cung cấp</a>
                    </div>
                </div>
                <div class="nav-item dropdown active">
                    <a href="#" class="dropdown-toggle">
                        <i class="fas fa-users"></i>
                        Nhân viên
                        <i class="fas fa-caret-down"></i>
                    </a>
                    <div class="dropdown-menu">
                        <a href="so-staff" class="dropdown-item">Danh sách nhân viên</a>
                        <a href="so-commission" class="dropdown-item">Hoa hồng</a>
                    </div>
                </div>
                <a href="so-promotions" class="nav-item">
                    <i class="fas fa-gift"></i>
                    Khuyến mãi
                </a>
                <div class="nav-item dropdown">
                    <a href="#" class="dropdown-toggle">
                        <i class="fas fa-chart-bar"></i>
                        Báo cáo
                        <i class="fas fa-caret-down"></i>
                    </a>
                    <div class="dropdown-menu">
                        <a href="so-invoices?reportType=income" class="dropdown-item">Doanh Thu thuần</a>
                        <a href="so-invoices?reportType=outcome" class="dropdown-item">Khoảng chi</a>
                    </div>
                </div>
            </nav>
            <div class="header-right">
                <div class="user-dropdown">
                    <a href="#" class="user-icon gradient" id="dropdownToggle">
                        <i class="fas fa-user-circle fa-2x"></i>
                    </a>
                    <div class="dropdown-menu" id="dropdownMenu">
                        <a href="profile" class="dropdown-item">Thông tin chi tiết</a>
                        <a href="logout" class="dropdown-item">Đăng xuất</a>
                    </div>
                </div>      
            </div>
        </div>
    </header>

    <div class="staff-details-container">
        <div class="staff-details-header">
            <h2>Chi tiết nhân viên</h2>
        </div>
        <div class="avatar-container">
            <img src="${staff.avaUrl != null ? staff.avaUrl : 'https://via.placeholder.com/120'}" alt="Avatar">
        </div>
        <div class="staff-details">
            <div class="info-card">
                <h3>Thông tin cá nhân</h3>
                <div class="info-row">
                    <label>Mã nhân viên:</label>
                    <span>${staff.userID}</span>
                </div>
                <div class="info-row">
                    <label>Họ tên:</label>
                    <span>${staff.fullName}</span>
                </div>
                <div class="info-row">
                    <label>Giới tính:</label>
                    <span>${staff.gender == 1 ? 'Nam' : 'Nữ'}</span>
                </div>
                <div class="info-row">
                    <label>Địa chỉ:</label>
                    <span>${staff.address != null ? staff.address : 'Không có'}</span>
                </div>
            </div>
            <div class="info-card">
                <h3>Thông tin liên hệ</h3>
                <div class="info-row">
                    <label>Số điện thoại:</label>
                    <span>${staff.phone}</span>
                </div>
                <div class="info-row">
                    <label>Email:</label>
                    <span>${staff.email}</span>
                </div>
            </div>
            <div class="info-card">
                <h3>Thông tin công việc</h3>
                <div class="info-row">
                    <label>Chức danh:</label>
                    <span>${staff.roleName}</span>
                </div>
                <div class="info-row">
                    <label>Chi nhánh/Kho:</label>
                    <span>${staff.branchName != null ? staff.branchName : (staff.warehouseName != null ? staff.warehouseName : '')}</span>
                </div>
                <div class="info-row">
                    <label>Trạng thái:</label>
                    <span>${staff.isActive == 1 ? 'Đang làm việc' : 'Nghỉ việc'}</span>
                </div>
            </div>
        </div>
        <div class="form-actions">
            <form action="so-staff" method="get" style="display:inline;">
                <input type="hidden" name="action" value="delete"/>
                <input type="hidden" name="userID" value="${staff.userID}"/>
                <button type="submit" class="btn btn-delete" onclick="return confirm('Bạn có chắc muốn sa thải nhân viên này?')">
                    <i class="fas fa-trash"></i> Sa Thải
                </button>
            </form>
            <a href="so-staff" class="btn btn-back">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="notification success" id="notification">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="notification error" id="notification">${error}</div>
    </c:if>

    <script>
        const toggle = document.getElementById("dropdownToggle");
        const menu = document.getElementById("dropdownMenu");

        toggle.addEventListener("click", function (e) {
            e.preventDefault();
            menu.style.display = menu.style.display === "block" ? "none" : "block";
        });

        document.addEventListener("click", function (e) {
            if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                menu.style.display = "none";
            }
        });

        const noti = document.getElementById("notification");
        if (noti && noti.textContent.trim() !== "") {
            setTimeout(() => {
                noti.classList.add("hide");
            }, 4000);
        }
    </script>
</body>
</html>