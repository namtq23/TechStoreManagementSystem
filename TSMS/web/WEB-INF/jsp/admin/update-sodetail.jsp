<%-- 
    Document   : update-sodetail
    Created on : Jun 22, 2025, 11:19:55 PM
    Author     : admin
--%>

<%@ page import="model.ShopOwnerDTO" %>
<%@ page import="util.Validate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết chủ cửa hàng - TSMS</title>
        <link rel="stylesheet" type="text/css" href="css/sa-home.css">
        <link rel="stylesheet" type="text/css" href="css/sa-sodetails.css">
        <link rel="stylesheet" type="text/css" href="css/sa-update-so-detail.css">
    </head>
    <body>
        <%
        ShopOwnerDTO shopOwner = (ShopOwnerDTO) request.getAttribute("shopOwner");
        %>
        <div class="container">
            <!-- Header -->
            <div class="header">
                <div class="logo">
                    <a href="sa-home" style="text-decoration: none; color: #4285f4; font-weight: bold">ADMIN</a>
                </div>
                <a href="sa-logout" style="text-decoration: none"><button class="sidebar-item" style="color: red">Đăng xuất</button></a>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="page-header">
                    <div class="breadcrumb">
                        <a href="sa-home" class="breadcrumb-link">Quản lý người dùng</a>
                        <span class="breadcrumb-separator">></span>
                        <a href="sa-sodetails?id=<%= shopOwner.getOwnerId() %>" class="breadcrumb-link">Chi tiết chủ cửa hàng</a>
                        <span class="breadcrumb-separator">></span>
                        <span class="breadcrumb-current">Chỉnh sửa thông tin chủ cửa hàng</span>
                    </div>
                    <h1 class="page-title">Chỉnh sửa thông tin chủ cửa hàng</h1>
                </div>

                <%
                if (shopOwner != null) {
                    boolean isActive = shopOwner.getIsActive() == 1;
                    String statusText = isActive ? "Hoạt động" : "Không hoạt động";
                    String statusClass = isActive ? "status-active" : "status-inactive";
                %>

                <div class="details-container">
                    <div class="details-card">
                        <div class="card-header">
                            <h2>Thông tin cơ bản</h2>
                            <div class="status-badge">
                                <span class="<%= statusClass %>"><%= statusText %></span>
                            </div>
                        </div>
                        <div class="card-content">
                            <div class="info-grid">
                                <form action="sa-soUpdate" method="post">
                                    <input class="info-value" name="ownerId" value="<%= shopOwner.getOwnerId() %>" hidden="">
                                    <div class="info-item">
                                        <label class="info-label">Họ và tên:</label>
                                        <input class="info-value" name="fullName" value="<%= shopOwner.getFullName() %>">
                                    </div>
                                    <div class="info-item">
                                        <label class="info-label">Tên cửa hàng:</label>
                                        <input class="info-value" name="shopName" value="<%= shopOwner.getShopName() %>">
                                    </div>
                                    <div class="info-item">
                                        <label class="info-label">Gói đăng ký:</label>
                                        <select name="subscription" id="subscription">
                                            <option value="<%= shopOwner.getSubscription() %>" selected><%= shopOwner.getSubscription() %> tháng</option>
                                            <option value="1">3 tháng</option>
                                            <option value="2">6 tháng</option>
                                            <option value="3">12 tháng</option>
                                            <option value="4">24 tháng</option>
                                        </select>
                                    </div>
                                    <div class="actions-card">
                                        <div class="card-header">
                                            <h2>Hành động</h2>
                                        </div>
                                        <div class="card-content">
                                            <div class="action-buttons">
                                                <% if (isActive) { %>
                                                <button class="action-btn danger" onclick="toggleStatus(<%= shopOwner.getOwnerId() %>, false)">
                                                    Chặn tài khoản
                                                </button>
                                                <% } else { %>
                                                <button class="action-btn success" onclick="toggleStatus(<%= shopOwner.getOwnerId() %>, true)">
                                                    Bỏ chặn tài khoản
                                                </button>
                                                <% } %>
                                                <button class="action-btn primary" type="submit" style="background-color: green">
                                                    Cập nhật
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>



                    <% if(request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="none" title="Error"><path fill-rule="evenodd" clip-rule="evenodd" d="M8 14.667A6.667 6.667 0 1 0 8 1.333a6.667 6.667 0 0 0 0 13.334z" fill="#D00E17" stroke="#D00E17" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path><path fill-rule="evenodd" clip-rule="evenodd" d="M8 4.583a.75.75 0 0 1 .75.75V8a.75.75 0 0 1-1.5 0V5.333a.75.75 0 0 1 .75-.75z" fill="#fff"></path><path d="M8.667 10.667a.667.667 0 1 1-1.334 0 .667.667 0 0 1 1.334 0z" fill="#fff"></path></svg>
                        <span><%= request.getAttribute("error") %></span>
                    </div>
                    <% } %>

                    <% if(request.getAttribute("success") != null) { %>
                    <div class="success-message">
                        <span><%= request.getAttribute("success") %></span>
                    </div>
                    <% } %>
                </div>

                <% } else { %>
                <div class="error-message">
                    <h2>Không tìm thấy thông tin chủ cửa hàng</h2>
                    <p>Chủ cửa hàng với ID được yêu cầu không tồn tại trong hệ thống.</p>
                    <a href="sa-home" class="back-btn">Quay lại danh sách</a>
                </div>
                <% } %>
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
        </script>
    </body>
</html>
