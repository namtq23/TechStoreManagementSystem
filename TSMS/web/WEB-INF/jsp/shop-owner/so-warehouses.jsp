<%-- 
    Document   : so-warehouses
    Created on : Jul 5, 2025, 3:32:51 PM
    Author     : admin
--%>

<%@ page import="java.util.*, model.Warehouse" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý kho tổng - TSMS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/header.css"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                color: #333;
            }

            .main-content {
                min-height: calc(100vh - 160px);
                padding: 20px;
                background-color: #f5f5f5;
                display: flex;
                justify-content: center;
            }

            .container {
                width: 100%;
                max-width: 1400px;
                display: flex;
                gap: 24px;
                align-items: flex-start;
            }

            .sidebar {
                width: 280px;
                flex-shrink: 0;
                background: white;
                border-radius: 8px;
                padding: 20px;
                height: fit-content;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
            }

            .sidebar h3 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }

            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar-menu li {
                margin-bottom: 8px;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                padding: 12px 16px;
                text-decoration: none;
                color: #666;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .sidebar-menu a:hover,
            .sidebar-menu a.active {
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .sidebar-menu i {
                margin-right: 12px;
                width: 20px;
                font-size: 16px;
            }

            .main-panel {
                flex: 1;
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                overflow: hidden;
            }

            .panel-header {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .panel-header-left {
                display: flex;
                align-items: center;
            }

            .panel-header i {
                color: #1976d2;
                font-size: 20px;
                padding-right: 10px;
            }

            .panel-header h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 600;
                color: #333;
            }

            .panel-header-right {
                display: flex;
                gap: 12px;
            }

            .btn {
                padding: 10px 20px;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
            }

            .btn-primary {
                background: #1976d2;
                color: white;
            }

            .btn-primary:hover {
                background: #1565c0;
                transform: translateY(-1px);
                box-shadow: 0 4px 12px rgba(25, 118, 210, 0.3);
            }

            .btn-success {
                background: #28a745;
                color: white;
            }

            .btn-success:hover {
                background: #218838;
                transform: translateY(-1px);
            }

            .btn-danger {
                background: #dc3545;
                color: white;
            }

            .btn-danger:hover {
                background: #c82333;
                transform: translateY(-1px);
            }

            .btn-secondary {
                background: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background: #5a6268;
                transform: translateY(-1px);
            }

            .panel-content {
                padding: 30px;
            }

            .warehouses-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            }

            .warehouses-table th,
            .warehouses-table td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #e9ecef;
            }

            .warehouses-table th {
                background: #f8f9fa;
                font-weight: 600;
                color: #333;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .warehouses-table tr {
                transition: background-color 0.3s ease;
                cursor: pointer;
            }

            .warehouses-table tr:hover {
                background-color: #f8f9fa;
            }

            .warehouses-table tr.selected {
                background-color: #e3f2fd;
            }

            .warehouses-table tbody tr:last-child td {
                border-bottom: none;
            }

            .warehouses-table .btn {
                padding: 6px 12px;
                font-size: 12px;
                border-radius: 4px;
            }

            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-active {
                background: #d4edda;
                color: #155724;
            }

            .status-inactive {
                background: #f8d7da;
                color: #721c24;
            }

            .edit-form {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                margin-top: 30px;
                display: none;
            }

            .edit-form.show {
                display: block;
                animation: slideDown 0.3s ease-out;
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .edit-form h4 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .form-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group.full-width {
                grid-column: 1 / -1;
            }

            .form-group label {
                margin-bottom: 8px;
                font-weight: 500;
                color: #333;
            }

            .required {
                color: #dc3545;
            }

            .form-input {
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                transition: all 0.3s ease;
                background-color: white;
            }

            .form-input:focus {
                outline: none;
                border-color: #1976d2;
                box-shadow: 0 0 0 3px rgba(25, 118, 210, 0.1);
            }

            .form-checkbox {
                display: flex;
                align-items: center;
                gap: 8px;
                margin-top: 10px;
            }

            .form-checkbox input[type="checkbox"] {
                width: 18px;
                height: 18px;
                cursor: pointer;
            }

            .form-buttons {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #e9ecef;
            }

            .flash-message {
                position: fixed;
                top: 20px;
                right: 30px;
                padding: 16px 24px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                color: white;
                z-index: 1000;
                font-size: 16px;
                animation: slideIn 0.3s ease-out, fadeOut 0.5s ease-in-out 4.5s forwards;
            }

            .flash-message.success {
                background-color: #4CAF50;
            }

            .flash-message.error {
                background-color: #f44336;
            }

            @keyframes slideIn {
                from {
                    opacity: 0;
                    transform: translateX(100px);
                }
                to {
                    opacity: 1;
                    transform: translateX(0);
                }
            }

            @keyframes fadeOut {
                to {
                    opacity: 0;
                    transform: translateY(-20px);
                    visibility: hidden;
                }
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }

            .empty-state i {
                font-size: 48px;
                margin-bottom: 20px;
                color: #ccc;
            }

            .empty-state h3 {
                margin-bottom: 10px;
                font-size: 18px;
                color: #333;
            }

            .empty-state p {
                margin-bottom: 20px;
                font-size: 14px;
            }

            .create-form {
                background: #f8f9fa;
                padding: 25px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                margin-bottom: 30px;
                display: none;
            }

            .create-form.show {
                display: block;
                animation: slideDown 0.3s ease-out;
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                }

                .form-grid {
                    grid-template-columns: 1fr;
                }

                .form-buttons {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }
            }

            .edit-form {
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: white;
                padding: 30px;
                z-index: 999;
                width: 90%;
                max-width: 600px;
                border-radius: 10px;
                border: 1px solid #ccc;
                box-shadow: 0 10px 25px rgba(0,0,0,0.2);
                display: none;
            }

            .edit-form.show {
                display: block;
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translate(-50%, -60%);
                }
                to {
                    opacity: 1;
                    transform: translate(-50%, -50%);
                }
            }

            /* Optional: mờ nền phía sau form */
            .modal-overlay {
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                width: 100vw;
                background: rgba(0, 0, 0, 0.4);
                z-index: 998;
                display: none;
            }

            .modal-overlay.show {
                display: block;
            }

        </style>
    </head>
    <body>
        <!-- Header -->
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

                    <div class="nav-item dropdown">
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
                            <a href="so-outcome" class="dropdown-item">Khoảng chi</a>
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

        <!-- Flash Messages -->
        <c:if test="${not empty sessionScope.success}">
            <div class="flash-message success">${sessionScope.success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>

        <c:if test="${not empty sessionScope.error}">
            <div class="flash-message error">${sessionScope.error}</div>
            <c:remove var="error" scope="session"/>
        </c:if>


        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Left Sidebar -->
                <div class="sidebar">
                    <h3>Gian hàng</h3>
                    <ul class="sidebar-menu">
                        <li><a href="so-information"><i class="fas fa-info-circle"></i> Thông tin gian hàng</a></li>
                        <li><a href="so-change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                        <li><a href="so-branches"><i class="fas fa-code-branch"></i> Quản lý chi nhánh</a></li>
                        <li><a href="so-warehouses" class="active"><i class="fas fa-warehouse"></i> Quản lý kho tổng</a></li>
                        <li><a href="subscription"><i class="fas fa-shopping-cart"></i> Gói dịch vụ</a></li>
                        <li><a href="subscription-logs"><i class="fas fa-history"></i> Lịch sử mua hàng</a></li>
                    </ul>
                </div>

                <!-- Main Panel -->
                <div class="main-panel">
                    <div class="panel-header">
                        <div class="panel-header-left">
                            <i class="fas fa-warehouse"></i>
                            <h2>Quản lý kho tổng</h2>
                        </div>
                        <div class="panel-header-right">
                            <button type="button" class="btn btn-primary" onclick="toggleCreateForm()">
                                <i class="fas fa-plus"></i> Tạo kho tổng mới
                            </button>
                        </div>
                    </div>

                    <div class="panel-content">
                        <!-- Create Form -->
                        <div class="create-form" id="createForm">
                            <a href="so-create-warehouse" style="text-decoration: none;">
                                <h4><i class="fas fa-plus"></i> Tạo kho tổng mới</h4>
                            </a>
                        </div>

                        <!-- Warehouse Table -->
                        <c:choose>
                            <c:when test="${empty warehouses}">
                                <div class="empty-state">
                                    <i class="fas fa-warehouse"></i>
                                    <h3>Chưa có kho tổng nào</h3>
                                    <p>Tạo kho tổng đầu tiên để bắt đầu quản lý hàng hóa</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="warehouses-table">
                                    <thead>
                                        <tr>
                                            <th>Tên kho tổng</th>
                                            <th>Địa chỉ</th>
                                            <th>Số điện thoại</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="warehouse" items="${warehouses}">
                                            <tr onclick="selectWarehouse(this)"
                                                data-warehouse-id="${warehouse.wareHouseId}"
                                                data-warehouse-name="${warehouse.wareHouseName}"
                                                data-address="${warehouse.wareHouseAddress}"
                                                data-phone="${warehouse.phone}"
                                                data-is-active="${warehouse.isActive}">
                                                <td><strong>${warehouse.wareHouseName}</strong></td>
                                                <td>${warehouse.wareHouseAddress}</td>
                                                <td>${warehouse.phone}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${warehouse.isActive == 1}">
                                                            <span class="status-badge status-active">Hoạt động</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-inactive">Tạm dừng</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <button type="button" class="btn btn-danger" onclick="deleteWarehouse(${warehouse.wareHouseId}, '${warehouse.wareHouseName}', event)">
                                                        <i class="fas fa-trash"></i> Xóa
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>

                        <!-- Edit Form -->
                        <div class="edit-form" id="editForm">
                            <form action="so-warehouses" method="POST">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="warehouseId" id="editWarehouseId">

                                <h4><i class="fas fa-edit"></i> Chỉnh sửa kho tổng</h4>

                                <div class="form-grid">
                                    <div class="form-group full-width">
                                        <label for="editWarehouseName">
                                            Tên kho tổng <span class="required">*</span>
                                        </label>
                                        <input type="text" id="editWarehouseName" name="warehouseName" class="form-input" placeholder="Nhập tên kho tổng" required maxlength="100">
                                    </div>

                                    <div class="form-group full-width">
                                        <label for="editAddress">
                                            Địa chỉ <span class="required">*</span>
                                        </label>
                                        <input type="text" id="editAddress" name="address" class="form-input" placeholder="Nhập địa chỉ kho tổng" required maxlength="200">
                                    </div>

                                    <div class="form-group">
                                        <label for="editPhone">
                                            Số điện thoại <span class="required">*</span>
                                        </label>
                                        <input type="tel" id="editPhone" name="phone" class="form-input" placeholder="Nhập số điện thoại" required pattern="[0-9]{10,11}" maxlength="11">
                                    </div>

                                    <div class="form-group">
                                        <label>Trạng thái</label>
                                        <div class="form-checkbox">
                                            <input type="checkbox" id="editIsActive" name="isActive" value="true">
                                            <label for="editIsActive">Kho tổng đang hoạt động</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-buttons">
                                    <button type="button" class="btn btn-secondary" onclick="hideEditForm()">
                                        <i class="fas fa-times"></i> Hủy
                                    </button>
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-save"></i> Cập nhật
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <div class="modal-overlay" id="modalOverlay" onclick="hideEditForm()"></div>

        <script>
            // Các hàm toggleForm, selectWarehouse, hideEditForm, deleteWarehouse tương tự như trước nhưng đổi tên biến và function phù hợp
            function toggleCreateForm() {
                const createForm = document.getElementById('createForm');
                const editForm = document.getElementById('editForm');
                editForm.classList.remove('show');
                createForm.classList.toggle('show');
            }

            function selectWarehouse(rowElement) {
                document.querySelectorAll('.warehouses-table tr').forEach(row => row.classList.remove('selected'));
                rowElement.classList.add('selected');

                document.getElementById('editWarehouseId').value = rowElement.dataset.warehouseId;
                document.getElementById('editWarehouseName').value = rowElement.dataset.warehouseName;
                document.getElementById('editAddress').value = rowElement.dataset.address;
                document.getElementById('editPhone').value = rowElement.dataset.phone;
                document.getElementById('editIsActive').checked = rowElement.dataset.isActive === "1" || rowElement.dataset.isActive === "true";

                document.getElementById('editForm').classList.add('show');
                document.getElementById('modalOverlay').classList.add('show');
                document.getElementById('createForm').classList.remove('show');
            }

            function hideEditForm() {
                document.getElementById('editForm').classList.remove('show');
                document.getElementById('modalOverlay').classList.remove('show');
                document.querySelectorAll('.warehouses-table tr').forEach(row => row.classList.remove('selected'));
            }

            function deleteWarehouse(warehouseId, warehouseName, event) {
                event.stopPropagation();
                if (confirm(`Bạn có chắc chắn muốn xóa kho tổng "${warehouseName}"?`)) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = 'so-warehouses';

                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete';

                    const warehouseIdInput = document.createElement('input');
                    warehouseIdInput.type = 'hidden';
                    warehouseIdInput.name = 'warehouseId';
                    warehouseIdInput.value = warehouseId;

                    form.appendChild(actionInput);
                    form.appendChild(warehouseIdInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            }

            // Xử lý nhập số điện thoại như trước
            document.getElementById('editPhone').addEventListener('input', function (e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        </script>
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
        </script>
    </body>
</html>
