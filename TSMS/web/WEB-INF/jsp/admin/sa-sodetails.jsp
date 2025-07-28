<%-- 
    Document   : sa-sodetails
    Created on : Jun 1, 2025, 5:18:16 PM
    Author     : admin
--%>

<%@ page import="java.util.*, model.ShopOwnerDTO, util.Validate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="util.Validate" %>
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
        <link rel="stylesheet" href="css/sa-sodetails.css"/>
        <style>
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
                        <li><a class="active" href="sa-accounts">
                                <span class="sidebar-icon"><i class="fas fa-users"></i></span>
                                <span>Quản lý tài khoản</span>
                            </a></li>
                        <!--                        <li><a href="#">
                                                        <span class="sidebar-icon"><i class="fas fa-dollar-sign"></i></span>
                                                        <span>Doanh thu</span>
                                                    </a></li>-->
                        <li><a href="sa-subscriptions">
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
                    }
                %>

                <div class="content-grid">
                    <div class="card full-width-card">
                        <div class="card-header">
                            <h2>Chi tiết tài khoản</h2>
                        </div>

                        <%
                ShopOwnerDTO shopOwner = (ShopOwnerDTO) request.getAttribute("shopOwner");
                if (shopOwner != null) {
                    boolean isActive = shopOwner.getIsActive() == 1;
                    String statusText = isActive ? "Hoạt động" : "Không hoạt động";
                    String statusClass = isActive ? "status-active" : "status-inactive";
                        %>

                        <form action="sa-soUpdate" method="post" class="edit-form">
                            <div class="details-card">
                                <div class="card-content">
                                    <div class="info-grid">
                                        <input type="hidden" name="ownerId" value="<%= shopOwner.getOwnerId() %>"/>

                                        <div class="info-item">
                                            <label class="info-label">Họ và tên*:</label>
                                            <input type="text" name="fullName" class="info-input" value="<%= shopOwner.getFullName() %>" required/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Tên cửa hàng*:</label>
                                            <input type="text" name="shopName" class="info-input" value="<%= shopOwner.getShopName() %>" required/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Tên Database:</label>
                                            <input type="text" name="databaseName" class="info-input" value="<%= shopOwner.getDatabaseName() %>" readonly/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Email:</label>
                                            <input type="email" name="email" class="info-input" value="<%= shopOwner.getEmail() != null ? shopOwner.getEmail() : "" %>" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Số điện thoại:</label>
                                            <input type="text" name="phone" class="info-input" value="<%= shopOwner.getPhone() != null ? shopOwner.getPhone() : "" %>" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày tạo:</label>
                                            <input type="date" class="info-input" value="<%= Validate.toInputDate(shopOwner.getCreatedAt()) %>" readonly />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Tình trạng tài khoản*:</label>
                                            <select name="status" class="info-input">
                                                <option value="ACTIVE" <%= shopOwner.getIsActive() == 1 ? "selected" : "" %>>Hoạt động</option>
                                                <option value="INACTIVE" <%= shopOwner.getIsActive() == 0 ? "selected" : "" %>>Không hoạt động</option>
                                            </select>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày thử:</label>
                                            <input type="date" name="trial" class="info-input"
                                                   value="<%= shopOwner.getTrial() != null ? Validate.toInputDate(shopOwner.getTrial()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày hết hạn thử:</label>
                                            <input type="date" name="trial" class="info-input"
                                                   value="<%= shopOwner.getTrialEnd() != null ? Validate.toInputDate(shopOwner.getTrialEnd()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Gói đăng ký:</label>
                                            <input type="text" name="subscription" class="info-input" value="<%= shopOwner.getSubscription() %> tháng" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày đăng ký:</label>
                                            <input type="date" name="subscriptionStart" class="info-input"
                                                   value="<%= shopOwner.getSubscriptionStart() != null ? Validate.toInputDate(shopOwner.getSubscriptionStart()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Ngày hết hạn:</label>
                                            <input type="date" name="subscriptionEnd" class="info-input"
                                                   value="<%= shopOwner.getSubscriptionEnd() != null ? Validate.toInputDate(shopOwner.getSubscriptionEnd()) : "" %>" />
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Mã số thuế:</label>
                                            <input type="text" name="taxNumber" class="info-input" value="<%= shopOwner.getTaxNumber() != null ?  shopOwner.getTaxNumber() : "Chưa cập nhật"%>" readonly=""/>
                                        </div>

                                        <div class="info-item">
                                            <label class="info-label">Website:</label>
                                            <input type="text" name="webUrl" class="info-input" value="<%= shopOwner.getWebURL() != null ?  shopOwner.getWebURL() : "Chưa cập nhật"%>" readonly=""/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="actions-card">
                                <div class="card-header">
                                    <h2>Tổng tiền đã chi cho cá gói dịch vụ</h2>
                                </div>
                                <span style="font-weight: bold">${Validate.formatCostPriceToVND(totalSpent)}đ</span>
                            </div>


                            <div class="actions-card">
                                <div class="card-header">
                                    <h2>Hành động</h2>
                                </div>
                                <div class="card-content">
                                    <div class="action-buttons">
                                        <button type="submit" class="action-btn primary">Cập nhật</button>
                                        <a href="sa-accounts" class="action-btn">Hủy</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                        <% } else { %>
                        <div class="error-message">
                            <h2>Không tìm thấy thông tin chủ cửa hàng</h2>
                            <p>Chủ cửa hàng với ID được yêu cầu không tồn tại trong hệ thống.</p>
                            <a href="sa-home" class="back-btn">Quay lại danh sách</a>
                        </div>
                        <% } %>
                    </div> 
                </div>


                <!-- Subscription History Container -->
                <div class="history-container">
                    <div class="history-header">
                        <h2>
                            <i class="fas fa-history"></i>
                            Lịch sử đăng ký
                        </h2>
                    </div>

                    <form method="get" action="sa-sodetails" class="filters" style="margin: 20px 20px 0px 20px;">
                        <input hidden="" name="id" value="${shopOwner.ownerId}"/>
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
                                                        log.status == 'Refuse' ? 'status-expired' :
                                                        log.status == 'Pending' ? 'status-pending' : 
                                                        'status-cancelled'}">
                                                    <i class="fas
                                                       ${log.status == 'Done' ? 'fa-check-circle' : 
                                                         log.status == 'Refuse' ? 'fa-times-circle' : 
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
                                <form method="get" action="sa-sodetails" style="display:inline;">
                                    <input hidden="" name="id" value="${shopOwner.ownerId}"/>
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
                                <form method="get" action="sa-sodetails?id=3" style="display:inline;">
                                    <input hidden="" name="id" value="${shopOwner.ownerId}"/>
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
                                <form method="get" action="sa-sodetails?id=3" style="display:inline;">
                                    <input hidden="" name="id" value="${shopOwner.ownerId}"/>
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
                                <form method="get" action="sa-sodetails?id=3" style="display:inline;">
                                    <input hidden="" name="id" value="${shopOwner.ownerId}"/>
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