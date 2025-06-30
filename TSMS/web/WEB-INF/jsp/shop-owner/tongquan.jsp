<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Tổng quan</title>
        <link rel="stylesheet" href="css/header.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/so-overall.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> 

    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="so-overview" class="nav-item active">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="so-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="so-createimport" class="dropdown-item">Tạo đơn nhập hàng</a>
                            <a href="so-ienoti" class="dropdown-item">Thông báo nhập/xuất</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-customer" class="dropdown-item">Khách hàng</a>
                            <a href="so-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-staff" class="dropdown-item">Danh sách nhân viên</a>
                            <a href="so-commission" class="dropdown-item">Hoa hồng</a>
                        </div>
                    </div>

                    <a href="so-promotions" class="nav-item">
                        <i class="fas fa-gift"></i>
                        Khuyến mãi
                    </a>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-invoices?reportType=income" class="dropdown-item">Doanh Thu thuần</a>
                            <a href="so-outcome" class="dropdown-item">Khoảng chi</a>
                        </div>
                    </div>

                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="#" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="profile" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
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
                    <form id="chartFilterForm" action="so-overview" method="GET">
                        <input type="hidden" name="sortBy" value="${sortBy}">
                        <input type="hidden" name="topPeriod" value="${topPeriod}">
                        <div class="chart-header">
                            <h3>
                                DOANH THU THUẦN 
                                ${currentPeriod == 'last_month' ? 'THÁNG TRƯỚC' : 'THÁNG NÀY'}
                                <i class="fas fa-info-circle"></i>
                            </h3>
                            <div class="chart-controls">

                                <select name="period" class="period-select">
                                    <option value="this_month" ${currentPeriod == 'this_month' ? 'selected' : ''}>
                                        Tháng này
                                    </option>
                                    <option value="last_month" ${currentPeriod == 'last_month' ? 'selected' : ''}>
                                        Tháng trước
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="chart-filters">


                            <button type="submit" name="filterType" value="day"
                                    class="filter-btn ${currentFilter == 'day' ? 'active' : ''}">
                                Theo ngày
                            </button>

                            <button type="submit" name="filterType" value="hour"
                                    class="filter-btn ${currentFilter == 'hour' ? 'active' : ''}">
                                Theo giờ
                            </button>

                            <button type="submit" name="filterType" value="weekday"
                                    class="filter-btn ${currentFilter == 'weekday' ? 'active' : ''}">
                                Theo thứ
                            </button>

                        </div>
                    </form>


                    <c:set var="hasData" value="false"/>
                    <c:forEach var="data" items="${revenueData.data}">
                        <c:if test="${data gt 0}">
                            <c:set var="hasData" value="true"/>
                        </c:if>

                    </c:forEach>


                    <div class="chart-container">
                        <div class="no-data">
                            <c:if test="${not hasData}">
                                <div class="no-data">
                                    <i class="fas fa-box"></i>
                                    <p>Không có dữ liệu</p>
                                </div>
                            </c:if>
                            <c:if test="${hasData}">
                                <canvas id="monthlyRevenueByDayChart"></canvas>
                                    <c:set var="labels" value="${revenueData.labels}" />
                                    <c:set var="data" value="${revenueData.data}" />
                                    <c:set var="chartTitle" value="${revenueData.chartTitle}" />
                                </c:if>
                        </div>
                    </div>
                </section>

                <!-- Top Products Section -->
                <section class="top-products">
                    <div class="section-header">
                        <h3>TOP 5 HÀNG HÓA BÁN CHẠY ${topPeriod == 'last_month' ? 'THÁNG TRƯỚC' : 'THÁNG NÀY'}</h3>
                        <form id="topProductsForm" action="so-overview" method="GET">

                            <input type="hidden" name="period" value="${currentPeriod}">
                            <input type="hidden" name="filterType" value="${currentFilter}">
                            <div class="section-controls">
                                <select name="sortBy" class="sort-select">
                                    <option value="quantity" ${sortBy == 'quantity' ? 'selected' : ''}>THEO SỐ LƯỢNG</option>
                                    <option value="revenue" ${sortBy == 'revenue' ? 'selected' : ''}>THEO DOANH THU THUẦN</option>

                                </select>
                                <select name="topPeriod" class="period-select">
                                    <option value="this_month" ${topPeriod == 'this_month' ? 'selected' : ''}>Tháng này</option>
                                    <option value="last_month" ${topPeriod == 'last_month' ? 'selected' : ''}>Tháng trước</option>
                                </select>
                            </div>
                        </form>
                    </div>
                    <div class="products-table">

                        <canvas id="myTopProduct" ></canvas>
                    </div>
                </section>

            </main>
            <!--                        <div class="no-data">
                   <canvas id="myTopProduct" width="600" height="300"></canvas>
                  <i class="fas fa-box"></i>
                    <p>Không có dữ liệu</p>
                </div>-->

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
                        <h4>TSMS ra mắt kênh CSKH Zalo Official Account</h4>
                        <button class="qr-btn">QUÉT TẠI NGAY</button>
                    </div>
                    <div class="qr-code">
                        <i class="fas fa-qrcode"></i>
                    </div>
                </div>

                <!-- Notifications -->
                <div class="notifications" style="padding: 16px; background: #ffffff; border-radius: 8px; margin-bottom: 16px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
                    <h4 style="font-size: 18px; font-weight: 600; color: #1a1a1a; margin-bottom: 12px; border-bottom: 1px solid #e0e0e0; padding-bottom: 8px;">THÔNG BÁO</h4>
                    <c:if test="${not empty recentAnnouncements}">
                        <c:forEach var="item" items="${recentAnnouncements}">
                            <div class="notification-item" style="display: flex; align-items: flex-start; padding: 8px; margin-bottom: 8px; background: #fff5f5; border-radius: 6px; border-left: 4px solid #f44336;">
                                <i class="fas fa-bell" style="margin-top: 2px; color: #f44336; font-size: 14px; margin-right: 8px;"></i>
                                <div style="flex: 1;">
                                    <!-- Tiêu đề -->
                                    <div style="font-weight: 600; font-size: 13px; color: #d32f2f;">${item.title}</div>
                                    <!-- Mô tả ngắn -->
                                    <div style="font-size: 12px; color: #555;">${item.description}</div>
                                    <!-- Chi nhánh + Người gửi -->
                                    <div style="font-size: 11px; color: #777; margin-top: 2px;">
                                        <i class="fas fa-map-marker-alt" style="margin-right: 4px; color: #9c27b0;"></i> ${item.locationName}
                                        <span style="margin-left: 8px;">
                                            <i class="fas fa-user" style="margin-right: 4px; color: #2196f3;"></i> ${item.senderName}
                                        </span>
                                    </div>
                                    <!-- Ngày + trạng thái -->
                                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 2px;">
                                        <div style="font-size: 10px; color: #999;">
                                            <i class="fas fa-clock" style="margin-right: 4px;"></i>
                                            <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                        <span style="font-size: 10px; padding: 2px 6px; background: #e3f2fd; color: #1976d2; border-radius: 10px;">
                                            ${item.status}
                                        </span>
                                    </div>
                                </div>
                            </div>                        
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty recentAnnouncements}">
                        <p style="text-align: center; color: #9e9e9e; font-size: 14px; padding: 20px 0;">Không có thông báo nào.</p>
                    </c:if>
                </div>

                <!-- Các hoạt động gần đây -->
                <div class="activities" style="padding: 16px; background: #ffffff; border-radius: 8px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);">
                    <div style="display: flex; align-items: center; margin-bottom: 16px; border-bottom: 1px solid #e0e0e0; padding-bottom: 8px;">
                        <i  style="color: #2196f3; font-size: 18px; margin-right: 8px;"></i>
                        <h4 style="margin: 0; color: #1a1a1a; font-size: 18px; font-weight: 600;">CÁC HOẠT ĐỘNG GẦN ĐÂY</h4>
                    </div>

                    <c:if test="${not empty activityLogs}">
                        <c:forEach var="log" items="${activityLogs}">
                            <div class="activity-card" style="display: flex; background: #f9f9f9; border-radius: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); padding: 16px; margin-bottom: 12px; gap: 12px;">

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

        <!-- Support Chat Button -->
        <div class="support-chat">
            <i class="fas fa-headset"></i>
            <span>Hỗ trợ:1900 6522</span>
        </div>
    </body>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        const ctx = document.getElementById('monthlyRevenueByDayChart').getContext('2d');

        // Convert BigDecimal to proper JavaScript numbers
        const labels = [
        <c:forEach var="label" items="${revenueData.labels}" varStatus="status">
        "${label}"<c:if test="${!status.last}">,</c:if>
        </c:forEach>
        ];

        const data = [
        <c:forEach var="amount" items="${revenueData.data}" varStatus="status">
            ${amount}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
        ];

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
                        text: "${revenueData.chartTitle}"
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
    <script>
        // Lắng nghe sự kiện "change" trên thẻ select
        document.querySelector('.period-select').addEventListener('change', function () {
            // Tự động submit form khi người dùng thay đổi lựa chọn
            this.form.submit();
        });
    </script>

    <script>
        const ctxTop = document.getElementById('myTopProduct').getContext('2d');
        const labelsTop = [
        <c:forEach var="p" items="${topProducts}" varStatus="status">
        "${p.productName}"<c:if test="${!status.last}">,</c:if>
        </c:forEach>
        ];
        const dataTop = [
        <c:forEach var="p" items="${topProducts}" varStatus="status">
            <c:choose>
                <c:when test="${param.sortBy == 'revenue'}">
                    ${p.revenue != null ? p.revenue : 0}
                </c:when>
                <c:otherwise>
                    ${p.totalQuantity}
                </c:otherwise>
            </c:choose><c:if test="${!status.last}">,</c:if>
        </c:forEach>
        ];


        new Chart(ctxTop, {
            type: 'bar',
            data: {
                labels: labelsTop,
                datasets: [{
                        label: '${sortBy == "quantity" ? "Số lượng bán" : "Doanh thu thuần"}',
                        data: dataTop,
                        backgroundColor: '#1787FC',
                        borderColor: '#1787FC',
                        borderWidth: 1
                    }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                plugins: {
                    legend: {display: false},
                    title: {
                        display: true,
                        text: 'TOP 5 HÀNG HÓA BÁN CHẠY ${topPeriod == "last_month" ? "THÁNG TRƯỚC" : "THÁNG NÀY"}'
                    }
                },
                scales: {x: {beginAtZero: true}}
            }
        });
    </script>


    <script>
        // Tự động submit form khi thay đổi bất kỳ select nào trong topProductsForm
        document.querySelectorAll('#topProductsForm select').forEach(function (select) {
            select.addEventListener('change', function () {
                this.form.submit();
            });
        });
    </script>

</script>

</html>