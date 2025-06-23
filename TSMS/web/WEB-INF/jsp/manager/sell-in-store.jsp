<%-- 
Document   : sell-in-store
Created on : Jun 4, 2025, 2:39:25 PM
Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.ProductDTO" %>
<%@ page import="util.Validate" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Hệ thống Bán hàng</title>
        <link rel="stylesheet" href="css/bm-cart.css">
        <link rel="stylesheet" href="css/header.css">
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

                    <div class="nav-item dropdown">
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

                    <a href="bm-cart" class="nav-item active">
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

        <!-- Main Content -->
        <div class="main-container">
            <!-- Left Panel - Invoice -->
            <div class="invoice-panel">
                <div class="panel-header">
                    <h2>Hóa đơn bán hàng</h2>
                    <div class="invoice-actions">
                        <a href="bm-cart" style="text-decoration: none">
                            <button class="btn-secondary">
                                <i class="fas fa-plus"></i>
                                Tạo mới
                            </button>
                        </a>
                    </div>
                </div>

                <div class="customer-section">
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm khách hàng (F4)" class="customer-input">
                    </div>
                    <button class="btn-secondary" id="addCustomerBtn">
                        <i class="fas fa-user-plus"></i>
                        Thêm KH
                    </button>
                </div>

                <!-- Form tạo khách hàng -->
                <div  class="create-customer hidden" id="createCustomerForm">
                    <h2>Tạo khách hàng</h2>


                    <div class="customer-info">
                        <div class="form-row">
                            <label>Họ tên:</label>
                            <input type="text" name="fullName" required="">
                        </div>
                        <div class="form-row">
                            <label>Số điện thoại:</label>
                            <input type="text" name="phone" required="">
                        </div>
                        <div class="form-row">
                            <label>Giới tính:</label>
                            <select name="gender">
                                <option value="1">Nam</option>
                                <option value="0">Nữ</option>
                            </select>
                        </div>
                        <div class="form-row">
                            <label>Địa chỉ:</label>
                            <input type="text" name="address">
                        </div>
                        <div class="form-row">
                            <label>Email:</label>
                            <input type="email" name="email">
                        </div>
                        <div class="form-row">
                            <label>Ngày sinh:</label>
                            <input type="date" name="dob">
                        </div>
                    </div>

                    <!-- Nút thanh toán và đóng -->
                    <div class="form-actions">
                        <button type="button" id="createCustomerSubmit" class="btn-primary">
                            <i class="fas fa-credit-card"></i> Thêm
                        </button>
                        <button type="button" id="closeCustomerSubmit" class="btn-secondary">
                            <i class="fas fa-times"></i> Đóng
                        </button>
                    </div>

                </div>

                <div class="customer-search-results" style="display: none;"></div>



                <div class="invoice-table">
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>ID SP</th>
                                <th>Mã SP</th>
                                <th>Tên sản phẩm</th>
                                <th>SL</th>
                                <th>Đơn giá</th>
                                <th>Thành tiền</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                </div>

                <div class="invoice-summary">
                    <div class="summary-row">
                        <span>Tổng số lượng:</span>
                        <span class="summary-value"></span>
                    </div>
                    <div class="summary-row">
                        <span>Tạm tính:</span>
                        <span class="summary-value"></span>
                    </div>
                    <div class="summary-row total-row">
                        <span>Tổng cộng (10% VAT):</span>
                        <span class="summary-value"></span>
                    </div>
                </div>

                <div class="payment-section">
                    <button class="btn-primary complete-btn">
                        <i class="fas fa-check"></i>
                        Tiến hành thanh toán
                    </button>
                </div>
            </div>

            <!-- Right Panel - Products -->
            <div class="product-panel">
                <div class="panel-header">
                    <h2>Danh sách sản phẩm</h2>
<!--                    <div class="product-filters">
                        <select class="filter-select">
                            <option>Tất cả danh mục</option>
                            <option>Điện thoại</option>
                            <option>Laptop</option>
                            <option>Phụ kiện</option>
                        </select>
                    </div>-->
                </div>

                <div class="search-section">
                    <div class="search-container">
                        <i class="fas fa-search"></i>
                        <input type="text" placeholder="Tìm kiếm sản phẩm (F3)" class="search-input">
                    </div>
                </div>


                <div class="product-grid">
                    <% List<ProductDTO> products = (List<ProductDTO>) request.getAttribute("products");
                    for (ProductDTO product : products) { %>
                    <div class="product-card" data-product-id="<%= product.getProductDetailId()%>">
                        <div class="product-content" style="display: flex; justify-content: flex-start">
                            <div class="product-image">
                                <img src="<%= product.getImgUrl()%>" alt="<%= product.getProductName()%>">
                            </div>
                            <div class="product-info">
                                <h3><%= product.getDescription() %></h3>
                                <%
                                    String retailPriceStr = product.getRetailPrice();
                                    Double discountPercent = product.getDiscountPercent();
                                    double retailPrice = 0;
                                    double discountedPrice = 0;
    

                                        if (retailPriceStr != null) {
                                            retailPrice = Double.parseDouble(retailPriceStr.trim());
            
                                            if (discountPercent != null && discountPercent > 0) {
                                                discountedPrice = retailPrice * (1 - discountPercent / 100.0);
                                %>
                                <div class="discount">Giảm <%= String.format("%.1f", discountPercent) %>%</div>
                                <div class="product-price original-price"><%= Validate.formatCostPriceToVND((int)retailPrice) %></div>
                                <div class="product-price discounted-price"><%= Validate.formatCostPriceToVND((int)discountedPrice) %></div>
                                <%
                                            } else {
                                %>
                                <div class="product-price"><%= Validate.formatCostPriceToVND((int)retailPrice) %></div>
                                <%
                                            }
                                        } else {
                                %>
                                <div class="product-price">Giá không khả dụng</div>
                                <%
                                        }
                                %>

                                <div class="product-stock">Còn: <%= product.getQuantity() %></div>
                            </div>
                        </div>

                        <button class="add-to-cart">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                    <%}%>
                </div>
            </div>
        </div>

        <!-- Overlay làm mờ nền -->
        <div id="overlay" class="overlay hidden"></div>

        <!-- Form chi tiết đơn hàng -->
        <div class="order-detail hidden">
            <h2>Chi tiết đơn hàng</h2>

            <form id="checkoutForm" action="bm-cart" method="post">
                <!-- Form nhập thông tin khách hàng -->
                <div class="customer-info-form" id="mainCustomerForm">
                    <div class="form-row">
                        <label>Họ tên:</label>
                        <input type="text" name="fullName" readonly="" value="Khách lẻ">
                    </div>
                    <div class="form-row">
                        <label>Số điện thoại:</label>
                        <input type="text" name="phone" readonly="" value="N/A">
                    </div>
                    <div class="form-row">
                        <label>Giới tính:</label>
                        <select name="gender">
                            <option value="1">Nam</option>
                            <option value="0">Nữ</option>
                        </select>
                    </div>
                    <div class="form-row">
                        <label>Địa chỉ:</label>
                        <input type="text" name="address" readonly="" value="N/A">
                    </div>
                    <div class="form-row">
                        <label>Email:</label>
                        <input type="email" name="email" readonly="" value="N/A">
                    </div>
                    <div class="form-row">
                        <label>Ngày sinh:</label>
                        <input type="date" name="dob" readonly="">
                    </div>
                </div>

                <hr>

                <!-- Tổng tiền và giảm giá -->
                <div class="payment-summary">
                    <div class="form-row">
                        <label>Tổng tiền hàng:</label>
                        <input type="text" name="totalAmount" id="totalAmount" value="0đ" readonly="">
                    </div>
                    <div class="form-row">
                        <label>Phương thức thanh toán:</label>
                        <select name="paymentMethod">
                            <option value="Tiền mặt">Tiền mặt</option>
                            <option value="Chuyển khoản">Chuyển khoản</option>
                        </select>
                    </div>
                    <div class="form-row discount-wrapper">
                        <label>Giảm giá (%):</label>
                        <div class="input-percent">
                            <input type="text" id="discountPercent" placeholder="Phần trăm giảm giá...">
                        </div>
                    </div>
                    <div class="form-row vat-wrapper">
                        <label>VAT (10%):</label>
                        <div class="input-percent">
                            <input type="text" id="vat" placeholder="Phần trăm giảm giá..." value="" readonly="">
                        </div>
                    </div>
                    <div class="form-row">
                        <label>Khách cần trả:</label>
                        <input type="text" name="amountDue" id="amountDue" value="0đ" readonly="">
                    </div>
                </div>

                <hr>

                <!-- Tiền khách đưa và tiền thừa -->
                <div class="payment-input">
                    <div class="form-row">
                        <label>Tiền khách đưa:</label>
                        <input type="text" name="cashGiven" id="cashGiven" placeholder="Nhập số tiền">
                    </div>
                    <div class="form-row">
                        <label>Tiền thừa trả lại:</label>
                        <input type="text" name="changeDue" id="changeDue" value="0đ" readonly="">
                    </div>
                </div>

                <!-- Nút thanh toán và đóng -->
                <div class="form-actions">
                    <button type="submit" id="processPayment" class="btn-primary">
                        <i class="fas fa-credit-card"></i> Thanh toán
                    </button>
                    <button type="button" id="closeOrderDetail" class="btn-secondary">
                        <i class="fas fa-times"></i> Đóng
                    </button>
                </div>

                <input type="hidden" name="cartData" id="cartDataInput">
            </form>

        </div>


        <script>
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

            document.querySelector('.complete-btn').addEventListener('click', () => {
                const tbody = document.querySelector('.invoice-table tbody');
                if (tbody.children.length > 0) {
                    document.querySelector('.order-detail').classList.remove('hidden');
                    document.querySelector('#overlay').classList.remove('hidden');
                } else {

                }
            });

            document.querySelector('#closeOrderDetail').addEventListener('click', () => {
                document.querySelector('.order-detail').classList.add('hidden');
                document.querySelector('#overlay').classList.add('hidden');
            });


            document.querySelector(".overlay").addEventListener("click", () => {
                document.querySelector(".order-detail").classList.add("hidden");
                document.querySelector(".overlay").classList.add("hidden");
            });
            const cashGivenInput = document.getElementById("cashGiven");

            cashGivenInput.addEventListener("input", function () {
                let rawValue = this.value.replace(/[^\d]/g, '');

                if (rawValue === '') {
                    this.value = '';
                    return;
                }

                let number = parseInt(rawValue, 10);
                this.value = number.toLocaleString('vi-VN') + ' đ';
            });

            function getCashGivenValue() {
                let value = document.getElementById('cashGiven').value;
                return parseInt(value.replace(/[^\d]/g, ''), 10) || 0;
            }


            const discountInput = document.getElementById('discountPercent');

            discountInput.addEventListener('input', function () {
                let rawValue = this.value.replace(/[^\d]/g, '');

                if (rawValue === '') {
                    this.value = '';
                    return;
                }

                if (isNaN(rawValue) || rawValue < 0) {
                    discountInput.value = 0;
                } else if (rawValue > 100) {
                    discountInput.value = 100;
                }
            });
        </script>
        <script src="js/bm-cart.js"></script>
    </body>
</html>