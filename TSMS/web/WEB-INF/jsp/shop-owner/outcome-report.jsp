<%-- 
    Document   : outcome-report
    Created on : June 20, 2025, 3:38:00 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Báo cáo chi phí</title>
        <link rel="stylesheet" href="css/so-invoices.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
                            <a href="nhap-hang" class="dropdown-item">Tạo đơn nhập hàng</a>
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

                    <div class="nav-item dropdown active">
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

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="so-outcome" method="get" class="filter-form">
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

                        <div class="filter-item">
                            <label for="branchId">Cửa hàng:</label>
                            <select id="branchId" name="branchId" class="form-select" onchange="this.form.submit()">
                                <option value="">--Tất cả--</option>
                                <c:forEach var="branch" items="${branchList}">
                                    <option value="${branch.branchId}" ${branchId == branch.branchId ? 'selected' : ''}>
                                        ${branch.branchName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-item">
                            <label for="employeeId">Nhân viên:</label>
                            <select id="employeeId" name="employeeId" class="form-select" 
                                    ${empty branchId ? 'disabled' : ''}>
                                <c:choose>
                                    <c:when test="${empty branchId}">
                                        <option value="">--Chọn cửa hàng trước--</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="">--Tất cả nhân viên--</option>
                                        <c:forEach var="employee" items="${employeeList}">
                                            <option value="${employee.userID}" ${employeeId == employee.userID ? 'selected' : ''}>
                                                ${employee.fullName}
                                            </option>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
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
                                    <label>
                                        <input type="radio" name="paymentMethod" value="${method}" 
                                               ${paymentMethod == method ? 'checked' : ''}>
                                        ${method}
                                    </label>
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
                    <h1>Báo cáo chi phí</h1>
                    <div class="header-actions">
                        <button class="btn btn-success" onclick="exportToExcel()">
                            <i class="fas fa-file-excel"></i>
                            Export Excel
                        </button>
                    </div>
                </div>

                <!-- Outcome Table -->
                <div class="table-container">
                    <table class="invoices-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã giao dịch</th>
                                <th>Danh mục</th>
                                <th>Phương thức TT</th>
                                <th>Ngày tạo</th>
                                <th>Chi nhánh</th>
                                <th>Người Tạo</th>
                                <th>Số tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty outcomeList}">
                                    <c:forEach var="outcome" items="${outcomeList}" varStatus="status">
                                        <tr>
                                            <td><c:out value="${status.index + 1}"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${outcome.cashFlowID > 0}">
                                                        ${outcome.cashFlowID} 
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty outcome.category}">
                                                        <span class="badge bg-warning text-dark">
                                                            <c:out value="${outcome.category}"/>
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty outcome.paymentMethod}">
                                                        <c:out value="${outcome.paymentMethod}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${outcome.createdAt != null}">
                                                        <c:out value="${outcome.formattedCreatedAt}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty outcome.branchName}">
                                                        <c:out value="${outcome.branchName}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty outcome.createdByName}">
                                                        <c:out value="${outcome.createdByName}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-danger">
                                                <c:choose>
                                                    <c:when test="${outcome.amount != null}">
                                                        <c:out value="${outcome.formattedAmount}"/>
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" style="text-align: center;">Không có dữ liệu</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <!-- Total Summary -->
                <div class="total-summary">
                    <div class="summary-item">
                        <span class="summary-label">Tổng chi phí:</span>
                        <span class="summary-value text-danger">
                            <c:choose>
                                <c:when test="${totalOutcomeAmount != null}">
                                    ${totalOutcomeAmount}
                                </c:when>
                                <c:otherwise>
                                    0 ₫
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <!-- Pagination -->
                <form method="GET" action="so-outcome">
                    <input type="hidden" name="branchId" value="${branchId}">
                    <input type="hidden" name="employeeId" value="${employeeId}">
                    <input type="hidden" name="fromDate" value="${dateFrom}">
                    <input type="hidden" name="toDate" value="${dateTo}">
                    <input type="hidden" name="paymentMethod" value="${paymentMethod}">

                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị ${startRecord} - ${endRecord} / Tổng số ${totalRecords} giao dịch
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
                        </div>


                        <div class="pagination">
                            <!-- Trang đầu -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="so-outcome?page=1&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
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
                                    <a href="so-outcome?page=${currentPage - 1}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
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
                                        <a href="so-outcome?page=${i}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Trang sau -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="so-outcome?page=${currentPage + 1}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
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
                                    <a href="so-outcome?page=${totalPages}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}&paymentMethod=${paymentMethod}" class="page-btn">
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

            // Tab functionality
            document.querySelectorAll('.tab-btn').forEach(btn => {
                btn.addEventListener('click', function () {
                    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Reset all filters
            function resetFilters() {
                // Redirect về trang gốc, loại bỏ tất cả parameters
                window.location.href = window.location.pathname;
            }




            // Hàm helper để format date cho input HTML
            function formatDateForInput(date) {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
                    }
        </script>

        <script>
            function exportToExcel() {
                // Lấy giá trị từ các input field
                var branchId = document.getElementById('branchId').value || '';
                var employeeId = document.getElementById('employeeId').value || '';
                var fromDate = document.getElementById('fromDate').value || '';
                var toDate = document.getElementById('toDate').value || '';
                var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked')?.value || '';

                // Build URL với cách nối chuỗi truyền thống
                var url = 'export-excel?type=outcome&branchId=' + branchId +
                        '&employeeId=' + employeeId +
                        '&fromDate=' + fromDate +
                        '&toDate=' + toDate
                        + '&paymentMethod=' + paymentMethod;
                // Debug log
                console.log('Export URL:', url);

                // Tạo link download
                var link = document.createElement('a');
                link.href = url;
                link.download = 'outcome_report.xlsx';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        </script>

    </body>
</html>
