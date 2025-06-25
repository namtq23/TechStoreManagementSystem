<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #${order.orderID}</title>
    <link rel="stylesheet" href="css/header.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            line-height: 1.6;
        }

        /* Header Styles - Match với thiết kế của bạn */
        .header {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 50%, #0D47A1 100%);
            height: 60px;
            display: flex;
            align-items: center;
            padding: 0 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        /* Logo Styles */
        .logo {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: white;
            margin-right: 30px;
        }

        .logo-icon {
            width: 36px;
            height: 36px;
            background: white;
            color: #2196F3;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            font-weight: bold;
            margin-right: 12px;
        }

        .logo-text {
            font-size: 20px;
            font-weight: 700;
            color: white;
        }

        /* Navigation Styles */
        .main-nav {
            display: flex;
            align-items: center;
            flex: 1;
            gap: 0;
        }

        .nav-item {
            position: relative;
            color: white;
            text-decoration: none;
            padding: 18px 20px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 500;
            white-space: nowrap;
        }

        .nav-item:hover, .nav-item.active {
            background: rgba(255,255,255,0.15);
            color: white;
            text-decoration: none;
        }

        .nav-item i {
            font-size: 16px;
        }

        /* Dropdown Styles */
        .dropdown {
            position: relative;
        }

        .dropdown-toggle {
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .dropdown-toggle .fa-caret-down {
            font-size: 12px;
            margin-left: 4px;
        }

        .dropdown-menu {
            position: absolute;
            top: 100%;
            left: 0;
            background: white;
            min-width: 200px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            border-radius: 8px;
            padding: 8px 0;
            opacity: 0;
            visibility: hidden;
            transform: translateY(-10px);
            transition: all 0.3s ease;
            z-index: 1000;
            border: 1px solid rgba(0,0,0,0.1);
        }

        .dropdown:hover .dropdown-menu {
            opacity: 1;
            visibility: visible;
            transform: translateY(0);
        }

        .dropdown-item {
            display: block;
            padding: 12px 20px;
            color: #333;
            text-decoration: none;
            transition: background-color 0.3s ease;
            font-size: 14px;
        }

        .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #2196F3;
            text-decoration: none;
        }

        /* Header Right - User Section */
        .header-right {
            display: flex;
            align-items: center;
        }

        .user-dropdown {
            position: relative;
        }

        .user-icon {
            color: white;
            text-decoration: none;
            padding: 8px;
            border-radius: 50%;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: rgba(255,255,255,0.1);
        }

        .user-icon:hover {
            background: rgba(255,255,255,0.2);
            color: white;
            text-decoration: none;
        }

        .user-icon i {
            font-size: 20px;
        }

        .user-dropdown .dropdown-menu {
            right: 0;
            left: auto;
            min-width: 180px;
        }

        /* Main Content Styles */
        .main-content {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .page-header {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            border-left: 5px solid #2196F3;
        }

        .page-title {
            color: #333;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .page-subtitle {
            color: #666;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .back-btn {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            color: white;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .back-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.4);
            color: white;
            text-decoration: none;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .info-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 20px;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            font-size: 18px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-body {
            padding: 25px;
        }

        .info-row {
            display: flex;
            padding: 12px 0;
            border-bottom: 1px solid #f8f9fa;
            align-items: flex-start;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 140px;
            flex-shrink: 0;
        }

        .info-value {
            color: #212529;
            flex: 1;
            word-break: break-word;
        }

        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            font-size: 14px;
            display: inline-block;
        }

        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-processing { background-color: #cce5ff; color: #004085; }
        .status-completed { background-color: #d4edda; color: #155724; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }

        .avatar-img, .product-img {
            border-radius: 8px;
            object-fit: cover;
            border: 2px solid #dee2e6;
        }

        .avatar-img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
        }

        .product-img {
            width: 80px;
            height: 80px;
        }

        .image-placeholder {
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
            font-size: 24px;
        }

        .edit-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 5px solid #2196F3;
        }

        .edit-title {
            color: #333;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #2196F3;
            box-shadow: 0 0 0 3px rgba(33, 150, 243, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 16px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(33, 150, 243, 0.4);
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
            transform: translateY(-2px);
        }

        .badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-success { background-color: #d4edda; color: #155724; }
        .badge-danger { background-color: #f8d7da; color: #721c24; }
        .badge-info { background-color: #cce5ff; color: #004085; }

        .price-highlight {
            font-weight: 700;
            color: #2196F3;
            font-size: 18px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .main-nav {
                gap: 0;
            }
            
            .nav-item {
                padding: 18px 15px;
                font-size: 13px;
            }
        }

        @media (max-width: 768px) {
            .header {
                height: auto;
                padding: 10px 15px;
            }

            .header-container {
                flex-direction: column;
                gap: 15px;
            }

            .main-nav {
                flex-wrap: wrap;
                justify-content: center;
                width: 100%;
            }

            .nav-item {
                padding: 12px 15px;
                font-size: 12px;
            }

            .logo {
                margin-right: 0;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .btn-group {
                flex-direction: column;
                align-items: center;
            }

            .page-title {
                font-size: 24px;
            }

            .main-content {
                padding: 0 15px;
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
                            <a href="so-createimport" class="dropdown-item">Tạo đơn nhập hàng</a>
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

    <!-- Main Content -->
    <div class="main-content">
        <!-- Page Header -->
        <div class="page-header">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <h1 class="page-title">
                        <i class="fas fa-receipt"></i>
                        Chi Tiết Đơn Hàng #${order.orderID}
                    </h1>
                    <p class="page-subtitle">
                        <i class="fas fa-calendar-alt"></i>
                        Ngày tạo: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </p>
                </div>
                <a href="so-orders" class="back-btn">
                    <i class="fas fa-arrow-left"></i>Quay lại danh sách
                </a>
            </div>
        </div>

        <!-- Info Grid -->
        <div class="info-grid">
            <!-- Phần 1: Thông tin sản phẩm -->
            <div class="info-card">
                <div class="card-header">
                    <i class="fas fa-box"></i>
                    Thông Tin Sản Phẩm
                </div>
                <div class="card-body">
                    <div style="display: flex; gap: 20px; margin-bottom: 20px;">
                        <div style="flex-shrink: 0;">
                            <c:choose>
                                <c:when test="${not empty order.imageURL}">
                                    <img src="${order.imageURL}" alt="Product Image" class="product-img">
                                </c:when>
                                <c:otherwise>
                                    <div class="product-img image-placeholder">
                                        <i class="fas fa-image"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="flex: 1;">
                            <div class="info-row">
                                <span class="info-label">Mã sản phẩm:</span>
                                <span class="info-value">${order.productID}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Tên sản phẩm:</span>
                                <span class="info-value">${order.productName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Trạng thái:</span>
                                <span class="info-value">
                                    <c:choose>
                                        <c:when test="${order.productIsActive}">
                                            <span class="badge badge-success">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">Ngừng hoạt động</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Giá gốc:</span>
                        <span class="info-value">
                            <fmt:formatNumber value="${order.costPrice}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">VAT:</span>
                        <span class="info-value">${order.VAT}%</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Mô tả:</span>
                        <span class="info-value">${order.productDescription}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Mã code:</span>
                        <span class="info-value">${order.productCode}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Bảo hành:</span>
                        <span class="info-value">${order.warrantyPeriod}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Serial Number:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${not empty order.serialNumber}">
                                    ${order.serialNumber}
                                </c:when>
                                <c:otherwise>
                                    <span style="color: #6c757d; font-style: italic;">Chưa có serial number</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Phần 2: Thông tin đơn hàng -->
            <div class="info-card">
                <div class="card-header">
                    <i class="fas fa-shopping-cart"></i>
                    Thông Tin Đơn Hàng
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <span class="info-label">Mã đơn hàng:</span>
                        <span class="info-value">#${order.orderID}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Chi nhánh:</span>
                        <span class="info-value">${order.branchName}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Trạng thái:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${order.orderStatus == 'Pending'}">
                                    <span class="status-badge status-pending">Chờ xử lý</span>
                                </c:when>
                                <c:when test="${order.orderStatus == 'Processing'}">
                                    <span class="status-badge status-processing">Đang xử lý</span>
                                </c:when>
                                <c:when test="${order.orderStatus == 'Completed'}">
                                    <span class="status-badge status-completed">Hoàn thành</span>
                                </c:when>
                                <c:when test="${order.orderStatus == 'Cancelled'}">
                                    <span class="status-badge status-cancelled">Đã hủy</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge status-pending">${order.orderStatus}</span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Ngày tạo:</span>
                        <span class="info-value">
                            <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Phương thức TT:</span>
                        <span class="info-value">${order.paymentMethod}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Số lượng:</span>
                        <span class="info-value">${order.quantity}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Ghi chú:</span>
                        <span class="info-value">${order.notes}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Tổng tiền:</span>
                        <span class="info-value price-highlight">
                            <fmt:formatNumber value="${order.grandTotal}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Khách đưa:</span>
                        <span class="info-value">
                            <fmt:formatNumber value="${order.customerPay}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Tiền thừa:</span>
                        <span class="info-value">
                            <fmt:formatNumber value="${order.change}" type="currency" currencySymbol="₫"/>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Phần 3: Thông tin nhân viên -->
            <div class="info-card">
                <div class="card-header">
                    <i class="fas fa-user-tie"></i>
                    Thông Tin Nhân Viên Tạo
                </div>
                <div class="card-body">
                    <div style="display: flex; gap: 20px; margin-bottom: 20px;">
                        <div style="flex-shrink: 0;">
                            <c:choose>
                                <c:when test="${not empty order.createdByAvaUrl}">
                                    <img src="${order.createdByAvaUrl}" alt="Avatar" class="avatar-img">
                                </c:when>
                                <c:otherwise>
                                    <div class="avatar-img image-placeholder">
                                        <i class="fas fa-user"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div style="flex: 1;">
                            <div class="info-row">
                                <span class="info-label">Mã NV:</span>
                                <span class="info-value">${order.createdBy}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Họ tên:</span>
                                <span class="info-value">${order.createdByName}</span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Chức vụ:</span>
                                <span class="info-value">
                                    <span class="badge badge-info">${order.roleName}</span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value">${order.createdByEmail}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Điện thoại:</span>
                        <span class="info-value">${order.createdByPhone}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Giới tính:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${order.createdByGender}">Nam</c:when>
                                <c:otherwise>Nữ</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Địa chỉ:</span>
                        <span class="info-value">${order.createdByAddress}</span>
                    </div>
                </div>
            </div>

            <!-- Phần 4: Thông tin khách hàng -->
            <div class="info-card">
                <div class="card-header">
                    <i class="fas fa-user"></i>
                    Thông Tin Khách Hàng
                </div>
                <div class="card-body">
                    <div class="info-row">
                        <span class="info-label">Họ tên:</span>
                        <span class="info-value">${order.customerName}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Điện thoại:</span>
                        <span class="info-value">${order.customerPhone}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value">${order.customerEmail}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Địa chỉ:</span>
                        <span class="info-value">${order.customerAddress}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Giới tính:</span>
                        <span class="info-value">
                            <c:choose>
                                <c:when test="${order.customerGender}">Nam</c:when>
                                <c:otherwise>Nữ</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Ngày sinh:</span>
                        <span class="info-value">
                            <c:if test="${not empty order.customerDOB}">
                                <fmt:formatDate value="${order.customerDOB}" pattern="dd/MM/yyyy"/>
                            </c:if>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Section -->
        <div class="edit-section">
            <h2 class="edit-title">
                <i class="fas fa-edit"></i>
                Chỉnh Sửa Đơn Hàng
            </h2>
            <form action="so-orders" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="orderID" value="${order.orderID}">
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="orderStatus" class="form-label">
                            <i class="fas fa-flag"></i>Trạng thái đơn hàng
                        </label>
                        <select class="form-control" id="orderStatus" name="orderStatus" required>
                            <option value="Pending" ${order.orderStatus == 'Pending' ? 'selected' : ''}>Chờ xử lý</option>
                            <option value="Processing" ${order.orderStatus == 'Processing' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="Completed" ${order.orderStatus == 'Completed' ? 'selected' : ''}>Hoàn thành</option>
                            <option value="Cancelled" ${order.orderStatus == 'Cancelled' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="notes" class="form-label">
                            <i class="fas fa-sticky-note"></i>Ghi chú
                        </label>
                        <textarea class="form-control" id="notes" name="notes" rows="4" 
                                  placeholder="Nhập ghi chú cho đơn hàng...">${order.notes}</textarea>
                    </div>
                </div>
                
                <div class="btn-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>Cập Nhật Đơn Hàng
                    </button>
                    <a href="so-orders" class="btn btn-secondary">
                        <i class="fas fa-times"></i>Hủy Bỏ
                    </a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Dropdown functionality for user menu
        document.addEventListener('DOMContentLoaded', function() {
            const dropdownToggle = document.getElementById('dropdownToggle');
            const dropdownMenu = document.getElementById('dropdownMenu');
            
            if (dropdownToggle && dropdownMenu) {
                dropdownToggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    const isVisible = dropdownMenu.style.opacity === '1';
                    dropdownMenu.style.opacity = isVisible ? '0' : '1';
                    dropdownMenu.style.visibility = isVisible ? 'hidden' : 'visible';
                    dropdownMenu.style.transform = isVisible ? 'translateY(-10px)' : 'translateY(0)';
                });
                
                document.addEventListener('click', function(e) {
                    if (!dropdownToggle.contains(e.target) && !dropdownMenu.contains(e.target)) {
                        dropdownMenu.style.opacity = '0';
                        dropdownMenu.style.visibility = 'hidden';
                        dropdownMenu.style.transform = 'translateY(-10px)';
                    }
                });
            }
        });

        // Form submission confirmation
        document.querySelector('form').addEventListener('submit', function(e) {
            if (!confirm('Bạn có chắc chắn muốn cập nhật đơn hàng này?')) {
                e.preventDefault();
            }
        });

        // Show success/error messages
        <c:if test="${param.success == 'update'}">
            alert('Cập nhật đơn hàng thành công!');
        </c:if>
        <c:if test="${param.error == 'update'}">
            alert('Có lỗi xảy ra khi cập nhật đơn hàng!');
        </c:if>
    </script>
</body>
</html>
