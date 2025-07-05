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
        <title>TSMS - Danh sách đơn nhập hàng</title>
        <link rel="stylesheet" href="css/import.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    </head>
    <body>
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="wh-products?page=1" class="nav-item ">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <a href="wh-import" class="nav-item active">
                        <i class="fa-solid fa-download"></i>
                        Nhập hàng
                    </a>

                    <a href="" class="nav-item">
                        <i class="fa-solid fa-upload"></i>
                        Xuất hàng
                    </a>

                    <a href="" class="nav-item">
                        <i class="fa-solid fa-bell"></i>
                        Thông báo
                    </a>

                    <a href="" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Yêu cầu nhập hàng
                    </a>

                    <a href="" class="nav-item">
                        <i class="fas fa-chart-bar"></i>
                        Báo cáo
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
                <form action="import.jsp" method="get" class="filter-form">
                    <fieldset>
                        <legend>Bộ lọc</legend>

                        <div class="filter-item">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" id="fromDate" name="fromDate" class="form-input">
                        </div>

                        <div class="filter-item">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" id="toDate" name="toDate" class="form-input">
                        </div>

                        <div class="filter-item">
                            <label for="branchId">Cửa hàng:</label>
                            <select id="branchId" name="branchId" class="form-select" onchange="this.form.submit()">
                                <option value="">--Tất cả--</option>
                                <option value="1">Chi nhánh Hà Nội</option>
                                <option value="2">Chi nhánh TP.HCM</option>
                                <option value="3">Chi nhánh Đà Nẵng</option>
                            </select>
                        </div>

                        <div class="filter-item">
                            <label for="supplierId">Nhà cung cấp:</label>
                            <select id="supplierId" name="supplierId" class="form-select">
                                <option value="">--Tất cả nhà cung cấp--</option>
                                <option value="1">Công ty TNHH ABC</option>
                                <option value="2">Công ty XYZ</option>
                                <option value="3">Nhà cung cấp DEF</option>
                                <option value="4">Công ty GHI</option>
                            </select>
                        </div>

                        <div class="filter-item">
                            <label>Trạng thái:</label>
                            <div class="form-radio-group">
                                <label>
                                    <input type="radio" name="status" value="" checked>
                                    Tất cả
                                </label>
                                <label>
                                    <input type="radio" name="status" value="completed">
                                    Hoàn thành
                                </label>
                                <label>
                                    <input type="radio" name="status" value="pending">
                                    Chờ xử lý
                                </label>
                                <label>
                                    <input type="radio" name="status" value="processing">
                                    Đang xử lý
                                </label>
                                <label>
                                    <input type="radio" name="status" value="cancelled">
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
                    <h1>Danh sách đơn nhập hàng</h1>
                    <div class="header-actions">
                        <button class="btn btn-success" onclick="exportToExcel()">
                            <i class="fas fa-file-excel"></i>
                            Export Excel
                        </button>
                    </div>
                </div>

                <!-- Import Orders Table -->
                <div class="table-container">
                    <table class="invoices-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã đơn nhập</th>
                                <th>Nhà cung cấp</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Người tạo</th>
                                <th>Tổng tiền</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${importRequests}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${req.movementID}</td>
                                    <td>${req.fromSupplierName}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${req.responseStatus eq 'pending'}">
                                                <span class="status-badge pending">Chờ xử lý</span>
                                            </c:when>
                                            <c:when test="${req.responseStatus eq 'processing'}">
                                                <span class="status-badge processing">Đang xử lý</span>
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
                                    <td>${req.formattedTotalAmount}</td>
                                    <td>
                                        <div class="action-buttons">
                                            <c:choose>
                                                <c:when test="${req.responseStatus eq 'pending'}">
                                                    <button class="btn-action edit" onclick="editOrder('${req.movementID}')">Xử lý</button>
                                                </c:when>
                                                <c:when test="${req.responseStatus eq 'processing'}">
                                                    <button class="btn-action process" onclick="editOrder('${req.movementID}')">Tiếp tục nhập</button>
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
                            </c:forEach>
                        </tbody>
                    </table>
                </div>




                <!-- Pagination -->
                <form method="GET" action="import.jsp">
                    <input type="hidden" name="branchId" value="">
                    <input type="hidden" name="supplierId" value="">
                    <input type="hidden" name="fromDate" value="">
                    <input type="hidden" name="toDate" value="">
                    <input type="hidden" name="status" value="">
                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị 1 - 5 / Tổng số 5 đơn nhập hàng
                        </div>

                        <div class="records-per-page">
                            <label for="recordsPerPage">Hiển thị:</label>
                            <select id="recordsPerPage" name="recordsPerPage" class="records-select" onchange="this.form.submit()">
                                <option value="5">5</option>
                                <option value="10" selected>10</option>
                                <option value="20">20</option>
                                <option value="50">50</option>
                            </select>
                            <span>bản ghi/trang</span>
                        </div>

                        <div class="pagination">
                            <!-- Trang đầu -->
                            <span class="page-btn disabled">
                                <i class="fas fa-angle-double-left"></i>
                            </span>

                            <!-- Trang trước -->
                            <span class="page-btn disabled">
                                <i class="fas fa-angle-left"></i>
                            </span>

                            <!-- Trang hiện tại -->
                            <span class="page-btn active">1</span>

                            <!-- Trang sau -->
                            <span class="page-btn disabled">
                                <i class="fas fa-angle-right"></i>
                            </span>

                            <!-- Trang cuối -->
                            <span class="page-btn disabled">
                                <i class="fas fa-angle-double-right"></i>
                            </span>
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

            // Export to Excel function


            // Action functions
            function viewOrder(orderId) {
                console.log('Xem chi tiết đơn hàng: ' + orderId);
                // Redirect to view page or open modal
                window.location.href = 'view-import.jsp?id=' + orderId;
            }

            function editOrder(orderId) {
                console.log('Chỉnh sửa đơn hàng: ' + orderId);
                // Redirect to edit page or open modal
                window.location.href = 'serial-check?id=' + orderId;
            }


        </script>

    </body>
</html>
