<%@ page import="java.util.*, model.ShopOwner" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
                                >
                                    ID
                                </th>
                                <th class="name-column">Họ tên</th>
                                <th class="dtb-column">Tên Database</th>
                                <th class="shop-column">Cửa hàng</th>
                                <th class="status-column">Trạng thái</th>
                                <th class="action-column">Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            List<ShopOwner> shopOwners = (List<ShopOwner>) request.getAttribute("shopOwners");
                            for (ShopOwner shopOwner : shopOwners) {
                                boolean isActive = shopOwner.getIsActive() == 1;
                                String statusText = isActive ? "Hoạt động" : "Không hoạt động";
                                String statusClass = isActive ? "status-active" : "status-inactive";
                                String buttonLabel = isActive ? "Chặn" : "Bỏ chặn";
                            %>
                            <tr>
                                <td class="id-column"><%= shopOwner.getOwnerId() %></td>
                                <td class="name-column"><%= shopOwner.getFullName() %></td>
                                <td class="dtb-column"><%= shopOwner.getDatabaseName() %></td>
                                <td class="shop-column"><%= shopOwner.getShopName() %></td>
                                <td class="status-column">
                                    <span class="<%= statusClass %>"><%= statusText %></span>
                                </td>
                                <td class="action-column">
                                    <a href="so-details?id=<%= shopOwner.getOwnerId() %>">
                                        <button class="details-btn">Xem chi tiết</button>
                                    </a>
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
