<%-- 
    Document   : employee
    Created on : Jun 2, 2025, 2:30:10 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.UserDTO" %>
<%@ page import="util.Validate" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Nhân Viên</title>
        <link rel="stylesheet" href="css/header.css"> 
        <link rel="stylesheet" href="css/so-staff.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
        <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
        <title>JSP Page</title>
        <style>
            .btn-successs {
                background-color: #2196F3;
            }

            .btn-successs:hover {
                background-color: #1976D2;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(33, 150, 243, 0.3);
            }
        </style>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="bm-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="bm-overview" class="nav-item">
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
                            <a href="bm-stockmovement?type=import" class="dropdown-item">Nhập hàng</a>
                            <a href="request-stock" class="dropdown-item">Yêu cầu nhập hàng</a>
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

                    <div class="nav-item dropdown active">
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
            <!-- Sidebar -->
            <aside class="sidebar">
                <form action="bm-staff" method="get" id="filterForm">
                    <!-- Status Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3>Trạng thái nhân viên</h3>
                        </div>
                        <div class="filter-content">
                            <div class="category-tree">
                                <div class="category-item">
                                    <input type="radio" id="status-all" name="status" value="" ${selectedStatus == null ? 'checked' : ''}>
                                    <label for="status-all" class="category-label">
                                        <span>Tất cả</span>
                                    </label>
                                </div>
                                <div class="category-item">
                                    <input type="radio" id="status-1" name="status" value="1" ${selectedStatus == 1 ? 'checked' : ''}>
                                    <label for="status-1" class="category-label">
                                        <span>Đang làm việc</span>
                                    </label>
                                </div>
                                <div class="category-item">
                                    <input type="radio" id="status-0" name="status" value="0" ${selectedStatus == 0 ? 'checked' : ''}>
                                    <label for="status-0" class="category-label">
                                        <span>Nghỉ việc</span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Action Buttons -->
                    <div class="filter-actions">
                        <a href="bm-staff?page=1" class="btn-clear">
                            <i class="fas fa-eraser"></i>
                            Xóa bộ lọc
                        </a>
                        <button type="submit" class="btn-apply">
                            <i class="fas fa-filter"></i>
                            Áp dụng lọc
                        </button>
                    </div>             
                </form>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <div class="page-header">
                    <h1>Nhân viên</h1>
                    <div class="header-actions">
                        <form class="search-input" action="bm-staff" method="get" style="display: flex; align-items: center; gap: 20px;">
                            <div style="position: relative; flex: 1;">
                                <i class="fas fa-search" style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #aaa;"></i>
                                <input type="text" name="search" placeholder="Theo mã, tên nhân viên"  value="${search}"
                                       style="padding: 10px 10px 10px 30px; width: 100%; border: 1px solid #ccc; border-radius: 15px;">
                                <c:if test="${selectedStatus != null}">
                                    <input type="hidden" name="status" value="${selectedStatus}">
                                </c:if>
                                <c:if test="${selectedRole != null}">
                                    <input type="hidden" name="role" value="${selectedRole}">
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Staff Table -->
                <div class="table-container">
                    <table class="products-table">
                        <thead>
                            <tr>
                                <th class="checkbox-col"><input type="checkbox" id="selectAll"></th>
                                <th>Mã nhân viên</th>
                                <th>Tên nhân viên</th>
                                <th>Chức danh</th>
                                <th>Chi nhánh/Kho</th>
                                <th>Số điện thoại</th>
                                <th>Trạng thái</th>
                                <th style="justify-content: center; text-align: center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                List<UserDTO> staffList = (List<UserDTO>) request.getAttribute("staffList");
                                if (staffList != null && !staffList.isEmpty()) {
                                    for (UserDTO staff : staffList) {
                            %>
                            <tr>
                                <td class="checkbox-col">
                                    <input type="checkbox" name="selectedStaff" value="<%=staff.getUserID()%>">
                                </td>
                                <td><%=staff.getUserID()%></td>
                                <td><%=staff.getFullName()%></td>
                                <td><%=staff.getRoleName()%></td>
                                <td><%=staff.getBranchName() != null ? staff.getBranchName() : (staff.getWarehouseName() != null ? staff.getWarehouseName() : "")%></td>
                                <td><%=staff.getPhone() != null ? staff.getPhone() : ""%></td>
                                <td><%=staff.getIsActive() == 1 ? "Đang làm việc" : "Nghỉ việc"%></td>
                                <td class="actions-col" style="justify-content: center; display: flex; gap: 5px">
                                    <form action="bm-staff" method="get" style="display:inline;">
                                        <input type="hidden" name="action" value="view"/>
                                        <input type="hidden" name="userID" value="<%=staff.getUserID()%>"/>
                                        <button type="submit" class="btn btn-success" style="text-decoration: none; width: 79px; background:#2196F3">Chi tiết</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="8" style="text-align:center;">Không có nhân viên nào!</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startStaff} - ${endStaff} / Tổng số ${totalStaff} nhân viên
                    </div>
                    <div class="pagination">
                        <a href="bm-staff?page=1${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == 1 ? 'disabled' : '')}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="bm-staff?page=${currentPage - 1}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == 1 ? 'disabled' : '')}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="bm-staff?page=${i}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (i == currentPage ? 'active' : '')}">${i}</a>
                        </c:forEach>
                        <a href="bm-staff?page=${currentPage + 1}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == totalPages ? 'disabled' : '')}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="bm-staff?page=${totalPages}${selectedStatus != null ? '&status=' += selectedStatus : ''}${selectedRole != null ? '&role=' += selectedRole : ''}" class="page-btn ${totalStaff == 0 ? 'disabled' : (currentPage == totalPages ? 'disabled' : '')}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>

            </main>
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

