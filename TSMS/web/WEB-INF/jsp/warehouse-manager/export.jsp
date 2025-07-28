<%-- 
    Document   : import
    Created on : December 27, 2024, 9:00:00 PM
    Author     : admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Danh sách xuất hàng đến chi nhánh</title>
        <link rel="stylesheet" href="css/import.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
           <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="wh-products?page=1" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="wh-products?page=1" class="nav-item ">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <a href="wh-import" class="nav-item ">
                        <i class="fa-solid fa-download"></i>
                        Nhập hàng
                    </a>

                    <a href="wh-export" class="nav-item active">
                        <i class="fa-solid fa-upload"></i>
                        Xuất hàng
                    </a>

                    <a href="wh-import-request" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Tạo thông báo
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
            </div>
        </header>

        <div class="main-container">
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="wh-export" method="get" class="filter-form">
                    <input type="hidden" name="page" value="1">
                    <fieldset>
                        <legend>Bộ lọc</legend>

                        <div class="filter-item">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" id="fromDate" name="fromDate" class="form-input" value="${fromDate}">
                        </div>

                        <div class="filter-item">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" id="toDate" name="toDate" class="form-input" value="${toDate}">
                        </div>



                        <div class="filter-item">
                            <label>Trạng thái:</label>
                            <div class="form-radio-group">
                                <label>
                                    <input type="radio" name="status" value="" ${empty status ? 'checked' : ''}>
                                    Tất cả
                                </label>
                                <label>
                                    <input type="radio" name="status" value="pending" ${status eq 'pending' ? 'checked' : ''}>
                                    Chờ xử lý
                                </label>
                                <label>
                                    <input type="radio" name="status" value="processing" ${status eq 'processing' ? 'checked' : ''}>
                                    Đang xử lý
                                </label>
                                <label>
                                    <input type="radio" name="status" value="transfer" ${status eq 'transfer' ? 'checked' : ''}>
                                    Đang vận chuyển
                                </label>
                                <label>
                                    <input type="radio" name="status" value="completed" ${status eq 'completed' ? 'checked' : ''}>
                                    Hoàn thành
                                </label>
                                <label>
                                    <input type="radio" name="status" value="cancelled" ${status eq 'cancelled' ? 'checked' : ''}>
                                    Đã hủy
                                </label>
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
                    <h1>Danh sách hàng xuất</h1>

                </div>

                <!-- Import Orders Table -->
                <!-- Export Orders Table -->
                <div class="table-container">
                    <table class="invoices-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã đơn xuất</th>
                                <th>Chi nhánh gửi</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Người tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${exportRequests}" varStatus="loop">
                                <tr>
                                    <td>${(currentPage - 1) * itemsPerPage + loop.index + 1}</td>
                                    <td>${req.movementID}</td>
                                    <td>${req.fromBranchName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${req.responseStatus eq 'pending'}">
                                                <span class="status-badge pending">Chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'processing'}">
                                                <span class="status-badge processing">Đang xử lý</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'transfer'}">
                                                <span class="status-badge transfer">Đang vận chuyển</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'completed'}">
                                                <span class="status-badge completed">Hoàn thành</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'cancelled'}">
                                                <span class="status-badge cancelled">Đã huỷ</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge unknown">Không rõ</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${req.formattedDate}</td>
                                    <td>${req.createdByName}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <c:choose>
                                                <c:when test="${req.responseStatus eq 'pending'}">
                                                    <button class="btn-action edit" onclick="editOrder('${req.movementID}', '${req.movementType}')">Xử lý</button>
                                                </c:when>
                                                <c:when test="${req.responseStatus eq 'processing'}">
                                                    <button class="btn-action process" onclick="editOrder('${req.movementID}', '${req.movementType}')">Tiếp tục xuất</button>
                                                </c:when>
                                                <c:when test="${req.responseStatus eq 'transfer'}">
                                                    <button class="btn-action transfer" onclick="viewOrder('${req.movementID}')" >Đang vận chuyển</button>
                                                </c:when>
                                                <c:when test="${req.responseStatus eq 'completed'}">
                                                    <button class="btn-action view" onclick="viewOrder('${req.movementID}')">Xem</button>
                                                </c:when>
                                                <c:when test="${req.responseStatus eq 'cancelled'}">
                                                    <button class="btn-action cancelled" disabled>Đã huỷ</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-action view" onclick="viewOrder('${req.movementID}')">Xem</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                                <c:if test="${not empty exportRequests}">
                                    <!-- Table content -->
                                </c:if>
                                <c:if test="${empty exportRequests}">
                                    <tr>
                                        <td colspan="7" class="no-data">
                                            <i class="fas fa-box-open"></i>
                                            <p>Không có đơn xuất hàng nào</p>
                                        </td>
                                    </tr>
                                </c:if>

                            </c:forEach>
                        </tbody>

                    </table>
                </div>





                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-left">
                        <div class="pagination-info">
                            Hiển thị ${startItem} - ${endItem} trong tổng số ${totalItems} đơn xuất hàng
                            (Trang ${currentPage} / ${totalPages})
                        </div>

                        <div class="records-per-page">
                            <label>Hiển thị:</label>
                            <form method="GET" class="records-per-page-form">
                                <input type="hidden" name="fromDate" value="${fromDate}">
                                <input type="hidden" name="toDate" value="${toDate}">
                                <input type="hidden" name="branchId" value="${branchId}">
                                <input type="hidden" name="status" value="${status}">
                                <select name="recordsPerPage" class="records-select" onchange="this.form.submit()">
                                    <option value="5" ${itemsPerPage == 5 ? 'selected' : ''}>5</option>
                                    <option value="10" ${itemsPerPage == 10 ? 'selected' : ''}>10</option>
                                    <option value="20" ${itemsPerPage == 20 ? 'selected' : ''}>20</option>
                                    <option value="50" ${itemsPerPage == 50 ? 'selected' : ''}>50</option>
                                </select>
                            </form>
                            <span>bản ghi/trang</span>
                        </div>
                    </div>

                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <!-- First page -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="wh-export?fromDate=${fromDate}&toDate=${toDate}&branchId=${branchId}&status=${status}&recordsPerPage=${itemsPerPage}&page=1" class="page-btn">⏮</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">⏮</span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Previous page -->
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="wh-export?fromDate=${fromDate}&toDate=${toDate}&branchId=${branchId}&status=${status}&recordsPerPage=${itemsPerPage}&page=${currentPage - 1}" class="page-btn">◀</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">◀</span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Page numbers -->
                            <c:forEach var="i" begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" 
                                       end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-btn active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="wh-export?fromDate=${fromDate}&toDate=${toDate}&branchId=${branchId}&status=${status}&recordsPerPage=${itemsPerPage}&page=${i}" class="page-btn">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>

                            <!-- Next page -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="wh-export?fromDate=${fromDate}&toDate=${toDate}&branchId=${branchId}&status=${status}&recordsPerPage=${itemsPerPage}&page=${currentPage + 1}" class="page-btn">▶</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">▶</span>
                                </c:otherwise>
                            </c:choose>

                            <!-- Last page -->
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="wh-export?fromDate=${fromDate}&toDate=${toDate}&branchId=${branchId}&status=${status}&recordsPerPage=${itemsPerPage}&page=${totalPages}" class="page-btn">⏭</a>
                                </c:when>
                                <c:otherwise>
                                    <span class="page-btn disabled">⏭</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                </div>

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
                window.location.href = 'wh-export';
            }

            // Export to Excel function


            // Action functions
            function viewOrder(orderId) {
                console.log('Xem chi tiết đơn hàng: ' + orderId);
                // Redirect to view page or open modal
                window.location.href = 'wh-import-export-detail?id=' + orderId;
            }

            function editOrder(orderId, movementType) {
                console.log('Chỉnh sửa đơn hàng: ' + orderId + ' - ' + movementType);
                window.location.href = 'serial-check?id=' + orderId + '&movementType=' + movementType;
            }



        </script>

    </body>
</html>
