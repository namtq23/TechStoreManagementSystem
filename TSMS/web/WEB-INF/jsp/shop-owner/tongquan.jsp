<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>KiotViet - Tổng quan</title>
        <link rel="stylesheet" href="css/header.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/so-overall.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> 
    </head>
    <body>
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview"" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="so-overview"" class="nav-item active">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>
                    <a href="so-products" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>
                    <a href="so-orders" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Giao dịch
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-handshake"></i>
                        Đối tác
                    </a>
                    <a href="#" class="nav-item">
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
            <!-- Main Content -->
            <main class="main-content">
                <!-- Sales Results Section -->
                <section class="sales-results">
                    <h2>KẾT QUẢ BÁN HÀNG HÔM NAY</h2>
                    <div class="metrics-grid">
                        <div class="metric-card revenue">
                            <div class="metric-icon">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                            <div class="metric-content">
                                <div class="metric-label">${invoiceToDay} Hóa đơn</div>
                                <div class="metric-value">${incomeTotal}</div>
                                <div class="metric-subtitle">Doanh thu</div>
                            </div>
                        </div>

                        <!--                    <div class="metric-card orders">
                                                <div class="metric-icon">
                                                    <i class="fas fa-shopping-bag"></i>
                                                </div>
                                                <div class="metric-content">
                                                    <div class="metric-label">0 phiếu</div>
                                                    <div class="metric-value">0</div>
                                                    <div class="metric-subtitle">Đặt hàng</div>
                                                </div>
                                            </div>-->

                        <c:set var="bgColor" value="${percentageChange lt 0 ? '#f24444a1' : '#e8f5e8'}" />
                        <c:set var="iconClass" value="${percentageChange lt 0 ? 'fa-arrow-down' : 'fa-arrow-up'}"/>
                        <c:set var="iconBg" value="${percentageChange lt 0 ? 'red' : '#4caf50'}"/>

                        <c:set var="bgColorMonth" value="${monthlyChange lt 0 ? '#f24444a1' : '#e8f5e8'}" />
                        <c:set var="iconClassMonth" value="${monthlyChange lt 0 ? 'fa-arrow-down' : 'fa-arrow-up'}"/>
                        <c:set var="iconBgMonth" value="${monthlyChange lt 0 ? 'red' : '#4caf50'}"/>


                        <div class="metric-card growth-1" style="background: ${bgColor};">
                            <div class="metric-icon" style="background:${iconBg}">
                                <i class="fas ${iconClass}"></i>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">${percentageChange}%</div>
                                <div class="metric-subtitle">So với hôm qua</div>
                            </div>
                        </div>

                        <div class="metric-card growth-2" style="background: ${bgColorMonth};">
                            <div class="metric-icon" style="background: ${iconBgMonth}";>
                                <i class="fas ${iconClassMonth}"></i>
                            </div>
                            <div class="metric-content" >
                                <div class="metric-value">${monthlyChange}%</div>
                                <div class="metric-subtitle">So với cùng kỳ tháng trước</div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Revenue Chart Section -->
                <section class="revenue-chart">
                    <div class="chart-header">
                        <h3>DOANH THU THUẦN THÁNG NÀY <i class="fas fa-info-circle"></i></h3>
                        <div class="chart-controls">
                            <select class="period-select">
                                <option>Tháng này</option>
                                <option>7 ngày qua</option>
                            </select>
                        </div>
                    </div>
                    <form>
                        <div class="chart-filters">
                            <button type="submit" class="filter-btn active" onclick="sendFilter('day')">Theo ngày</button>
                        <button type="submit"  class="filter-btn" onclick="sendFilter('hour')">Theo giờ</button>
                        <button type="submit"  class="filter-btn" onclick="sendFilter('weekday')">Theo thứ</button>
                    </div>
                    </form>
                    


                    <div class="chart-container">
                        <div class="no-data">
                            <canvas id="monthlyRevenueByDayChart"></canvas>
                                <c:set var="labels" value="${revenueData.labels}" />
                                <c:set var="data" value="${revenueData.data}" />
                                <c:set var="chartTitle" value="${revenueData.chartTitle}" />
                        </div>
                    </div>
                </section>

                <!-- Top Products Section -->
                <section class="top-products">
                    <div class="section-header">
                        <h3>TOP 10 HÀNG HÓA BÁN CHẠY THÁNG NÀY</h3>
                        <div class="section-controls">
                            <select class="sort-select">
                                <option>THEO DOANH THU THUẦN</option>
                            </select>
                            <select class="period-select">
                                <option>Tháng này</option>
                                <option>7 ngày qua</option>
                            </select>
                        </div>
                    </div>

                    <div class="products-table">
                        <div class="no-data">
                            <i class="fas fa-box"></i>
                            <p>Không có dữ liệu</p>
                        </div>
                    </div>
                </section>
            </main>

            <!-- Sidebar -->
            <aside class="sidebar">
                <!-- Promotion Banner -->
                <div class="promo-banner">
                    <div class="promo-content">
                        <h4>Nhận Hóa đơn điện tử & Chữ ký số</h4>
                        <span class="promo-badge">MIỄN PHÍ</span>
                        <button class="promo-btn">Kích hoạt ngay</button>
                    </div>
                    <div class="promo-image">
                        <i class="fas fa-file-invoice"></i>
                    </div>
                </div>

                <!-- QR Code Section -->
                <div class="qr-section">
                    <div class="qr-content">
                        <h4>KiotViet ra mắt kênh CSKH Zalo Official Account</h4>
                        <button class="qr-btn">QUÉT TẠI NGAY</button>
                    </div>
                    <div class="qr-code">
                        <i class="fas fa-qrcode"></i>
                    </div>
                </div>

                <!-- Notifications -->
                <div class="notifications">
                    <h4>THÔNG BÁO</h4>
                    <div class="notification-item">
                        <div class="notification-icon error">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <div class="notification-content">
                            <p>Có <strong>1 hoạt động đăng nhập khác thường</strong> cần kiểm tra.</p>
                        </div>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                </div>

                <!-- Recent Activities -->
                <div class="activities">
                    <h4>CÁC HOẠT ĐỘNG GẦN ĐÂY</h4>

                    <div class="activity-item">
                        <div class="activity-icon error">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="activity-content">
                            <p><span class="activity-user">hoang minh kien</span> vừa <span class="activity-action">nhập hàng</span> với giá trị <strong>0</strong></p>
                            <span class="activity-time">41 phút trước</span>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon primary">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="activity-content">
                            <p><span class="activity-user">hoang minh kien</span> vừa <span class="activity-action">bán đơn hàng</span> với giá trị <strong>4,886,000</strong></p>
                            <span class="activity-time">41 phút trước</span>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon info">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="activity-content">
                            <p><span class="activity-user">Nguyễn Lê Hùng Cường</span> vừa <span class="activity-action">bán đơn hàng</span> với giá trị <strong>1,396,000</strong></p>
                            <span class="activity-time">một ngày trước</span>
                        </div>
                    </div>

                    <div class="activity-item">
                        <div class="activity-icon error">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="activity-content">
                            <p><span class="activity-user">Nguyễn Lê Hùng Cường</span> vừa <span class="activity-action">nhập hàng</span> với giá trị <strong>0</strong></p>
                        </div>
                    </div>
                </div>
            </aside>
        </div>

        <!-- Support Chat Button -->
        <div class="support-chat">
            <i class="fas fa-headset"></i>
            <span>Hỗ trợ:1900 6522</span>
        </div>
    </body>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('monthlyRevenueByDayChart').getContext('2d');
        const labels = ${labels};
        const data = ${data};

        const revenueChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                        label: "Doanh thu (VND)",
                        data: data,
                        backgroundColor: "#338DF6"
                    }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {display: false},
                    title: {
                        display: true,
                        text: "${chartTitle}"
                    }
                },
                scales: {
                    y: {
                        ticks: {
                            callback: function (value) {
                                return value.toLocaleString('vi-VN') + ' đ';
                            }
                        }
                    }
                }
            }
        });
    </script>

</html>