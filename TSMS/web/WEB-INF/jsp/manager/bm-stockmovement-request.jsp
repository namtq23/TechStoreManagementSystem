<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Yêu cầu nhập hàng</title>
        <link rel="stylesheet" href="css/header.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .product-card:hover {
                background-color: #f1f1f1;
                cursor: pointer;
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
                            <a href="bm-stockmovement?type=import" class="dropdown-item">Nhập hàng</a>
                            <a href="bm-stockmovement?type=request" class="dropdown-item">Yêu cầu nhập hàng</a>
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
                            <a href="profile" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
        </header>

        <div class="container-fluid mt-4">
            <div class="row">
                <!-- Phiếu yêu cầu nhập hàng -->
                <div class="col-md-7">
                    <h5>Phiếu yêu cầu nhập hàng</h5>
                    <form action="bm-stockmovement" method="post">
                        <input type="hidden" name="action" value="submitRequest" />
                        <table class="table table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>STT</th>
                                    <th>Mã SP</th>
                                    <th>Tên SP</th>
                                    <th>SL yêu cầu</th>
                                    <th>Ghi chú</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="requestItems"></tbody>
                        </table>

                        <div class="mb-3">
                            <label for="note" class="form-label">Ghi chú chung:</label>
                            <textarea class="form-control" name="note" id="note" rows="2"></textarea>
                        </div>

                        <input type="hidden" name="productData" id="productData"/>
                        <div class="d-flex justify-content-between align-items-center">
                            <p><strong>Tổng sản phẩm:</strong> <span id="totalQty">0</span></p>
                            <button type="submit" class="btn btn-success" onclick="prepareSubmit()">Gửi yêu cầu nhập</button>
                        </div>
                    </form>
                </div>

                <!-- Danh sách sản phẩm tại chi nhánh -->
                <div class="col-md-5 border-start">
                    <h5>Danh sách sản phẩm tại chi nhánh</h5>
                    <input type="text" class="form-control mb-3" placeholder="Tìm kiếm sản phẩm...">

                    <div id="productList">
                        <c:forEach var="p" items="${productList}">
                            <div class="card product-card mb-2 p-3 d-flex justify-content-between align-items-center" data-id="${p.id}">
                                <div onclick="handleProductClick('${p.id}')">
                                    <strong>${p.name}</strong><br>
                                    <small>Tồn kho: ${p.quantity}</small>
                                </div>
                                <button class="btn btn-sm btn-outline-primary" onclick="addProductToRequest('${p.id}', '${p.name}')" type="button">+</button>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="productExistsModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Thông báo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="modalProductMessage"></div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function addProductToRequest(id, name) {
                const exists = Array.from(document.querySelectorAll("#requestItems tr")).some(row => row.children[1].textContent === id);
                if (exists)
                    return handleProductClick(id);

                const table = document.getElementById("requestItems");
                const row = document.createElement("tr");
                row.innerHTML = `
                  <td>${table.rows.length + 1}</td>
                  <td>${id}</td>
                  <td>${name}</td>
                  <td><input type="number" class="form-control quantity-input" min="1" value="1"></td>
                  <td><input type="text" class="form-control note-input"></td>
                  <td><button class="btn btn-sm btn-danger" onclick="removeRow(this)">X</button></td>
                `;
                table.appendChild(row);
                updateTotalQty();
            }

            function removeRow(btn) {
                btn.closest("tr").remove();
                updateTotalQty();
            }

            function updateTotalQty() {
                const qtyInputs = document.querySelectorAll(".quantity-input");
                let total = 0;
                qtyInputs.forEach(input => total += parseInt(input.value || 0));
                document.getElementById("totalQty").textContent = total;
            }

            function handleProductClick(productId) {
                const rows = document.querySelectorAll("#requestItems tr");
                for (const row of rows) {
                    if (row.children[1].textContent === productId) {
                        const name = row.children[2].textContent;
                        const qty = row.querySelector(".quantity-input").value;
                        const note = row.querySelector(".note-input").value;
                        document.getElementById("modalProductMessage").innerHTML = `Sản phẩm <strong>${name}</strong> đã được chọn:<br><strong>Số lượng:</strong> ${qty}<br><strong>Ghi chú:</strong> ${note || "(Không có)"}`;
                        new bootstrap.Modal(document.getElementById('productExistsModal')).show();
                        break;
                    }
                }
            }

            function prepareSubmit() {
                const data = [];
                document.querySelectorAll("#requestItems tr").forEach(row => {
                    data.push({
                        id: row.children[1].textContent,
                        name: row.children[2].textContent,
                        quantity: row.querySelector(".quantity-input").value,
                        note: row.querySelector(".note-input").value
                    });
                });
                document.getElementById("productData").value = JSON.stringify(data);
            }
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
