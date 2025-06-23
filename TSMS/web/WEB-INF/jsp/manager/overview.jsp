<%-- 
    Document   : overview
    Created on : Jun 2, 2025, 9:14:41 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>KiotViet - Tổng quan</title>
        <link rel="stylesheet" href="css/header.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/so-overall.css">
    </head>
    <body>
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="bm-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="bm-overview" class="nav-item active">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>
                    
                    <a href="bm-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>
                    
                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Đơn hàng</a>
                            <a href="#" class="dropdown-item">Nhập hàng</a>
                            <a href="#" class="dropdown-item">Yêu cầu nhập hàng</a>
                        </div>
                    </div>
                    
                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-customer" class="dropdown-item">Khách hàng</a>
                            <a href="bm-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>
                    
                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-staff" class="dropdown-item">Danh sách nhân viên</a>
                            <a href="#" class="dropdown-item">Hoa hồng</a>
                        </div>
                    </div>
                    <a href="bm-promotions" class="nav-item">
                        <i class="fas fa-ticket"></i>
                        Khuyến mãi
                    </a>
                    
                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Tài chính</a>
                            <a href="#" class="dropdown-item">Đật hàng</a>
                            <a href="#" class="dropdown-item">Hàng hoá</a>
                            <a href="#" class="dropdown-item">Khách hàng</a>
                        </div>
                    </div>
                    
                    <a href="bm-cart" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="profile" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
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
                                <div class="metric-label">1 Hóa đơn</div>
                                <div class="metric-value">4,886,000</div>
                                <div class="metric-subtitle">Doanh thu</div>
                            </div>
                        </div>

                        <div class="metric-card orders">
                            <div class="metric-icon">
                                <i class="fas fa-shopping-bag"></i>
                            </div>
                            <div class="metric-content">
                                <div class="metric-label">0 phiếu</div>
                                <div class="metric-value">0</div>
                                <div class="metric-subtitle">Đặt hàng</div>
                            </div>
                        </div>

                        <div class="metric-card growth-1">
                            <div class="metric-icon">
                                <i class="fas fa-arrow-up"></i>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">250.00%</div>
                                <div class="metric-subtitle">So với hôm qua</div>
                            </div>
                        </div>

                        <div class="metric-card growth-2">
                            <div class="metric-icon">
                                <i class="fas fa-arrow-up"></i>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">133.33%</div>
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
                            </select>
                        </div>
                    </div>

                    <div class="chart-filters">
                        <button class="filter-btn active">Theo ngày</button>
                        <button class="filter-btn">Theo giờ</button>
                        <button class="filter-btn">Theo thứ</button>
                    </div>

                    <div class="chart-container">
                        <div class="no-data">
                            <i class="fas fa-chart-line"></i>
                            <p>Không có dữ liệu</p>
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
    <script>
        const toggle = document.getElementById("dropdownToggle");
        const menu = document.getElementById("dropdownMenu");

        toggle.addEventListener("click", function (e) {
            e.preventDefault();
            menu.style.display = menu.style.display === "block" ? "none" : "block";
        });

        // Đóng dropdown nếu click ra ngoài
        document.addEventListener("click", function (e) {
            if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                menu.style.display = "none";
            }
        });
    </script>
</html>
