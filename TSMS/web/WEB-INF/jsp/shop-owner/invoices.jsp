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
                    <a href="bm-overview" class="logo">
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
                    <a href="so-invoices" class="nav-item active">
                        <i class="fas fa-chart-bar"></i>
                        Báo cáo Chi tiết
                    </a>
                 
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
    <form action="bm-invoices" method="get" class="filter-form">
        <!-- Basic Filters -->
        <fieldset class="filter-group">
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
                <label for="status">Trạng thái:</label>
                <select id="status" name="status" class="form-select">
                    <option value="">--Tất cả--</option>
                    <option value="completed">Đã xong</option>
                    <option value="pending">Đang xử lý</option>
                    <option value="cancelled">Đã hủy</option>
                </select>
            </div>
            
            <div class="filter-item">
                <label for="shop">Cửa hàng:</label>
                <select id="shop" name="shop" class="form-select">
                    <option value="">--Tất cả--</option>
                    <option value="1">Shop 1</option>
                    <option value="2">Shop 2</option>
                    <option value="3">Shop 3</option>
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
                        <div class="search-container">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Theo mã đơn, tên khách hàng" class="search-input">
                            <i class="fas fa-chevron-down"></i>
                        </div>
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
                                <th class="checkbox-col">
                                    <input type="checkbox">
                                </th>
                                <th>STT</th>
                                <th>Mã đơn hàng</th>
                                <th>Tên sản phẩm</th>
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                                <th>Ngày tạo</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Sample data row -->
                            <tr>
                                <td><input type="checkbox"></td>
                                <td>1</td>
                                <td>HD001</td>
                                <td>Dell Laptop</td>
                                <td>10</td>
                                <td>10.000$</td>
                                <td>1.677.000đ</td>
                                <td>22/05/2025</td>
                                <td><span class="status-badge completed">Đã xong</span></td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn-action view" title="Xem chi tiết">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button class="btn-action edit" title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn-action delete" title="Xóa">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <!-- Empty rows for demonstration -->
                            <tr class="empty-row">
                                <td><input type="checkbox"></td>
                                <td>2</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                            </tr>
                            <tr class="empty-row">
                                <td><input type="checkbox"></td>
                                <td>3</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Total Summary -->
                <div class="total-summary">
                    <div class="summary-item">
                        <span class="summary-label">Tổng cộng:</span>
                        <span class="summary-value">250.506.000đ</span>
                    </div>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị 1 - 10 / Tổng số 1 hóa đơn
                    </div>
                    <div class="pagination">
                        <a href="#" class="page-btn disabled">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="#" class="page-btn disabled">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <a href="#" class="page-btn active">1</a>
                        <a href="#" class="page-btn">...</a>
                        <a href="#" class="page-btn">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="#" class="page-btn">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>
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
                btn.addEventListener('click', function() {
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
    </body>
</html>
