<%-- 
    Document   : sa-subscriptions
    Created on : Jun 29, 2025, 2:30:06 PM
    Author     : admin
--%>

<%@ page import="java.util.*, model.ShopOwnerSubsDTO" %>
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
        <style>
            .flash-message {
                position: fixed;
                top: 20px;
                right: 30px;
                padding: 16px 24px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                color: white;
                z-index: 1000;
                font-size: 16px;
                animation: fadeOut 0.5s ease-in-out 4.5s forwards;
            }

            .flash-message.success {
                background-color: #4CAF50;
            }

            .flash-message.error {
                background-color: #f44336;
            }

            @keyframes fadeOut {
                to {
                    opacity: 0;
                    transform: translateY(-20px);
                    visibility: hidden;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Sidebar -->
            <div class="sidebar">
                <div class="logo">
                    <a href="sa-home" class="logo">
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
                        <!--                        <li><a href="#">
                                                        <span class="sidebar-icon"><i class="fas fa-dollar-sign"></i></span>
                                                        <span>Doanh thu</span>
                                                    </a></li>-->
                        <li><a class="active" href="#">
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
                <%
                String updateStatus = request.getParameter("update");
                if ("success".equals(updateStatus)) {
                %>
                <div id="flash-message" class="flash-message success">
                    Cập nhật thành công!
                </div>
                <%
                    } else if ("error".equals(updateStatus)) {
                %>
                <div id="flash-message" class="flash-message error">
                    Cập nhật thất bại. Vui lòng thử lại.
                </div>
                <%
                    } else if ("success-refuse".equals(updateStatus)) {
                %>
                <div id="flash-message" class="flash-message success">
                    Từ chối thành công!
                </div>
                <%
                    } 
                %>

                <div class="content-grid">
                    <!-- Bộ lọc -->
                    <div class="filter-container card">
                        <form method="get" action="sa-subscriptions" class="formFilter">
                            <input type="hidden" name="search" value="${param.search}" />
                            <input type="hidden" name="recordsPerPage" value="${param.recordsPerPage}" />
                            <div>
                                <label for="subscription">Gói dịch vụ:</label>
                                <select name="subscription" id="subscription">
                                    <option value="">Tất cả</option>
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
                            <a href="sa-subscriptions?page=1" style="display: flex; text-decoration: none"><button type="button" class="btn btn-filter"><i class="fas fa-eraser"></i>Xoá</button></a>   

                            <a href="" style="display: flex; text-decoration: none"><button type="submit" class="btn btn-filter"><i class="fas fa-filter"></i>Lọc</button></a> 
                        </form>
                    </div>

                    <div style="align-content: center;">
                        <form action="sa-subscriptions" method="get" class="search-form" style="display: flex; align-items: center; gap: 8px;">
                            <div style="position: relative; flex: 1;">
                                <i class="fas fa-search" style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #aaa;"></i>
                                <input type="text" name="search" placeholder="Tìm kiếm người dùng..." value="${param.search}"
                                       style="padding: 10px 10px 10px 35px; width: 100%; border: 1px solid #ccc; border-radius: 100px;">
                            </div>
                            <input type="hidden" name="subscription" value="${param.subscription}" />
                            <input type="hidden" name="status" value="${param.status}" />
                            <input type="hidden" name="fromDate" value="${param.fromDate}" />
                            <input type="hidden" name="search" value="${param.toDate}" />
                            <input type="hidden" name="recordsPerPage" value="${recordsPerPage}" />
                            <button type="submit" class="btn btn-success" style="padding: 10px 18px;">Tìm Kiếm</button>
                        </form>
                    </div>

                    <!-- Bảng dữ liệu -->
                    <div class="card full-width-card">
                        <div class="card-header">
                            <h2>Yêu cầu gia hạn</h2>
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
                                        <th>Ngày yêu cầu</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty shopOwners}">
                                            <tr>
                                                <td colspan="8" class="empty-state">
                                                    <h5>Không có yêu cầu nào!</h5>
                                                </td>
                                            </tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="owner" items="${shopOwners}">
                                                <tr>
                                                    <td>${owner.ownerId}</td>
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
                                                    <td>${owner.subscriptionMonth} tháng</td>
                                                    <td><fmt:formatDate value="${owner.logCreatedAt}" pattern="dd/MM/yyyy" /></td>
                                                    <td style="width: 250px;">
                                                        <a href="sa-approved-subs?id=${owner.ownerId}&action=accept&methodId=1&subsMonth=${owner.subscriptionMonth}"><button class="btn btn-primary">Chấp nhận</button></a> 
                                                        <a href="sa-approved-subs?id=${owner.ownerId}&action=refuse&methodId=1&subsMonth=${owner.subscriptionMonth}"><button class="btn btn-ref">Từ chối</button></a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <form method="GET" action="sa-subscriptions">
                            <div class="pagination-container">
                                <div class="pagination-info">
                                    Hiển thị ${startUser} - ${endUser} / Tổng số ${totalRecords} tài khoản
                                </div>
                                <input type="hidden" name="subscription" value="${param.subscription}" />
                                <input type="hidden" name="status" value="${param.status}" />
                                <input type="hidden" name="fromDate" value="${param.fromDate}" />
                                <input type="hidden" name="toDate" value="${param.toDate}" />
                                <input type="hidden" name="search" value="${param.search}" />
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
                                    <a href="${pagingUrl}1" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                                        <i class="fas fa-angle-double-left"></i>
                                    </a>
                                    <a href="${pagingUrl}${currentPage - 1}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                                        <i class="fas fa-angle-left"></i>
                                    </a>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <a href="${pagingUrl}${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                                    </c:forEach>
                                    <a href="${pagingUrl}${currentPage + 1}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                                        <i class="fas fa-angle-right"></i>
                                    </a>
                                    <a href="${pagingUrl}${totalPages}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
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
