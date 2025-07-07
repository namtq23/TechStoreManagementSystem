<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css"> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/so-staff.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <title>Chỉnh sửa nhân viên</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f6fa;
                margin: 0;
                padding: 0;
            }

            .staff-edit-container {
                max-width: 800px;
                margin: 30px auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            }

            .staff-edit-header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                border-bottom: 2px solid #2196F3;
                padding-bottom: 10px;
                margin-bottom: 20px;
            }

            .staff-edit-header h2 {
                margin: 0;
                color: #2196F3;
                font-size: 24px;
                font-weight: 600;
            }

            .edit-form {
                display: grid;
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .form-group {
                display: flex;
                flex-direction: column;
            }

            .form-group label {
                font-weight: 500;
                color: #555;
                margin-bottom: 5px;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                padding: 10px;
                border: 1px solid #e0e0e0;
                border-radius: 5px;
                font-size: 14px;
                width: 100%;
                box-sizing: border-box;
            }

            .form-group input:disabled {
                background-color: #f0f0f0;
                cursor: not-allowed;
            }

            .form-group textarea {
                resize: vertical;
                min-height: 100px;
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

            .btn-save {
                background-color: #28a745;
                color: white;
            }

            .btn-save:hover {
                background-color: #218838;
                transform: translateY(-2px);
                box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
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

            .btn-delete {
                background-color: #dc3545;
                color: white;
            }

            .btn-delete:hover {
                background-color: #c82333;
                transform: translateY(-2px);
                box-shadow: 0 2px 8px rgba(220, 53, 69, 0.3);
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

            .error-message {
                color: #dc3545;
                font-size: 12px;
                margin-top: 5px;
                display: none;
            }

            .server-error {
                color: #dc3545;
                font-size: 12px;
                margin-top: 5px;
            }
            .section-card {
                border: 1px solid #ddd;
                border-left: 4px solid #2196F3;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 25px;
                background-color: #fdfdfd;
                box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            }

            .section-title {
                font-size: 18px;
                color: #2196F3;
                font-weight: 600;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .section-title i {
                font-size: 16px;
            }

            .form-row {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
            }

            .form-group.half {
                flex: 1 1 45%;
            }

            .form-group.full {
                flex: 1 1 100%;
            }

            .form-group input:focus,
            .form-group select:focus,
            .form-group textarea:focus {
                outline: none;
                border-color: #2196F3;
                box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
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
                            <a href="nhap-hang" class="dropdown-item">Tạo đơn nhập hàng</a>
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
                            <a href="so-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <div class="staff-edit-container">
            <div class="staff-edit-header">
                <h2>Chỉnh sửa nhân viên</h2>
            </div>
            <form id="editStaffForm" action="so-staff" method="get">
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="userID" value="${staff.userID}"/>
                <div class="edit-form">
                    <!-- Thông tin cá nhân -->
                    <div class="section-card">
                        <div class="section-title">
                            <i class="fas fa-id-card"></i> Thông tin cá nhân
                        </div>
                        <div class="form-row">
                            <div class="form-group half">
                                <label>Mã nhân viên</label>
                                <input type="text" value="${staff.userID}" disabled/>
                            </div>
                            <div class="form-group half">
                                <label>Họ tên</label>
                                <input type="text" name="fullName" id="fullName" value="${staff.fullName}" required/>
                                <div class="error-message" id="fullNameError">Vui lòng nhập họ tên</div>
                            </div>
                            <div class="form-group half">
                                <label>Ngày sinh</label>
                                <input type="date" name="DOB" id="DOB" value="<fmt:formatDate value='${staff.DOB}' pattern='yyyy-MM-dd'/>" />
                                <div class="error-message" id="DOBError">Ngày sinh không hợp lệ</div>
                            </div>
                            <div class="form-group half">
                                <label>Giới tính</label>
                                <select name="gender" id="gender">
                                    <option value="1" ${staff.gender == 1 ? 'selected' : ''}>Nam</option>
                                    <option value="0" ${staff.gender == 0 ? 'selected' : ''}>Nữ</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin liên hệ -->
                    <div class="section-card">
                        <div class="section-title">
                            <i class="fas fa-phone"></i> Thông tin liên hệ
                        </div>
                        <div class="form-row">
                            <div class="form-group full">
                                <label>Địa chỉ</label>
                                <textarea name="address" id="address">${staff.address != null ? staff.address : ''}</textarea>
                            </div>
                            <div class="form-group half">
                                <label>Số điện thoại</label>
                                <input type="text" name="phone" id="phone" value="${staff.phone}" required/>
                                <div class="error-message" id="phoneError">Số điện thoại không hợp lệ</div>
                                <c:if test="${not empty phoneError}">
                                    <div class="server-error">${phoneError}</div>
                                </c:if>
                            </div>
                            <div class="form-group half">
                                <label>Email</label>
                                <input type="email" name="email" id="email" value="${staff.email}" required/>
                                <div class="error-message" id="emailError">Email không hợp lệ</div>
                                <c:if test="${not empty emailError}">
                                    <div class="server-error">${emailError}</div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin công việc -->
                    <div class="section-card">
                        <div class="section-title">
                            <i class="fas fa-briefcase"></i> Thông tin công việc
                        </div>
                        <div class="form-row">
                            <div class="form-group half">
                                <label>Chức danh</label>
                                <select name="roleID" id="roleID" required>
                                    <c:forEach var="role" items="${roles}">
                                        <option value="${role.roleID}" ${staff.roleID == role.roleID ? 'selected' : ''}>${role.roleName}</option>
                                    </c:forEach>
                                </select>
                                <div class="error-message" id="roleIDError">Vui lòng chọn chức danh</div>
                            </div>
                            <div class="form-group half">
                                <label>Chi nhánh</label>
                                <select name="branchID" id="branchID">
                                    <option value="">Không thuộc chi nhánh</option>
                                    <c:forEach var="branch" items="${branchesList}">
                                        <option value="${branch.branchId}" ${staff.branchID == branch.branchId ? 'selected' : ''}>${branch.branchName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group half">
                                <label>Kho</label>
                                <select name="warehouseID" id="warehouseID">
                                    <option value="">Không quản lý kho</option>
                                    <c:forEach var="warehouse" items="${warehousesList}">
                                        <option value="${warehouse.wareHouseId}" ${staff.warehouseID == warehouse.wareHouseId ? 'selected' : ''}>${warehouse.wareHouseName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group half">
                                <label>Trạng thái</label>
                                <select name="isActive" id="isActive">
                                    <option value="1" ${staff.isActive == 1 ? 'selected' : ''}>Đang làm việc</option>
                                    <option value="0" ${staff.isActive == 0 ? 'selected' : ''}>Nghỉ việc</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-save">
                        <i class="fas fa-save"></i> Lưu
                    </button>
                    <a href="so-staff" class="btn btn-back">
                        <i class="fas fa-arrow-left"></i> Quay lại
                    </a>
                    <a href="so-staff?action=delete&userID=${staff.userID}" class="btn btn-delete" onclick="return confirm('Bạn có chắc muốn sa thải nhân viên này?');">
                        <i class="fas fa-trash"></i> Sa thải
                    </a>
                </div>
            </form>
        </div>

        <c:if test="${not empty success}">
            <div class="notification success" id="notification">${success}</div>
            <c:remove var="success" scope="session"/>
        </c:if>
        <c:if test="${not empty error}">
            <div class="notification error" id="notification">${error}</div>
            <c:remove var="error" scope="session"/>
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

            // Handle notification
            const noti = document.getElementById("notification");
            if (noti && noti.textContent.trim() !== "") {
                // Show notification for 4 seconds, then hide it
                setTimeout(() => {
                    noti.classList.add("hide");
                    // Optionally remove the notification element from the DOM
                    setTimeout(() => {
                        noti.remove();
                    }, 500); // Wait for the fade-out animation to complete
                }, 4000);
            }

            // Form validation
            const form = document.getElementById("editStaffForm");
            const fullName = document.getElementById("fullName");
            const DOB = document.getElementById("DOB");
            const phone = document.getElementById("phone");
            const email = document.getElementById("email");
            const roleID = document.getElementById("roleID");

            const fullNameError = document.getElementById("fullNameError");
            const DOBError = document.getElementById("DOBError");
            const phoneError = document.getElementById("phoneError");
            const emailError = document.getElementById("emailError");
            const roleIDError = document.getElementById("roleIDError");

            form.addEventListener("submit", function (e) {
                let valid = true;

                // Reset client-side error messages
                fullNameError.style.display = "none";
                DOBError.style.display = "none";
                phoneError.style.display = "none";
                emailError.style.display = "none";
                roleIDError.style.display = "none";

                // Validate full name
                if (!fullName.value.trim()) {
                    fullNameError.style.display = "block";
                    valid = false;
                }

                // Validate DOB
                if (DOB.value) {
                    const dobDate = new Date(DOB.value);
                    const today = new Date();
                    if (dobDate > today) {
                        DOBError.style.display = "block";
                        valid = false;
                    }
                }

                // Validate phone
                const phoneRegex = /^[0-9]{10,11}$/;
                if (!phoneRegex.test(phone.value.trim())) {
                    phoneError.style.display = "block";
                    valid = false;
                }

                // Validate email
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email.value.trim())) {
                    emailError.style.display = "block";
                    valid = false;
                }

                // Validate role
                if (!roleID.value) {
                    roleIDError.style.display = "block";
                    valid = false;
                }

                if (!valid) {
                    e.preventDefault();
                }
            });
        </script>
    </body>
</html>