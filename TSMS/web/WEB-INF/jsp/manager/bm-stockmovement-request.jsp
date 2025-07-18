<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<c:set var="products" value="${requestScope.products}" />
<c:set var="warehouses" value="${requestScope.warehouses}" />
<c:set var="selectedID" value="${requestScope.selectedToWarehouseID}" />
<c:set var="draft" value="${requestScope.draftDetails}" />
<c:set var="draftProductDetails" value="${requestScope.draftProductDetails}" />

<!DOCTYPE html>
<html>
    <head>
        <title>Yêu cầu nhập hàng</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/bmstockmovement.css" />
        <link rel="stylesheet" href="css/header.css" />
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
                    <a href="bm-overview" class="nav-item active">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="request-stock" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-incoming-orders" class="dropdown-item">Theo dõi đơn nhập hàng</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
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
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-users"></i>
                            Nhân viên
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-staff" class="dropdown-item">Danh sách nhân viên</a>
                            <a href="#" class="dropdown-item">Hoa hồng</a>
                        </div>
                    </div>
                    <a href="bm-promotions" class="nav-item">
                        <i class="fas fa-ticket"></i>
                        Khuyến mãi
                    </a>

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-chart-bar"></i>
                            Báo cáo
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Tài chính</a>
                            <a href="#" class="dropdown-item">Đật hàng</a>
                            <a href="#" class="dropdown-item">Hàng hoá</a>
                            <a href="#" class="dropdown-item">Khách hàng</a>
                        </div>
                    </div>

                    <a href="bm-cart" class="nav-item">
                        <i class="fas fa-cash-register"></i>
                        Bán hàng
                    </a>
                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="staff-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
        </header>

        <div class="main-container">
            <div class="invoice-panel">
                <div class="panel-header">
                    Phiếu yêu cầu xuất hàng
                    <c:if test="${not empty draft}">
                        <form method="post" action="request-stock" style="display: inline;">
                            <input type="hidden" name="action" value="reset" />
                            <input type="hidden" name="keyword" value="${param.keyword}" />
                            <button type="submit" class="btn-secondary" onclick="return confirm('Bạn có chắc muốn xóa tất cả sản phẩm?')">
                                <i class="fa fa-trash"></i> Xóa tất cả
                            </button>
                        </form>
                    </c:if>
                </div>

                <form action="request-stock" method="post" id="requestForm">
                    <div class="invoice-table-body">
                        <table>
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Mã sản phẩm</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Số lượng yêu cầu</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty draft and not empty draftProductDetails}">
                                        <c:forEach var="d" items="${draft}" varStatus="loop">
                                            <tr>
                                                <td>${loop.index + 1}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${loop.index lt fn:length(draftProductDetails)}">
                                                            ${draftProductDetails[loop.index].productCode}
                                                        </c:when>
                                                        <c:otherwise>Không tìm thấy</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${loop.index lt fn:length(draftProductDetails)}">
                                                            ${draftProductDetails[loop.index].description}
                                                        </c:when>
                                                        <c:otherwise>Không tìm thấy</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <input 
                                                        type="number" 
                                                        name="quantity_${d.productDetailID}" 
                                                        id="quantity_${d.productDetailID}" 
                                                        value="${d.quantity}" 
                                                        min="1" 
                                                        required 
                                                        onchange="autoUpdateQuantity(${d.productDetailID})" />

                                                </td>
                                                <td>
                                                    <button type="button" onclick="removeItem(${d.productID})">
                                                        <i class="fa fa-trash"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td colspan="5"><strong>Chưa có sản phẩm được chọn</strong></td></tr>
                                    </c:otherwise>
                                </c:choose>
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
                            <span class="value">${fn:length(draft)}</span>
                        </div>
                        <div class="total-products-display">
                            <span class="label">Tổng số lượng sản phẩm yêu cầu</span>
                            <span class="value">${totalQuantity}</span>
                        </div>
                        <div class="form-row">
                            <label for="toWarehouseID">Chọn kho đích</label>
                            <select name="toWarehouseID" id="toWarehouseID" required>
                                <option value="">-- Chọn kho --</option>
                                <c:forEach var="w" items="${warehouses}">
                                    <option value="${w.wareHouseId}" <c:if test="${w.wareHouseId == selectedID}">selected</c:if>>
                                        ${w.wareHouseName} - ${w.wareHouseAddress}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="payment-section">
                        <button type="submit" class="btn-primary">Gửi yêu cầu xuất</button>
                    </div>
                </form>

                <form id="removeForm" method="post" action="request-stock" style="display:none;">
                    <input type="hidden" name="action" value="remove" />
                    <input type="hidden" name="productDetailID" id="removeProductDetailID" />
                    <input type="hidden" name="toWarehouseID" id="removeToWarehouseID" />
                </form>
            </div>

            <div class="product-panel">
                <div class="panel-header"><h2>Danh sách sản phẩm tại chi nhánh</h2></div>
                <div class="search-section">
                    <form method="get" action="request-stock" class="search-form">
                        <div class="search-container">
                            <i class="fa fa-search"></i>
                            <input type="text" class="search-input" name="keyword" placeholder="Tìm kiếm sản phẩm..." value="${param.keyword}" />
                            <button type="submit" class="btn-primary">Tìm kiếm</button>
                        </div>
                    </form>
                </div>

                <div class="product-grid">
                    <c:forEach var="p" items="${products}">
                        <div class="product-card">
                            <div class="product-info">
                                <h4>${p.description}</h4>
                                <div class="product-stock">Serial: ${p.productCode} – Tồn kho: <strong>${p.quantity}</strong></div>
                            </div>
                            <form action="request-stock" method="post">
                                <input type="hidden" name="action" value="add" />
                                <input type="hidden" name="productDetailID" value="${p.productDetailID}" />
                                <button type="submit" class="add-to-cart"><i class="fa fa-plus"></i></button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Modal Thông báo -->
        <div id="modalBackdrop" class="modal-backdrop"></div>
        <div id="feedbackModal" class="modal">
            <div class="modal-header">
                <h5>Thông báo</h5>
                <button onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
            </div>
        </div>

        <script>
            function showModal() {
                document.getElementById("modalBackdrop").classList.add("show");
                document.getElementById("feedbackModal").classList.add("show");
            }
            function closeModal() {
                document.getElementById("modalBackdrop").classList.remove("show");
                document.getElementById("feedbackModal").classList.remove("show");
            }
            window.addEventListener("DOMContentLoaded", function () {
                const hasMessage = ${not empty successMessage or not empty errorMessage};
                if (hasMessage)
                    showModal();
            });

            function removeItem(productId) {
                document.getElementById("removeProductDetailID").value = productId;
                document.getElementById("removeToWarehouseID").value = document.querySelector("select[name='toWarehouseID']").value;
                document.getElementById("removeForm").submit();
            }

            function autoUpdateQuantity(productDetailID) {
                const quantityInput = document.getElementById("quantity_" + productDetailID);
                let quantity = "1";

                if (quantityInput) {
                    quantity = quantityInput.value.trim();
                    if (!quantity || isNaN(quantity) || parseInt(quantity) < 1) {
                        quantity = "1";
                    }
                }

                console.log("Submitting productDetailID =", productDetailID);
                console.log("Quantity =", quantity);

                const form = document.createElement("form");
                form.method = "POST";
                form.action = "request-stock";

                const actionInput = document.createElement("input");
                actionInput.type = "hidden";
                actionInput.name = "action";
                actionInput.value = "updateQuantity";
                form.appendChild(actionInput);

                const idInput = document.createElement("input");
                idInput.type = "hidden";
                idInput.name = "productDetailID";
                idInput.value = productDetailID;
                form.appendChild(idInput);

                const quantityInputHidden = document.createElement("input");
                quantityInputHidden.type = "hidden";
                quantityInputHidden.name = "quantity";
                quantityInputHidden.value = quantity;
                form.appendChild(quantityInputHidden);

                document.body.appendChild(form);
                form.submit();
            }




        </script>

    </body>
</html>