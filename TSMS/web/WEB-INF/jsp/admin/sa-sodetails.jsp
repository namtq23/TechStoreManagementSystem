<%-- 
    Document   : sa-sodetails
    Created on : Jun 1, 2025, 5:18:16 PM
    Author     : admin
--%>

<%@ page import="java.util.*, model.ShopOwnerDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.Validate" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Subscription Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="css/sa-home.css"/>
        <link rel="stylesheet" href="css/sa-acc-manage.css"/>
        <link rel="stylesheet" href="css/sa-sodetails.css"/>
    </head>
    <body>
        <div class="container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="logo">
                    <a href="sa-home" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">Admin</span>
                    </a>
                </div>
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="sa-home">
                                <span class="sidebar-icon"><i class="fas fa-chart-bar"></i></span>
                                <span>Dashboard</span>
                            </a></li>
                        <li><a class="active" href="sa-accounts">
                                <span class="sidebar-icon"><i class="fas fa-users"></i></span>
                                <span>Quản lý tài khoản</span>
                            </a></li>
<!--                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-dollar-sign"></i></span>
                                <span>Doanh thu</span>
                            </a></li>-->
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span>
                                <span>Subscription</span>
                            </a></li>
                        <li><a href="sa-logout">
                                <span class="sidebar-icon"><i class="fas fa-sign-out-alt"></i></span>
                                <span>Đăng xuất</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <%
                String updateStatus = request.getParameter("update");
                if ("success".equals(updateStatus)) {
                %>
                <div id="flash-message" class="flash-message success">
                    Cập nhật thành công!
                </div>
                <%
                    } else if ("error".equals(updateStatus)) {
                %>
                <div id="flash-message" class="flash-message error">
                    Cập nhật thất bại. Vui lòng thử lại.
                </div>
                <%
                    }
                %>

                <div class="content-grid">
                    <div class="card full-width-card">
                        <div class="card-header">
                            <h2>Chi tiết tài khoản</h2>
                        </div>

                        <%
                ShopOwnerDTO shopOwner = (ShopOwnerDTO) request.getAttribute("shopOwner");
                if (shopOwner != null) {
                    boolean isActive = shopOwner.getIsActive() == 1;
                    String statusText = isActive ? "Hoạt động" : "Không hoạt động";
                    String statusClass = isActive ? "status-active" : "status-inactive";
                        %>

                        <form action="sa-soUpdate" method="post" class="edit-form">
                            <div class="details-card">
                                <div class="card-content">
                                    <div class="info-grid">
                                        <input type="hidden" name="ownerId" value="<%= shopOwner.getOwnerId() %>"/>

                                        <div class="info-item">
                                            <label class="info-label">Họ và tên*:</label>
                                            <input type="text" name="fullName" class="info-input" value="<%= shopOwner.getFullName() %>" required/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Tên cửa hàng*:</label>
                                            <input type="text" name="shopName" class="info-input" value="<%= shopOwner.getShopName() %>" required/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Tên Database:</label>
                                            <input type="text" name="databaseName" class="info-input" value="<%= shopOwner.getDatabaseName() %>" readonly/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Email:</label>
                                            <input type="email" name="email" class="info-input" value="<%= shopOwner.getEmail() != null ? shopOwner.getEmail() : "" %>" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Số điện thoại:</label>
                                            <input type="text" name="phone" class="info-input" value="<%= shopOwner.getPhone() != null ? shopOwner.getPhone() : "" %>" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày tạo:</label>
                                            <input type="date" class="info-input" value="<%= Validate.toInputDate(shopOwner.getCreatedAt()) %>" readonly />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Tình trạng tài khoản*:</label>
                                            <select name="status" class="info-input">
                                                <option value="ACTIVE" <%= shopOwner.getIsActive() == 1 ? "selected" : "" %>>Hoạt động</option>
                                                <option value="INACTIVE" <%= shopOwner.getIsActive() == 0 ? "selected" : "" %>>Không hoạt động</option>
                                            </select>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày thử:</label>
                                            <input type="date" name="trial" class="info-input"
                                                   value="<%= shopOwner.getTrial() != null ? Validate.toInputDate(shopOwner.getTrial()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày hết hạn thử:</label>
                                            <input type="date" name="trial" class="info-input"
                                                   value="<%= shopOwner.getTrialEnd() != null ? Validate.toInputDate(shopOwner.getTrialEnd()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Gói đăng ký:</label>
                                            <input type="text" name="subscription" class="info-input" value="<%= shopOwner.getSubscription() %> tháng" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày đăng ký:</label>
                                            <input type="date" name="subscriptionStart" class="info-input"
                                                   value="<%= shopOwner.getSubscriptionStart() != null ? Validate.toInputDate(shopOwner.getSubscriptionStart()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày hết hạn:</label>
                                            <input type="date" name="subscriptionEnd" class="info-input"
                                                   value="<%= shopOwner.getSubscriptionEnd() != null ? Validate.toInputDate(shopOwner.getSubscriptionEnd()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Mã số thuế:</label>
                                            <input type="text" name="taxNumber" class="info-input" value="<%= shopOwner.getTaxNumber() != null ?  shopOwner.getTaxNumber() : "Chưa cập nhật"%>" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Website:</label>
                                            <input type="text" name="webUrl" class="info-input" value="<%= shopOwner.getWebUrl() != null ?  shopOwner.getWebUrl() : "Chưa cập nhật"%>" readonly=""/>
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
                                        <button type="submit" class="action-btn primary">Cập nhật</button>
                                        <a href="sa-accounts" class="action-btn">Hủy</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <% } else { %>
                        <div class="error-message">
                            <h2>Không tìm thấy thông tin chủ cửa hàng</h2>
                            <p>Chủ cửa hàng với ID được yêu cầu không tồn tại trong hệ thống.</p>
                            <a href="sa-home" class="back-btn">Quay lại danh sách</a>
                        </div>
                        <% } %>
                    </div> 
                </div>
            </div>   
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Optional: Animation for cards
                const cards = document.querySelectorAll('.card, .stat-card');
                cards.forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-2px)';
                    });
                    card.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });
                });
            });
        </script>
    </body>
</html>