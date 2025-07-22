<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ProductDTO, util.Validate" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Chi tiết sản phẩm</title>
        <link rel="stylesheet" href="css/so-products.css">
        <link rel="stylesheet" href="css/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                background: #f5f7fa;
            }

            .main-container {
                padding: 30px;
                max-width: 900px;
                margin: auto;
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .page-header h1 {
                font-size: 26px;
                color: #333;
            }

            .btn {
                padding: 10px 18px;
                border: none;
                border-radius: 6px;
                color: white;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-success {
                background-color: #2196F3;
            }

            .btn-success:hover {
                background-color: #1976D2;
            }

            .btn-danger {
                background-color: #f44336;
            }

            .btn-danger:hover {
                background-color: #d32f2f;
            }

            .form-container {
                background: white;
                padding: 25px 30px;
                border-radius: 12px;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
            }

            .form-group {
                display: flex;
                flex-direction: column;
                margin-bottom: 18px;
            }

            .form-group label {
                font-weight: 600;
                margin-bottom: 6px;
                color: #555;
            }

            .form-group input,
            .form-group textarea,
            .form-group select {
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 15px;
                background: #fafafa;
            }

            .form-group input[readonly] {
                background-color: #eee;
                color: #666;
                cursor: not-allowed;
            }

            .form-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 30px;
            }

            textarea {
                resize: vertical;
            }

            @media (max-width: 768px) {
                .main-container {
                    padding: 20px;
                }

                .form-actions {
                    flex-direction: column;
                    align-items: stretch;
                }
            }
        </style>
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
                    <a href="so-overview" class="nav-item active">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="so-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="so-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="import-request" class="dropdown-item">Tạo đơn nhập hàng</a>
                            <a href="so-track-movements" class="dropdown-item">Theo dõi nhập/xuất</a>
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

        <div class="main-container">
            <main class="main-content">
                <div class="page-header">
                    <h1>Chi tiết sản phẩm</h1>
                    <a href="so-products" class="btn btn-success" style="text-decoration: none">← Quay lại</a>
                </div>

                <div class="form-container">
                    <form action="so-products" method="post" class="product-form">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="productDetailId" value="${product.productDetailId}">
                        <input type="hidden" name="productId" value="${product.productId}">

                        <!-- Read-only Fields -->
                        <div class="form-group">
                            <label>Mã hàng:</label>
                            <input type="text" value="${product.productDetailId}" readonly>
                        </div>
                        <div class="form-group">
                            <label>Tên hàng:</label>
                            <input type="text" value="${product.productName}" readonly>
                        </div>
                        <div class="form-group">
                            <label>Thương hiệu:</label>
                            <input type="text" value="${product.brandName}" readonly>
                        </div>
                        <div class="form-group">
                            <label>Nhóm hàng:</label>
                            <input type="text" value="${product.categoryName}" readonly>
                        </div>
                        <div class="form-group">
                            <label>Nhà cung cấp:</label>
                            <input type="text" value="${product.supplierName}" readonly>
                        </div>
                        <div class="form-group">
                            <label>Số lượng tồn kho:</label>
                            <input type="text" value="${product.quantity}" readonly>
                        </div>
                        <div class="form-group">
                            <label>Số serial/IMEI:</label>
                            <input type="text" value="${product.serialNum}" readonly>
                        </div>
                        <div class="form-group">
                            <label>Thời hạn bảo hành:</label>
                            <input type="text" value="${product.warrantyPeriod}" readonly>
                        </div>

                        <!-- Editable Fields -->
                        <div class="form-group">
                            <label>Giá bán:</label>
                            <input type="text" name="retailPrice" value="${product.retailPrice}" required>
                        </div>
                        <div class="form-group">
                            <label>Giá vốn:</label>
                            <input type="text" name="costPrice" value="${product.costPrice}" required>
                        </div>
                        <div class="form-group">
                            <label>Mô tả:</label>
                            <textarea name="description" rows="4">${product.description}</textarea>
                        </div>
                        <div class="form-group">
                            <label>Trạng thái:</label>
                            <select name="isActive" required>
                                <option value="1" ${product.isActive() ? 'selected' : ''}>Kích hoạt</option>
                                <option value="0" ${!product.isActive() ? 'selected' : ''}>Ngừng kinh doanh</option>
                            </select>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-actions">
                            <button type="submit" class="btn btn-success">Cập nhật</button>
                            <a href="so-products" class="btn btn-danger">Hủy</a>
                        </div>
                    </form>
                </div>
            </main>
        </div>
        <script>
            document.querySelector('.product-form').addEventListener('submit', function (e) {
                const costPrice = parseFloat(document.querySelector('input[name="costPrice"]').value);
                const retailPrice = parseFloat(document.querySelector('input[name="retailPrice"]').value);

                if (isNaN(costPrice) || isNaN(retailPrice)) {
                    alert("Giá vốn và giá bán phải là số hợp lệ.");
                    e.preventDefault();
                    return;
                }

                if (costPrice <= 0 || retailPrice <= 0) {
                    alert("Giá vốn và giá bán phải lớn hơn 0.");
                    e.preventDefault();
                    return;
                }

                if (retailPrice <= costPrice) {
                    alert("Giá bán phải lớn hơn giá vốn.");
                    e.preventDefault();
                    return;
                }
            });

            // Ngăn người dùng nhập ký tự không phải số
            const onlyNumberInputs = document.querySelectorAll('input[name="costPrice"], input[name="retailPrice"]');
            onlyNumberInputs.forEach(input => {
                input.addEventListener('input', function () {
                    this.value = this.value.replace(/[^0-9.]/g, '');
                });
            });
        </script>

    </body>
</html>
