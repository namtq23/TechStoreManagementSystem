<%@ page import="java.util.*, model.ShopOwnerSADTO, model.SubscriptionsDTO, model.SubscriptionLogDTO, util.Validate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="css/sa-home.css"/>
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
                            </a>
                        </li>
                        <li><a href="sa-accounts">
                                <span class="sidebar-icon"><i class="fas fa-users"></i></span>
                                <span>Quản lý tài khoản</span>
                            </a>
                        </li>
<!--                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-dollar-sign"></i></span>
                                <span>Doanh thu</span>
                            </a>
                        </li>-->
                        <li><a href="sa-subscriptions">
                                <span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span>
                                <span>Subscription</span>
                            </a>
                        </li>
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
                <!-- Header -->
                <div class="header">
                    <h1>Dashboard Tổng quan</h1>
                </div>

                <%
                ShopOwnerSADTO so = (ShopOwnerSADTO) request.getAttribute("so");
                %>
                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-card-title">Doanh thu tháng này</div>
                            <div class="stat-card-icon revenue">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                        </div>
                        <h3><%= Validate.formatCostPriceToVND(so.getRevenueThisMonth()) %> ₫</h3>

                        <%
                            String revenueGrowth = Validate.formatGrowthPercent(so.getRevenueGrowthPercent());
                            String color = revenueGrowth.startsWith("+") ? "green" : "red";
                        %>

                        <div class="change" style="color: <%= color %>;">
                            <%= revenueGrowth %>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-card-title">Tổng người dùng</div>
                            <div class="stat-card-icon users">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <h3><%= so.getTotalUsersThisMonth() %></h3>
                        <%
                            String userGrowth = Validate.formatGrowthPercent(so.getUserGrowthPercent());
                            String color1 = userGrowth.startsWith("+") ? "green" : "red";
                        %>

                        <div class="change" style="color: <%= color1 %>;">
                            <%= userGrowth %>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-card-title">Subscription đang hoạt động</div>
                            <div class="stat-card-icon subscriptions">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                        </div>
                        <h3><%= so.getActiveSubscribersThisMonth() %></h3>
                        <%
                            String subsGrowth = Validate.formatGrowthPercent(so.getActiveSubscribersGrowthPercent());
                            String color2 = userGrowth.startsWith("+") ? "green" : "red";
                        %>

                        <div class="change" style="color: <%= color2 %>;">
                            <%= subsGrowth %>
                        </div>
                    </div>
                </div>

                <div class="content-grid">
                    <div class="card">
                        <div class="card-header">
                            <h2>Yêu cầu gia hạn</h2>
                        </div>

                        <% 
                        List<SubscriptionLogDTO> logs = (List<SubscriptionLogDTO>) request.getAttribute("subscriptionLogs");
                        if (logs != null) {
                            for (SubscriptionLogDTO log : logs) {
                                String status = log.getStatus();
                                if ("Pending".equalsIgnoreCase(status) || "Done".equalsIgnoreCase(status)) {
                                    String iconClass = status.equalsIgnoreCase("Pending") ? "user" : "payment";
                                    String actionText = status.equalsIgnoreCase("Pending") ? "đã yêu cầu đăng ký gói" : "đã thanh toán thành công gói";
                        %>

                        <div class="activity-item">
                            <div class="activity-icon <%= iconClass %>">
                                <i class="fas fa-<%= iconClass.equals("user") ? "user-plus" : "credit-card" %>"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">
                                    <%= log.getOwnerName() %> <%= actionText %>: <%= log.getSubscriptionName() %> - <%= log.getSubscriptionPrice() %> đ
                                </div>
                                <div class="activity-time"><%= Validate.formatTimeAgo(log.getMinutesAgo()) %></div>
                            </div>
                        </div>

                        <%      
                                }
                            }
                        } else { %>
                        <p>Không có hoạt động nào.</p>
                        <% } %>
                    </div>
                </div>



                <!-- Subscription Plans -->
                <div class="card full-width-card" style="margin-top: 24px;">
                    <div class="card-header">
                        <h2>Thống kê gói Subscription</h2>
                    </div>

                    <%
                        List<SubscriptionsDTO> subsList = (List<SubscriptionsDTO>) request.getAttribute("subsList");
                        if (subsList != null && !subsList.isEmpty()) {
                    %>
                    <div class="subscription-stats" style="display: flex; gap: 16px;">
                        <% for (SubscriptionsDTO sub : subsList) { %>
                        <div class="subscription-stat" style="padding: 12px; border: 1px solid #ccc; border-radius: 8px; flex: 1; text-align: center;">
                            <h3><%= sub.getTotalUsers() %> người dùng</h3>
                            <p>Gói:    <%= sub.getSubscriptionName() %> - <%= sub.getSubscriptionPrice() %> ₫</p>
                        </div>
                        <% } %>
                    </div>
                    <%
                        } else {
                    %>
                    <p style="padding: 16px;">Không có dữ liệu gói subscription.</p>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const sidebarLinks = document.querySelectorAll('.sidebar-nav a');
            const currentPath = window.location.pathname;

            sidebarLinks.forEach(link => {
                const href = link.getAttribute('href');
                // So khớp tương đối với pathname
                if (href && currentPath.includes(href)) {
                    link.classList.add('active');
                } else {
                    link.classList.remove('active');
                }
            });

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