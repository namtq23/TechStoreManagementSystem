<%-- 
    Document   : products.
    Created on : May 22, 2025, 11:19:37 AM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KiotViet - Hàng hóa</title>
    <link rel="stylesheet" href="css/bm-products.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../common/header.jsp" />

    <div class="main-container">
        <!-- Sidebar -->
        <aside class="sidebar">
            <!-- Product Type Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Loại hàng</h3>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <label class="checkbox-item">
                        <input type="checkbox" checked>
                        <span class="checkmark"></span>
                        Hàng hóa thường
                    </label>
                    <label class="checkbox-item">
                        <input type="checkbox">
                        <span class="checkmark"></span>
                        Hàng hóa - Serial/IMEI
                    </label>
                    <label class="checkbox-item">
                        <input type="checkbox">
                        <span class="checkmark"></span>
                        Dịch vụ
                    </label>
                    <label class="checkbox-item">
                        <input type="checkbox">
                        <span class="checkmark"></span>
                        Combo - Đóng gói
                    </label>
                </div>
            </div>

            <!-- Product Group Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Nhóm hàng</h3>
                    <i class="fas fa-question-circle"></i>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm nhóm hàng">
                    </div>
                    <div class="category-tree">
                        <div class="category-item">
                            <span class="category-label">Tất cả</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Điện thoại</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Đồng hồ thông minh</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Laptop</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Máy tính bảng</span>
                        </div>
                        <div class="category-item expandable">
                            <i class="fas fa-plus"></i>
                            <span class="category-label">Phụ kiện</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Inventory Filter -->
            <div class="filter-section">
                <div class="filter-header">
                    <h3>Tồn kho</h3>
                    <i class="fas fa-chevron-up"></i>
                </div>
                <div class="filter-content">
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="all" checked>
                        <span class="radio-mark"></span>
                        <span class="status-indicator all"></span>
                        Tất cả
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="below">
                        <span class="radio-mark"></span>
                        <span class="status-indicator below"></span>
                        Dưới định mức tồn
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="above">
                        <span class="radio-mark"></span>
                        <span class="status-indicator above"></span>
                        Vượt định mức tồn
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="in-stock">
                        <span class="radio-mark"></span>
                        <span class="status-indicator in-stock"></span>
                        Còn hàng trong kho
                    </label>
                    <label class="radio-item">
                        <input type="radio" name="inventory" value="out-stock">
                        <span class="radio-mark"></span>
                        <span class="status-indicator out-stock"></span>
                        Hết hàng trong kho
                    </label>
                </div>
            </div>
        </aside>

        <!-- Main Content -->
        <main class="main-content">
            <div class="page-header">
                <h1>Hàng hóa</h1>
                <div class="header-actions">
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Theo mã, tên hàng" class="search-input">
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <button class="btn btn-success">
                        <i class="fas fa-plus"></i>
                        Thêm mới
                        <i class="fas fa-chevron-down"></i>
                    </button>
                    <button class="btn btn-success">
                        <i class="fas fa-download"></i>
                        Import
                    </button>
                    <button class="btn btn-success">
                        <i class="fas fa-upload"></i>
                        Xuất file
                    </button>
                    <button class="btn btn-menu">
                        <i class="fas fa-bars"></i>
                        <i class="fas fa-chevron-down"></i>
                    </button>
                </div>
            </div>

            <!-- Products Table -->
            <div class="table-container">
                <table class="products-table">
                    <thead>
                        <tr>
                            <th class="checkbox-col">
                                <input type="checkbox">
                            </th>
                            <th class="favorite-col">
                                <i class="far fa-star"></i>
                            </th>
                            <th class="image-col"></th>
                            <th>Mã hàng</th>
                            <th>Tên hàng</th>
                            <th>Giá bán</th>
                            <th>Giá vốn</th>
                            <th>Tồn kho</th>
                            <th>Khách đặt</th>
                            <th>Thời gian tạo</th>
                            <th>Dự kiến hết hàng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="summary-row">
                            <td colspan="7"></td>
                            <td class="summary-cell">184</td>
                            <td class="summary-cell">0</td>
                            <td class="summary-cell">---</td>
                            <td class="summary-cell">---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image phone"></div></td>
                            <td>TB000014</td>
                            <td>Samsung Galaxy Tab S9 5G 128GB</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr class="highlighted">
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image phone"></div></td>
                            <td>TB000013</td>
                            <td>Samsung Galaxy Tab S9 5G 128GB</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image tablet"></div></td>
                            <td>TB000012</td>
                            <td>iPad Air 6 M2 11" 5G 128GB</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image tablet"></div></td>
                            <td>TB000011</td>
                            <td>iPad Air 6 M2 11" 5G 128GB</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image accessory"></div></td>
                            <td>PK000020</td>
                            <td>Giá đỡ Laptop/Macbook hợp kim nhôm</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image accessory"></div></td>
                            <td>PK000019</td>
                            <td>Miếng dán kính cường lực iPhone 15 Pro Jincase</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image accessory"></div></td>
                            <td>PK000018</td>
                            <td>Cáp Baseus Crystal Shine Type-C to Lightning 2M</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image accessory"></div></td>
                            <td>PK000017</td>
                            <td>Ốp lưng iPhone 15 Pro Max Nhua dẻo TPU UNIQ HYBRID Air Fender ID</td>
                            <td>0</td>
                            <td>0</td>
                            <td>92</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image accessory"></div></td>
                            <td>PK000016</td>
                            <td>Chuột không dây Logitech M331</td>
                            <td>349,000</td>
                            <td>0</td>
                            <td>92</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                        <tr>
                            <td><input type="checkbox"></td>
                            <td><i class="far fa-star"></i></td>
                            <td><div class="product-image accessory"></div></td>
                            <td>PK000015</td>
                            <td>Chuột không dây Logitech M331</td>
                            <td>349,000</td>
                            <td>0</td>
                            <td>0</td>
                            <td>0</td>
                            <td>01/06/2025 21:29</td>
                            <td>---</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="pagination-container">
                <div class="pagination-info">
                    Hiển thị 1 - 15 / Tổng số 30 hàng hóa
                </div>
                <div class="pagination">
                    <button class="page-btn" disabled>
                        <i class="fas fa-angle-double-left"></i>
                    </button>
                    <button class="page-btn" disabled>
                        <i class="fas fa-angle-left"></i>
                    </button>
                    <button class="page-btn active">1</button>
                    <button class="page-btn">2</button>
                    <button class="page-btn">
                        <i class="fas fa-angle-right"></i>
                    </button>
                    <button class="page-btn">
                        <i class="fas fa-angle-double-right"></i>
                    </button>
                </div>
            </div>
        </main>
    </div>

    <!-- Support Chat Button -->
    <div class="support-chat">
        <i class="fas fa-headset"></i>
        <span>Hỗ trợ:1900 6522</span>
    </div>
</body>
</html>
