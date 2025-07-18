<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="movementType" value="${movementType}" />

<!DOCTYPE html>
<html>
    <head>
        <title>Kiểm hàng - Đơn nhập kho</title>
        <link rel="stylesheet" href="css/stock-check.css">
        <link rel="stylesheet" href="css/header.css"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    </head>
    <body>
        <!-- Header giống như trang import.jsp -->
        <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="wh-products?page=1" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="wh-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>
                    <a href="wh-import" class="nav-item <c:choose>
                           <c:when test="${movementType == 'export'}"></c:when>
                           <c:otherwise>active</c:otherwise>
                       </c:choose>">
                        <i class="fa-solid fa-download"></i>
                        Nhập hàng
                    </a>
                    <a href="" class="nav-item  <c:choose>
                           <c:when test="${movementType == 'export'}">active</c:when>
                           <c:otherwise></c:otherwise>
                       </c:choose>">
                        <i class="fa-solid fa-upload"></i>
                        Xuất hàng
                    </a>
                    <a href="" class="nav-item">
                        <i class="fa-solid fa-bell"></i>
                        Thông báo
                    </a>
                    <a href="" class="nav-item">
                        <i class="fas fa-exchange-alt"></i>
                        Yêu cầu nhập hàng
                    </a>
                    <a href="" class="nav-item">
                        <i class="fas fa-chart-bar"></i>
                        Báo cáo
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
            </div>
        </header>

        <div class="container">
            <div class="main-content">
                <!-- Sidebar Filter -->
                <div class="filter-sidebar">
                    <form method="GET" action="">
                        <h3>Bộ lọc</h3>

                        <div class="filter-group">
                            <label>Từ ngày:</label>
                            <input type="date" name="fromDate" class="form-control" value="${param.fromDate}">
                        </div>

                        <div class="filter-group">
                            <label>Đến ngày:</label>
                            <input type="date" name="toDate" class="form-control" value="${param.toDate}">
                        </div>

                        <div class="filter-group">
                            <label>Sản phẩm:</label>
                            <select name="productFilter" class="form-control">
                                <option value="">--Tất cả--</option>
                                <c:forEach var="product" items="${productList}">
                                    <option value="${product.id}" ${param.productFilter == product.id ? 'selected' : ''}>${product.name}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label>Trạng thái:</label>
                            <div class="radio-group">
                                <label><input type="radio" name="status" value="" ${empty param.status ? 'checked' : ''}> Tất cả</label>
                                <label><input type="radio" name="status" value="completed" ${param.status == 'completed' ? 'checked' : ''}> Hoàn thành</label>
                                <label><input type="radio" name="status" value="pending" ${param.status == 'pending' ? 'checked' : ''}> Chờ xử lý</label>
                                <label><input type="radio" name="status" value="processing" ${param.status == 'processing' ? 'checked' : ''}> Đang xử lý</label>
                                <label><input type="radio" name="status" value="cancelled" ${param.status == 'cancelled' ? 'checked' : ''}> Đã hủy</label>
                            </div>
                        </div>

                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter"></i> Áp dụng lọc
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="window.location.href = window.location.pathname">
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
                        <h2>
                            Chi tiết đơn 
                            <c:choose>
                                <c:when test="${movementType == 'export'}">xuất</c:when>
                                <c:otherwise>nhập</c:otherwise>
                            </c:choose>
                            hàng #${movementID}
                        </h2>

                        <div class="header-actions">
                            <c:if test="${allCompleted}">
                                <form method="post" action="${movementType == 'export' ? 'complete-stock-export' : 'complete-stock'}">
                                    <input type="hidden" name="movementID" value="${movementID}" />
                                    <input type="hidden" name="movementType" value="${movementType}" />
                                    <input type="hidden" name="detailID" id="formDetailID">
                                    <input type="hidden" name="warehouseID" value="${sessionScope.warehouseId}" />
                                    <button class="btn btn-success" type="submit">Hoàn tất đơn nhập</button>
                                </form>



                            </c:if>
                            <button class="btn btn-secondary" onclick="cancelCheck('${movementID}', '${movementType}')">

                                Hủy đơn nhập
                            </button>
                        </div>
                    </div>
                    <!-- Stock Check Table -->
                    <div class="table-container">
                        <table class="stock-check-table">
                            <thead>
                                <tr>
                                    <th>Tên sản phẩm</th>
                                    <th>Serial number</th>
                                    <th>Số lượng cần nhập</th>
                                    <th>Đã nhập</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${movementDetails}">
                                    <tr class="${item.quantity == item.scanned ? 'row-completed' : ''}">
                                        <!-- Tên sản phẩm + mã -->
                                        <td>
                                            <div><strong>${item.productName}</strong></div>
                                            <div class="text-muted">(${item.productCode})</div>
                                        </td>
                                        <!-- Serial number -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${empty item.serials}">
                                                    <span class="text-muted">Chưa có serial nào</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="serial" items="${item.serials}">
                                                        <div class="serial-item ${serial.error != null ? 'error' : ''}">
                                                            ${serial.serialNumber}
                                                            <c:if test="${serial.error != null}">
                                                                <span class="error-msg">(${serial.error})</span>
                                                            </c:if>
                                                        </div>
                                                    </c:forEach>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <!-- Số lượng cần nhập -->
                                        <td>${item.quantity}</td>
                                        <!-- Số đã nhập -->
                                        <td>${item.scanned}/${item.quantity}</td>
                                        <!-- Thao tác -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${item.quantity > item.scanned}">
                                                    <button class="btn-scan" onclick="scanSerial('${item.detailID}', '${item.productDetailID}')">Quét</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-success">Đã đủ</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td><td>${item.productDetailID}</td> <!-- kiểm tra thử -->



                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination đơn giản -->
                    <div class="pagination-container">
                        <div class="pagination-info">
                            <span>Hiển thị ${startItem} - ${endItem} / Tổng số ${totalItems} sản phẩm</span>
                            <div class="items-per-page">
                                <label>Hiển thị:</label>
                                <form method="GET" style="display: inline;" onsubmit="return checkBeforeSubmit(event)">
                                    <select name="itemsPerPage" onchange="this.form.submit()">
                                        <option value="10" ${param.itemsPerPage == '10' ? 'selected' : ''}>10</option>
                                        <option value="25" ${param.itemsPerPage == '25' ? 'selected' : ''}>25</option>
                                        <option value="50" ${param.itemsPerPage == '50' ? 'selected' : ''}>50</option>
                                    </select>
                                </form>
                                <span>bản ghi/trang</span>
                            </div>
                        </div>
                        <div class="pagination-controls">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=1" class="btn-page" onclick="return checkBeforeLeave(event)">⏮</a>
                                <a href="?page=${currentPage - 1}" class="btn-page" onclick="return checkBeforeLeave(event)">◀</a>
                            </c:if>
                            <span class="btn-page active">${currentPage}</span>
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}" class="btn-page" onclick="return checkBeforeLeave(event)">▶</a>
                                <a href="?page=${totalPages}" class="btn-page" onclick="return checkBeforeLeave(event)">⏭</a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- QR Scanner Modal -->
        <div id="qrScannerModal" class="modal">
            <form id="serialForm" method="post" 
                  action="${movementType == 'export' ? 'serial-check-export' : 'serial-check'}?id=${movementID}"onsubmit="return handleSerialFormSubmit(event)">
                <input type="hidden" name="scannedSerial" id="formSerial">
                <input type="hidden" name="detailID" id="formDetailID">
                <input type="hidden" name="productDetailID" id="formProductDetailID">
                <input type="hidden" name="movementID" value="${movementID}" />
                <input type="hidden" name="movementType" value="${movementType}" />
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
            let currentProductDetailID = null; // ✅ Thêm dòng này
            let isScanning = false;


            // ===== BIẾN THEO DÕI TRẠNG THÁI FORM =====
            let hasUnsavedChanges = false;
            let isFormSubmitting = false;

            // Lấy URL hiện tại để so sánh
            const currentPagePath = window.location.pathname;
            const currentPageBase = currentPagePath.split('?')[0]; // Lấy phần base URL không có query params

            // Simple notification
            function showNotification(message, type = "info") {
                const notification = document.createElement("div");
                notification.className = `notification notification-${type}`;
                notification.textContent = message;
                document.body.appendChild(notification);
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.parentNode.removeChild(notification);
                    }
                }, 3000);
            }

            // ===== FUNCTIONS QUẢN LÝ TRẠNG THÁI =====
            function markFormAsChanged() {
                hasUnsavedChanges = true;
                console.log('🔄 Form đã có thay đổi - cần hoàn thành');
            }

            function markFormAsSubmitted() {
                isFormSubmitting = true;
                hasUnsavedChanges = false;
                console.log('✅ Form đã được submit - không cần cảnh báo');
            }

            // ===== FUNCTION KIỂM TRA CÓ PHẢI CÙNG TRANG KHÔNG =====
            function isSamePage(targetUrl) {
                try {
                    // Nếu là relative URL (bắt đầu bằng ?)
                    if (targetUrl.startsWith('?')) {
                        console.log('🔄 Cùng trang - chỉ thay đổi query params');
                        return true;
                    }

                    // Nếu là absolute URL
                    const targetPath = new URL(targetUrl, window.location.origin).pathname;
                    const isSame = targetPath === currentPageBase || targetPath.includes('serial-check');

                    return isSame;
                } catch (e) {
                    // Lỗi parse URL, coi như khác trang để cảnh báo an toàn
                    return false;
                }
            }

            function checkBeforeLeave(event) {
                // Lấy URL đích
                let targetUrl = '';
                if (event.target && event.target.href) {
                    targetUrl = event.target.href;
                } else if (event.target && event.target.closest('a')) {
                    targetUrl = event.target.closest('a').href;
                }

                // Nếu cùng trang (serial-check) thì không cảnh báo
                if (isSamePage(targetUrl)) {
                    return true;
                }

                // Nếu khác trang và có thay đổi chưa lưu thì cảnh báo
                if (hasUnsavedChanges && !isFormSubmitting) {
                    const message = 'Bạn hãy tiếp tục hoàn thành biểu mẫu. Các thay đổi chưa được lưu sẽ bị mất.';
                    console.warn('⚠️ CẢNH BÁO NAVIGATION - Rời khỏi trang: ' + message);

                    const confirmLeave = confirm(message);
                    if (!confirmLeave) {
                        event.preventDefault();
                        console.log('🛑 Người dùng đã chọn ở lại để hoàn thành biểu mẫu');
                        return false;
                    } else {
                        console.warn('⚠️ Người dùng đã chọn rời khỏi trang mà chưa hoàn thành biểu mẫu');
                        markFormAsSubmitted(); // Đánh dấu đã submit để tránh beforeunload
                        return true;
                    }
                }
                return true;
            }

            function checkBeforeSubmit(event) {
                console.log('📤 Form đang được submit - cho phép');
                markFormAsSubmitted();
                return true;
            }

            function resetFilters() {
                // Reset filter không cần cảnh báo vì cùng trang
                window.location.href = window.location.pathname;
            }

            // ===== BEFOREUNLOAD EVENT - CHỈ CHO BROWSER ACTIONS (F5, đóng tab, nhập URL mới) =====
            window.addEventListener('beforeunload', function (event) {
                if (hasUnsavedChanges && !isFormSubmitting) {
                    const message = 'Bạn hãy tiếp tục hoàn thành biểu mẫu. Các thay đổi chưa được lưu sẽ bị mất.';
                    console.warn('⚠️ BEFOREUNLOAD - Browser action: ' + message);

                    event.preventDefault();
                    event.returnValue = message; // Chrome
                    return message; // Other browsers
                }
            });

            // ===== UNLOAD EVENT =====
            window.addEventListener('unload', function () {
                if (hasUnsavedChanges && !isFormSubmitting) {
                    console.error('🚨 NGƯỜI DÙNG ĐÃ RỜI KHỎI TRANG MÀ CHƯA HOÀN THÀNH BIỂU MẪU!');
                    console.log('📋 Vui lòng quay lại và hoàn thành việc nhập serial cho đơn hàng #' + '${movementID}');
                }
            });


            function scanSerial(detailID, productDetailID) {
                currentDetailID = detailID;
                currentProductDetailID = productDetailID;
                console.log('📱 Mở modal nhập serial cho detail ID:', detailID, 'productDetailID:', productDetailID);

                // ĐÁNH DẤU CÓ THAY ĐỔI NGAY KHI MỞ MODAL
                markFormAsChanged();

                // Hiển thị modal
                document.getElementById("qrScannerModal").style.display = "block";

                // Đặt giá trị cho 2 input hidden
                document.getElementById("formDetailID").value = detailID;
                document.getElementById("formProductDetailID").value = productDetailID;

                // Focus input nhập
                const input = document.getElementById("scannedSerial");
                input.value = "";
                input.focus();

                // Ẩn QR reader
                document.getElementById("qrReaderContainer").style.display = "none";
            }


            // Bắt đầu quét QR (tùy chọn)
            function startQRScanner() {
                if (isScanning)
                    return;

                console.log('📷 Bắt đầu quét QR...');

                // Hiển thị QR reader container
                document.getElementById("qrReaderContainer").style.display = "block";

                // Kiểm tra camera
                Html5Qrcode.getCameras().then(devices => {
                    console.log('📹 Tìm thấy cameras:', devices.length);

                    if (devices && devices.length) {
                        // Khởi tạo scanner
                        html5QrCode = new Html5Qrcode("qr-reader");

                        // Config đơn giản
                        const config = {
                            fps: 10,
                            qrbox: 250
                        };

                        // Bắt đầu quét
                        html5QrCode.start(
                                {facingMode: "environment"},
                                config,
                                function (decodedText, decodedResult) {
                                    // Thành công - điền vào input
                                    console.log('✅ QR detected:', decodedText);
                                    document.getElementById("scannedSerial").value = decodedText;
                                    showNotification('Đã quét được: ' + decodedText, 'success');

                                    // ĐÁNH DẤU CÓ THAY ĐỔI KHI QUÉT THÀNH CÔNG
                                    markFormAsChanged();

                                    // Tự động dừng quét
                                    stopQRScanner();
                                }
                        ).then(() => {
                            isScanning = true;
                            document.getElementById("startScanBtn").style.display = "none";
                            document.getElementById("stopScanBtn").style.display = "inline-flex";
                            showNotification('Camera đã khởi động', 'success');
                            console.log('📷 Scanner started successfully');
                        }).catch(err => {
                            console.error('❌ Lỗi khởi động scanner:', err);
                            showNotification('Không thể khởi động camera. Vui lòng nhập thủ công.', 'warning');

                            // Ẩn QR reader và focus vào input
                            document.getElementById("qrReaderContainer").style.display = "none";
                            document.getElementById("scannedSerial").focus();
                        });
                    } else {
                        console.log('❌ Không tìm thấy camera');
                        showNotification('Không tìm thấy camera. Vui lòng nhập thủ công.', 'warning');

                        // Ẩn QR reader và focus vào input
                        document.getElementById("qrReaderContainer").style.display = "none";
                        document.getElementById("scannedSerial").focus();
                    }
                }).catch(err => {
                    console.error('❌ Lỗi truy cập camera:', err);
                    showNotification('Lỗi truy cập camera. Vui lòng nhập thủ công.', 'warning');

                    // Ẩn QR reader và focus vào input
                    document.getElementById("qrReaderContainer").style.display = "none";
                    document.getElementById("scannedSerial").focus();
                });
            }

            // Dừng quét QR
            function stopQRScanner() {
                if (html5QrCode && isScanning) {
                    html5QrCode.stop().then(() => {
                        console.log('⏹️ Scanner stopped');
                        isScanning = false;
                        document.getElementById("startScanBtn").style.display = "inline-flex";
                        document.getElementById("stopScanBtn").style.display = "none";

                        // Ẩn QR reader container
                        document.getElementById("qrReaderContainer").style.display = "none";
                    }).catch(err => {
                        console.error('❌ Lỗi dừng scanner:', err);
                        // Force reset
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
                    event.preventDefault(); // Ngăn form submit nếu không có serial
                    return false;
                }

                console.log('➕ Đang thêm serial:', serial, 'cho detail:', currentDetailID);

                // Đặt giá trị vào các input hidden của form
                document.getElementById("formSerial").value = serial;
                document.getElementById("formDetailID").value = currentDetailID;
                document.getElementById("formProductDetailID").value = currentProductDetailID; // ✅ dòng mới thêm


                markFormAsSubmitted(); // Đánh dấu đã submit trước khi form gửi đi
                showNotification('Đã thêm serial: ' + serial + '. Đang xử lý...', 'info');

                // Form sẽ tự submit sau khi hàm này kết thúc (nếu không có preventDefault)
                return true;
            }

            // Đóng modal
            function closeQRScanner() {
                document.getElementById("qrScannerModal").style.display = "none";

                // Dừng scanner nếu đang chạy
                stopQRScanner();

                // Reset input
                document.getElementById("scannedSerial").value = "";

                // Reset variables
                currentDetailID = null;
            }

            // Main action functions
            function saveCheck() {
                if (confirm("Bạn có chắc chắn muốn lưu và hoàn thành đơn nhập này?")) {
                    showNotification("Đang xử lý...", "info");
                    document.getElementById("completeForm").submit();
                }
            }


            function cancelCheck(movementID, movementType) {
                if (confirm("Bạn có chắc chắn muốn hủy đơn này?")) {
                    console.log('❌ Hủy đơn:', movementID, movementType);
                    markFormAsSubmitted(); // Đánh dấu đã submit
                    showNotification('Đang xử lý...', 'info');

                    const actionUrl = movementType === 'export' ? 'cancel-stock-export' : 'cancel-stock';
                    window.location.href = `${actionUrl}?id=${movementID}`;
                            }
                        }


                        // Đóng modal khi click ngoài vùng
                        window.onclick = function (event) {
                            const modal = document.getElementById("qrScannerModal");
                            if (event.target === modal) {
                                closeQRScanner();
                            }
                        };

                        // Sự kiện DOM loaded
                        document.addEventListener('DOMContentLoaded', function () {
                            console.log('📋 Trang chi tiết đơn nhập hàng đã được tải');
                            console.log('🎯 Đơn hàng ID:', '${movementID}');
                            console.log('🌐 Current page base:', currentPageBase);
                            console.log('⏰ Thời gian:', new Date().toLocaleString());

                            // Enter key để submit serial
                            document.getElementById("scannedSerial").addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    e.preventDefault(); // Ngăn Enter tạo dòng mới hoặc submit form mặc định
                                    document.getElementById("serialForm").submit(); // Kích hoạt submit form
                                }
                            });

                            // Theo dõi input changes để đánh dấu có thay đổi
                            document.getElementById("scannedSerial").addEventListener('input', function () {
                                if (this.value.trim()) {
                                    console.log('✏️ Đang nhập serial:', this.value);
                                    markFormAsChanged();
                                }
                            });

                            // Nhắc nhở định kỳ nếu có thay đổi chưa lưu
                            setInterval(function () {
                                if (hasUnsavedChanges && !isFormSubmitting) {
                                    console.log('⏳ Nhắc nhở: Bạn đang có thay đổi chưa được lưu. Vui lòng hoàn thành biểu mẫu.');
                                }
                            }, 30000); // Mỗi 30 giây
                        });

                        // Cleanup on page unload
                        window.addEventListener("beforeunload", () => {
                            if (html5QrCode && isScanning) {
                                html5QrCode.stop();
                            }
                        });
        </script>
    </body>
</html>
