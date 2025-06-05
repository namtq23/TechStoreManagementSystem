<%-- 
    Document   : employee
    Created on : Jun 2, 2025, 2:30:10 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Customer" %>
<%@ page import="util.Validate" %>
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
                    <a href="bm-products" class="nav-item">
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
                    <a href="bm-staff" class="nav-item ">
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
                    <a href="#" class="nav-item">
                        <i class="fas fa-shopping-cart"></i>
                        Bán Online
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
                </nav>

                <div class="header-right">
                    <a href="profile" class="user-icon gradient">
                        <i class="fas fa-user-circle fa-2x"></i>
                    </a>
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
                    </div>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Khách hàng</h1>
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
                                <th>Mã Khách Hàng</th>
                                <th>Tên Khách hàng</th>
                                <th>Số Điện Thoại</th>
                                <th>Gmail</th>
                                <th>Địa Chỉ</th>
                                  <th>Ngày tạo thông tin</th>
                                    <th>cập nhật thông tin</th>
                            </tr>
                        </thead>
                        <tbody>
<% 
    List<Customer> customers = (List<Customer>) request.getAttribute("customers");
    for (Customer customer : customers) { 
%>
<tr>
   
    <td><%= customer.getCustomerId() %></td>
    <td><%= customer.getFullName() %></td>
    <td><%= customer.getPhoneNumber() %></td>
    <td><%= customer.getEmail() != null ? customer.getEmail() : "" %></td>
    <td><%= customer.getAddress() != null ? customer.getAddress() : "" %></td>
    <td><%= Validate.formatDateTime(customer.getCreatedAt()) %></td>
    <td><%= customer.getUpdatedAt() != null ? Validate.formatDateTime(customer.getUpdatedAt()) : "" %></td>
</tr>
<% } %>


                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị 1 - 15 / Tổng số 30 khách hàng
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
    </body>
</html>

