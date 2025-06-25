<%-- 
    Document   : employee
    Created on : Jun 2, 2025, 2:30:10 PM
    Author     : admin
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
        <link rel="stylesheet" href="css/khachhang.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="bm-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="bm-overview" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Đơn hàng</a>
                            <a href="#" class="dropdown-item">Nhập hàng</a>
                            <a href="#" class="dropdown-item">Yêu cầu nhập hàng</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown active">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-customer" class="dropdown-item">Khách hàng</a>
                            <a href="bm-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-staff" class="dropdown-item">Danh sách nhân viên</a>
                            <a href="#" class="dropdown-item">Hoa hồng</a>
                        </div>
                    </div>    
                    <a href="bm-promotions" class="nav-item">
                        <i class="fas fa-ticket"></i>
                        Khuyến mãi
                    </a>
                    
                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Tài chính</a>
                            <a href="#" class="dropdown-item">Đật hàng</a>
                            <a href="#" class="dropdown-item">Hàng hoá</a>
                            <a href="#" class="dropdown-item">Khách hàng</a>
                        </div>
                    </div>

                    <a href="bm-cart" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="profile" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
        </header>

        <div class="main-container">


<!-- Sidebar -->
<aside class="sidebar">
    <form action="bm-customer" method="get">
        <!-- Thêm dòng này để kích hoạt lọc theo khoảng giá -->
        <input type="hidden" name="showTop" value="true" />

        <!-- Category Filter -->
        <div class="filter-section">
            <div class="filter-header">
                <h3>Nhóm khách hàng</h3>
            </div>
            <div class="filter-content">
                <div class="category-tree">
                    <div class="category-item">
                        <input type="checkbox" id="all-categories" name="categories" value="all">
                        <label for="all-categories" class="category-label">
                            <span>Tất cả</span>
                        </label>
                    </div>
                </div>
            </div>
        </div>

        <!-- Price Range Filter -->
        <div class="filter-section">
            <div class="filter-header">
                <h3>Khoảng chi tiêu</h3>
            </div>
            <div class="filter-content">
                <div class="price-range">
                    <input type="number" name="minGrandTotal" placeholder="Số tiền chi từ"
                           value="${minGrandTotal}" class="GrandTotal-input">
                    <input type="number" name="maxGrandTotal" placeholder="Số tiền chi đến"
                           value="${maxGrandTotal}" class="GrandTotal-input">
                </div>
            </div>
        </div>

        <!-- Status Filter -->
        <div class="filter-section">
            <div class="filter-header">
                <h3>Giới tính</h3>
            </div>
            <div class="filter-content">
                <label class="radio-item">
                    <input type="radio" name="gender" value="all">
                    <span class="radio-mark"></span> Tất cả
                </label>
                <label class="radio-item">
                    <input type="radio" id="gender-male" name="gender" value="male"
                           <%= "male".equals(request.getParameter("gender")) ? "checked" : "" %>>
                    <span class="radio-mark">Nam</span><br>
                </label>
                <label class="radio-item"> 
                    <input type="radio" id="gender-female" name="gender" value="female"
                           <%= "female".equals(request.getParameter("gender")) ? "checked" : "" %>>
                    <span class="radio-mark">Nữ</span><br>
                </label>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="filter-actions">
            <a href="bm-customer?page=1" class="btn-clear">
                <i class="fas fa-eraser"></i> Xóa bộ lọc
            </a>
            <button type="submit" class="btn-apply">
                <i class="fas fa-filter"></i> Áp dụng lọc
            </button>
        </div>
    </form>
</aside>


            </aside> 
                             
            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Khách hàng</h1>
                    <div class="header-actions">

                        <form action="bm-customer" method="get" class="search-container">
                            <i class="fas fa-search"></i>
                            <input type="text" name="keyword" placeholder="Theo mã, tên khách hàng" class="search-input"
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
                <!-- Products Table -->
                <div class="table-container">
                    <table class="products-table table table-bordered">
                        <thead class="table-light">
                            <tr>
                                <th>Mã Khách Hàng</th>
                                <th>Tên Khách hàng</th>
                                <th>Số Điện Thoại</th>
<!--                                <th>Gmail</th>
-->                                <th>Địa Chỉ</th><!--
                                <th>Giới Tính</th>-->
                                <th>Tổng tiền đã chi</th>
<!--                                <th>Ngày tạo thông tin</th>-->
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${customers}" varStatus="loop">
                                <!-- Dòng chính -->
                                <tr onclick="toggleDetails(${loop.index})" style="cursor: pointer;">
                                    <td>${customer.customerId}</td>
                                    <td>${customer.fullName}</td>
                                    <td>${customer.phoneNumber}</td>
<!--                                    <td>${customer.email}</td>
-->                                    <td>${customer.address}</td><!--
                                    <td>${customer.gender ? 'Nam' : 'Nữ'}</td>-->
                                    <td><fmt:formatNumber value="${customer.grandTotal}" type="number" groupingUsed="true"/> ₫</td>
<!--                                    <td>${customer.createdAt}</td>-->
                                </tr>
                                
<tr id="details-${loop.index}" class="detail-row" style="display: none;">
    <td colspan="8">
        <div class="border rounded p-3 bg-light">
            <form method="post" action="bm-customer">
                <input type="hidden" name="id" value="${customer.customerId}" />

                <div class="row">
                    <!-- Cột trái: ảnh -->
                    <div class="col-md-3 text-center">
                        <img src="https://via.placeholder.com/250x250?text=Ảnh"
                             class="img-fluid border rounded" alt="Avatar" />
                    </div>

                    <!-- Cột phải: thông tin -->
                    <div class="col-md-9">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Mã KH:</strong> ${customer.customerId}</p>

                                <p><strong>Tên khách:</strong>
                                    <input type="text" name="fullName" class="form-control"
                                           value="${customer.fullName}" />
                                </p>

                                <p><strong>Email:</strong>
                                    <input type="email" name="email" class="form-control"
                                           value="${customer.email}" />
                                </p>

                                <p><strong>Giới tính:</strong>
                                    <select name="gender" class="form-control">
                                        <option value="true" ${customer.gender ? 'selected' : ''}>Nam</option>
                                        <option value="false" ${!customer.gender ? 'selected' : ''}>Nữ</option>
                                    </select>
                                </p>
                            </div>

                            <div class="col-md-6">
                                <p><strong>SĐT:</strong>
                                    <input type="text" name="phoneNumber" class="form-control"
                                           value="${customer.phoneNumber}" />
                                </p>

                                <p><strong>Địa chỉ:</strong>
                                    <input type="text" name="address" class="form-control"
                                           value="${customer.address}" />
                                </p>

                                <p><strong>Ngày tạo:</strong>
                                    <fmt:formatDate value="${customer.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>

                                <p><strong>Cập nhật lần cuối:</strong>
                                    <fmt:formatDate value="${customer.updatedAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>

                                <p><strong>Tổng chi tiêu:</strong>
                                    <fmt:formatNumber value="${customer.grandTotal}" type="number" groupingUsed="true" /> ₫
                                </p>
                            </div>
                        </div>

                        <!-- Nút hành động -->
                        <div class="mt-2 text-end">
                            <button type="submit" class="btn btn-sm btn-success">Lưu</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </td>
</tr>





                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container mt-3 d-flex justify-content-between align-items-center">
                    <div class="pagination-info">
                        Hiển thị ${startCustomer} - ${endCustomer} / Tổng số ${totalCustomers} Khách hàng
                    </div>
                    <div class="pagination">
                        <a href="bm-customer?page=1" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="bm-customer?page=${currentPage - 1}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="bm-customer?page=${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="bm-customer?page=${currentPage + 1}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="bm-customer?page=${totalPages}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
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
    if (saveBtn) saveBtn.classList.remove('d-none');

    const cancelBtn = document.getElementById(`cancel-btn-${index}`);
    if (cancelBtn) cancelBtn.classList.remove('d-none');

    const editBtn = document.querySelector(`#details-${index} button[onclick*="enableEdit"]`);
    if (editBtn) editBtn.classList.add('d-none'); // Ẩn nút "Chỉnh sửa"
}

</script>
                
                
                
                
 </html>

 
 
 
 
 
 