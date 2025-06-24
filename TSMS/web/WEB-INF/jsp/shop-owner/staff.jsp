<%-- 
    Document   : staff
    Created on : Jun 14, 2025, 10:25:30 AM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.UserDTO" %>

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
        <style>
.btn-successs {
    background-color: #2196F3;
}

.btn-successs:hover {
    background-color: #1976D2;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
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

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
            <form action="so-staff" method="get" id="filterForm">
            <!-- Status Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Trạng thái nhân viên</h3>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <div class="category-tree">
                        <div class="category-item">
                            <input type="radio" id="status-all" name="status" value="" ${selectedStatus == null ? 'checked' : ''}>
                            <label for="status-all" class="category-label">
                                <span>Tất cả</span>
                            </label>
                        </div>
                        <div class="category-item">
                            <input type="radio" id="status-1" name="status" value="1" ${selectedStatus == 1 ? 'checked' : ''}>
                            <label for="status-1" class="category-label">
                                <span>Đang làm việc</span>
                            </label>
                        </div>
                        <div class="category-item">
                            <input type="radio" id="status-0" name="status" value="0" ${selectedStatus == 0 ? 'checked' : ''}>
                            <label for="status-0" class="category-label">
                                <span>Nghỉ việc</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Role Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Chức danh</h3>
                </div>
                <div class="filter-content">
                    <div class="category-tree">
                        <div class="category-item ${selectedRole == null ? 'selected' : ''}">
                            <input type="radio" id="role-all" name="role" value="" ${selectedRole == null ? 'checked' : ''}>
                            <label for="role-all" class="category-label">
                                <span>Tất cả</span>
                            </label>
                        </div>
                        <div class="category-item ${selectedRole == 1 ? 'selected' : ''}">
                            <input type="radio" id="role-1" name="role" value="1" ${selectedRole == 1 ? 'checked' : ''}>
                            <label for="role-1" class="category-label">
                                <span>Quản lý chi nhánh</span>
                            </label>
                        </div>
                        <div class="category-item ${selectedRole == 2 ? 'selected' : ''}">
                            <input type="radio" id="role-2" name="role" value="2" ${selectedRole == 2 ? 'checked' : ''}>
                            <label for="role-2" class="category-label">
                                <span>Nhân viên bán hàng</span>
                            </label>
                        </div>
                        <div class="category-item ${selectedRole == 3 ? 'selected' : ''}">
                            <input type="radio" id="role-3" name="role" value="3" ${selectedRole == 3 ? 'checked' : ''}>
                            <label for="role-3" class="category-label">
                                <span>Quản lý kho</span>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Action Buttons -->
            <div class="filter-actions">
                <a href="so-staff?page=1" class="btn-clear">
                    <i class="fas fa-eraser"></i>
                    Xóa bộ lọc
                </a>
                <button type="submit" class="btn-apply">
                    <i class="fas fa-filter"></i>
                    Áp dụng lọc
                </button>
            </div>             
            </form>
        </aside>


            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Nhân viên</h1>
                    <div class="header-actions">
                        <form class="search-input" action="so-staff" method="get" style="display: flex; align-items: center; gap: 20px;">
                        <div style="position: relative; flex: 1;">
                            <i class="fas fa-search" style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #aaa;"></i>
                            <input type="text" name="search" placeholder="Theo mã, tên nhân viên"  value="${search}"
                                   style="padding: 10px 10px 10px 60px; width: 100%; border: 1px solid #ccc; border-radius: 15px;">
                            <c:if test="${selectedStatus != null}">
                                <input type="hidden" name="status" value="${selectedStatus}">
                            </c:if>
                            <c:if test="${selectedRole != null}">
                                <input type="hidden" name="role" value="${selectedRole}">
                            </c:if>
                        </div>
                            <button type="submit" class="btn btn-successs">Tìm Kiếm</button>
                    </form>
                        <div>
                        <button class="btn btn-success">
                            <i class="fas fa-plus"></i>
                            Thêm mới
                        </button>
                        </div>
                    </div>
                </div>

                
            <!-- Staff Table -->
            <div class="table-container">
                <table class="products-table">
                    <thead>
                        <tr>
                            <th class="checkbox-col"><input type="checkbox" id="selectAll"></th>
                            <th>Mã nhân viên</th>
                            <th>Tên nhân viên</th>
                            <th>Chức danh</th>
                            <th>Chi nhánh/Kho</th>
                            <th>Số điện thoại</th>
                            <th>Trạng thái</th>
                            <th style="justify-content: center; text-align: center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<UserDTO> staffList = (List<UserDTO>) request.getAttribute("staffList");
                            if (staffList != null && !staffList.isEmpty()) {
                                for (UserDTO staff : staffList) {
                        %>
                        <tr>
                            <td class="checkbox-col">
                                <input type="checkbox" name="selectedStaff" value="<%=staff.getUserID()%>">
                            </td>
                            <td><%=staff.getUserID()%></td>
                            <td><%=staff.getFullName()%></td>
                            <td><%=staff.getRoleName()%></td>
                            <td><%=staff.getBranchName() != null ? staff.getBranchName() : (staff.getWarehouseName() != null ? staff.getWarehouseName() : "")%></td>
                            <td><%=staff.getPhone() != null ? staff.getPhone() : ""%></td>
                            <td><%=staff.getIsActive() == 1 ? "Đang làm việc" : "Nghỉ việc"%></td>
                            <td class="actions-col" style="justify-content: center; display: flex; gap: 5px">
                                <form action="so-staff" method="get" style="display:inline;">
                                    <input type="hidden" name="action" value="view"/>
                                    <input type="hidden" name="userID" value="<%=staff.getUserID()%>"/>
                                    <button type="submit" class="btn btn-success" style="text-decoration: none; width: 79px; background:#2196F3">Chi tiết</button>
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr>
                            <td colspan="8" style="text-align:center;">Không có nhân viên nào!</td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="pagination-container">
                <div class="pagination-info">
                    Hiển thị ${startStaff} - ${endStaff} / Tổng số ${totalStaff} nhân viên
                </div>
                <div class="pagination">
                    <a href="so-staff?page=1${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == 1 ? 'disabled' : '')}">
                        <i class="fas fa-angle-double-left"></i>
                    </a>
                    <a href="so-staff?page=${currentPage - 1}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == 1 ? 'disabled' : '')}">
                        <i class="fas fa-angle-left"></i>
                    </a>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <a href="so-staff?page=${i}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (i == currentPage ? 'active' : '')}">${i}</a>
                    </c:forEach>
                    <a href="so-staff?page=${currentPage + 1}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == totalPages ? 'disabled' : '')}">
                        <i class="fas fa-angle-right"></i>
                    </a>
                    <a href="so-staff?page=${totalPages}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == totalPages ? 'disabled' : '')}">
                        <i class="fas fa-angle-double-right"></i>
                    </a>
                </div>
            </div>
        </main>
    </div>


        <c:if test="${not empty success}">
            <div class="notification success" id="notification">${success}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="notification error" id="notification">${error}</div>
        </c:if>


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
                                <option value="${wh.wareHouseId}">${wh.wareHouseName}</option>
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
