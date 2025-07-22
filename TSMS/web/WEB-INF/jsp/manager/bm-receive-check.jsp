<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="movementType" value="${movementType}" />
<!-- Set default values để tránh null -->
<c:if test="${empty currentPage}"><c:set var="currentPage" value="1"/></c:if>
<c:if test="${empty totalPages}"><c:set var="totalPages" value="1"/></c:if>
<c:if test="${empty itemsPerPage}"><c:set var="itemsPerPage" value="10"/></c:if>
<c:if test="${empty totalItems}"><c:set var="totalItems" value="0"/></c:if>
<c:if test="${empty startItem}"><c:set var="startItem" value="0"/></c:if>
<c:if test="${empty endItem}"><c:set var="endItem" value="0"/></c:if>


<!DOCTYPE html>
<html>
    <head>
        <title>Kiểm tra đơn hàng - Chi nhánh</title>
        <link rel="stylesheet" href="css/bm-receive-check.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    
    </head>
    
    <body>
        <!-- Header BM -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="bm-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="bm-overview" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>
                    <a href="bm-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>
                    <a href="bm-orders?page=1" class="nav-item">
                        <i class="fas fa-shopping-cart"></i>
                        Đơn hàng
                    </a>
                    <a href="bm-incoming-orders" class="nav-item active">
                        <i class="fas fa-truck"></i>
                        Đơn hàng đến
                    </a>
                    <a href="bm-customers?page=1" class="nav-item">
                        <i class="fas fa-users"></i>
                        Khách hàng
                    </a>
                    <a href="bm-staff?page=1" class="nav-item">
                        <i class="fas fa-user-tie"></i>
                        Nhân viên
                    </a>
                </nav>
                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="bm-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>


        <div class="container">
            <div class="main-content">
                <!-- Sidebar Filter -->
                <div class="filter-sidebar">
                    <form method="GET" action="bm-receive-check">
                        <input type="hidden" name="id" value="${movementID}">
                        <input type="hidden" name="page" value="1">


                        <h3>Bộ lọc</h3>


                        <div class="filter-group">
                            <label>Từ ngày:</label>
                            <input type="date" name="fromDate" class="form-control" value="${fromDate}">
                        </div>


                        <div class="filter-group">
                            <label>Đến ngày:</label>
                            <input type="date" name="toDate" class="form-control" value="${toDate}">
                        </div>


                        <div class="filter-group">
                            <label>Sản phẩm:</label>
                            <select name="productFilter" class="form-control">
                                <option value="">--Tất cả sản phẩm--</option>
                                <c:forEach var="product" items="${productList}">
                                    <option value="${product}" ${productFilter eq product ? 'selected' : ''}>${product}</option>
                                </c:forEach>
                            </select>
                        </div>


                        <div class="filter-group">
                            <label>Trạng thái:</label>
                            <div class="radio-group">
                                <label><input type="radio" name="status" value="" ${empty status ? 'checked' : ''}> Tất cả</label>
                                <label><input type="radio" name="status" value="completed" ${status eq 'completed' ? 'checked' : ''}> Hoàn thành</label>
                                <label><input type="radio" name="status" value="pending" ${status eq 'pending' ? 'checked' : ''}> Chờ xử lý</label>
                                <label><input type="radio" name="status" value="processing" ${status eq 'processing' ? 'checked' : ''}> Đang xử lý</label>
                            </div>
                        </div>


                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i> Áp dụng lọc
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetFilters()">
                                <i class="fas fa-undo"></i> Reset
                            </button>
                        </div>
                    </form>
                </div>


                <!-- Main Content Area -->
                <div class="content-area">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success">${success}</div>
                    </c:if>
                   
                    <div class="page-header">
                        <h2>Kiểm tra đơn hàng #${movementID}</h2>
                        <div class="order-info">
                            <c:if test="${not empty orderInfo}">
                                <span class="info-item">
                                    <strong>Trạng thái:</strong>
                                    <span class="status-badge ${orderInfo.responseStatus}">
                                        <c:choose>
                                            <c:when test="${orderInfo.responseStatus eq 'transfer'}">
                                                <i class="fas fa-truck"></i> Đang vận chuyển
                                            </c:when>
                                            <c:when test="${orderInfo.responseStatus eq 'processing'}">
                                                <i class="fas fa-clock"></i> Đang xử lý
                                            </c:when>
                                            <c:otherwise>
                                                ${orderInfo.responseStatus}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </span>
                            </c:if>
                        </div>


                        <div class="header-actions">
                            <c:if test="${allCompleted}">
                                <form method="post" action="bm-receive-order" id="completeForm">
                                    <input type="hidden" name="movementID" value="${movementID}" />
                                    <button class="btn btn-success" type="submit" onclick="return confirm('Bạn có chắc chắn đã kiểm tra đủ tất cả sản phẩm và muốn hoàn tất nhận hàng?')">
                                        <i class="fas fa-check-circle"></i> Hoàn tất nhận hàng
                                    </button>
                                </form>
                            </c:if>
                           
                            <a href="bm-incoming-orders" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> Quay lại
                            </a>
                        </div>
                    </div>


                    <!-- Stock Check Table -->
                    <div class="table-container">
                        <table class="stock-check-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Serial number</th>
                                    <th>Số lượng cần nhận</th>
                                    <th>Đã quét</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${movementDetails}" varStatus="loop">
                                    <tr class="${item.quantity == item.scanned ? 'row-completed' : ''}">
                                        <!-- STT -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty currentPage and not empty itemsPerPage}">
                                                    ${(currentPage - 1) * itemsPerPage + loop.index + 1}
                                                </c:when>
                                                <c:otherwise>
                                                    ${loop.index + 1}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>


                                        <!-- Tên sản phẩm + mã -->
                                        <td>
                                            <div><strong>${not empty item.productName ? item.productName : 'N/A'}</strong></div>
                                            <div class="text-muted">(${not empty item.productCode ? item.productCode : 'N/A'})</div>
                                        </td>


                                        <!-- Serial number -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty item.serials}">
                                                    <span class="text-muted">Chưa có serial nào</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="serial" items="${item.serials}">
                                                        <div class="serial-item ${not empty serial.error ? 'error' : ''}">
                                                            ${not empty serial.serialNumber ? serial.serialNumber : 'N/A'}
                                                            <c:if test="${not empty serial.error}">
                                                                <span class="error-msg">(${serial.error})</span>
                                                            </c:if>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>


                                        <!-- Số lượng cần nhận -->
                                        <td>${not empty item.quantity ? item.quantity : 0}</td>


                                        <!-- Số đã quét -->
                                        <td>
                                            <span class="${item.quantity == item.scanned ? 'text-success' : 'text-warning'}">
                                                ${not empty item.scanned ? item.scanned : 0}/${not empty item.quantity ? item.quantity : 0}
                                            </span>
                                        </td>


                                        <!-- Thao tác -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${(not empty item.quantity ? item.quantity : 0) > (not empty item.scanned ? item.scanned : 0)}">
                                                    <button class="btn-scan" onclick="scanSerial('${item.detailID}', '${item.productDetailID}')">
                                                        <i class="fas fa-qrcode"></i> Quét
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-success">
                                                        <i class="fas fa-check"></i> Đã đủ
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>


                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-container">
                            <div class="pagination">
                                <!-- First page -->
                                <c:if test="${currentPage > 1}">
                                    <a href="bm-receive-check?id=${movementID}&fromDate=${fromDate}&toDate=${toDate}&productFilter=${productFilter}&status=${status}&itemsPerPage=${itemsPerPage}&page=1" class="btn-page">⏮ Đầu</a>
                                    <a href="bm-receive-check?id=${movementID}&fromDate=${fromDate}&toDate=${toDate}&productFilter=${productFilter}&status=${status}&itemsPerPage=${itemsPerPage}&page=${currentPage - 1}" class="btn-page">‹ Trước</a>
                                </c:if>


                                <!-- Page numbers -->
                                <c:set var="startPage" value="${currentPage - 2 > 0 ? currentPage - 2 : 1}" />
                                <c:set var="endPage" value="${currentPage + 2 <= totalPages ? currentPage + 2 : totalPages}" />


                                <c:if test="${startPage > 1}">
                                    <span class="page-dots">...</span>
                                </c:if>


                                <c:forEach var="i" begin="${startPage}" end="${endPage}">
                                    <c:choose>
                                        <c:when test="${i == currentPage}">
                                            <span class="btn-page active">${i}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="bm-receive-check?id=${movementID}&fromDate=${fromDate}&toDate=${toDate}&productFilter=${productFilter}&status=${status}&itemsPerPage=${itemsPerPage}&page=${i}" class="btn-page">${i}</a>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>


                                <c:if test="${endPage < totalPages}">
                                    <span class="page-dots">...</span>
                                </c:if>


                                <!-- Next and last page -->
                                <c:if test="${currentPage < totalPages}">
                                    <a href="bm-receive-check?id=${movementID}&fromDate=${fromDate}&toDate=${toDate}&productFilter=${productFilter}&status=${status}&itemsPerPage=${itemsPerPage}&page=${currentPage + 1}" class="btn-page">Sau ›</a>
                                    <a href="bm-receive-check?id=${movementID}&fromDate=${fromDate}&toDate=${toDate}&productFilter=${productFilter}&status=${status}&itemsPerPage=${itemsPerPage}&page=${totalPages}" class="btn-page">Cuối ⏭</a>
                                </c:if>
                            </div>


                            <div class="pagination-info">
                                <span>
                                    Hiển thị
                                    ${not empty startItem ? startItem : 1} - ${not empty endItem ? endItem : 0} /
                                    Tổng số ${not empty totalItems ? totalItems : 0} sản phẩm
                                    (Trang ${not empty currentPage ? currentPage : 1}/${not empty totalPages ? totalPages : 1})
                                </span>
                                <div class="items-per-page">
                                    <label>Hiển thị:</label>
                                    <form method="GET" style="display: inline;">
                                        <input type="hidden" name="id" value="${movementID}">
                                        <input type="hidden" name="fromDate" value="${fromDate}">
                                        <input type="hidden" name="toDate" value="${toDate}">
                                        <input type="hidden" name="productFilter" value="${productFilter}">
                                        <input type="hidden" name="status" value="${status}">
                                        <select name="itemsPerPage" onchange="this.form.submit()">
                                            <option value="10" ${itemsPerPage == 10 ? 'selected' : ''}>10</option>
                                            <option value="25" ${itemsPerPage == 25 ? 'selected' : ''}>25</option>
                                            <option value="50" ${itemsPerPage == 50 ? 'selected' : ''}>50</option>
                                        </select>
                                    </form>
                                    <span>bản ghi/trang</span>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>


        <!-- QR Scanner Modal -->
        <div id="qrScannerModal" class="modal">
            <form id="serialForm" method="post" action="bm-verify-serial" onsubmit="return handleSerialFormSubmit(event)">
                <input type="hidden" name="scannedSerial" id="formSerial">
                <input type="hidden" name="detailID" id="formDetailID">
                <input type="hidden" name="productDetailID" id="formProductDetailID">
                <input type="hidden" name="movementID" value="${movementID}" />
                <input type="hidden" name="movementType" value="import" />
                <div class="modal-content">
                    <div class="modal-header">
                        <h3>Nhập Serial Sản phẩm</h3>
                        <button class="close-btn" onclick="closeQRScanner()">&times;</button>
                    </div>
                    <div class="modal-body">
                        <!-- Luôn hiển thị input để nhập thủ công -->
                        <div class="scan-result">
                            <label for="scannedSerial">Serial Number:</label>
                            <input type="text" id="scannedSerial" placeholder="Nhập serial hoặc quét QR..."
                                   style="margin-bottom: 15px; padding: 12px; font-size: 16px;">
                        </div>
                        <!-- QR Scanner controls -->
                        <div class="scan-controls">
                            <button id="startScanBtn" type="button" class="btn btn-primary" onclick="startQRScanner()">
                                <i class="fas fa-qrcode"></i> Quét QR Code
                            </button>
                            <button id="stopScanBtn" type="button" class="btn btn-secondary" onclick="stopQRScanner()" style="display: none;">
                                <i class="fas fa-stop"></i> Dừng quét
                            </button>
                        </div>
                        <!-- QR Reader container - ẩn mặc định -->
                        <div class="qr-reader-container" id="qrReaderContainer" style="display: none; margin: 15px 0;">
                            <div id="qr-reader"></div>
                        </div>
                        <!-- Action buttons -->
                        <div style="margin-top: 20px; text-align: center;">
                            <button type="submit" class="btn btn-success" style="margin-right: 10px;">
                                <i class="fas fa-plus"></i> Thêm Serial
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="closeQRScanner()">
                                <i class="fas fa-times"></i> Hủy
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>


        <script>
            // Header dropdown
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");
            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            });
            document.addEventListener("click", function (e) {
                if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                    menu.style.display = "none";
                }
            });


            // QR Scanner variables
            let html5QrCode = null;
            let currentDetailID = null;
            let currentProductDetailID = null;
            let isScanning = false;


            function resetFilters() {
                window.location.href = 'bm-receive-check?id=${movementID}';
            }


            function showNotification(message, type) {
                // Simple notification
                const notification = document.createElement('div');
                notification.className = 'alert alert-' + (type === 'success' ? 'success' : type === 'error' ? 'danger' : 'info');
                notification.textContent = message;
                notification.style.position = 'fixed';
                notification.style.top = '20px';
                notification.style.right = '20px';
                notification.style.zIndex = '9999';
                notification.style.maxWidth = '400px';
               
                document.body.appendChild(notification);
               
                setTimeout(() => {
                    document.body.removeChild(notification);
                }, 3000);
            }


            function scanSerial(detailID, productDetailID) {
                console.log('📱 Mở modal nhập serial cho detail ID:', detailID, 'productDetailID:', productDetailID);


                if (!detailID || detailID === 'null' || detailID === 'undefined') {
                    showNotification('Lỗi: Không tìm thấy ID chi tiết', 'error');
                    return;
                }


                if (!productDetailID || productDetailID === 'null' || productDetailID === 'undefined') {
                    showNotification('Lỗi: Không tìm thấy ID sản phẩm', 'error');
                    return;
                }


                currentDetailID = detailID;
                currentProductDetailID = productDetailID;


                // Hiển thị modal
                document.getElementById("qrScannerModal").style.display = "block";


                // Đặt giá trị cho input hidden
                document.getElementById("formDetailID").value = detailID;
                document.getElementById("formProductDetailID").value = productDetailID;


                // Focus input nhập
                const input = document.getElementById("scannedSerial");
                if (input) {
                    input.value = "";
                    input.focus();
                }


                // Ẩn QR reader
                const qrContainer = document.getElementById("qrReaderContainer");
                if (qrContainer) {
                    qrContainer.style.display = "none";
                }
            }


            // Bắt đầu quét QR (tùy chọn)
            function startQRScanner() {
                if (isScanning) return;


                console.log('📷 Bắt đầu quét QR...');


                // Hiển thị QR reader container
                document.getElementById("qrReaderContainer").style.display = "block";


                // Kiểm tra camera
                Html5Qrcode.getCameras().then(devices => {
                    if (devices && devices.length) {
                        html5QrCode = new Html5Qrcode("qr-reader");


                        const config = {
                            fps: 10,
                            qrbox: 250
                        };


                        html5QrCode.start(
                                {facingMode: "environment"},
                                config,
                                function (decodedText, decodedResult) {
                                    console.log('✅ QR detected:', decodedText);
                                    document.getElementById("scannedSerial").value = decodedText;
                                    showNotification('Đã quét được: ' + decodedText, 'success');
                                    stopQRScanner();
                                },
                                function (errorMessage) {
                                    // Ignore errors
                                }
                        ).then(() => {
                            isScanning = true;
                            document.getElementById("startScanBtn").style.display = "none";
                            document.getElementById("stopScanBtn").style.display = "inline-flex";
                            showNotification('Camera đã khởi động', 'success');
                        }).catch(err => {
                            showNotification('Không thể khởi động camera. Vui lòng nhập thủ công.', 'warning');
                            document.getElementById("qrReaderContainer").style.display = "none";
                            document.getElementById("scannedSerial").focus();
                        });
                    } else {
                        showNotification('Không tìm thấy camera. Vui lòng nhập thủ công.', 'warning');
                        document.getElementById("qrReaderContainer").style.display = "none";
                        document.getElementById("scannedSerial").focus();
                    }
                }).catch(err => {
                    showNotification('Lỗi truy cập camera. Vui lòng nhập thủ công.', 'warning');
                    document.getElementById("qrReaderContainer").style.display = "none";
                    document.getElementById("scannedSerial").focus();
                });
            }


            // Dừng quét QR
            function stopQRScanner() {
                if (html5QrCode && isScanning) {
                    html5QrCode.stop().then(() => {
                        isScanning = false;
                        document.getElementById("startScanBtn").style.display = "inline-flex";
                        document.getElementById("stopScanBtn").style.display = "none";
                        document.getElementById("qrReaderContainer").style.display = "none";
                    }).catch(err => {
                        isScanning = false;
                        document.getElementById("startScanBtn").style.display = "inline-flex";
                        document.getElementById("stopScanBtn").style.display = "none";
                        document.getElementById("qrReaderContainer").style.display = "none";
                    });
                }
            }


            // Xử lý submit form serial
            function handleSerialFormSubmit(event) {
                const serialInput = document.getElementById("scannedSerial");
                const serial = serialInput.value.trim();


                if (!serial) {
                    showNotification('Vui lòng quét hoặc nhập serial', 'warning');
                    serialInput.focus();
                    event.preventDefault();
                    return false;
                }


                console.log('➕ Đang thêm serial:', serial, 'cho detail:', currentDetailID);


                // Đặt giá trị vào các input hidden của form
                document.getElementById("formSerial").value = serial;
                document.getElementById("formDetailID").value = currentDetailID;
                document.getElementById("formProductDetailID").value = currentProductDetailID;


                showNotification('Đã thêm serial: ' + serial + '. Đang xử lý...', 'info');
                return true;
            }


            // Đóng modal
            function closeQRScanner() {
                document.getElementById("qrScannerModal").style.display = "none";
                stopQRScanner();
                document.getElementById("scannedSerial").value = "";
                currentDetailID = null;
                currentProductDetailID = null;
            }


            // Đóng modal khi click ngoài vùng
            window.onclick = function (event) {
                const modal = document.getElementById("qrScannerModal");
                if (event.target === modal) {
                    closeQRScanner();
                }
            };


            // Enter key để submit serial
            document.addEventListener('DOMContentLoaded', function () {
                console.log('📋 Trang kiểm tra đơn hàng BM đã được tải');
                console.log('🎯 Đơn hàng ID:', '${movementID}');


                document.getElementById("scannedSerial").addEventListener('keypress', function (e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        document.getElementById("serialForm").submit();
                    }
                });
            });
        </script>
    </body>
</html>



