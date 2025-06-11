<%-- 
    Document   : employee
    Created on : Jun 2, 2025, 2:30:10 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Customer" %>
<%@ page import="util.Validate" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                    <a href="#" class="logo">
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
                    <a href="#" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Giao dịch
                    </a>
                    <a href="bm-customer" class="nav-item active">
                        <i class="fas fa-handshake"></i>
                        Đối tác
                    </a>
                    <a href="bm-staff" class="nav-item">
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
                    <a href="bm-cart" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
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
<<<<<<< Updated upstream
                        <form action="action">
                            <label class="checkbox-item">
                                <input type="radio" id="active" name="employeeStatus" value="active" checked="">
                                <span for="active">Tổng hợp</span><br>
                                
                            </label>
                            <label class="checkbox-item">
                                <input type="radio" id="inactive" name="employeeStatus" value="inactive">
                                <span for="inactive">Tiềm năng</span><br>
                            </label>
                        </form>
=======
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
>>>>>>> Stashed changes
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
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>Mã Khách Hàng</th>
                                <th>Tên Khách hàng</th>
                                <th>Số Điện Thoại</th>
                                <th>Gmail</th>
                                <th>Địa Chỉ</th>
                                <th>Giới Tính</th>
                                <th>Số tiền đã chi</th>
                                <th>Ngày tạo thông tin</th>
                                
                            </tr>
                        </thead>
                        <tbody>
<c:forEach var="customer" items="${customers}">
<tr>
    <td>${customer.customerId}</td>
    <td>${customer.fullName}</td>
    <td>${customer.phoneNumber}</td>
    <td>${customer.email}</td>
    <td>${customer.address}</td>
    <td>${customer.gender ? 'Nam' : 'Nữ'}</td>
    <td><fmt:formatNumber value="${customer.grandTotal}" type="number" groupingUsed="true" /> ₫</td>
    <td>${customer.createdAt}</td>
</tr>
</c:forEach>





                        </tbody>
                    </table>
                </div>

<!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startCustomer} - ${endCustomer} / Tổng số ${totalProducts} Khách hàng
                    </div>
                    <div class="pagination">
                        <a href="bm-customer?page=1" class="page-btn ${currentPage == 1 ? "disabled" : ""}"> 
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="bm-customer?page=${currentPage - 1}" class="page-btn ${currentPage == 1 ? "disabled" : ""}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="bm-customer?page=${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <a href="bm-customer?page=${currentPage + 1}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="bm-customer?page=${totalPages}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>
        <!-- Support Chat Button -->
        <div class="support-chat">
            <i class="fas fa-headset"></i>
            <span>Hỗ trợ:1900 9999</span>
        </div>
    </body>
</html>

