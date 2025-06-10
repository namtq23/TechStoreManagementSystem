<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="model.OrdersDTO" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Hàng hóa</title>
    <link rel="stylesheet" href="css/so-products.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../common/header-so.jsp" />

    <div class="main-container">
        <!-- Sidebar -->
        <aside class="sidebar">

            <!-- Category Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Chi nhánh</h3>
                    <i class="fas fa-question-circle"></i>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <div class="category-tree">
                        <div class="category-item selected">
                            <span class="category-label" onclick="filterProducts(null)">Tất cả</span>
                        </div>
                        <!-- Danh sách chi nhánh sẽ được hiển thị ở đây -->
                    </div>
                </div>
            </div>

            <!-- Time Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Thời gian</h3>
                </div>
                <div class="filter-content">
                    <label class="radio-item">
                        <input type="radio" name="time" value="this-month" checked>
                        <span class="radio-mark"></span>
                        Tháng này
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="time" value="custom">
                        <span class="radio-mark"></span>
                        Lựa chọn khác
                    </label>
                    <input type="date" name="custom-date" style="margin-left: 25px; margin-top: 5px;">
                </div>
            </div>

            <!-- Creator Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Người tạo</h3>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <select name="creator" class="creator-dropdown">
                        <option value="">Chọn người tạo</option>
                        <!-- Thêm option ở đây -->
                        <option value="user1">Nguyễn Văn A</option>
                        <option value="user2">Trần Thị B</option>
                    </select>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1>Trang đơn hàng</h1>
                <div class="header-actions">
                    <form class="search-form" style="display: flex; align-items: center; gap: 8px;">
                        <div style="position: relative; flex: 1;">
                            <i class="fas fa-search" style="position: absolute; top: 50%; left: 10px; transform: translateY(-50%); color: #aaa;"></i>
                            <input type="text" name="search" placeholder="Theo tên hàng"
                                style="padding: 10px 10px 10px 60px; width: 100%; border: 1px solid #ccc; border-radius: 15px;">
                        </div>
                        <button type="submit" class="btn btn-success" style="padding: 10px 18px;">Tìm Kiếm</button>
                    </form>

                    <form class="add-form">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-plus"></i> Thêm mới
                        </button>
                    </form>

                    <button class="btn btn-menu">
                        <i class="fas fa-bars"></i>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                </div>
            </div>

           <!-- Orders Table -->
<div class="table-container">
    <table class="products-table">
        <thead>
            <tr>
                <th class="checkbox-col"><input type="checkbox" id="selectAll"></th>
                <th></th>
                <th>Mã đơn hàng</th>
                <th>Chi nhánh</th>
                <th>Khách hàng</th>
                <th>Nhân viên tạo</th>
                <th>Thời gian tạo</th>
                <th>Trạng thái đơn</th>
                <th>Tổng tiền</th>
                <th>Phương thức</th>
                <th>Ghi chú</th>
                <th style="justify-content: center;text-align: center">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<OrdersDTO> ordersList = (List<OrdersDTO>) request.getAttribute("ordersList");
                if (ordersList != null && !ordersList.isEmpty()) {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    java.text.NumberFormat currencyFormat = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("vi", "VN"));
                    for (OrdersDTO order : ordersList) {
            %>
            <tr>
                <td class="checkbox-col">
                    <input type="checkbox" name="selectedOrders" value="<%=order.getOrderID()%>">
                </td>
                <td></td>
                <td><%=order.getOrderID()%></td>
                <td><%=order.getBranchName()%></td>
                <td><%=order.getCustomerName()%></td>
                <td><%=order.getCreatedByName()%></td>
                <td>
                    <%=order.getCreatedAt() != null ? sdf.format(order.getCreatedAt()) : ""%>
                </td>
                <td><%=order.getOrderStatus()%></td>
                <td>
                    <%=currencyFormat.format(order.getGrandTotal())%>
                </td>
                <td><%=order.getPaymentMethod()%></td>
                <td><%=order.getNotes()%></td>
                <td class="actions-col" style="justify-content: center; display: flex; gap: 5px">
                    <a href="so-orders?action=view&id=<%=order.getOrderID()%>"
                       class="btn btn-success"
                       style="text-decoration: none; width: 79px; background:#2196F3">Chi tiết</a>
                    <form action="delete-order" method="post" style="display:inline;">
                        <input type="hidden" name="orderID" value="<%=order.getOrderID()%>"/>
                        <button type="submit" class="btn btn-success" style="background: #f44336;"
                                onclick="return confirm('Bạn có chắc chắn muốn xoá đơn hàng này?');">Xoá</button>
                    </form>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="12" style="text-align:center;">Không có đơn hàng nào!</td>
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
                Hiển thị ${startOrder} - ${endOrder} / Tổng số ${totalOrders} đơn hàng
            </div>
            <div class="pagination">
                <a href="so-orders?page=1" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                    <i class="fas fa-angle-double-left"></i>
                </a>
                <a href="so-orders?page=${currentPage - 1}" class="page-btn ${currentPage == 1 ? 'disabled' : ''}">
                    <i class="fas fa-angle-left"></i>
                </a>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="so-orders?page=${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                </c:forEach>
                <a href="so-orders?page=${currentPage + 1}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                    <i class="fas fa-angle-right"></i>
                </a>
                <a href="so-orders?page=${totalPages}" class="page-btn ${currentPage == totalPages ? 'disabled' : ''}">
                    <i class="fas fa-angle-double-right"></i>
                </a>
            </div>
        </div>
    </main>

    <script>
        document.getElementById('selectAll').addEventListener('change', function () {
            const checkboxes = document.querySelectorAll('.product-checkbox');
            checkboxes.forEach(cb => cb.checked = this.checked);
        });

        function filterProducts(categoryId) {
            const search = document.getElementById('searchInput').value;
            let url = 'so-products.html?page=1&search=' + encodeURIComponent(search);

            if (categoryId !== null && categoryId !== undefined) {
                url += '&categoryId=' + encodeURIComponent(categoryId);
            }

            const inventory = document.querySelector('input[name="inventory"]:checked')?.value || 'all';
            url += '&inventory=' + encodeURIComponent(inventory);

            console.log('Chuyển hướng đến URL: ' + url);
            window.location.href = url;
        }
    </script>
</body>
</html>
