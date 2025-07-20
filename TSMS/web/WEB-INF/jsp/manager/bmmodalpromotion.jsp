<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Chi tiết khuyến mãi</title>
        <link rel="stylesheet" href="css/so-promotion.css">
        <link rel="stylesheet" href="css/header.css">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .readonly-form .form-control,
            .readonly-form .form-select {
                background-color: #f8f9fa;
                border-color: #dee2e6;
                cursor: not-allowed;
            }

            .readonly-badge {
                position: absolute;
                top: 10px;
                right: 10px;
                background: #6c757d;
                color: white;
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: bold;
            }

            .info-section {
                background: #f8f9fa;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 20px;
            }

            .info-section h6 {
                color: #495057;
                margin-bottom: 10px;
                font-weight: 600;
            }

            .list-group-item {
                border: none;
                padding: 8px 0;
                background: transparent;
            }

            .status-display {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 8px 16px;
                border-radius: 20px;
                font-weight: 500;
                font-size: 14px;
            }

            .status-active {
                background: #d4edda;
                color: #155724;
            }

            .status-scheduled {
                background: #fff3cd;
                color: #856404;
            }

            .status-expired {
                background: #f8d7da;
                color: #721c24;
            }
        </style>
    </head>
    <body>
          <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="bm-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="bm-overview" class="nav-item ">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item ">
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
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="request-stock" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-incoming-orders" class="dropdown-item">Theo dõi nhập hàng</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-customer" class="dropdown-item">Khách hàng</a>
                            <a href="bm-supplier" class="dropdown-item">Nhà cung cấp</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-staff" class="dropdown-item">Danh sách nhân viên</a>
                            <a href="#" class="dropdown-item">Hoa hồng</a>
                        </div>
                    </div>

                    <a href="bm-promotions" class="nav-item active">
                        <i class="fas fa-ticket"></i>
                        Khuyến mãi
                    </a>

                    <div class="nav-item dropdown ">
                        <a href="#" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-invoices" class="dropdown-item">Báo cáo thu thuần</a>
                            <a href="bm-outcome" class="dropdown-item">Báo cáo chi</a>
                        </div>
                    </div>

                    <a href="bm-cart" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="#" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="staff-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <div class="container mt-5">
            <div class="card position-relative">
                <div class="readonly-badge">
                    <i class="fas fa-eye"></i> Chỉ xem
                </div>

                <div class="card-header">
                    <h5 class="card-title">
                        <i class="fas fa-ticket"></i>
                        Chi tiết khuyến mãi: ${promotion.promoName}
                    </h5>
                </div>

                <div class="card-body readonly-form">
                    <!-- Thông tin cơ bản -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="info-section">
                                <h6><i class="fas fa-info-circle"></i> Thông tin khuyến mãi</h6>
                                <div class="mb-3">
                                    <label class="form-label">Mã khuyến mãi</label>
                                    <input type="text" class="form-control" value="${promotion.promotionID}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Tên khuyến mãi</label>
                                    <input type="text" class="form-control" value="${promotion.promoName}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Tỷ lệ giảm giá</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" value="${promotion.discountPercent}" readonly>
                                        <span class="input-group-text">%</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-section">
                                <h6><i class="fas fa-calendar-alt"></i> Thời gian áp dụng</h6>
                                <div class="mb-3">
                                    <label class="form-label">Ngày bắt đầu</label>
                                    <input type="text" class="form-control" value="${promotion.startDateFormatted}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Ngày kết thúc</label>
                                    <input type="text" class="form-control" value="${promotion.endDateFormatted}" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Trạng thái</label>
                                    <div class="mt-2">
                                        <c:choose>
                                            <c:when test="${promotion.status == 'active'}">
                                                <span class="status-display status-active">
                                                    <i class="fas fa-play"></i> Đang hoạt động
                                                </span>
                                            </c:when>
                                            <c:when test="${promotion.status == 'scheduled'}">
                                                <span class="status-display status-scheduled">
                                                    <i class="fas fa-clock"></i> Đã lên lịch
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-display status-expired">
                                                    <i class="fas fa-stop"></i> Đã hết hạn
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Chi nhánh áp dụng -->
                    <div class="row mb-4">
                        <!-- Chi nhánh áp dụng - chỉ hiển thị chi nhánh hiện tại -->
                        <div class="col-md-6">
                            <div class="info-section">
                                <h6><i class="fas fa-store"></i> Chi nhánh áp dụng</h6>
                                <c:choose>
                                    <c:when test="${not empty branches}">
                                        <c:forEach var="branch" items="${branches}">
                                            <div class="alert alert-info">
                                                <div class="d-flex align-items-center">
                                                    <i class="fas fa-map-marker-alt text-primary me-3" style="font-size: 24px;"></i>
                                                    <div>
                                                        <h6 class="mb-1">${branch.branchName}</h6>
                                                        <p class="mb-1">${branch.address}</p>
                                                        <c:if test="${not empty branch.phone}">
                                                            <small class="text-muted">
                                                                <i class="fas fa-phone"></i> ${branch.phone}
                                                            </small>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">Khuyến mãi không áp dụng cho chi nhánh này</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Sản phẩm áp dụng -->
                        <div class="col-md-6">
                            <div class="info-section">
                                <h6><i class="fas fa-box"></i> Sản phẩm áp dụng tại chi nhánh 
                                    (${productDetails != null ? productDetails.size() : 0} sản phẩm)
                                </h6>
                                <c:choose>
                                    <c:when test="${not empty productDetails}">
                                        <div class="list-group list-group-flush" style="max-height: 300px; overflow-y: auto;">
                                            <c:forEach var="product" items="${productDetails}">
                                                <div class="list-group-item">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-cube text-success me-2"></i>
                                                            <div>
                                                                <strong>${product.productCode}</strong>
                                                                <br>
                                                                <small class="text-muted">${product.description}</small>
                                                                <c:if test="${not empty product.warrantyPeriod}">
                                                                    <br>
                                                                    <small class="text-">
                                                                        <i></i> Bảo hành: ${product.warrantyPeriod}
                                                                    </small>
                                                                </c:if>
                                                            </div>
                                                        </div>
                                                        <div class="text-end">
                                                            <div class="badge bg-primary">SL: ${product.quantity}</div> 
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle"></i>
                                            <strong>Không có sản phẩm nào</strong>
                                            <p class="mb-0">Chi nhánh này không có sản phẩm nào được áp dụng khuyến mãi hoặc đã hết hàng.</p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="text-end">
                            <a href="bm-promotions" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại danh sách
                            </a>
                        </div>        
                    </div>

                    <!-- Alert Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                </div>


            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
            // Disable all form interactions (extra security)
            const formElements = document.querySelectorAll('input, select, textarea, button[type="submit"]');
                    formElements.forEach(element => {
                    if (!element.classList.contains('btn-close') && element.type !== 'button') {
                    element.setAttribute('readonly', true);
                            element.setAttribute('disabled', true);
                    }
                    });
        </script>
    </body>
</html>
