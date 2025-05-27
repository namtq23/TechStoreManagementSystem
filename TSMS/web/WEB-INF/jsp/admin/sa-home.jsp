<%-- 
    Document   : adhomepage
    Created on : May 26, 2025, 4:21:02 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.UserDTO" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Admin - TSMS</title>
        <link rel="stylesheet" type="text/css" href="css/sa-home.css">
    </head>
    <body>
        <div class="container">
            <!-- Header -->
            <div class="header">
                <div class="logo">
                    <a href="sa-home" style="text-decoration: none; color: #4285f4">TechStore Management System</a>
                </div>
                <!--<div class="user-avatar">👤</div>-->
            </div>

            <!-- Sidebar -->
            <div class="sidebar">
                <button class="sidebar-item active">Quản lý người dùng</button>
                <button class="sidebar-item">Thông kê người dùng</button>
                <a href="sa-logout" style="text-decoration: none"><button class="sidebar-item" style="color: red">Đăng xuất</button></a>

            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="page-header">
                    <h1 class="page-title">Tài khoản</h1>
                    <div class="controls">
                        <div class="search-box">
                            <input type="text" class="search-input" placeholder="Tìm kiếm tài khoản...">
                        </div>
                        <select class="filter-select">
                            <option>Vai trò</option>
                            <option>Chủ Cửa Hàng</option>
                            <option>Quản Lý Chi Nhánh</option>
                            <option>Nhân viên bán hàng</option>
                        </select>
                        <select class="filter-select">
                            <option>Tất cả</option>
                            <option>Active</option>
                            <option>Inactive</option>
                        </select>

                        <button class="add-btn">Lọc</button>
                    </div>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th 
                                    class="id-column" style="
                                    padding-left: 24px;"
                                    >ID
                                </th>
                                <th class="name-column">Họ tên</th>
                                <th class="role-column">Vai trò</th>
                                <th class="shop-column">Cửa hàng</th>
                                <th class="status-column">Trạng thái</th>
                                <th class="action-column"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            List<UserDTO> users = (List<UserDTO>) request.getAttribute("users");
                            for (UserDTO user : users) {
                                String roleName = "";
                                switch (user.getRole()) {
                                    case 1:
                                        roleName = "Chủ cửa hàng";
                                        break;
                                    case 2:
                                        roleName = "Quản lý chi nhánh";
                                        break;
                                    case 3:
                                        roleName = "Nhân viên bán hàng";
                                        break;
                                }

                                boolean isActive = user.getIsActive() == 1;
                                String statusText = isActive ? "Hoạt động" : "Không hoạt động";
                                String statusClass = isActive ? "status-active" : "status-inactive";
                                String buttonLabel = isActive ? "Chặn" : "Bỏ chặn";
                            %>
                            <tr>
                                <td class="id-column"><%= user.getAccountId() %></td>
                                <td class="name-column"><%= user.getFullName() %></td>
                                <td class="role-column"><%= roleName %></td>
                                <td class="shop-column"><%= user.getShopName() %></td>
                                <td class="status-column">
                                    <span class="<%= statusClass %>"><%= statusText %></span>
                                </td>
                                <td class="action-column">
                                    <form action="toggleUserStatus" method="post" style="display:inline;">
                                        <input type="hidden" name="email" value="<%= user.getEmail() %>"/>
                                        <input type="hidden" name="isActive" value="<%= user.getIsActive() %>"/>
                                        <button type="submit" class="edit-btn"><%= buttonLabel %></button>
                                    </form>
                                </td>
                            </tr>
                            <% } %>

                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <script>
            // Sidebar navigation
            document.querySelectorAll('.sidebar-item').forEach(item => {
                item.addEventListener('click', function () {
                    document.querySelectorAll('.sidebar-item').forEach(i => i.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Search functionality
            document.querySelector('.search-input').addEventListener('input', function () {
                const searchTerm = this.value.toLowerCase();
                const rows = document.querySelectorAll('.table tbody tr');

                rows.forEach(row => {
                    const name = row.querySelector('.name-column').textContent.toLowerCase();
                    if (name.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });

            // Filter functionality
            document.querySelectorAll('.filter-select').forEach(select => {
                select.addEventListener('change', function () {
                    console.log('Filter changed:', this.value);
                    // Implement filtering logic here
                });
            });
        </script>
    </body>
</html>
