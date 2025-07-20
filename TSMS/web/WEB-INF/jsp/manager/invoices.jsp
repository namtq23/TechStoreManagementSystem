<%-- 
    Document   : invoices (Branch Manager version)
    Created on : July 20, 2025
    Author     : TRIEU NAM
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Báo cáo đơn bán hàng chi nhánh</title>
        <link rel="stylesheet" href="css/so-invoices.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
                    <a href="bm-overview" class="nav-item ">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item">
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
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="request-stock" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-incoming-orders" class="dropdown-item">Theo dõi nhập hàng</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-customer" class="dropdown-item">Khách hàng</a>
                            <a href="bm-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>

                    <a href="bm-staff" class="nav-item">
                        <i class="fas fa-users"></i>
                        Nhân viên
                    </a>

                    <a href="bm-promotions" class="nav-item">
                        <i class="fas fa-ticket"></i>
                        Khuyến mãi
                    </a>

                    <div class="nav-item dropdown active">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-invoices" class="dropdown-item">Báo cáo thu thuần</a>
                            <a href="bm-outcome" class="dropdown-item">Báo cáo chi</a>
                        </div>
                    </div>

                    <a href="bm-cart" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="#" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="staff-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="bm-invoices" method="get" class="filter-form">
                    <fieldset>
                        <legend>Bộ lọc</legend>

                        <div class="filter-item">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" id="fromDate" name="fromDate" class="form-input" 
                                   value="${dateFrom}">
                        </div>

                        <div class="filter-item">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" id="toDate" name="toDate" class="form-input" 
                                   value="${dateTo}">
                        </div>

                        <!-- BỎ PHẦN CHỌN CỬA HÀNG - CHỈ HIỂN thị CHI NHÁNH HIỆN TẠI -->
                        <div class="filter-item">
                            <label>Chi nhánh hiện tại:</label>
                            <div class="current-branch-info">
                                <i class="fas fa-store"></i>
                                <span>${currentBranchName}</span>

                            </div>
                        </div>

                        <!-- PHẦN CHỌN NHÂN VIÊN - KHÔNG CẦN DISABLED VÀ DEPENDENCY -->
                        <div class="filter-item">
                            <label for="employeeId">Nhân viên:</label>
                            <select id="employeeId" name="employeeId" class="form-select">
                                <option value="">--Tất cả nhân viên--</option>
                                <c:forEach var="employee" items="${employeeList}">
                                    <option value="${employee.userID}" ${employeeId == employee.userID ? 'selected' : ''}>
                                        ${employee.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-item">
                            <label>Phương thức thanh toán:</label>
                            <div class="form-radio-group">
                                <label>
                                    <input type="radio" name="paymentMethod" value="" 
                                           ${empty paymentMethod ? 'checked' : ''}>
                                    Tất cả
                                </label>

                                <c:forEach var="method" items="${paymentMethodList}">
                                    <c:if test="${method ne 'Thẻ công ty'}">
                                        <label>
                                            <input type="radio" name="paymentMethod" value="${method}" 
                                                   ${paymentMethod == method ? 'checked' : ''}>
                                            ${method}
                                        </label>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </fieldset>

                    <!-- Action Buttons -->
                    <div class="filter-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter"></i>
                            Áp dụng lọc
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="resetFilters()">
                            <i class="fas fa-undo"></i>
                            Reset
                        </button>
                    </div>
                </form>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Báo cáo chi tiết chi nhánh</h1>
                    <div class="header-actions">
                        <button class="btn btn-success" onclick="exportToExcel()">
                            <i class="fas fa-file-excel"></i>
                            Export Excel
                        </button>
                    </div>
                </div>

                <!-- Error Display -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle"></i>
                        ${error}
                    </div>
                </c:if>

                <!-- Invoices Table -->
                <div class="table-container">
                    <table class="invoices-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã đơn hàng</th>
                                <th>Tên khách hàng</th>
                                <th>Phương thức TT</th>
                                <th>Ngày tạo</th>
                                <th>Người Tạo</th>
                                <th>Số tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty incomeList}">
                                    <c:forEach var="income" items="${incomeList}" varStatus="status">
                                        <tr>
                                            <td><c:out value="${(currentPage - 1) * recordsPerPage + status.index + 1}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${income.relatedOrderID > 0}">
                                                        ${income.relatedOrderID} 
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty income.customerName}">
                                                        <c:out value="${income.customerName}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty income.paymentMethod}">
                                                        <c:out value="${income.paymentMethod}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${income.createdAt != null}">
                                                        <c:out value="${income.formattedDate}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty income.description}">
                                                        <c:out value="${income.createdByName}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${income.amount != null}">
                                                        <c:out value="${income.formattedAmountVND}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" style="text-align: center;">Không có dữ liệu</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Total Summary -->
                <div class="total-summary">
                    <div class="summary-item">
                        <span class="summary-label">Tổng thu chi nhánh:</span>
                        <span class="summary-value">${totalIncomeAmount}</span>
                    </div>
                </div>

                <!-- Pagination -->
                <form method="GET" action="bm-invoices">
                    <input type="hidden" name="employeeId" value="${employeeId}">
                    <input type="hidden" name="fromDate" value="${dateFrom}">
                    <input type="hidden" name="toDate" value="${dateTo}">
                    <input type="hidden" name="paymentMethod" value="${paymentMethod}">

                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị ${startRecord} - ${endRecord} / Tổng số ${totalRecords} hóa đơn
                        </div>

                        <div class="records-per-page">
                            <label for="recordsPerPage">Hiển thị:</label>
                            <select id="recordsPerPage" name="recordsPerPage" class="records-select" onchange="this.form.submit()">
                                <c:forEach var="option" items="${recordsPerPageOptions}">
                                    <option value="${option}" ${recordsPerPage == option ? 'selected' : ''}>
                                        ${option}
                                    </option>
                                </c:forEach>
                            </select>
                            <span>bản ghi/trang</span>
                        </div>

                        <div class="pagination">
                            <!-- Trang đầu -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="bm-invoices?page=1&recordsPerPage=${recordsPerPage}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
                                        <i class="fas fa-angle-double-left"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">
                                        <i class="fas fa-angle-double-left"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Trang trước -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="bm-invoices?page=${currentPage - 1}&recordsPerPage=${recordsPerPage}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
                                        <i class="fas fa-angle-left"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">
                                        <i class="fas fa-angle-left"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Các trang số -->
                            <c:forEach var="i" begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" 
                                       end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="bm-invoices?page=${i}&recordsPerPage=${recordsPerPage}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Trang sau -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="bm-invoices?page=${currentPage + 1}&recordsPerPage=${recordsPerPage}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
                                        <i class="fas fa-angle-right"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">
                                        <i class="fas fa-angle-right"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Trang cuối -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="bm-invoices?page=${totalPages}&recordsPerPage=${recordsPerPage}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
                                        <i class="fas fa-angle-double-right"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">
                                        <i class="fas fa-angle-double-right"></i>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </form>
            </main>
        </div>

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

            // Reset all filters
            function resetFilters() {
                // Redirect về trang gốc, loại bỏ tất cả parameters
                window.location.href = window.location.pathname;
            }

            // Export Excel function - modified for BM
            function exportToExcel() {
                // Lấy giá trị từ các input field - BỎ branchId
                var employeeId = document.getElementById('employeeId').value || '';
                var fromDate = document.getElementById('fromDate').value || '';
                var toDate = document.getElementById('toDate').value || '';
                var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked')?.value || '';

                // Build URL - BỎ branchId vì đã có từ session
                var url = 'export-excel?type=income-bm' +
                        '&employeeId=' + employeeId +
                        '&fromDate=' + fromDate +
                        '&toDate=' + toDate +
                        '&paymentMethod=' + paymentMethod;

                // Debug log
                console.log('Export URL:', url);

                // Tạo link download
                var link = document.createElement('a');
                link.href = url;
                link.download = 'income_branch_report.xlsx';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        </script>

        <!-- CSS cho current-branch-info và alert -->
        <style>
            .current-branch-info {
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 8px 12px;
                background: #f8f9fa;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                color: #495057;
                font-weight: 500;
            }

            .current-branch-info i {
                color: #28a745;
            }

            .alert {
                padding: 12px 16px;
                margin-bottom: 16px;
                border: 1px solid;
                border-radius: 4px;
            }

            .alert-danger {
                color: #721c24;
                background-color: #f8d7da;
                border-color: #f5c6cb;
            }
        </style>

    </body>
</html>
