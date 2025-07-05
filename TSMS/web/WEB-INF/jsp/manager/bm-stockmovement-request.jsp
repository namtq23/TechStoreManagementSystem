<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ProductDetails" %>
<%@ page import="java.util.List" %>
<%@ page import="model.StockMovement.StockMovementDetail" %>

<%
    List<ProductDetails> products = (List<ProductDetails>) request.getAttribute("products");
    List<model.Warehouse> warehouses = (List<model.Warehouse>) request.getAttribute("warehouses");
    String selectedID = (String) request.getAttribute("selectedToWarehouseID");
    List<StockMovementDetail> draft = (List<StockMovementDetail>) request.getAttribute("draftDetails");
%>

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
                    <a href="bm-overview" class="nav-item">
                        <i class="fas fa-chart-line"></i>
                        Tổng quan
                    </a>

                    <a href="bm-products?page=1" class="nav-item">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <div class="nav-item dropdown active" >
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                            <i class="fas fa-caret-down"></i>
                        </a>
                        <div class="dropdown-menu">
                            <a href="#" class="dropdown-item">Đơn hàng</a>
                            <a href="#" class="dropdown-item">Nhập hàng</a>
                            <a href="#" class="dropdown-item">Yêu cầu nhập hàng</a>
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
            <!-- Phiếu yêu cầu nhập -->
            <div class="invoice-panel">
                <div class="panel-header">Phiếu yêu cầu nhập hàng
                    <% if (draft != null && !draft.isEmpty()) { %>
                    <form method="post" action="request-stock" style="display: inline;">
                        <input type="hidden" name="action" value="reset" />
                        <input type="hidden" name="keyword" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>" />
                        <button type="submit" class="btn-secondary" onclick="return confirm('Bạn có chắc muốn xóa tất cả sản phẩm?')">
                            <i class="fa fa-trash"></i> Xóa tất cả
                        </button>
                    </form>
                    <% } %></div>

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
                                <% 
                                List<ProductDetails> draftProductDetails = (List<ProductDetails>) request.getAttribute("draftProductDetails");
                                if (draft != null && !draft.isEmpty() && draftProductDetails != null) {
                                    int stt = 1;
                                    for (int i = 0; i < draft.size(); i++) {
                                        StockMovementDetail d = draft.get(i);
                                        ProductDetails product = i < draftProductDetails.size() ? draftProductDetails.get(i) : null;
                                        String productName = product != null ? product.getDescription() : "Không tìm thấy";
                                %>
                                <tr>
                                    <td><%= stt++ %></td>
                                    <td><%= d.getProductDetailID() %></td>
                                    <td><%= productName %></td>
                                    <td>
                                        <input type="number" name="quantity" value="<%= d.getQuantity() %>" min="1" required />
                                    </td>
                                    <td>
                                        <button type="button" onclick="removeItem(<%= d.getProductDetailID() %>)">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="5" style="font-size: 15px"><strong>Chưa có sản phẩm được chọn</strong></td>
                                </tr>
                                <% } %>
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
                            <span class="value"><%= draft != null ? draft.size() : 0 %></span>
                        </div>
                        <div class="total-products-display">
                            <span class="label">Tổng số lượng sản phẩm yêu cầu</span>
                            <span class="value"><%= request.getAttribute("totalQuantity") != null ? request.getAttribute("totalQuantity") : 0 %></span>
                        </div>
                        <div class="form-row">
                            <label for="toWarehouseID">Chọn kho đích</label>
                            <select name="toWarehouseID" id="toWarehouseID" required>
                                <option value="">-- Chọn kho --</option>
                                <% for (model.Warehouse w : warehouses) {
                                    String selected = (selectedID != null && selectedID.equals(String.valueOf(w.getWareHouseId()))) ? "selected" : "";
                                %>
                                <option value="<%= w.getWareHouseId() %>" <%= selected %>>
                                    <%= w.getWareHouseName() %> - <%= w.getWareHouseAddress() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="payment-section">
                        <button type="submit" class="btn-primary">Gửi yêu cầu nhập</button>
                    </div>
                </form>
                <form id="removeForm" method="post" action="request-stock" class="hidden">
                    <input type="hidden" name="action" value="remove" />
                    <input type="hidden" name="productDetailID" id="removeProductDetailID" />
                    <input type="hidden" name="toWarehouseID" id="removeToWarehouseID" />
                </form>
            </div>


            <!-- Danh sách sản phẩm -->
            <div class="product-panel">
                <div class="panel-header">
                    <h2>Danh sách sản phẩm tại chi nhánh</h2>
                </div>

                <div class="search-section">
                    <form method="get" action="request-stock" id="searchForm" class="search-form">
                        <div class="search-container">
                            <i class="fa fa-search"></i>
                            <input
                                type="text"
                                class="search-input"
                                name="keyword"
                                placeholder="Tìm kiếm sản phẩm..."
                                value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>"
                                />
                            <button type="submit" class="btn-primary">Tìm kiếm</button>
                        </div>
                    </form>
                </div>



                <div class="product-grid">
                    <% for (ProductDetails p : products) { %>
                    <div class="product-card">
                        <div class="product-info">
                            <h4><%= p.getDescription() %></h4>
                            <div class="product-stock">Serial: <%= p.getProductCode() %> – Tồn kho: <strong><%= p.getQuantity() %></strong></div>
                        </div>
                        <form action="request-stock" method="post">
                            <input type="hidden" name="action" value="add" />
                            <input type="hidden" name="productDetailID" value="<%= p.getProductDetailID() %>" />
                            <button type="submit" class="add-to-cart"><i class="fa fa-plus"></i></button>
                        </form>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div id="modalBackdrop" class="modal-backdrop"></div>

        <div id="feedbackModal" class="modal">
            <div class="modal-header">
                <h5>Thông báo</h5>
                <button onclick="closeModal()">×</button>
            </div>
            <div class="modal-body">
                <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("successMessage") %> </div>
                <% } else if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
            </div>
        </div>


        <!-- Script -->
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
                const hasMessage = <%= (request.getAttribute("successMessage") != null || request.getAttribute("errorMessage") != null) %>;
                if (hasMessage) {
                    showModal();
                }
            });


            function removeItem(productId) {
                document.getElementById("removeProductDetailID").value = productId;
                const selectedWarehouse = document.querySelector("select[name='toWarehouseID']").value;
                document.getElementById("removeToWarehouseID").value = selectedWarehouse;
                document.getElementById("removeForm").submit();
            }
            document.querySelectorAll('.nav-item.dropdown > .dropdown-toggle').forEach(toggle => {
                toggle.addEventListener('click', function (e) {
                    e.preventDefault();
                    this.parentElement.classList.toggle('active');
                });
            });
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");

            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                menu.classList.toggle("show");
            });

            document.addEventListener("click", function (e) {
                if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                    menu.classList.remove("show");
                }
            });
        </script>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
