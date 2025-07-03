<%-- modal.jsp --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - <c:choose><c:when test="${action == 'update'}">Chỉnh sửa khuyến mãi</c:when><c:otherwise>Tạo khuyến mãi mới</c:otherwise></c:choose></title>
                <link rel="stylesheet" href="css/so-promotion.css">
                <link rel="stylesheet" href="css/header.css">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <style>
                    .dropdown-checkbox {
                        position: relative;
                    }

                    .dropdown-toggle-custom {
                        width: 100%;
                        text-align: left;
                        border: 1px solid #ced4da;
                        border-radius: 0.375rem;
                        padding: 0.375rem 0.75rem;
                        background-color: #fff;
                        cursor: pointer;
                        min-height: 38px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .dropdown-toggle-custom:hover {
                        border-color: #86b7fe;
                    }

                    .dropdown-toggle-custom:focus {
                        border-color: #86b7fe;
                        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
                        outline: 0;
                    }

                    .dropdown-menu-custom {
                        display: none;
                        position: absolute;
                        top: 100%;
                        left: 0;
                        z-index: 1000;
                        width: 100%;
                        padding: 0.5rem 0;
                        margin: 0.125rem 0 0;
                        background-color: #fff;
                        border: 1px solid rgba(0, 0, 0, 0.175);
                        border-radius: 0.375rem;
                        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.175);
                        max-height: 200px;
                        overflow-y: auto;
                    }

                    .dropdown-menu-custom.show {
                        display: block;
                    }

                    .dropdown-item-custom {
                        display: block;
                        width: 100%;
                        padding: 0.375rem 1rem;
                        clear: both;
                        font-weight: 400;
                        color: #212529;
                        text-decoration: none;
                        white-space: nowrap;
                        background-color: transparent;
                        border: 0;
                        cursor: pointer;
                    }

                    .dropdown-item-custom:hover {
                        background-color: #e9ecef;
                    }

                    .dropdown-item-custom input[type="checkbox"] {
                        margin-right: 0.5rem;
                    }

                    .selected-count {
                        color: #6c757d;
                        font-size: 0.875em;
                    }

                    .placeholder-text {
                        color: #6c757d;
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

                            <div class="nav-item dropdown">
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

                            <a href="so-promotions" class="nav-item active">
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

                <div class="container mt-5">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title">
                                    <i class="fas fa-<c:choose><c:when test="${action == 'update'}">edit</c:when><c:otherwise>tags</c:otherwise></c:choose>"></i>
                        <c:choose><c:when test="${action == 'update'}">Chỉnh sửa khuyến mãi</c:when><c:otherwise>Tạo khuyến mãi mới</c:otherwise></c:choose>
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="so-promotions" id="promotionForm">
                                    <input type="hidden" name="action" value="${action}">
                        <c:if test="${action == 'update'}">
                            <input type="hidden" name="promotionId" value="${promotion.promotionID}">
                        </c:if>

                        <div class="mb-3">
                            <label for="promoName" class="form-label">
                                Tên khuyến mãi *
                            </label>
                            <input type="text" class="form-control" id="promoName" name="promoName" 
                                   value="${action == 'update' ? promotion.promoName : ''}" 
                                   placeholder="VD: Khuyến mãi mùa hè 2024" required>
                        </div>

                        <div class="mb-3">
                            <label for="discountPercent" class="form-label">
                                Tỷ lệ giảm giá (%) *
                            </label>
                            <input type="number" class="form-control" id="discountPercent" name="discountPercent" 
                                   value="${action == 'update' ? promotion.discountPercent : ''}" 
                                   min="0" max="100" step="0.1" placeholder="VD: 15" required>
                        </div>

                        <!-- Branch Dropdown -->
                        <div class="mb-3">
                            <label class="form-label">
                                Branch áp dụng khuyến mãi *
                            </label>
                            <div class="dropdown-checkbox">
                                <div class="dropdown-toggle-custom" id="branchDropdown" tabindex="0">
                                    <span id="branchPlaceholder" class="placeholder-text">-- Chọn branch áp dụng --</span>
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="dropdown-menu-custom" id="branchDropdownMenu">
                                    <c:forEach var="branch" items="${branches}">
                                        <label class="dropdown-item-custom">
                                            <input type="checkbox" name="branchIds" value="${branch.branchId}"
                                                   <c:if test="${action == 'update' && promotion.branchIDs.contains(branch.branchId)}">checked</c:if>>
                                            ${branch.branchName}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <!-- Product Detail Dropdown -->
                        <div class="mb-3">
                            <label class="form-label">Sản phẩm áp dụng khuyến mãi *</label>
                            <div class="dropdown-checkbox">
                                <div class="dropdown-toggle-custom" id="productDropdown" tabindex="0">
                                    <span id="productPlaceholder" class="placeholder-text">-- Chọn sản phẩm áp dụng --</span>
                                    <i class="fas fa-chevron-down"></i>
                                </div>
                                <div class="dropdown-menu-custom" id="productDropdownMenu">
                                    <c:forEach var="productDetail" items="${productDetails}">
                                        <label class="dropdown-item-custom">
                                            <input type="checkbox" name="productDetailIds" value="${productDetail.productDetailID}"
                                                   <c:if test="${action == 'update' && promotion.productDetailIDs.contains(productDetail.productDetailID)}">checked</c:if>>
                                            ${productDetail.productCode} - ${productDetail.description}
                                        </label>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="startDate" class="form-label">Ngày bắt đầu *</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" 
                                       value="${action == 'update' ? promotion.startDateFormatted : ''}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="endDate" class="form-label">Ngày kết thúc *</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" 
                                       value="${action == 'update' ? promotion.endDateFormatted : ''}" required>
                            </div>
                        </div>

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

                        <div class="card-footer text-end">
                            <a href="so-promotions" class="btn btn-secondary">Hủy</a>
                            <button type="submit" class="btn btn-success" style="background-color: #2196F3; border-color:#2196F3">
                                <c:choose><c:when test="${action == 'update'}">Cập nhật</c:when><c:otherwise>Tạo khuyến mãi</c:otherwise></c:choose>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Date validation
                const today = new Date().toISOString().split('T')[0];
                const startDateInput = document.getElementById('startDate');
                const endDateInput = document.getElementById('endDate');

                startDateInput.min = today;
                startDateInput.addEventListener('change', function () {
                    endDateInput.min = this.value;
                });

                // Dropdown functionality
                function initDropdown(dropdownId, menuId, placeholderId, fieldName) {
                    const dropdown = document.getElementById(dropdownId);
                    const menu = document.getElementById(menuId);
                    const placeholder = document.getElementById(placeholderId);
                    const checkboxes = menu.querySelectorAll('input[type="checkbox"]');

                    // Toggle dropdown
                    dropdown.addEventListener('click', function (e) {
                        e.stopPropagation();
                        menu.classList.toggle('show');

                        // Close other dropdowns
                        document.querySelectorAll('.dropdown-menu-custom').forEach(function (otherMenu) {
                            if (otherMenu !== menu) {
                                otherMenu.classList.remove('show');
                            }
                        });
                    });

                    dropdown.addEventListener('keydown', function (e) {
                        if (e.key === 'Enter' || e.key === ' ') {
                            e.preventDefault();
                            dropdown.click();
                        }
                    });

                    // Prevent dropdown from closing when clicking inside
                    menu.addEventListener('click', function (e) {
                        e.stopPropagation();
                    });

                    // Update placeholder text
                    function updatePlaceholder() {
                        const checkedBoxes = Array.from(checkboxes).filter(cb => cb.checked);
                        if (checkedBoxes.length === 0) {
                            if (fieldName === 'branch') {
                                placeholder.textContent = `-- Chọn branch áp dụng --`;
                            } else {
                                placeholder.textContent = `-- Chọn sản phẩm áp dụng --`;
                            }
                            placeholder.className = 'placeholder-text';
                        } else if (checkedBoxes.length === 1) {
                            placeholder.textContent = checkedBoxes[0].parentElement.textContent.trim();
                            placeholder.className = '';
                        } else {
                            if (fieldName === 'branch') {
                                placeholder.textContent = 'Đã chọn ' + checkedBoxes.length + ' branch';
                            } else {
                                placeholder.textContent = 'Đã chọn ' + checkedBoxes.length + ` sản phẩm`;
                            }
                            placeholder.className = '';
                        }
                    }

                    // Listen for checkbox changes
                    checkboxes.forEach(function (checkbox) {
                        checkbox.addEventListener('change', updatePlaceholder);
                    });

                    // Initialize placeholder
                    updatePlaceholder();
                }

                // Initialize both dropdowns
                initDropdown('branchDropdown', 'branchDropdownMenu', 'branchPlaceholder', 'branch');
                initDropdown('productDropdown', 'productDropdownMenu', 'productPlaceholder', 'productDetail');

                // Close dropdowns when clicking outside
                document.addEventListener('click', function () {
                    document.querySelectorAll('.dropdown-menu-custom').forEach(function (menu) {
                        menu.classList.remove('show');
                    });
                });

                // Form validation
                const form = document.getElementById('promotionForm');
                form.addEventListener('submit', function (event) {
                    const branchCheckboxes = document.querySelectorAll('input[name="branchIds"]:checked');
                    const productCheckboxes = document.querySelectorAll('input[name="productDetailIds"]:checked');

                    let isValid = true;
                    let errorMessage = '';

                    // Check if at least one branch is selected
                    if (branchCheckboxes.length === 0) {
                        isValid = false;
                        errorMessage += 'Vui lòng chọn ít nhất một branch.\n';
                    }

                    // Check if at least one product is selected
                    if (productCheckboxes.length === 0) {
                        isValid = false;
                        errorMessage += 'Vui lòng chọn ít nhất một sản phẩm.\n';
                    }

                    // Check date validation
                    if (new Date(startDateInput.value) > new Date(endDateInput.value)) {
                        isValid = false;
                        errorMessage += 'Ngày kết thúc phải sau ngày bắt đầu!';
                    }

                    if (!form.checkValidity() || !isValid) {
                        event.preventDefault();
                        event.stopPropagation();
                        if (errorMessage) {
                            alert(errorMessage);
                        }
                        form.classList.add('was-validated');
                    }
                });
            });
        </script>
    </body>
</html>