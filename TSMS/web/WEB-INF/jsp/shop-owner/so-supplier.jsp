<%-- 
    Document   : so-supplier
    Created on : Jun 27, 2025, 3:41:46 PM
    Author     : Kawaii
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Customer" %>
<%@ page import="util.Validate" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Nhân Viên</title>
        <link rel="stylesheet" href="css/so-customer.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
                    <a href="so-overview" class="nav-item ">
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

                    <div class="nav-item dropdown active">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-customer" class="dropdown-item ">Khách hàng</a>
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
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="so-customer" method="get">
                    <!-- Thêm dòng này để kích hoạt lọc theo khoảng giá -->
                    <input type="hidden" name="showTop" value="true" />



                    <!-- Price Range Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Khoảng chi tiêu</h3>
                        </div>
                        <div class="filter-content">
                            <div class="price-range">
                                <input type="number" name="minGrandTotal" placeholder="Số tiền nhập từ"
                                       value="${minGrandTotal}" class="GrandTotal-input">
                                <input type="number" name="maxGrandTotal" placeholder="Số tiền nhập đến"
                                       value="${maxGrandTotal}" class="GrandTotal-input">
                            </div>
                        </div>
                    </div>


                    <!-- Action Buttons -->
                    <div class="filter-actions">
                        <a href="so-customer?page=1" class="btn-clear">
                            <i class="fas fa-eraser"></i> Xóa bộ lọc
                        </a>
                        <button type="submit" class="btn-apply">
                            <i class="fas fa-filter"></i> Áp dụng lọc
                        </button>
                    </div>
                </form>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Nhà cung cấp</h1>
                    <div class="header-actions">

                        <form action="bm-supplier" method="get" class="search-container">
                            <i class="fas fa-search"></i>
                            <input type="text" name="keyword" placeholder="Theo tên nhà cung cấp" class="search-input"
                                   value="${param.keyword != null ? param.keyword : ''}" />

                            <button type="submit" style="border: none; background: none;">
                                <i class="fas fa-chevron-down"></i>
                            </button>
                        </form>

                        <button class="btn btn-success">
                            <i class="fas fa-plus"></i>
                            Thêm mới
                            <i class="fas fa-chevron-down"></i>
                        </button>
                    </div>
                </div>
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <div class="table-container">
                    <table class="products-table table table-bordered">
                        <thead class="table-light">
                            <tr>
                                <th>Mã Nhà cung cấp</th>
                                <th>Tên Công Ty</th>
                                <th>Người giao dịch</th>
                                <th>Số điện thoại</th>
                                <th>Gmail</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="supplier" items="${suppliers}" varStatus="loop">
                                <!-- Dòng chính -->
                                <tr onclick="toggleDetails(${loop.index})" style="cursor: pointer;">
                                    <td>${supplier.supplierID}</td>
                                    <td>${supplier.supplierName}</td>
                                    <td>${supplier.contactName}</td>
                                    <td>${supplier.phone}</td>
                                    <td>${supplier.email}</td>
                                </tr>

                                <!-- Dòng chi tiết để chỉnh sửa -->
                                <tr id="details-${loop.index}" class="detail-row" style="display: none;">
                                    <td colspan="5">
                                        <form method="post" action="so-supplier">
                                            <input type="hidden" name="id" value="${supplier.supplierID}" />

                                            <div class="row">
                                                <div class="col-md-6">
                                                    <p><strong>Tên công ty:</strong>
                                                        <input type="text" name="supplierName" class="form-control"
                                                               value="${supplier.supplierName}" />
                                                    </p>

                                                    <p><strong>Người giao dịch:</strong>
                                                        <input type="text" name="contactName" class="form-control"
                                                               value="${supplier.contactName}" />
                                                    </p>
                                                </div>

                                                <div class="col-md-6">
                                                    <p><strong>Số điện thoại:</strong>
                                                        <input type="text" name="phone" class="form-control"
                                                               value="${supplier.phone}" />
                                                    </p>

                                                    <p><strong>Email:</strong>
                                                        <input type="email" name="email" class="form-control"
                                                               value="${supplier.email}" />
                                                    </p>
                                                </div>
                                            </div>

                                            <div class="mt-2 text-end">
                                                <button type="submit" class="btn btn-sm btn-success">Lưu</button>
                                            </div>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Scripts -->
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script>
                                    function toggleDetails(index) {
                                        $(".detail-row").not("#details-" + index).hide(); // Ẩn các dòng chi tiết khác
                                        $("#details-" + index).fadeToggle(200);
                                    }

                                    // Dropdown xử lý menu (giữ nguyên)
                                    const toggle = document.getElementById("dropdownToggle");
                                    const menu = document.getElementById("dropdownMenu");

                                    toggle?.addEventListener("click", function (e) {
                                        e.preventDefault();
                                        menu.style.display = menu.style.display === "block" ? "none" : "block";
                                    });

                                    document.addEventListener("click", function (e) {
                                        if (!toggle?.contains(e.target) && !menu?.contains(e.target)) {
                                            menu.style.display = "none";
                                        }
                                    });
                </script>

                <script>
                    function enableEdit(index) {
                        // Hiện input và ẩn text
                        const fields = ['fullName', 'email', 'gender', 'phone', 'address'];
                        fields.forEach(field => {
                            document.getElementById(`${field}-text-${index}`).style.display = 'none';
                                        document.getElementById(`${field}-input-${index}`).classList.remove('d-none');
                                                });

                                                // Hiện nút "Lưu"
                                                document.getElementById(`save-btn-${index}`).classList.remove('d-none');
                                            }
                </script>

                <script>
                    function enableEdit(index) {
                        const fields = ['fullName', 'email', 'gender', 'phone', 'address'];

                        fields.forEach(field => {
                            const span = document.getElementById(`${field}-text-${index}`);
                                        const input = document.getElementById(`${field}-input-${index}`);
                                                    if (span && input) {
                                                        span.classList.add('d-none');
                                                        input.classList.remove('d-none');
                                                    }
                                                });

                                                const saveBtn = document.getElementById(`save-btn-${index}`);
                                                if (saveBtn)
                                                    saveBtn.classList.remove('d-none');

                                                const cancelBtn = document.getElementById(`cancel-btn-${index}`);
                                                if (cancelBtn)
                                                    cancelBtn.classList.remove('d-none');

                                                const editBtn = document.querySelector(`#details-${index} button[onclick*="enableEdit"]`);
                                                if (editBtn)
                                                    editBtn.classList.add('d-none'); // Ẩn nút "Chỉnh sửa"
                                            }

                </script>

                <script>
                    setTimeout(() => {
                        const alert = document.querySelector(".alert");
                        if (alert) {
                            alert.style.transition = "opacity 0.5s";
                            alert.style.opacity = 0;
                            setTimeout(() => alert.remove(), 500);
                        }
                    }, 3000);
                </script>
                </html>

