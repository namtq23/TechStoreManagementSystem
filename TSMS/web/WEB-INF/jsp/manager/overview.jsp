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
        <title>TSMS - Tổng quan</title>
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
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="request-stock" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-incoming-orders" class="dropdown-item">Theo dõi nhập hàng</a>
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
                            <a href="staff-information" class="dropdown-item">Thông tin chi tiết</a>
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
                <!-- THÔNG BÁO -->
                <div class="notifications" style="padding: 16px; background: #fff; border-radius: 8px; margin-bottom: 16px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.08);">
                    <h4 style="font-size: 18px; font-weight: 600; color: #1a1a1a; margin-bottom: 12px; border-bottom: 1px solid #e0e0e0; padding-bottom: 8px;">THÔNG BÁO</h4>

                    <c:if test="${not empty recentAnnouncements}">
                        <c:forEach var="item" items="${recentAnnouncements}">
                            <div class="notification-item" style="display: flex; align-items: flex-start; gap: 10px; background: #fff5f5; border-left: 4px solid #f44336; padding: 12px; margin-bottom: 10px; border-radius: 6px;">
                                <i class="fas fa-bell" style="color: #f44336; font-size: 14px; margin-top: 2px;"></i>
                                <div style="flex: 1;">
                                    <div style="font-size: 13px; font-weight: 600; color: #d32f2f;">${item.title}</div>
                                    <div style="font-size: 12px; color: #555;">${item.description}</div>
                                    <div style="font-size: 11px; color: #777; margin-top: 4px;">
                                        <i class="fas fa-map-marker-alt" style="margin-right: 4px; color: #9c27b0;"></i>${item.locationName}
                                        <span style="margin-left: 8px;">
                                            <i class="fas fa-user" style="margin-right: 4px; color: #2196f3;"></i>${item.senderName}
                                        </span>
                                    </div>
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 4px;">
                                        <div style="font-size: 10px; color: #999;">
                                            <i class="fas fa-clock" style="margin-right: 4px;"></i>
                                            <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                        <span style="font-size: 10px; padding: 2px 6px; background: #e3f2fd; color: #1976d2; border-radius: 10px;">${item.status}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>

                    <c:if test="${empty recentAnnouncements}">
                        <p style="text-align: center; color: #9e9e9e; font-size: 14px; padding: 20px 0;">Không có thông báo nào.</p>
                    </c:if>
                </div>

                <!-- CÁC HOẠT ĐỘNG GẦN ĐÂY -->
                <div class="activities" style="padding: 16px; background: #fff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.08);">
                    <div style="display: flex; align-items: center; margin-bottom: 16px; border-bottom: 1px solid #e0e0e0; padding-bottom: 8px;">
                        <i style="color: #2196f3; font-size: 18px; margin-right: 8px;"></i>
                        <h4 style="margin: 0; font-size: 18px; font-weight: 600; color: #1a1a1a;">CÁC HOẠT ĐỘNG GẦN ĐÂY</h4>
                    </div>

                    <c:if test="${not empty activityLogs}">
                        <c:forEach var="log" items="${activityLogs}">
                            <div class="activity-card" style="display: flex; gap: 12px; padding: 16px; margin-bottom: 12px; background: #f9f9f9; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.05);">
                                <div style="flex-shrink: 0; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center;
                                     background: ${log.category eq 'Đơn hàng' ? '#e3f2fd' : (log.category eq 'Nhập hàng' or log.category eq 'Xuất kho') ? '#ede7f6' : '#fff3e0'};">
                                    <i class="fas
                                       ${log.category eq 'Đơn hàng' ? 'fa-shopping-cart' : (log.category eq 'Nhập hàng' or log.category eq 'Xuất kho') ? 'fa-dolly' : 'fa-dollar-sign'}" 
                                       style="color: #333;"></i>
                                </div>

                                <div style="flex: 1; font-size: 13px;">
                                    <c:choose>
                                        <c:when test="${log.category eq 'Đơn hàng'}">
                                            <div style="font-weight: 600; margin-bottom: 4px;">Đơn hàng mới</div>
                                            <div>Mã: ${log.rawDescription}</div>
                                            <div>Người tạo: ${log.senderName}</div>
                                            <div>Chi nhánh: ${log.locationName}</div>
                                            <div>Tổng tiền: ${log.description}</div>
                                        </c:when>

                                        <c:when test="${log.category eq 'Nhập hàng' or log.category eq 'Xuất kho'}">
                                            <div style="font-weight: 600; margin-bottom: 4px;">${log.category}</div>
                                            <div>Người gửi: ${log.senderName}</div>
                                            <div>Gửi từ: ${log.fromLocation}</div>
                                            <div>Đến: ${log.toLocation}</div>
                                            <div>Ghi chú: ${log.rawDescription}</div>
                                        </c:when>

                                        <c:otherwise>
                                            <div style="font-weight: 600; margin-bottom: 4px;">${log.status}</div>
                                            <div>Danh mục: ${log.category}</div>
                                            <div>Số tiền: ${log.description}</div>
                                            <div>Mô tả: ${log.rawDescription}</div>
                                            <div>Chi nhánh: ${log.locationName}</div>
                                            <div>Người ghi: ${log.senderName}</div>
                                        </c:otherwise>
                                    </c:choose>

                                    <div style="margin-top: 6px; font-size: 12px; color: #888;">
                                        <i class="fas fa-clock" style="margin-right: 4px;"></i>
                                        <fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:if>

                    <c:if test="${empty activityLogs}">
                        <div style="text-align: center; padding: 32px 0; color: #9e9e9e;">
                            <i class="fas fa-history" style="font-size: 32px; margin-bottom: 12px; opacity: 0.5;"></i>
                            <p style="margin: 0; font-size: 14px;">Chưa có hoạt động nào</p>
                        </div>
                    </c:if>
                </div>

            </aside>
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
