<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập hàng - TSMS</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="style.css" rel="stylesheet">
</head>
<body>
    <!-- Header -->
    <header class="main-header">
        <div class="header-left">
            <button class="back-btn" onclick="history.back()">
                <i class="fas fa-arrow-left"></i>
            </button>
            <h1 class="page-title">Nhập hàng</h1>
        </div>
        <div class="header-right">
            <div class="search-container">
                <i class="fas fa-search"></i>
                <input type="text" class="search-input" placeholder="Tìm hàng hóa theo mã hoặc tên (F3)" id="searchInput">
                <span class="search-shortcut">F3</span>
            </div>
            <button class="header-btn"><i class="fas fa-list"></i></button>
            <button class="header-btn"><i class="fas fa-plus"></i></button>
            <button class="header-btn"><i class="fas fa-print"></i></button>
            <div class="user-info">
                <span>Nguyen Van A</span>
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Left Content -->
        <div class="main-content">
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
                        <h3>Danh sách sản phẩm nhập</h3>
                        <span class="product-count">Tổng: <span id="totalProducts">0</span> sản phẩm</span>
                    </div>
                    <button class="add-product-btn" id="addProductBtn">
                        <i class="fas fa-plus"></i>
                        Thêm sản phẩm
                    </button>
                </div>

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
                                <th>Số lượng</th>
                                <th>Đơn giá</th>
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
                        <button class="bulk-btn" id="deleteSelected">
                            <i class="fas fa-trash"></i>
                            Xóa đã chọn
                        </button>
                    </div>
                    <div class="table-summary">
                        <span>Tổng tiền hàng: <strong id="totalAmount">0 ₫</strong></span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Sidebar -->
        <div class="sidebar">
            <div class="sidebar-section">
                <h3>Mã phiếu nhập</h3>
                <p class="auto-code">Mã phiếu tự động</p>
            </div>

            <div class="sidebar-section">
                <h3>Mã đặt hàng nhập</h3>
                <input type="text" class="sidebar-input" placeholder="Nhập mã đặt hàng">
            </div>

            <div class="sidebar-section">
                <h3>Trạng thái</h3>
                <p class="status">Phiếu tạm</p>
            </div>

            <div class="sidebar-section">
                <div class="summary-row">
                    <span>Tổng tiền hàng</span>
                    <span class="summary-value" id="sidebarTotal">0</span>
                </div>
            </div>

            <div class="sidebar-section">
                <div class="summary-row">
                    <span>Giảm giá</span>
                    <span class="summary-value">0</span>
                </div>
            </div>

            <div class="sidebar-section">
                <div class="summary-row">
                    <span>Cần trả nhà cung cấp</span>
                    <span class="summary-value highlight" id="totalPayable">0</span>
                </div>
            </div>

            <div class="sidebar-actions">
                <button class="btn-save" id="saveBtn">
                    <i class="fas fa-save"></i>
                    Lưu tạm
                </button>
                <button class="btn-complete" id="completeBtn">
                    <i class="fas fa-check"></i>
                    Hoàn thành
                </button>
            </div>
        </div>
    </div>

    <!-- Add Product Modal -->
    <div class="modal-overlay" id="addProductModal">
        <div class="modal">
            <div class="modal-header">
                <h3>Thêm sản phẩm</h3>
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
                    </select>
                </div>
                <div class="form-group">
                    <label>Số lượng *</label>
                    <input type="number" id="productQuantity" placeholder="0" min="1" required>
                </div>
                <div class="form-group">
                    <label>Đơn giá *</label>
                    <input type="number" id="productPrice" placeholder="0" min="0" required>
                </div>
                <div class="form-group">
                    <label>Giảm giá</label>
                    <input type="number" id="productDiscount" placeholder="0" min="0">
                </div>
            </div>
            <div class="modal-footer">
                <button class="btn-cancel" onclick="closeAddProductModal()">Hủy</button>
                <button class="btn-add" onclick="addProduct()">Thêm</button>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>