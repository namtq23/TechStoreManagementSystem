<%-- 
    Document   : subscription-logs
    Created on : Jul 5, 2025, 5:41:21 PM
    Author     : admin
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử đăng ký - TSMS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/header.css"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                color: #333;
            }

            .main-content {
                min-height: calc(100vh - 160px);
                padding: 20px;
                background-color: #f5f5f5;
                display: flex;
                justify-content: center;
            }

            .container {
                width: 100%;
                max-width: 1400px;
                display: flex;
                gap: 24px;
                align-items: flex-start;
            }

            .sidebar {
                width: 280px;
                flex-shrink: 0;
                background: white;
                border-radius: 8px;
                padding: 20px;
                height: fit-content;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
            }

            .sidebar h3 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }

            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar-menu li {
                margin-bottom: 8px;
            }

            .sidebar-menu a {
                display: flex;
                align-items: center;
                padding: 12px 16px;
                text-decoration: none;
                color: #666;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .sidebar-menu a:hover,
            .sidebar-menu a.active {
                background-color: #e3f2fd;
                color: #1976d2;
            }

            .sidebar-menu i {
                margin-right: 12px;
                width: 20px;
                font-size: 16px;
            }

            .history-container {
                flex: 1;
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                overflow: hidden;
            }

            .history-header {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
                justify-content: space-between;
            }

            .history-header h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 600;
                color: #333;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .history-header i {
                color: #1976d2;
            }

            .history-content {
                padding: 30px;
            }

            .filters {
                display: flex;
                align-items: center;
                gap: 16px;
                margin-bottom: 24px;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .filter-group label {
                font-weight: 500;
                color: #333;
                font-size: 14px;
            }

            .filter-select {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                background-color: white;
                cursor: pointer;
            }

            .filter-select:focus {
                outline: none;
                border-color: #1976d2;
            }

            .table-container {
                overflow-x: auto;
                border-radius: 8px;
                border: 1px solid #e9ecef;
            }

            .subscription-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                font-size: 14px;
            }

            .subscription-table th,
            .subscription-table td {
                padding: 16px;
                text-align: left;
                border-bottom: 1px solid #e9ecef;
            }

            .subscription-table th {
                background: #f8f9fa;
                font-weight: 600;
                color: #333;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            .subscription-table tr:hover {
                background-color: #f8f9fa;
            }

            .subscription-table tr:last-child td {
                border-bottom: none;
            }

            .status-badge {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-active {
                background-color: #d4edda;
                color: #155724;
            }

            .status-expired {
                background-color: #f8d7da;
                color: #721c24;
            }

            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }

            .status-cancelled {
                background-color: #f1f3f4;
                color: #5f6368;
            }

            .price {
                font-weight: 600;
                color: #1976d2;
            }

            .date {
                color: #666;
                font-size: 13px;
            }

            .package-name {
                font-weight: 500;
                color: #333;
            }

            .package-name .package-type {
                display: block;
                font-size: 12px;
                color: #666;
                font-weight: 400;
                margin-top: 2px;
            }

            .id-column {
                font-family: monospace;
                color: #666;
                font-size: 13px;
            }

            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 8px;
                margin-top: 24px;
                padding-top: 24px;
                border-top: 1px solid #e9ecef;
            }

            .pagination button {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background: white;
                color: #666;
                border-radius: 6px;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.3s ease;
            }

            .pagination button:hover:not(:disabled) {
                background: #f8f9fa;
                border-color: #1976d2;
                color: #1976d2;
            }

            .pagination button:disabled {
                opacity: 0.5;
                cursor: not-allowed;
            }

            .pagination button.active {
                background: #1976d2;
                color: white;
                border-color: #1976d2;
            }

            .stats-row {
                display: flex;
                gap: 24px;
                margin-bottom: 24px;
            }

            .stat-card {
                flex: 1;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 12px;
                text-align: center;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }

            .stat-card.green {
                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            }

            .stat-card.orange {
                background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            }

            .stat-card.red {
                background: linear-gradient(135deg, #fc466b 0%, #3f5efb 100%);
            }

            .stat-number {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .stat-label {
                font-size: 14px;
                opacity: 0.9;
            }

            .empty-state {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }

            .empty-state i {
                font-size: 48px;
                margin-bottom: 16px;
                color: #ccc;
            }

            .empty-state h3 {
                margin-bottom: 8px;
                color: #333;
            }

            .empty-state p {
                font-size: 14px;
                line-height: 1.5;
            }

            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                }

                .sidebar {
                    width: 100%;
                }

                .history-content {
                    padding: 20px;
                }

                .filters {
                    flex-direction: column;
                    align-items: stretch;
                }

                .stats-row {
                    flex-direction: column;
                    gap: 16px;
                }

                .subscription-table {
                    font-size: 13px;
                }

                .subscription-table th,
                .subscription-table td {
                    padding: 12px 8px;
                }

                .pagination {
                    flex-wrap: wrap;
                    gap: 4px;
                }

                .pagination button {
                    padding: 6px 8px;
                    font-size: 12px;
                }
            }
        </style>
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
                    <a href="so-overview" class="nav-item">
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
                            <a href="so-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Left Sidebar -->
                <div class="sidebar">
                    <h3>Gian hàng</h3>
                    <ul class="sidebar-menu">
                        <li><a href="so-information"><i class="fas fa-info-circle"></i> Thông tin gian hàng</a></li>
                        <li><a href="so-change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                        <li><a href="so-branches"><i class="fas fa-code-branch"></i> Quản lý chi nhánh</a></li>
                        <li><a href="so-warehouses"><i class="fas fa-warehouse"></i> Quản lý kho tổng</a></li>
                        <li><a href="subscription"><i class="fas fa-shopping-cart"></i> Gói dịch vụ</a></li>
                        <li><a href="subscription-logs" class="active"><i class="fas fa-history"></i> Lịch sử mua hàng</a></li>
                    </ul>
                </div>

                <!-- Subscription History Container -->
                <div class="history-container">
                    <div class="history-header">
                        <h2>
                            <i class="fas fa-history"></i>
                            Lịch sử đăng ký
                        </h2>
                    </div>

                    <form method="get" class="filters" style="margin: 20px 20px 0px 20px;">
                        <div class="filter-group">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" id="fromDate" name="fromDate" value="${param.fromDate}" class="filter-select"/>
                        </div>
                        <div class="filter-group">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" id="toDate" name="toDate" value="${param.toDate}" class="filter-select"/>
                        </div>
                        <button type="submit" class="filter-select">Lọc</button>
                    </form>

                    <div class="history-content">
                        <!-- Table -->
                        <div class="table-container">
                            <table class="subscription-table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên gói</th>
                                        <th>Tình trạng</th>
                                        <th>Giá tiền</th>
                                        <th>Ngày đăng ký</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="log" items="${logs}">
                                        <tr>
                                            <td class="id-column">${log.logId}</td>
                                            <td>
                                                <div class="package-name">
                                                    ${log.subscriptionName}
                                                </div>
                                            </td>
                                            <td>
                                                <span class="status-badge
                                                      ${log.status == 'Done' ? 'status-active' : 
                                                        log.status == 'Expired' ? 'status-expired' :
                                                        log.status == 'Pending' ? 'status-pending' : 
                                                        'status-cancelled'}">
                                                    <i class="fas
                                                       ${log.status == 'Done' ? 'fa-check-circle' : 
                                                         log.status == 'Expired' ? 'fa-times-circle' : 
                                                         log.status == 'Pending' ? 'fa-clock' : 
                                                         'fa-ban'}"></i>
                                                       ${log.status}
                                                    </span>
                                                </td>
                                                <td class="price">${log.subscriptionPrice}₫</td>
                                                <td class="date"><fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy"/></td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty logs}">
                                            <tr>
                                                <td colspan="5" class="empty-state">
                                                    <i class="fas fa-info-circle"></i>
                                                    Không có dữ liệu trong khoảng thời gian đã chọn.
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>

                            <div class="pagination">
                                <!-- Nút Trang đầu -->
                                <form method="get" style="display:inline;">
                                    <input type="hidden" name="page" value="1"/>
                                    <input type="hidden" name="fromDate" value="${param.fromDate}"/>
                                    <input type="hidden" name="toDate" value="${param.toDate}"/>
                                    <button type="submit" 
                                            ${currentPage == 1 || totalPages == 1 ? "disabled" : ""}
                                            title="Trang đầu">
                                        <i class="fas fa-angle-double-left"></i>
                                    </button>
                                </form>

                                <!-- Nút Trang trước -->
                                <form method="get" style="display:inline;">
                                    <input type="hidden" name="page" value="${currentPage - 1}"/>
                                    <input type="hidden" name="fromDate" value="${param.fromDate}"/>
                                    <input type="hidden" name="toDate" value="${param.toDate}"/>
                                    <button type="submit" 
                                            ${currentPage == 1 || totalPages == 1 ? "disabled" : ""}
                                            title="Trang trước">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                </form>

                                <!-- Các nút số trang -->
                                <c:forEach begin="1" end="${totalPages}" var="p">
                                    <form method="get" style="display:inline;">
                                        <input type="hidden" name="page" value="${p}"/>
                                        <input type="hidden" name="fromDate" value="${param.fromDate}"/>
                                        <input type="hidden" name="toDate" value="${param.toDate}"/>
                                        <button type="submit" class="${p == currentPage ? 'active' : ''}">
                                            ${p}
                                        </button>
                                    </form>
                                </c:forEach>

                                <!-- Nút Trang sau -->
                                <form method="get" style="display:inline;">
                                    <input type="hidden" name="page" value="${currentPage + 1}"/>
                                    <input type="hidden" name="fromDate" value="${param.fromDate}"/>
                                    <input type="hidden" name="toDate" value="${param.toDate}"/>
                                    <button type="submit" 
                                            ${currentPage == totalPages || totalPages == 1 ? "disabled" : ""}
                                            title="Trang sau">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </form>

                                <!-- Nút Trang cuối -->
                                <form method="get" style="display:inline;">
                                    <input type="hidden" name="page" value="${totalPages}"/>
                                    <input type="hidden" name="fromDate" value="${param.fromDate}"/>
                                    <input type="hidden" name="toDate" value="${param.toDate}"/>
                                    <button type="submit" 
                                            ${currentPage == totalPages || totalPages == 1 ? "disabled" : ""}
                                            title="Trang cuối">
                                        <i class="fas fa-angle-double-right"></i>
                                    </button>
                                </form>
                            </div>

                        </div>
                    </div>
                </div>
            </main>

            <script>
                // Filter functionality
                document.getElementById('statusFilter').addEventListener('change', function () {
                    filterTable();
                });

                document.getElementById('packageFilter').addEventListener('change', function () {
                    filterTable();
                });

                function filterTable() {
                    const statusFilter = document.getElementById('statusFilter').value;
                    const packageFilter = document.getElementById('packageFilter').value;
                    const rows = document.querySelectorAll('.subscription-table tbody tr');

                    rows.forEach(row => {
                        const status = row.querySelector('.status-badge').textContent.toLowerCase();
                        const packageName = row.querySelector('.package-name').textContent.toLowerCase();

                        let showRow = true;

                        if (statusFilter && !status.includes(getStatusText(statusFilter))) {
                            showRow = false;
                        }

                        if (packageFilter && !packageName.includes(getPackageText(packageFilter))) {
                            showRow = false;
                        }

                        row.style.display = showRow ? '' : 'none';
                    });
                }

                function getStatusText(status) {
                    const statusMap = {
                        'active': 'hoạt động',
                        'expired': 'hết hạn',
                        'pending': 'chờ xử lý',
                        'cancelled': 'đã hủy'
                    };
                    return statusMap[status] || '';
                }

                function getPackageText(packageType) {
                    const packageMap = {
                        'basic': 'cơ bản',
                        'premium': 'premium',
                        'enterprise': 'enterprise'
                    };
                    return packageMap[packageType] || '';
                }

                // Pagination functionality
                document.querySelectorAll('.pagination button').forEach(button => {
                    button.addEventListener('click', function () {
                        if (!this.disabled && !this.classList.contains('active')) {
                            document.querySelector('.pagination button.active').classList.remove('active');
                            this.classList.add('active');
                            // Here you would implement actual pagination logic
                        }
                    });
                });
            </script>
        </body>
    </html>

