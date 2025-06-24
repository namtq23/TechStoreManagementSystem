<%@ page import="java.util.*, model.ShopOwner" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Subscription Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="css/sa-home.css"/>
    </head>
    <body>
        <div class="container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <h2>Admin Panel</h2>
                </div>
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="#" class="active">
                                <span class="sidebar-icon"><i class="fas fa-chart-bar"></i></span>
                                <span>Dashboard</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-users"></i></span>
                                <span>Quản lý tài khoản</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-dollar-sign"></i></span>
                                <span>Doanh thu</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span>
                                <span>Subscription</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-chart-line"></i></span>
                                <span>Báo cáo</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-cog"></i></span>
                                <span>Cài đặt</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-sign-out-alt"></i></span>
                                <span>Đăng xuất</span>
                            </a></li>
                    </ul>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <div class="header">
                    <h1>Dashboard Tổng quan</h1>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-card-title">Doanh thu tháng này</div>
                            <div class="stat-card-icon revenue">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                        </div>
                        <h3>₫2,450,000</h3>
                        <div class="change">+12.5% so với tháng trước</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-card-title">Tổng người dùng</div>
                            <div class="stat-card-icon users">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                        <h3>1,234</h3>
                        <div class="change">+5.2% so với tháng trước</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-card-header">
                            <div class="stat-card-title">Subscription đang hoạt động</div>
                            <div class="stat-card-icon subscriptions">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                        </div>
                        <h3>856</h3>
                        <div class="change">+8.1% so với tháng trước</div>
                    </div>
                </div>

                <!-- Content Grid -->
                <div class="content-grid">
                    <!-- Recent Activities -->
                    <div class="card">
                        <div class="card-header">
                            <h2>Hoạt động gần đây</h2>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon user">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Người dùng mới đăng ký</div>
                                <div class="activity-time">2 phút trước</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon payment">
                                <i class="fas fa-credit-card"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Thanh toán thành công</div>
                                <div class="activity-time">15 phút trước</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon cancel">
                                <i class="fas fa-times-circle"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Hủy subscription</div>
                                <div class="activity-time">1 giờ trước</div>
                            </div>
                        </div>
                        <div class="activity-item">
                            <div class="activity-icon upgrade">
                                <i class="fas fa-arrow-up"></i>
                            </div>
                            <div class="activity-content">
                                <div class="activity-title">Nâng cấp gói Premium</div>
                                <div class="activity-time">3 giờ trước</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Account Management -->
                <div class="card full-width-card">
                    <div class="card-header">
                        <h2>Quản lý tài khoản</h2>
                        
                    </div>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Tên người dùng</th>
                                    <th>Email</th>
                                    <th>Gói subscription</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày đăng ký</th>
                                    <th>Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>#001</td>
                                    <td>Nguyễn Văn A</td>
                                    <td>nguyenvana@email.com</td>
                                    <td>Premium</td>
                                    <td><span class="status active">Hoạt động</span></td>
                                    <td>15/01/2024</td>
                                    <td>
                                        <button class="btn btn-primary">Xem</button>
                                        <button class="btn btn-warning">Sửa</button>
                                        <button class="btn btn-danger">Khóa</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#002</td>
                                    <td>Trần Thị B</td>
                                    <td>tranthib@email.com</td>
                                    <td>Basic</td>
                                    <td><span class="status active">Hoạt động</span></td>
                                    <td>12/01/2024</td>
                                    <td>
                                        <button class="btn btn-primary">Xem</button>
                                        <button class="btn btn-warning">Sửa</button>
                                        <button class="btn btn-danger">Khóa</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#003</td>
                                    <td>Lê Văn C</td>
                                    <td>levanc@email.com</td>
                                    <td>Pro</td>
                                    <td><span class="status pending">Chờ xử lý</span></td>
                                    <td>10/01/2024</td>
                                    <td>
                                        <button class="btn btn-primary">Xem</button>
                                        <button class="btn btn-success">Kích hoạt</button>
                                        <button class="btn btn-warning">Sửa</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#004</td>
                                    <td>Phạm Thị D</td>
                                    <td>phamthid@email.com</td>
                                    <td>Basic</td>
                                    <td><span class="status inactive">Không hoạt động</span></td>
                                    <td>08/01/2024</td>
                                    <td>
                                        <button class="btn btn-primary">Xem</button>
                                        <button class="btn btn-success">Kích hoạt</button>
                                        <button class="btn btn-warning">Sửa</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>#005</td>
                                    <td>Hoàng Văn E</td>
                                    <td>hoangvane@email.com</td>
                                    <td>Premium</td>
                                    <td><span class="status active">Hoạt động</span></td>
                                    <td>05/01/2024</td>
                                    <td>
                                        <button class="btn btn-primary">Xem</button>
                                        <button class="btn btn-warning">Sửa</button>
                                        <button class="btn btn-danger">Khóa</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Subscription Plans -->
                <div class="card full-width-card" style="margin-top: 24px;">
                    <div class="card-header">
                        <h2>Thống kê gói Subscription</h2>
                    </div>
                    <div class="subscription-stats">
                        <div class="subscription-stat">
                            <h3>245</h3>
                            <p>Gói Basic</p>
                        </div>
                        <div class="subscription-stat">
                            <h3>456</h3>
                            <p>Gói Pro</p>
                        </div>
                        <div class="subscription-stat">
                            <h3>155</h3>
                            <p>Gói Premium</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Sidebar navigation
                const sidebarLinks = document.querySelectorAll('.sidebar-nav a');
                sidebarLinks.forEach(link => {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        sidebarLinks.forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    });
                });

                // Button interactions
                const buttons = document.querySelectorAll('.btn');
                buttons.forEach(button => {
                    button.addEventListener('click', function () {
                        if (!this.classList.contains('btn-outline')) {
                            const action = this.textContent.trim();
                            alert(`Thực hiện hành động: ${action}`);
                        }
                    });
                });

                // Subtle animations
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