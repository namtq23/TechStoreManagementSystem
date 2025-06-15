<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


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
                    <a href="so-overview"" class="nav-item">
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
                    
                    <a href="so-staff" class="nav-item">
                        <i class="fas fa-users"></i>
                        Nhân viên
                    </a>
                    <a href="so-promotions" class="nav-item">
                        <i class="fas fa-users"></i>
                        Khuyến mãi
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-wallet"></i>
                        Sổ quỹ
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-chart-bar"></i>
                        Báo cáo
                    </a>
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