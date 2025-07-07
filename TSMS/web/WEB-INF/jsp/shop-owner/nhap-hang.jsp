<%-- 
    Document   : nhap-hang
    Created on : December 27, 2024
    Author     : TSMS Team
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Tạo yêu cầu nhập hàng</title>
        <link rel="stylesheet" href="css/nhap-hang.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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

                    <div class="nav-item dropdown active">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="nhap-hang" class="dropdown-item active">Tạo đơn nhập hàng</a>
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

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-invoices?reportType=income" class="dropdown-item">Doanh Thu thuần</a>
                            <a href="so-invoices?reportType=outcome" class="dropdown-item">Khoảng chi</a>
                        </div>
                    </div>
                </nav>

                <div class="header-right">
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <input type="text" class="search-input" placeholder="Tìm hàng hóa theo mã hoặc tên (F3)" id="searchInput">
                        <span class="search-shortcut">F3</span>
                    </div>
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

        <!-- Main Container -->
        <div class="main-container">
            <!-- Left Content -->
            <div class="main-content">
                <!-- Breadcrumb -->
                <div class="breadcrumb">
                    <a href="so-overview">Tổng quan</a>
                    <i class="fas fa-chevron-right"></i>
                    <span>Tạo yêu cầu nhập hàng</span>
                </div>

                <!-- Upload Section -->
                <div class="upload-section" id="uploadSection">
                    <div class="upload-card">
                        <div class="upload-content">
                            <h2>Thêm sản phẩm từ file excel</h2>
                            <p>(Tải về file mẫu: <a href="#" id="downloadTemplate">Excel file</a>)</p>
                            <div class="upload-area" id="uploadArea">
                                <i class="fas fa-file-excel upload-icon"></i>
                                <button class="upload-btn" id="uploadBtn">
                                    <i class="fas fa-upload"></i>
                                    Chọn file dữ liệu
                                </button>
                                <input type="file" id="fileInput" accept=".xlsx,.xls" style="display: none;">
                                <p class="upload-note">Kéo thả file Excel vào đây hoặc click để chọn file</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Products Table Section -->
                <div class="products-section" id="productsSection" style="display: none;">
                    <div class="table-header">
                        <div class="table-title">
                            <h3>Danh sách sản phẩm yêu cầu nhập</h3>
                            <span class="product-count">Tổng: <span id="totalProducts">0</span> sản phẩm</span>
                        </div>
                        <button class="add-product-btn" id="addProductBtn">
                            <i class="fas fa-plus"></i>
                            Thêm sản phẩm
                        </button>
                    </div>

                    <form id="importForm" action="nhap-hang" method="post">
                        <div class="table-container">
                            <table class="products-table">
                                <thead>
                                    <tr>
                                        <th class="checkbox-col">
                                            <input type="checkbox" id="selectAll">
                                        </th>
                                        <th>STT</th>
                                        <th>Mã hàng</th>
                                        <th>Tên hàng</th>
                                        <th>ĐVT</th>
                                        <th>Số lượng yêu cầu</th>
                                        <th>Đơn giá dự kiến</th>
                                        <th>Giảm giá</th>
                                        <th>Thành tiền</th>
                                        <th class="action-col">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="productsTableBody">
                                    <!-- Products will be added here -->
                                </tbody>
                            </table>
                        </div>

                        <div class="table-footer">
                            <div class="bulk-actions">
                                <button type="button" class="bulk-btn" id="deleteSelected">
                                    <i class="fas fa-trash"></i>
                                    Xóa đã chọn
                                </button>
                            </div>
                            <div class="table-summary">
                                <span>Tổng tiền dự kiến: <strong id="totalAmount">0 ₫</strong></span>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Right Sidebar -->
            <div class="sidebar">
                <div class="sidebar-section">
                    <h3>Mã yêu cầu nhập</h3>
                    <p class="auto-code">Mã yêu cầu tự động</p>
                </div>

                <div class="sidebar-section">
                    <h3>Kho nhận hàng *</h3>
                    <select class="sidebar-select" id="warehouseId" name="warehouseId" required>
                        <option value="">-- Chọn kho --</option>
                        <c:forEach var="warehouse" items="${warehouses}">
                            <option value="${warehouse.warehouseID}">${warehouse.warehouseName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="sidebar-section">
                    <h3>Nhà cung cấp *</h3>
                    <select class="sidebar-select" id="supplierId" name="supplierId" required>
                        <option value="">-- Chọn nhà cung cấp --</option>
                        <c:forEach var="supplier" items="${suppliers}">
                            <option value="${supplier.supplierID}">${supplier.supplierName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="sidebar-section">
                    <h3>Mã đặt hàng</h3>
                    <input type="text" class="sidebar-input" name="orderCode" placeholder="Nhập mã đặt hàng (nếu có)">
                </div>

                <div class="sidebar-section">
                    <h3>Ghi chú yêu cầu</h3>
                    <textarea class="sidebar-textarea" name="notes" placeholder="Nhập ghi chú cho yêu cầu nhập hàng..."></textarea>
                </div>

                <div class="sidebar-section">
                    <h3>Độ ưu tiên</h3>
                    <select class="sidebar-select" name="priority">
                        <option value="normal">Bình thường</option>
                        <option value="high">Cao</option>
                        <option value="urgent">Khẩn cấp</option>
                    </select>
                </div>

                <div class="sidebar-section">
                    <h3>Trạng thái</h3>
                    <p class="status">Yêu cầu tạm</p>
                </div>

                <div class="sidebar-section">
                    <div class="summary-row">
                        <span>Tổng tiền dự kiến</span>
                        <span class="summary-value" id="sidebarTotal">0 ₫</span>
                    </div>
                </div>

                <div class="sidebar-section">
                    <div class="summary-row">
                        <span>Giảm giá tổng</span>
                        <input type="number" class="summary-input" id="discountAmount" name="discountAmount" value="0" min="0" placeholder="0">
                    </div>
                </div>

                <div class="sidebar-section">
                    <div class="summary-row">
                        <span>Tổng sau giảm giá</span>
                        <span class="summary-value highlight" id="totalPayable">0 ₫</span>
                    </div>
                </div>

                <div class="sidebar-actions">
                    <button type="button" class="btn-save" id="saveBtn">
                        <i class="fas fa-save"></i>
                        Lưu nháp
                    </button>
                    <button type="button" class="btn-submit" id="submitBtn">
                        <i class="fas fa-paper-plane"></i>
                        Gửi yêu cầu
                    </button>
                </div>
            </div>
        </div>

        <!-- Add Product Modal -->
        <div class="modal-overlay" id="addProductModal">
            <div class="modal">
                <div class="modal-header">
                    <h3>Thêm sản phẩm vào yêu cầu</h3>
                    <button class="modal-close" onclick="closeAddProductModal()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Mã hàng *</label>
                        <input type="text" id="productCode" placeholder="Nhập mã hàng" required>
                    </div>
                    <div class="form-group">
                        <label>Tên hàng *</label>
                        <input type="text" id="productName" placeholder="Nhập tên hàng" required>
                    </div>
                    <div class="form-group">
                        <label>Đơn vị tính</label>
                        <select id="productUnit">
                            <option value="Cái">Cái</option>
                            <option value="Chiếc">Chiếc</option>
                            <option value="Kg">Kg</option>
                            <option value="Thùng">Thùng</option>
                            <option value="Hộp">Hộp</option>
                            <option value="Bộ">Bộ</option>
                            <option value="Gói">Gói</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Số lượng yêu cầu *</label>
                        <input type="number" id="productQuantity" placeholder="0" min="1" required>
                    </div>
                    <div class="form-group">
                        <label>Đơn giá dự kiến</label>
                        <input type="number" id="productPrice" placeholder="0" min="0">
                        <small class="form-note">Có thể để trống, kho sẽ điền giá thực tế</small>
                    </div>
                    <div class="form-group">
                        <label>Giảm giá dự kiến</label>
                        <input type="number" id="productDiscount" placeholder="0" min="0">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn-cancel" onclick="closeAddProductModal()">Hủy</button>
                    <button class="btn-add" onclick="addProduct()">Thêm vào yêu cầu</button>
                </div>
            </div>
        </div>

        <!-- Include JavaScript -->
        <script src="js/nhap-hang.js"></script>
        
        <script>
            // Header dropdown functionality
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");

            toggle?.addEventListener("click", function (e) {
                e.preventDefault();
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            });

            document.addEventListener("click", function (e) {
                if (!toggle?.contains(e.target) && !menu?.contains(e.target)) {
                    menu.style.display = "none";
                }
            });

            // Dropdown menu navigation
            document.querySelectorAll('.dropdown-toggle').forEach(toggle => {
                toggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    const dropdown = this.parentElement;
                    const menu = dropdown.querySelector('.dropdown-menu');
                    
                    // Close other dropdowns
                    document.querySelectorAll('.dropdown-menu').forEach(otherMenu => {
                        if (otherMenu !== menu) {
                            otherMenu.style.display = 'none';
                        }
                    });
                    
                    // Toggle current dropdown
                    menu.style.display = menu.style.display === 'block' ? 'none' : 'block';
                });
            });

            // Close dropdowns when clicking outside
            document.addEventListener('click', function(e) {
                if (!e.target.closest('.dropdown')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.style.display = 'none';
                    });
                }
            });
        </script>
    </body>
</html>