<%@ page import="java.util.*, model.ShopOwnerDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Subscription Management</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="css/sa-home.css"/>
        <link rel="stylesheet" href="css/sa-acc-manage.css"/>
    </head>
    <body>
        <div class="container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="logo">
                    <a href="bm-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">Admin</span>
                    </a>
                </div>
                <nav class="sidebar-nav">
                    <ul>
                        <li><a href="sa-home">
                                <span class="sidebar-icon"><i class="fas fa-chart-bar"></i></span>
                                <span>Dashboard</span>
                            </a></li>
                        <li><a href="sa-accounts">
                                <span class="sidebar-icon"><i class="fas fa-users"></i></span>
                                <span>Quản lý tài khoản</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-dollar-sign"></i></span>
                                <span>Doanh thu</span>
                            </a></li>
                        <li><a href="#">
                                <span class="sidebar-icon"><i class="fas fa-clipboard-list"></i></span>
                                <span>Subscription</span>
                            </a></li>
                        <li><a href="sa-logout">
                                <span class="sidebar-icon"><i class="fas fa-sign-out-alt"></i></span>
                                <span>Đăng xuất</span>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="main-content">

                <!-- Content Grid -->
                <div class="content-grid">
                    <!-- Bộ lọc -->
                    <div class="filter-container">
                        <form method="get" action="sa-accounts" class="formFilter">
                            <div>
                                <label for="subscription">Gói dịch vụ:</label>
                                <select name="subscription" id="subscription">
                                    <option value="">Tất cả</option>
                                    <option value="TRIAL" ${param.subscription == 'TRIAL' ? 'selected' : ''}>Trial</option>
                                    <option value="3" ${param.subscription == '3' ? 'selected' : ''}>3 tháng</option>
                                    <option value="6" ${param.subscription == '6' ? 'selected' : ''}>6 tháng</option>
                                    <option value="12" ${param.subscription == '12' ? 'selected' : ''}>12 tháng</option>
                                    <option value="24" ${param.subscription == '24' ? 'selected' : ''}>24 tháng</option>
                                </select>
                            </div>
                            <div>
                                <label for="status">Trạng thái:</label>
                                <select name="status" id="status">
                                    <option value="">Tất cả</option>
                                    <option value="1" ${param.status == '1' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="0" ${param.status == '0' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                            <div>
                                <label for="fromDate">Từ ngày:</label>
                                <input type="date" name="fromDate" value="${param.fromDate}" />
                            </div>
                            <div>
                                <label for="toDate">Đến ngày:</label>
                                <input type="date" name="toDate" value="${param.toDate}" />
                            </div>
                            <button type="submit" class="btn btn-filter"><i class="fas fa-filter"></i> Lọc</button>
                        </form>
                    </div>

                    <!-- Account Management -->
                    <div class="card full-width-card">
                        <div class="card-header">
                            <h2>Quản lý tài khoản</h2>

                        </div>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Tên người dùng</th>
                                        <th>Email</th>
                                        <th>Tên shop</th>
                                        <th>Trạng thái</th>
                                        <th>Gói dịch vụ</th>
                                        <th>Ngày đăng ký</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="owner" items="${shopOwners}">
                                        <tr>
                                            <td>#${owner.ownerId}</td>
                                            <td>${owner.fullName}</td>
                                            <td>${owner.email}</td>
                                            <td>${owner.shopName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${owner.isActive == 1}">
                                                        <span class="status active">Hoạt động</span>
                                                    </c:when>
                                                    <c:when test="${owner.isActive == 0}">
                                                        <span class="status inactive">Không hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status pending">Chờ xử lý</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${owner.status}</td>
                                            <td>
                                                <fmt:formatDate value="${owner.createdAt}" pattern="dd/MM/yyyy" />
                                            </td>
                                            <td>
                                                <button class="btn btn-primary">Xem</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <!-- Pagination -->
                        <form method="GET" action="bm-products">
                            <div class="pagination-container">
                                <div class="pagination-info">
                                    Hiển thị  - / Tổng số  hàng hóa
                                </div>

                                <c:forEach var="catId" items="">
                                    <input type="hidden" name="categories" value="" />
                                </c:forEach>
                                <input type="hidden" name="inventory" value="" />
                                <input type="hidden" name="minPrice" value="" />
                                <input type="hidden" name="maxPrice" value="" />
                                <input type="hidden" name="status" value="" />
                                <input type="hidden" name="search" value="" />
                                <div class="records-per-page">
                                    <label for="recordsPerPage">Hiển thị:</label>
                                    <select id="recordsPerPage" name="recordsPerPage" class="records-select" onchange="this.form.submit()">
                                        <option value="10">10</option>
                                        <option value="25">25</option>
                                        <option value="50">50</option>
                                        <option value="100">100</option>
                                    </select>
                                    <span>bản ghi/trang</span>
                                </div>

                                <div class="pagination">
                                    <a href="" class="page-btn">
                                        <i class="fas fa-angle-double-left"></i>
                                    </a>
                                    <a href="" class="page-btn">
                                        <i class="fas fa-angle-left"></i>
                                    </a>

                                    <a href="" class="page-btn">1</a>

                                    <a href="" class="page-btn">
                                        <i class="fas fa-angle-right"></i>
                                    </a>
                                    <a href="" class="page-btn">
                                        <i class="fas fa-angle-double-right"></i>
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const sidebarLinks = document.querySelectorAll('.sidebar-nav a');
                const currentPath = window.location.pathname;

                sidebarLinks.forEach(link => {
                    const href = link.getAttribute('href');
                    // So khớp tương đối với pathname
                    if (href && currentPath.includes(href)) {
                        link.classList.add('active');
                    } else {
                        link.classList.remove('active');
                    }
                });

                // Optional: Animation for cards
                const cards = document.querySelectorAll('.card, .stat-card');
                cards.forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-2px)';
                    });
                    card.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(0)';
                    });
                });
            });
        </script>
    </body>
</html>