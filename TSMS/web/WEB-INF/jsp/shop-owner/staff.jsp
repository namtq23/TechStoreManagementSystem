<%-- 
    Document   : staff
    Created on : Jun 14, 2025, 10:25:30 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/header.css"> 
        <link rel="stylesheet" href="css/so-staff.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <title>JSP Page</title>
    </head>
    <body>
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview"" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="so-overview"" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>
                    <a href="so-products" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>
                    <a href="so-orders" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Giao dịch
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-handshake"></i>
                        Đối tác
                    </a>
                    <a href="so-staff" class="nav-item">
                        <i class="fas fa-users"></i>
                        Nhân viên
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-wallet"></i>
                        Sổ quỹ
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-chart-bar"></i>
                        Báo cáo
                    </a>
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

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <!--Product Type Filter--> 
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Trạng thái nhân viên</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <form action="action">
                            <label class="checkbox-item">
                                <input type="radio" id="active" name="employeeStatus" value="active" checked="">
                                <span for="active">Đang làm việc</span><br>
                            </label>
                            <label class="checkbox-item">
                                <input type="radio" id="inactive" name="employeeStatus" value="inactive">
                                <span for="inactive">Nghỉ việc</span><br>
                            </label>
                        </form>
                    </div>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Nhân viên</h1>
                    <div class="header-actions">
                        <div class="search-container">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Theo mã, tên hàng" class="search-input">
                            <i class="fas fa-chevron-down"></i>
                        </div>
                        <button class="btn btn-success">
                            <i class="fas fa-plus"></i>
                            Thêm mới
                            <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                </div>

                <!-- Products Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>Mã nhân viên</th>
                                <th>Tên nhân viên</th>
                                <th>Chức danh</th>
                                <th>Số điện thoại</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="">
                                <td>BM01</td>
                                <td>Nguyen Van Quan Ly</td>
                                <td>Quản lý chi nhánh</td>
                                <td>0912377614</td>
                                <td>Đang làm</td>
                            </tr>
                            <tr class="">
                                <td>SA01</td>
                                <td>Nguyen Van Sale</td>
                                <td>Sale</td>
                                <td>0912377614</td>
                                <td>Đang làm</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị 1 - 15 / Tổng số 30 nhân viên
                    </div>
                    <div class="pagination">
                        <button class="page-btn" disabled>
                            <i class="fas fa-angle-double-left"></i>
                        </button>
                        <button class="page-btn" disabled>
                            <i class="fas fa-angle-left"></i>
                        </button>
                        <button class="page-btn active">1</button>
                        <button class="page-btn">2</button>
                        <button class="page-btn">
                            <i class="fas fa-angle-right"></i>
                        </button>
                        <button class="page-btn">
                            <i class="fas fa-angle-double-right"></i>
                        </button>
                    </div>
                </div>
            </main>
        </div>

        <!-- Support Chat Button -->
        <div class="support-chat">
            <i class="fas fa-headset"></i>
            <span>Hỗ trợ:1900 9999</span>
        </div>

        <div class="notification" id="notification">
            <span style="color:red;">${error}</span>
            <span style="color:green;">${success}</span>
        </div>

        <!-- Overlay làm mờ nền -->
        <div id="overlay" class="overlay hidden"></div>

        <!-- Form tạo nhân viên -->
        <div class="create-staff hidden">
            <h2>Tạo nhân viên mới</h2>
            <form id="createStaff" action="so-staff" method="post">
                <!-- Form nhập thông tin khách hàng -->
                <div class="staff-info-form">
                    <div class="form-row">
                        <label>Họ tên:</label>
                        <input type="text" name="fullName" required="">
                    </div>
                    <div class="form-row">
                        <label>Số điện thoại:</label>
                        <input type="text" name="phone" required="">
                    </div>
                    <div class="form-row">
                        <label>Giới tính:</label>
                        <select name="gender">
                            <option value="1">Nam</option>
                            <option value="0">Nữ</option>
                        </select>
                    </div>
                    <div class="form-row">
                        <label>Ngày sinh:</label>
                        <input id="dob" name="dob" type="text" placeholder="dd/mm/yyyy">
                    </div>
                    <div class="form-row">
                        <label>Địa chỉ:</label>
                        <input type="text" name="address">
                    </div>
                    <div class="form-row">
                        <label>Email:</label>
                        <input type="email" name="email" required="">
                    </div>
                    <div class="form-row">
                        <label>Mật khẩu: </label>
                        <input type="password" name="password" required="">
                    </div>
                    <div class="form-row">
                        <label>Nhập lại mật khẩu: </label>
                        <input type="password" name="confirmPassword" required="">
                    </div>
                    <div class="form-row">
                        <label>Chức vụ:</label>
                        <select name="role" id="role">
                            <option disabled selected>Chọn vai trò</option>
                            <option value="1">Quản lý chi nhánh</option>
                            <option value="2">Nhân viên bán hàng</option>
                            <option value="3">Quản lý kho</option>
                        </select>
                    </div>

                    <!-- Chi nhánh -->
                    <div class="form-row" id="branchDiv">
                        <label>Chi nhánh:</label>
                        <select name="branch" id="branch">
                            <c:forEach var="branch" items="${branches}">
                                <option value="${branch.branchId}">${branch.branchName}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Kho tổng -->
                    <div class="form-row" id="whDiv">
                        <label>Chọn kho tổng:</label>
                        <select name="wh" id="wh">
                            <c:forEach var="wh" items="${whs}">
                                <option value="${wh.branchId}">${wh.branchName}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <!-- Nút thanh toán và đóng -->
                <div class="form-actions">
                    <button type="submit" id="processPayment" class="btn-primary">
                        <i class="fas fa-credit-card"></i> Tạo
                    </button>
                    <button type="button" id="closeOrderDetail" class="btn-secondary">
                        <i class="fas fa-times"></i> Đóng
                    </button>
                </div>
            </form>

        </div>
    </body>
    <script>
        const toggle = document.getElementById("dropdownToggle");
        const menu = document.getElementById("dropdownMenu");

        toggle.addEventListener("click", function (e) {
            e.preventDefault();
            menu.style.display = menu.style.display === "block" ? "none" : "block";
        });

        // Đóng dropdown nếu click ra ngoài
        document.addEventListener("click", function (e) {
            if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                menu.style.display = "none";
            }
        });

        document.querySelector('.btn-success').addEventListener('click', () => {
            document.querySelector('.create-staff').classList.remove('hidden');
            document.querySelector('#overlay').classList.remove('hidden');
        });

        document.querySelector('#closeOrderDetail').addEventListener('click', () => {
            document.querySelector('.create-staff').classList.add('hidden');
            document.querySelector('#overlay').classList.add('hidden');
        });


        document.querySelector(".overlay").addEventListener("click", () => {
            document.querySelector(".create-staff").classList.add("hidden");
            document.querySelector(".overlay").classList.add("hidden");
        });

        flatpickr("#dob", {
            dateFormat: "d/m/Y",
            altInput: true,
            altFormat: "d/m/Y",
            defaultDate: "today"
        });
    </script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const roleSelect = document.getElementById("role");
            const branchDiv = document.getElementById("branchDiv");
            const whDiv = document.getElementById("whDiv");

            function updateVisibility() {
                const selectedRole = roleSelect.value;

                if (selectedRole === "1" || selectedRole === "2") {
                    // Quản lý chi nhánh hoặc nhân viên bán hàng
                    branchDiv.style.display = "flex";
                    whDiv.style.display = "none";
                } else if (selectedRole === "3") {
                    // Quản lý kho
                    branchDiv.style.display = "none";
                    whDiv.style.display = "flex";
                } else {
                    // Mặc định ẩn cả 2
                    branchDiv.style.display = "none";
                    whDiv.style.display = "none";
                }
            }

            // Gọi ngay lúc đầu để ẩn đúng nếu có giá trị mặc định
            updateVisibility();

            // Gọi mỗi khi thay đổi vai trò
            roleSelect.addEventListener("change", updateVisibility);
        });
    </script>

    <script>
        const noti = document.getElementById("notification");
        console.log(noti);
        if (noti && noti.textContent.trim() !== "") {
            console.log("hello");
            setTimeout(() => {
                noti.classList.add("hide");
            }, 4000);
        }
    </script>



</html>
