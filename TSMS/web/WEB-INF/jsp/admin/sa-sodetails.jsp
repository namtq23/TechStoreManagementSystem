<%-- 
    Document   : sa-sodetails
    Created on : Jun 1, 2025, 5:18:16 PM
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
                <a href="sa-home" style="text-decoration: none; color: inherit;">
                    <button class="sidebar-item active">Quản lý người dùng</button>
                </a>
                <button class="sidebar-item">Thông kê người dùng</button>
                <a href="sa-logout" style="text-decoration: none">
                    <button class="sidebar-item" style="color: red">Đăng xuất</button>
                </a>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <div class="page-header">
                    <div class="breadcrumb">
                        <a href="sa-home" class="breadcrumb-link">Quản lý người dùng</a>
                        <span class="breadcrumb-separator">></span>
                        <span class="breadcrumb-current">Chi tiết chủ cửa hàng</span>
                    </div>
                    <h1 class="page-title">Chi tiết chủ cửa hàng</h1>
                </div>

                <%
                ShopOwnerDTO shopOwner = (ShopOwnerDTO) request.getAttribute("shopOwner");
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
                                <div class="info-item">
                                    <label class="info-label">ID:</label>
                                    <span class="info-value"><%= shopOwner.getOwnerId() %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Họ và tên:</label>
                                    <span class="info-value"><%= shopOwner.getFullName() %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Tên cửa hàng:</label>
                                    <span class="info-value"><%= shopOwner.getShopName() %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Tên Database:</label>
                                    <span class="info-value"><%= shopOwner.getDatabaseName() %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Email:</label>
                                    <span class="info-value"><%= shopOwner.getEmail() != null ? shopOwner.getEmail() : "Chưa cập nhật" %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Số điện thoại:</label>
                                    <span class="info-value"><%= shopOwner.getPhone() != null ? shopOwner.getPhone() : "Chưa cập nhật" %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Ngày tạo:</label>
                                    <span class="info-value"><%= shopOwner.getCreatedAt() != null ? Validate.formatDateTime(shopOwner.getCreatedAt()) : "Chưa cập nhật" %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Tình trạng tài khoản:</label>
                                    <span class="info-value"><%= shopOwner.getStatus() %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Ngày thử:</label>
                                    <span class="info-value"><%= shopOwner.getTrial() != null ? Validate.formatDateTime(shopOwner.getTrial()) : "Chưa cập nhật" %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Gói đăng ký:</label>
                                    <span class="info-value"><%= shopOwner.getSubscription() %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Ngày đăng ký:</label>
                                    <span class="info-value"><%= shopOwner.getSubscriptionStart() != null ? Validate.formatDateTime(shopOwner.getSubscriptionStart()) : "Chưa cập nhật" %></span>
                                </div>
                                <div class="info-item">
                                    <label class="info-label">Ngày hết hạn:</label>
                                    <span class="info-value"><%= shopOwner.getSubscriptionEnd() != null ? Validate.formatDateTime(shopOwner.getSubscriptionEnd()) : "Chưa cập nhật" %></span>
                                </div>
                            </div>
                        </div>
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
                                <button class="action-btn primary" onclick="editShopOwner(<%= shopOwner.getOwnerId() %>)">
                                    Chỉnh sửa thông tin
                                </button>
                                <button class="action-btn secondary" onclick="viewShopDetails(<%= shopOwner.getOwnerId() %>)">
                                    Xem chi tiết cửa hàng
                                </button>
                            </div>
                        </div>
                    </div>
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
