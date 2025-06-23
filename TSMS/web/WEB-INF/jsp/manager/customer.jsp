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
        <link rel="stylesheet" href="css/bm-staff.css">
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
                <!--Product Type Filter--> 
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Trạng thái khách hàng</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>

                    <div class="filter-content">

                        <form action="bm-customer" method="get">
                            <label class="checkbox-item">
                                <input type="radio" name="top" value="" 
                                       <%= request.getParameter("top") == null ? "checked" : "" %>>
                                <span>Tổng hợp</span><br>
                            </label>
                            <label class="checkbox-item">
                                <input type="radio" name="top" value="true" 
                                       <%= "true".equals(request.getParameter("top")) ? "checked" : "" %>>
                                <span>Tiềm năng</span><br>
                            </label>

                            <button type="submit" class="btn btn-primary btn-sm mt-2">Lọc</button>
                        </form>

                    </div>

                </div>
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Giới tính khách hàng</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <form action="bm-customer" method="get">
                            <label class="checkbox-item">
                                <input type="radio" id="gender-all" name="gender" value="all"
                                       <%= request.getParameter("gender") == null || "all".equals(request.getParameter("gender")) ? "checked" : "" %>>
                                <span for="gender-all">Tổng hợp</span><br>
                            </label>

                            <label class="checkbox-item">
                                <input type="radio" id="gender-male" name="gender" value="male"
                                       <%= "male".equals(request.getParameter("gender")) ? "checked" : "" %>>
                                <span for="gender-male">Nam</span><br>
                            </label>

                            <label class="checkbox-item">
                                <input type="radio" id="gender-female" name="gender" value="female"
                                       <%= "female".equals(request.getParameter("gender")) ? "checked" : "" %>>
                                <span for="gender-female">Nữ</span><br>
                            </label>

                            <button type="submit" class="btn btn-primary btn-sm mt-2">Lọc</button>
                        </form>
                    </div>

                </div>
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
                                <th>Gmail</th>
                                <th>Địa Chỉ</th>
                                <th>Giới Tính</th>
                                <th>Tổng tiền đã chi</th>
                                <th>Ngày tạo thông tin</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="customer" items="${customers}" varStatus="loop">
                                <!-- Dòng chính -->
                                <tr onclick="toggleDetails(${loop.index})" style="cursor: pointer;">
                                    <td>${customer.customerId}</td>
                                    <td>${customer.fullName}</td>
                                    <td>${customer.phoneNumber}</td>
                                    <td>${customer.email}</td>
                                    <td>${customer.address}</td>
                                    <td>${customer.gender ? 'Nam' : 'Nữ'}</td>
                                    <td><fmt:formatNumber value="${customer.grandTotal}" type="number" groupingUsed="true"/> ₫</td>
                                    <td>${customer.createdAt}</td>
                                </tr>

                                <!-- Dòng chi tiết ẩn -->
                                <tr id="details-${loop.index}" class="detail-row" style="display: none;">
                                    <td colspan="8">
                                        <div class="border rounded p-3 bg-light">
                                            <!-- Tabs -->
                                            <ul class="nav nav-tabs mb-3">
                                                <li class="nav-item">
                                                    <a class="nav-link active" data-bs-toggle="tab" href="#info-${loop.index}">Thông tin</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-bs-toggle="tab" href="#address-${loop.index}">Địa chỉ nhận hàng</a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" data-bs-toggle="tab" href="#debt-${loop.index}">Nợ cần thu từ khách</a>
                                                </li>
                                            </ul>

                                            <div class="tab-content">
                                                <!-- Tab Thông tin -->
                                                <div class="tab-pane fade show active" id="info-${loop.index}">
                                                    <div class="row">
                                                        <!-- Ảnh -->
                                                        <div class="col-md-3 text-center">
                                                            <img src="https://via.placeholder.com/250x250?text=Ảnh" class="img-fluid border rounded" alt="Avatar" />
                                                        </div>
                                                        <!-- Thông tin -->
                                                        <div class="col-md-9">
                                                            <div class="row">
                                                                <div class="col-md-6">
                                                                    <p><strong>Mã KH:</strong> ${customer.customerId}</p>
                                                                    <p><strong>Tên khách:</strong> ${customer.fullName}</p>
                                                                    <p><strong>Email:</strong> ${customer.email}</p>
                                                                    <p><strong>Giới tính:</strong> ${customer.gender ? 'Nam' : 'Nữ'}</p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <p><strong>SĐT:</strong> ${customer.phoneNumber}</p>
                                                                    <p><strong>Địa chỉ:</strong> ${customer.address}</p>
                                                                    <p><strong>Ngày tạo:</strong> ${customer.createdAt}</p>
                                                                    <p><strong>Tổng chi tiêu:</strong> <fmt:formatNumber value="${customer.grandTotal}" type="number" groupingUsed="true"/> ₫</p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Tab Địa chỉ -->
                                                <div class="tab-pane fade" id="address-${loop.index}">
                                                    <p>Chưa có dữ liệu địa chỉ nhận hàng.</p>
                                                </div>

                                                <!-- Tab Nợ -->
                                                <div class="tab-pane fade" id="debt-${loop.index}">
                                                    <p>Chưa có dữ liệu công nợ.</p>
                                                </div>
                                            </div>

                                            <!-- Nút hành động -->
                                            <div class="mt-3 d-flex gap-2 justify-content-start flex-wrap">
                                                <button class="btn btn-success">
                                                    <i class="bi bi-check-circle"></i> Cập nhật
                                                </button>
                                                <button class="btn btn-danger">
                                                    <i class="bi bi-lock-fill"></i> Ngừng hoạt động
                                                </button>
                                                <button class="btn btn-danger">
                                                    <i class="bi bi-trash"></i> Xóa
                                                </button>
                                            </div>

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
                        Hiển thị ${startCustomer} - ${endCustomer} / Tổng số ${totalProducts} Khách hàng
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




                </html>

