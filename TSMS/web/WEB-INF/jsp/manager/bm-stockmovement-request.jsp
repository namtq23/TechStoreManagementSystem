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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">  
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

                    <div class="nav-item dropdown active">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-exchange-alt"></i>
                            Giao dịch
                        </a>
                        <div class="dropdown-menu">
                            <a href="bm-orders" class="dropdown-item">Đơn hàng</a>
                            <a href="#" class="dropdown-item">Nhập hàng</a>
                            <a href="request-stock" class="dropdown-item">Tạo yêu cầu nhập</a>
                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a href="" class="dropdown-toggle">
                            <i class="fas fa-handshake"></i>
                            Đối tác
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
            </div>
        </header>

        <div class="main-container">
            <!-- Phiếu yêu cầu nhập -->
            <div class="invoice-panel">
                <div class="panel-header">
                    <h2>Phiếu yêu cầu nhập hàng</h2>
                </div>

                <form action="request-stock" method="post" id="requestForm">
                    <div class="invoice-table-body" style="overflow-y: auto; max-height: 400px;">
                        <table class="table table-bordered">
                            <thead style="position: sticky; top: 0; background-color: #f8fafc; z-index: 1;">
                                <tr>
                                    <th style="width: 50px; text-align: center;">STT</th>
                                    <th style="width: 120px; text-align: center;">Mã sản phẩm</th>
                                    <th style="width: 250px; text-align: center;">Tên sản phẩm</th>
                                    <th style="width: 150px; text-align: center;">Số lượng yêu cầu</th>
                                    <th style="width: 200px; text-align: center;">Ghi chú</th>
                                    <th style="width: 50px;"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (draft != null && !draft.isEmpty()) {
                                    int stt = 1;
                                    for (StockMovementDetail d : draft) {
                                        String productName = "";
                                        for (ProductDetails p : products) {
                                            if (p.getProductDetailID() == d.getProductDetailID()) {
                                                productName = p.getProductNameUnsigned();
                                                break;
                                            }
                                        }
                                %>
                                <tr class="item-row text-center align-middle">
                                    <td><%= stt++ %></td>
                                    <td><%= d.getProductDetailID() %></td>
                                    <td><%= productName %></td>
                                    <td>
                                        <input type="number" name="quantity" value="<%= d.getQuantity() %>" min="1"
                                               class="form-control form-control-sm text-center" required />
                                    </td>
                                    <td>
                                        <input type="text" name="note" class="form-control form-control-sm" />
                                    </td>
                                    <td>
                                        <button type="button" class="delete-btn" onclick="removeItem(<%= d.getProductDetailID() %>)">
                                            <i class="fa fa-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                                <% } } else { %>
                                <tr>
                                    <td colspan="6" class="text-center">Chưa có sản phẩm nào</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="invoice-summary compact-summary">
                        <label class="form-label mb-1"><strong>Ghi chú chung</strong></label>
                        <textarea name="overallNote" class="form-control form-control-sm mb-2" rows="2"></textarea>

                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <span class="text-muted">Tổng sản phẩm:</span>
                            <span><strong><%= draft != null ? draft.size() : 0 %></strong></span>
                        </div>

                        <label class="form-label mb-1"><strong>Chọn kho đích</strong></label>
                        <select name="toWarehouseID" class="form-select form-select-sm mb-2" required>
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

                    <div class="payment-section compact-payment">
                        <button type="submit" class="btn btn-primary w-100 py-2">Gửi yêu cầu nhập</button>
                    </div>
                </form>

                <!-- Form remove ẩn -->
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
                    <form method="get" action="request-stock" id="searchForm" class="d-flex w-100 align-items-center">
                        <div class="search-container" style="flex: 1; position: relative;">
                            <i class="fa fa-search" style="position: absolute; left: 12px; top: 50%; transform: translateY(-50%); color: #64748b;"></i>
                            <input
                                type="text"
                                class="search-input"
                                name="keyword"
                                placeholder="Tìm kiếm sản phẩm..."
                                value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>"
                                style="padding-left: 40px;"
                                />
                        </div>
                        <button type="submit" style="background-color: #1F90EC; border-color: #1F90EC" class="btn btn-secondary ms-2">
                            Tìm kiếm
                        </button>
                    </form>
                </div>


                <div class="product-grid">
                    <% for (ProductDetails p : products) { %>
                    <div class="product-card">
                        <div class="product-info">
                            <h4><%= p.getProductNameUnsigned() %></h4>
                            <div class="product-stock">Mã: <%= p.getProductCode() %> – Tồn kho: <%= p.getQuantity() %></div>
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
        <div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="feedbackModalLabel">Thông báo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button>
                    </div>
                    <div class="modal-body">
                        <% if (request.getAttribute("successMessage") != null) { %>
                        <div class="alert alert-success"><%= request.getAttribute("successMessage") %></div>
                        <% } else if (request.getAttribute("errorMessage") != null) { %>
                        <div class="alert alert-danger"><%= request.getAttribute("errorMessage") %></div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <!-- Script -->
        <script>
            window.addEventListener("DOMContentLoaded", function () {
                const hasMessage = <%= (request.getAttribute("successMessage") != null || request.getAttribute("errorMessage") != null) %>;
                if (hasMessage) {
                    const modal = new bootstrap.Modal(document.getElementById("feedbackModal"));
                    modal.show();
                }
            });

            function removeItem(productId) {
                document.getElementById("removeProductDetailID").value = productId;
                const selectedWarehouse = document.querySelector("select[name='toWarehouseID']").value;
                document.getElementById("removeToWarehouseID").value = selectedWarehouse;
                document.getElementById("removeForm").submit();
            }
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");

            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            });

            // Đóng dropdown nếu click ra ngoài
            document.addEventListener("click", function (e) {
                if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                    menu.style.display = "none";
                }
            });
        </script>
        

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
