<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">


<!DOCTYPE html>
<html>
    <head>
        <title>Yêu cầu nhập hàng</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/import-request.css" />
        <link rel="stylesheet" href="css/header.css" />
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            /* Bỏ hiển thị dropdown khi có class active */
.nav-item.dropdown.active .dropdown-menu {
    display: none;
}

/* Chỉ hiển thị khi hover */
.nav-item.dropdown:hover .dropdown-menu {
    display: block !important;
}

/* Hoặc chỉ hiển thị khi click */
.nav-item.dropdown.show .dropdown-menu {
    display: block;
}
        </style>
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
                    <a href="so-overview" class="nav-item ">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="so-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item active dropdown ">
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
                            <a href="so-outcome" class="dropdown-item">Khoảng chi</a>
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
            <!-- Phiếu yêu cầu nhập -->
            <div class="invoice-panel">

                <!-- Thông báo thành công -->
                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert-message success">
                        ${sessionScope.successMessage}
                    </div>
                    <c:remove var="successMessage" scope="session" />
                </c:if>

                <!-- Thông báo lỗi -->
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert-message error">
                        ${sessionScope.errorMessage}
                    </div>
                    <c:remove var="errorMessage" scope="session" />
                </c:if>


                <div class="panel-header">Phiếu yêu cầu nhập hàng

                    <form method="post" action="import-request" style="display: inline;">
                        <input type="hidden" name="action" value="reset" />
                        <input type="hidden" name="supplierId" value="${selectedSupplierID}" />
                        <input type="hidden" name="toWarehouseID" value="${selectedToWarehouseID}" />
                        <button type="submit" class="btn-secondary btn-delete-all"
                                onclick="return confirm('Bạn có chắc muốn xóa tất cả sản phẩm?')">
                            <i class="fa fa-trash"></i> Xóa tất cả
                        </button>
                    </form>

                </div>
                <div class="invoice-table-body">
                    <table>
                        <thead>
                            <tr>
                                <th class="col-stt">STT</th>
                                <th class="col-ma-sp">MÃ SẢN PHẨM</th>
                                <th class="col-ten-sp">TÊN SẢN PHẨM</th>
                                <th class="col-so-luong">SỐ LƯỢNG YÊU CẦU</th>
                                <th class="col-don-gia">ĐƠN GIÁ</th>
                                <th class="col-thanh-tien">THÀNH TIỀN</th>
                                <th class="col-thao-tac"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${sessionScope.cartItems}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${item.productCode}</td>
                                    <td>${item.productNameUnsigned}</td>
                                    <!--Số lượng-->
                                    <td>
                                        <form method="post" action="import-request">
                                            <input type="hidden" name="action" value="updateQuantity" />
                                            <input type="hidden" name="supplierId" value="${selectedSupplierID}" />
                                            <input type="hidden" name="productDetailID" value="${item.productDetailID}" />
                                            <input type="hidden" name="productDetailID" value="${item.productDetailID}" />
                                            <input type="number"
                                                   name="quantity"
                                                   value="${item.quantity}"  
                                                   min="1"
                                                   class="table-input quantity-input"
                                                   onchange="this.form.submit()" />
                                        </form>
                                    </td>



                                    <!-- Đơn giá -->
                                    <td>
                                        <input type="text"
                                               name="unitPrice_${item.productDetailID}"
                                               value="${item.formattedCostPrice}"
                                               readonly
                                               class="table-input unit-price-input"
                                               data-id="${item.productDetailID}" />


                                    </td>

                                    <!-- Thành tiền -->
                                    <td>
                                        <input type="text"
                                               name="totalAmount_${item.productDetailID}"
                                               value="<fmt:formatNumber value='${item.costPrice * item.quantity}' type='number' groupingUsed='false'/>"
                                               readonly
                                               class="table-input total-amount-input"
                                               data-id="${item.productDetailID}" />

                                    </td>


                                    <td>
                                        <form method="post" action="import-request" style="display:inline;">
                                            <input type="hidden" name="action" value="remove" />
                                            <input type="hidden" name="productDetailID" value="${item.productDetailID}" />
                                            <input type="hidden" name="supplierId" value="${selectedSupplierID}" />
                                            <button type="submit" class="btn-remove-item">
                                                <i class="fa fa-trash"></i>
                                            </button>
                                        </form>

                                    </td>
                                </tr>
                            </c:forEach>

                        </tbody>
                    </table>
                </div>
                <div class="invoice-summary">
                    <div class="form-row">
                        <label for="overallNote">Ghi chú chung</label>
                        <textarea name="overallNote" id="overallNote"></textarea>
                    </div>
                    <div class="total-products-display">
                        <span class="label">Tổng sản phẩm</span>
                        <span class="value">${fn:length(cartItems)}</span>
                    </div>
                    <c:set var="totalQuantity" value="0" />
                    <c:forEach var="item" items="${cartItems}">
                        <c:set var="totalQuantity" value="${totalQuantity + item.quantity}" />
                    </c:forEach>

                    <div class="total-products-display">
                        <span class="label">Tổng số lượng sản phẩm yêu cầu</span>
                        <span class="value">${totalQuantity}</span>
                    </div>
                    <div class="form-row">
                        <label for="toWarehouseID">Chọn kho đích</label>
                        <select name="toWarehouseID" id="toWarehouseID" required>
                            <option value="">-- Chọn kho --</option>
                            <c:forEach var="warehouse" items="${listWarehouse}">
                                <option value="${warehouse.wareHouseId}" <c:if test="${warehouse.wareHouseId eq selectedToWarehouseID}">selected</c:if>>
                                    ${warehouse.wareHouseName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="payment-section">
                    <form method="post" action="import-request">
                        <input type="hidden" name="action" value="submitRequest" />
                        <input type="hidden" name="toWarehouseID" id="hiddenToWarehouseID" />
                        <input type="hidden" name="overallNote" value="" id="hiddenOverallNote" />
                        <button type="submit" class="btn-primary" onclick="beforeSubmit()">Gửi yêu cầu nhập</button>
                    </form>

                </div>



            </div>
            <!-- Danh sách sản phẩm -->
            <div class="product-panel">
                <div class="panel-header">
                    <h2>Danh sách sản phẩm</h2>
                </div>
                <div class="supplier-selection-section">
                    <label for="supplierSelect">Chọn nhà cung cấp</label>
                    <form method="get" action="${pageContext.request.contextPath}/import-request">
                        <select id="supplierSelect" name="supplierId" 
                                onchange="this.form.submit()"
                                <c:if test="${not empty sessionScope.cartSupplierId}">disabled</c:if>>
                                    <option value="">-- Chọn nhà cung cấp --</option>
                                <c:forEach var="supplier" items="${listSuppliers}">
                                    <option value="${supplier.supplierID}"
                                            <c:if test="${supplier.supplierID eq sessionScope.cartSupplierId}">selected</c:if>>
                                        ${supplier.supplierName}
                                    </option>
                                </c:forEach>

                        </select>
                    </form>

                </div>
                <c:choose>
                    <c:when test="${empty selectedSupplierID}">
                        <div class="no-supplier-message">Vui lòng chọn nhà cung cấp để xem danh sách sản phẩm.</div>
                    </c:when>
                    <c:otherwise>
                        <c:set var="currentPage" value="${currentPage}" />
                        <c:set var="totalPages" value="${totalPages}" />

                        <div class="product-content">
                            <!-- Tìm kiếm -->

                            <form method="get" action="import-request" id="searchForm" class="search-form">
                                <input type="hidden" name="supplierId" value="${selectedSupplierID}" />
                                <input type="hidden" name="page" value="1" />

                                <div class="search-container">
                                    <i class="fas fa-search"></i>
                                    <input
                                        type="text"
                                        name="keyword"
                                        class="search-input"
                                        placeholder="Tìm kiếm theo tên hoặc mã sản phẩm..."
                                        value="${keyword != null ? keyword : ''}" />
                                </div>

                                <button type="submit" class="btn-add-new search-button">Tìm kiếm</button>
                            </form>


                            <!-- Hiển thị sản phẩm -->
                            <div class="product-grid">
                                <c:choose>
                                    <c:when test="${empty listProductDetails}">
                                        <div class="no-products">Không có sản phẩm nào từ nhà cung cấp này.</div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="product" items="${listProductDetails}">
                                            <div class="product-card">
                                                <div class="product-info">
                                                    <h4>${product.productNameUnsigned}</h4>
                                                    <div class="product-code">Mã: ${product.productCode}</div>                                               
                                                </div>
                                                <form action="import-request" method="post">
                                                    <input type="hidden" name="action" value="add" />
                                                    <input type="hidden" name="productDetailID" value="${product.productDetailID}" />
                                                    <input type="hidden" name="supplierId" value="${selectedSupplierID}" /> 
                                                    <button type="submit" class="add-to-cart" title="Thêm vào phiếu yêu cầu">
                                                        <i class="fa fa-plus"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- PHÂN TRANG -->
                            <c:if test="${totalPages > 1}">
                                <div class="pagination">
                                    <!-- Trang đầu -->
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <a href="import-request?supplierId=${selectedSupplierID}&keyword=${keyword}&page=1" class="page-btn">
                                                <i class="fas fa-angle-double-left"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-btn disabled">
                                                <i class="fas fa-angle-double-left"></i>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Trang trước -->
                                    <c:choose>
                                        <c:when test="${currentPage > 1}">
                                            <a href="import-request?supplierId=${selectedSupplierID}&keyword=${keyword}&page=${currentPage - 1}" class="page-btn">
                                                <i class="fas fa-angle-left"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-btn disabled">
                                                <i class="fas fa-angle-left"></i>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Các trang số -->
                                    <c:forEach var="i" begin="${currentPage - 2 > 0 ? currentPage - 2 : 1}" 
                                               end="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}">
                                        <c:choose>
                                            <c:when test="${i == currentPage}">
                                                <span class="page-btn active">${i}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="import-request?supplierId=${selectedSupplierID}&keyword=${keyword}&page=${i}" class="page-btn">${i}</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>

                                    <!-- Trang sau -->
                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <a href="import-request?supplierId=${selectedSupplierID}&keyword=${keyword}&page=${currentPage + 1}" class="page-btn">
                                                <i class="fas fa-angle-right"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-btn disabled">
                                                <i class="fas fa-angle-right"></i>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Trang cuối -->
                                    <c:choose>
                                        <c:when test="${currentPage < totalPages}">
                                            <a href="import-request?supplierId=${selectedSupplierID}&keyword=${keyword}&page=${totalPages}" class="page-btn">
                                                <i class="fas fa-angle-double-right"></i>
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="page-btn disabled">
                                                <i class="fas fa-angle-double-right"></i>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:if>

                        </div>


                    </c:otherwise>
                </c:choose>
            </div>
        </div>


        <!-- Modal -->


        <!-- Script -->

        <!-- Script -->
        <script>
            // Ẩn thông báo sau 4 giây
            setTimeout(function () {
                const alerts = document.querySelectorAll('.alert-message');
                alerts.forEach(el => el.style.display = 'none');
            }, 4000);
        </script>

        <script>
            // Dropdown trong thanh điều hướng
            document.querySelectorAll('.nav-item.dropdown > .dropdown-toggle').forEach(toggle => {
                toggle.addEventListener('click', function (e) {
                    e.preventDefault();
                    this.parentElement.classList.toggle('active');
                });
            });

            // Dropdown tài khoản người dùng
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");
            if (toggle && menu) {
                toggle.addEventListener("click", function (e) {
                    e.preventDefault();
                    menu.classList.toggle("show");
                });
                document.addEventListener("click", function (e) {
                    if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                        menu.classList.remove("show");
                    }
                });
            }

            // Floating buttons logic
            function toggleFloatingButtons() {
                const fabButtons = document.querySelectorAll('.floating-buttons .fab-button');
                const fabToggleIcon = document.getElementById('fabToggleIcon');
                fabButtons.forEach(button => {
                    button.classList.toggle('show');
                });
                if (fabToggleIcon && fabToggleIcon.classList.contains('fa-chevron-right')) {
                    fabToggleIcon.classList.remove('fa-chevron-right');
                    fabToggleIcon.classList.add('fa-chevron-up');
                } else if (fabToggleIcon) {
                    fabToggleIcon.classList.remove('fa-chevron-up');
                    fabToggleIcon.classList.add('fa-chevron-right');
                }
            }
        </script>






        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                // Chỉ còn lại phần định dạng tiền ban đầu 
                document.querySelectorAll('.unit-price-input').forEach(input => {
                    const raw = parseFloat(input.value.replace(/,/g, '').replace(/\./g, ''));
                    if (!isNaN(raw))
                        input.value = raw.toLocaleString('vi-VN');
                });

                document.querySelectorAll('.total-amount-input').forEach(input => {
                    const raw = parseFloat(input.value.replace(/,/g, '').replace(/\./g, ''));
                    if (!isNaN(raw))
                        input.value = raw.toLocaleString('vi-VN');
                });
            });
        </script>


        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const supplierSelect = document.getElementById('supplierSelect');
                const originalSupplierId = '${sessionScope.cartSupplierId}';

                supplierSelect?.addEventListener('change', function (e) {
                    const selected = this.value;
                    if (originalSupplierId && selected && selected !== originalSupplierId) {
                        const confirmed = confirm("Bạn đã chọn nhà cung cấp khác. Đơn nhập hàng chỉ được tạo từ một nhà cung cấp.\nBạn có muốn xóa giỏ hàng và chọn lại?");
                        if (confirmed) {
                            window.location.href = 'import-request?action=reset&supplierId=' + selected;
                        } else {
                            this.value = originalSupplierId;
                        }
                        e.preventDefault();
                    } else {
                        this.form.submit();
                    }
                });
            });
        </script>
        <script>
            function beforeSubmit() {
                // Ghi chú
                const note = document.getElementById("overallNote").value;
                document.getElementById("hiddenOverallNote").value = note;

                // Kho đích
                const warehouseSelect = document.getElementById("toWarehouseID");
                const selectedWarehouseId = warehouseSelect.value;
                document.getElementById("hiddenToWarehouseID").value = selectedWarehouseId;
            }
        </script>






    </body>
    <!-- Xóa session thông báo sau khi hiển thị -->
    <%
        session.removeAttribute("successMessage");
        session.removeAttribute("errorMessage");
    %>
</html>


