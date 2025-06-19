<%-- 
    Document   : invoices
    Created on : May 22, 2025, 2:30:00 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Báo cáo đơn bán hàng</title>
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
                    <a href="#" class="nav-item">
                        <i class="fas fa-wallet"></i>
                        Sổ quỹ
                    </a>

                    <div class="nav-item dropdown active">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo doanh thu
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-invoices" class="dropdown-item">Doanh thu thuần</a>
                            <a href="#" class="dropdown-item">Khoản tri</a>                          
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
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="so-invoices" method="get" class="filter-form">
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
                    <h1>Báo cáo chi tiết</h1>
                    <div class="header-actions">

                        <button class="btn btn-success">
                            <i class="fas fa-file-excel"></i>
                            Export Excel
                        </button>


                    </div>
                </div>




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
                                <th>Chi nhánh</th>
                                <th>Người Tạo</th>
                                <th>Số tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty incomeList}">
                                    <c:forEach var="income" items="${incomeList}" varStatus="status">
                                        <tr>

                                            <td><c:out value="${status.index + 1}"/></td>
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
                                                    <c:when test="${income.createdAt != null}">
                                                        <c:out value="${income.branchName}"/>
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
                        <span class="summary-label">Tổng thu tất cả:</span>
                        <span class="summary-value">250.506.000đ</span>
                    </div>
                </div>

                <!-- Pagination -->
                <form method="GET" action="so-invoices">
                    <input type="hidden" name="branchId" value="${branchId}">
                    <input type="hidden" name="employeeId" value="${employeeId}">
                    <input type="hidden" name="fromDate" value="${dateFrom}">
                    <input type="hidden" name="toDate" value="${dateTo}">
                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị ${startRecord} - ${endRecord} / Tổng số ${totalRecords} hóa đơn
                        </div>

                        <div class="records-per-page">
                            <label for="recordsPerPage">Hiển thị:</label>
                            <select id="recordsPerPage" name="recordsPerPage" class="records-select" onchange="this.form.submit()">
                                <option value="10" ${recordsPerPage == 10 ? 'selected' : ''}>10</option>
                                <option value="25" ${recordsPerPage == 25 ? 'selected' : ''}>25</option>
                                <option value="50" ${recordsPerPage == 50 ? 'selected' : ''}>50</option>
                                <option value="100" ${recordsPerPage == 100 ? 'selected' : ''}>100</option>
                            </select>
                            <span>bản ghi/trang</span>
                        </div>

                        <div class="pagination">
                          
                            <!-- Trang đầu -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="so-invoices?page=1&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}" class="page-btn">
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
                                    <a href="so-invoices?page=${currentPage - 1}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}" class="page-btn">
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
                                        <a href="so-invoices?page=${i}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}" class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Trang sau -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="so-invoices?page=${currentPage + 1}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}" class="page-btn">
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
                                    <a href="so-invoices?page=${totalPages}&recordsPerPage=${recordsPerPage}&branchId=${branchId}&employeeId=${employeeId}&fromDate=${dateFrom}&toDate=${dateTo}" class="page-btn">
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

        <!-- Support Chat Button -->
        <!--        <div class="support-chat">
                    <i class="fas fa-headset"></i>
                    <span>Hỗ trợ: 1900 9999</span>
                </div>-->

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
                const form = document.querySelector('.filter-form');
                form.reset();

                // Remove active class from quick buttons
                document.querySelectorAll('.quick-btn').forEach(btn => btn.classList.remove('active'));

                // Hide advanced filters
                const advancedFilters = document.getElementById('advancedFilters');
                const legend = document.querySelector('.expandable-legend');
                advancedFilters.classList.remove('show');
                legend.classList.remove('expanded');
            }
        </script>
       
        <script>
            function setQuickTime(period) {
                const today = new Date();
                const fromDate = document.getElementById('fromDate');
                const toDate = document.getElementById('toDate');

                // Remove active class from all quick buttons
                document.querySelectorAll('.quick-btn').forEach(btn => btn.classList.remove('active'));

                // Add active class to clicked button
                event.target.classList.add('active');

                let startDate = new Date();
                let endDate = new Date(today);

                switch (period) {
                    case 'today':
                        startDate = new Date(today);
                        endDate = new Date(today);
                        break;
                    case 'week':
                        startDate = new Date(today);
                        startDate.setDate(today.getDate() - 6);
                        endDate = new Date(today);
                        break;
                    case 'month':
                        startDate = new Date(today);
                        startDate.setDate(today.getDate() - 29);
                        endDate = new Date(today);
                        break;
                    case 'quarter':
                        startDate = new Date(today);
                        startDate.setMonth(today.getMonth() - 3);
                        endDate = new Date(today);
                        break;
                }

                // Chỉ set giá trị cho input, không submit form
                fromDate.value = formatDateForInput(startDate);
                toDate.value = formatDateForInput(endDate);
            }

// Hàm helper để format date cho input HTML
            function formatDateForInput(date) {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
                    }

        </script>

    </body>
</html>
