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
        <title>TSMS - Nhà cung cấp</title>
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
                    <a href="bm-overview" class="nav-item ">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item ">
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
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="request-stock" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-incoming-orders" class="dropdown-item">Theo dõi nhập hàng</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown active">
                        <a href="#" class="dropdown-toggle">
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
                        <a href="#" class="dropdown-toggle">
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

                    <div class="nav-item dropdown ">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-invoices" class="dropdown-item">Báo cáo thu thuần</a>
                            <a href="bm-outcome" class="dropdown-item">Báo cáo chi</a>
                        </div>
                    </div>

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
                            <a href="staff-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <div class="main-container">
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

                <!-- Products Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th>Mã Nhà cung cấp</th>
                                <th>Tên Công Ty</th>
                                <th>Người giao dịch</th>
                                <th>Số điện thoại</th>
                                <th>Gmail</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="supplier" items="${suppliers}">
                                <tr>
                                    <td>${supplier.supplierID}</td>
                                    <td>${supplier.supplierName}</td>
                                    <td>${supplier.contactName}</td>
                                    <td>${supplier.phone}</td>
                                    <td>${supplier.email}</td>
                                </tr>
                            </c:forEach>
                        </tbody>

                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startSupplier} - ${endSupplier} / Tổng số ${totalSuppliers} Nhà cung cấp
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
            </main>
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
    </script>
</html>

