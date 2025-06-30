<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Kiểm hàng - Đơn nhập kho</title>
    <link rel="stylesheet" href="css/stock-check.css">
    <link rel="stylesheet" href="css/header.css"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <!-- HEADER -->
   <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="so-overview" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="wh-products?page=1" class="nav-item ">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <a href="wh-import" class="nav-item active">
                        <i class="fa-solid fa-download"></i>
                        Nhập hàng
                    </a>

                    <a href="" class="nav-item">
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

    <div class="main-container">
        <div class="main-content">
            <!-- PAGE HEADER -->
            <div class="page-header">
                <h1>Kiểm hàng - Đơn nhập <span style="color:#2196f3">#${movementID}</span></h1>
                <div class="header-actions">
                    <button class="btn btn-success" onclick="saveCheck('${movementID}')">Lưu & Hoàn thành</button>
                    <button class="btn btn-secondary" onclick="cancelCheck('${movementID}')">Hủy đơn nhập</button>
                </div>
            </div>

            <!-- STOCK CHECK TABLE -->
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
                            <td>${item.productName}</td>
                            <td>
                                <c:forEach var="serial" items="${item.serials}">
                                    <div class="serial-item ${serial.error != null ? 'error' : ''}">
                                        ${serial.serialNumber}
                                        <c:if test="${serial.error != null}">
                                            <span class="error-msg">(${serial.error})</span>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </td>
                            <td>${item.quantity}</td>
                            <td>${item.scanned}</td>
                            <td>
                                <c:if test="${item.quantity > item.scanned}">
                                    <button class="btn-scan" onclick="scanSerial('${item.detailID}')">Quét</button>
                                </c:if>
                                <c:if test="${item.quantity == item.scanned}">
                                    <span class="badge badge-success">Đã đủ</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function scanSerial(detailID) {
            alert("Mở quét serial cho detailID: " + detailID);
            // Tương lai: mở modal + fetch bằng ajax
        }

        function saveCheck(movementID) {
            if (confirm("Xác nhận lưu & hoàn thành đơn nhập?")) {
                window.location.href = 'complete-check?id=' + movementID;
            }
        }

        function cancelCheck(movementID) {
            if (confirm("Bạn có chắc chắn muốn hủy đơn nhập này?")) {
                window.location.href = 'cancel-check?id=' + movementID;
            }
        }

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
    </script>
</body>
</html>
