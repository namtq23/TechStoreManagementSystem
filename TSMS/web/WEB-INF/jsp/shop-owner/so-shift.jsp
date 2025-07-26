<%-- 
    Document   : so-shift
    Created on : Jul 16, 2025, 5:20:05 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Shift" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="css/header.css"> 
        <link rel="stylesheet" href="css/so-staff.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <title>Quản lý ca làm việc</title>
        <style>
            .btn-successs {
                background-color: #2196F3;
            }

            .btn-successs:hover {
                background-color: #1976D2;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
            }

            .time-display {
                font-weight: bold;
                color: #2196F3;
                font-size: 14px;
            }

            .shift-name {
                font-weight: 600;
                color: #333;
            }

            .time-range {
            }

            .time-separator {
                color: #666;
                font-weight: bold;
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
                            <a href="import-request" class="dropdown-item">Tạo đơn nhập hàng</a>
                            <a href="so-track-movements" class="dropdown-item">Theo dõi nhập/xuất</a>
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
                            <a href="so-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <div class="main-container">
            <!-- Main Content -->
            <main class="main-content" style="margin-left: 0; width: 100%;">
                <div class="page-header">
                    <h1>Quản lý ca làm việc</h1>
                    <div class="header-actions">
                        <form class="search-input" action="so-shift" method="get" style="display: flex; align-items: center; gap: 20px;">
                            <div style="position: relative; flex: 1;">
                                <i class="fas fa-search" style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #aaa;"></i>
                                <input type="text" name="search" placeholder="Tìm kiếm theo tên ca làm việc" value="${search}"
                                       style="padding: 10px 10px 10px 30px; width: 100%; border: 1px solid #ccc; border-radius: 15px;">
                            </div>
                        </form>
                        <div>
                            <button class="btn btn-success">
                                <i class="fas fa-plus"></i>
                                Thêm ca làm việc
                            </button>
                        </div>
                        <div>
                            <a href="so-staff" style="text-decoration: none">
                                <button type="button" class="btn btn-success">
                                    <i class="fas fa-users"></i>
                                    Nhân viên
                                </button>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Shift Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th class="checkbox-col"><input type="checkbox" id="selectAll"></th>
                                <th>Mã ca</th>
                                <th>Tên ca làm việc</th>
                                <th>Giờ bắt đầu</th>
                                <th>Giờ kết thúc</th>
                                <th>Thời gian ca</th>
                                <th style="justify-content: center; text-align: center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<Shift> shiftList = (List<Shift>) request.getAttribute("shiftList");
                                if (shiftList != null && !shiftList.isEmpty()) {
                                    for (Shift shift : shiftList) {
                            %>
                            <tr>
                                <td class="checkbox-col">
                                    <input type="checkbox" name="selectedShift" value="<%=shift.getShiftID()%>">
                                </td>
                                <td><%=shift.getShiftID()%></td>
                                <td class="shift-name"><%=shift.getShiftName()%></td>
                                <td class="time-display"><%=shift.getStartTime()%></td>
                                <td class="time-display"><%=shift.getEndTime()%></td>
                                <%
                                    java.time.LocalTime start = shift.getStartTime();
                                    java.time.LocalTime end = shift.getEndTime();
                                    java.time.Duration duration = java.time.Duration.between(start, end);
                                    long hours = duration.toHours();
                                    long minutes = duration.toMinutes() % 60;
                                    String durationText = hours + " giờ " + (minutes > 0 ? minutes + " phút" : "");
                                %>
                                <td class="time-range"><%= durationText %></td>
                                <td class="actions-col" style="justify-content: center; display: flex; gap: 5px">
                                    <form action="so-shift" method="get" style="display:inline;">
                                        <input type="hidden" name="action" value="edit"/>
                                        <input type="hidden" name="shiftId" value="<%=shift.getShiftID()%>"/>
                                        <button type="submit" class="btn btn-success" style="text-decoration: none; width: 79px; background:#FFA726">
                                            <i class="fas fa-edit"></i> Sửa
                                        </button>
                                    </form>
                                    <form action="so-shift" method="post" style="display:inline;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa ca làm việc này?')">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="shiftId" value="<%=shift.getShiftID()%>"/>
                                        <button type="submit" class="btn btn-success" style="text-decoration: none; width: 79px; background:#f44336">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="7" style="text-align:center;">Không có ca làm việc nào!</td>
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
                        Hiển thị ${startShift} - ${endShift} / Tổng số ${totalShift} ca làm việc
                    </div>
                    <div class="pagination">
                        <a href="so-shift?page=1" class="page-btn ${totalShift == 0 ? 'disabled' : (currentPage == 1 ? 'disabled' : '')}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="so-shift?page=${currentPage - 1}" class="page-btn ${totalShift == 0 ? 'disabled' : (currentPage == 1 ? 'disabled' : '')}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="so-shift?page=${i}" class="page-btn ${totalShift == 0 ? 'disabled' : (i == currentPage ? 'active' : '')}">${i}</a>
                        </c:forEach>
                        <a href="so-shift?page=${currentPage + 1}" class="page-btn ${totalShift == 0 ? 'disabled' : (currentPage == totalPages ? 'disabled' : '')}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="so-shift?page=${totalPages}" class="page-btn ${totalShift == 0 ? 'disabled' : (currentPage == totalPages ? 'disabled' : '')}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>
            </main>
        </div>

        <c:if test="${not empty sessionScope.success}">
            <div class="notification success" id="notification">${sessionScope.success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="notification error" id="notification">${sessionScope.error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>

        <!-- Overlay làm mờ nền -->
        <div id="overlay" class="overlay hidden"></div>

        <!-- Form tạo/sửa ca làm việc -->
        <div class="create-staff hidden">
            <h2 id="formTitle">Tạo ca làm việc mới</h2>
            <form id="shiftForm" action="so-shift" method="post">
                <input type="hidden" name="action" value="create" id="formAction">
                <input type="hidden" name="shiftId" id="shiftId">

                <div class="staff-info-form">
                    <div class="form-row">
                        <label>Tên ca làm việc:</label>
                        <input type="text" name="shiftName" id="shiftName" required="" placeholder="Ví dụ: Ca sáng, Ca chiều, Ca tối">
                    </div>
                    <div class="form-row">
                        <label>Giờ bắt đầu:</label>
                        <input type="time" name="startTime" id="startTime" required="">
                    </div>
                    <div class="form-row">
                        <label>Giờ kết thúc:</label>
                        <input type="time" name="endTime" id="endTime" required="">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary" id="submitBtn">
                        <i class="fas fa-plus"></i> Tạo ca làm việc
                    </button>
                    <button type="button" id="closeShiftForm" class="btn-secondary">
                        <i class="fas fa-times"></i> Đóng
                    </button>
                </div>
            </form>
        </div>
    </body>
    <script>
        // Dropdown menu functionality
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

        // Form functionality
        const createBtn = document.querySelector('.btn-success');
        const formModal = document.querySelector('.create-staff');
        const overlay = document.querySelector('#overlay');
        const closeBtn = document.querySelector('#closeShiftForm');

        // Function to show form
        function showForm() {
            formModal.classList.remove('hidden');
            overlay.classList.remove('hidden');
        }

        // Function to hide form
        function hideForm() {
            formModal.classList.add('hidden');
            overlay.classList.add('hidden');
        }

        // Function to reset form for create mode
        function resetFormForCreate() {
            document.getElementById('formTitle').textContent = 'Tạo ca làm việc mới';
            document.getElementById('formAction').value = 'create';
            document.getElementById('submitBtn').innerHTML = '<i class="fas fa-plus"></i> Tạo ca làm việc';
            document.getElementById('shiftForm').reset();
            document.getElementById('shiftId').value = '';
        }

        // Function to set form for edit mode
        function setFormForEdit(shiftId, shiftName, startTime, endTime) {
            document.getElementById('formTitle').textContent = 'Sửa ca làm việc';
            document.getElementById('formAction').value = 'update';
            document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Cập nhật';
            document.getElementById('shiftId').value = shiftId;
            document.getElementById('shiftName').value = shiftName;
            document.getElementById('startTime').value = startTime;
            document.getElementById('endTime').value = endTime;
        }

        createBtn.addEventListener('click', () => {
            resetFormForCreate();
            showForm();
        });

        closeBtn.addEventListener('click', () => {
            hideForm();
        });

        overlay.addEventListener("click", () => {
            hideForm();
        });

        // Handle edit buttons and initial edit mode
        document.addEventListener('DOMContentLoaded', function () {
            // Add click event to edit buttons
            const editButtons = document.querySelectorAll('button[type="submit"][style*="background:#FFA726"]');
            editButtons.forEach(button => {
                button.addEventListener('click', function (e) {
                    e.preventDefault();

                    const form = this.closest('form');
                    const shiftId = form.querySelector('input[name="shiftId"]').value;

                    // Get data from table row
                    const row = this.closest('tr');
                    const cells = row.querySelectorAll('td');
                    const shiftName = cells[2].textContent.trim();
                    const startTime = cells[3].textContent.trim();
                    const endTime = cells[4].textContent.trim();

                    setFormForEdit(shiftId, shiftName, startTime, endTime);
                    showForm();
                });
            });

            // Check if we're in edit mode from server-side (when page loads with action=edit)
        <c:if test="${not empty editShift}">
            setFormForEdit(
                    '${editShift.shiftID}',
                    '${editShift.shiftName}',
                    '${editShift.formattedStartTime}',
                    '${editShift.formattedEndTime}'
                    );
            showForm();
        </c:if>

            // Handle URL parameters for editing (backup method)
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('action') === 'edit' && !${not empty editShift}) {
                const shiftId = urlParams.get('shiftId');
                if (shiftId) {
                    // If server-side didn't provide data, try to get from table
                    const rows = document.querySelectorAll('tbody tr');
                    rows.forEach(row => {
                        const cells = row.querySelectorAll('td');
                        if (cells.length > 1 && cells[1].textContent.trim() === shiftId) {
                            const shiftName = cells[2].textContent.trim();
                            const startTime = cells[3].textContent.trim();
                            const endTime = cells[4].textContent.trim();

                            setFormForEdit(shiftId, shiftName, startTime, endTime);
                            showForm();
                            return;
                        }
                    });
                }
            }
        });

        // Form validation
        document.getElementById('shiftForm').addEventListener('submit', function (e) {
            const startTime = document.getElementById('startTime').value;
            const endTime = document.getElementById('endTime').value;

            if (startTime && endTime) {
                const start = new Date(`2000-01-01T${startTime}`);
                const end = new Date(`2000-01-01T${endTime}`);

                if (start >= end) {
                    alert('Giờ kết thúc phải sau giờ bắt đầu!');
                    e.preventDefault();
                    return false;
                }
            }
        });

        // Select all checkbox functionality
        document.getElementById('selectAll').addEventListener('change', function () {
            const checkboxes = document.querySelectorAll('input[name="selectedShift"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
        });

        // Notification handling
        const noti = document.getElementById("notification");
        if (noti && noti.textContent.trim() !== "") {
            setTimeout(() => {
                noti.classList.add("hide");
            }, 4000);
        }
    </script>
</html>
