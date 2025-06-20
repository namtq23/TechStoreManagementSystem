<%-- 
    Document   : employee
    Created on : Jun 2, 2025, 2:30:10 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.User" %>
<%@ page import="util.Validate" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Nhân Viên</title>
        <link rel="stylesheet" href="css/bm-products.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="../common/header-bm.jsp" />

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <!--Product Type Filter--> 
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Trạng thái nhân viên</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <form action="action">
                            <label class="checkbox-item">
                                <input type="radio" id="active" name="employeeStatus" value="active" checked="">
                                <span for="active">Đang làm việc</span><br>
                            </label>
                            <label class="checkbox-item">
                                <input type="radio" id="inactive" name="employeeStatus" value="inactive">
                                <span for="inactive">Nghỉ việc</span><br>
                            </label>
                        </form>
                    </div>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Nhân viên</h1>
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
                                <th>Mã nhân viên</th>
                                <th>Tên nhân viên</th>
                                <th>Chức danh</th>
                                <th>Số điện thoại</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>

                            <% List<User> users = (List<User>) request.getAttribute("staffs");
                                for (User user : users) { %>
                            <tr class="">
                                <td>NV<%= user.getUserID() %></td>
                                <td><%= user.getFullName() %></td>
                                <td>Nhân viên bán hàng</td>
                                <td><%= user.getPhone() %></td>
                                <td><%= user.getIsActive() == 1 ? "Đang hoạt động" : "Không hoạt động"%></td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị 1 - 15 / Tổng số 30 nhân viên
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

