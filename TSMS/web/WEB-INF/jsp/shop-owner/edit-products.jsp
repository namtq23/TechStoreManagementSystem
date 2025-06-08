<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.ProductDTO" %>
<%@ page import="util.Validate" %>
<%
    ProductDTO product = (ProductDTO) request.getAttribute("product");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Google Fonts for modern look -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet">
    <style>
        body {
            background: #e3f0ff;
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            min-height: 100vh;
        }
        .container {
            max-width: 760px;
            margin: 40px auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 6px 30px rgba(50,90,193,.09), 0 1.5px 4px rgba(0,0,0,.07);
            padding: 36px 32px 32px 32px;
            animation: fadeIn 1.2s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px);}
            to { opacity: 1; transform: translateY(0);}
        }
        h2 {
            text-align: center;
            margin-bottom: 32px;
            color: #1667c1;
            letter-spacing: 1px;
            font-size: 2rem;
            font-weight: 700;
        }
        form {
            display: grid;
            grid-template-columns: 1fr 40px 1fr;
            gap: 18px 40px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 0;
        }
        .form-spacer {
            /* Empty column for spacing */
        }
        .form-group-full {
            grid-column: 1 / span 3;
        }
        form label {
            font-weight: 500;
            color: #1667c1;
            margin-bottom: 7px;
            margin-top: 8px;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 2px;
            border: 1.2px solid #dce8f7;
            border-radius: 8px;
            font-size: 1rem;
            transition: border 0.2s;
            font-family: inherit;
            background: #f5faff;
            resize: none;
            color: #244d66;
            box-sizing: border-box;
        }
        input[type="text"]:focus, textarea:focus, select:focus {
            border-color: #1667c1;
            outline: none;
            background: #e6f0fa;
        }
        textarea {
            min-height: 65px;
            max-height: 130px;
        }
        input[readonly], textarea[readonly] {
            background-color: #f1f6fb;
            color: #888;
            cursor: not-allowed;
        }
        select[disabled] {
            background-color: #f1f6fb;
            color: #888;
            cursor: not-allowed;
        }
        .btn-row {
            grid-column: 1 / span 3;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 28px;
        }
        button[type="submit"] {
            background: linear-gradient(90deg, #1667c1 0%, #49b6ff 100%);
            color: #fff;
            border: none;
            padding: 12px 38px;
            border-radius: 7px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.1s;
            box-shadow: 0 2px 8px rgba(22,103,193,0.09);
        }
        button[type="submit"]:hover {
            background: linear-gradient(90deg, #155199 0%, #3ca2e0 100%);
            transform: translateY(-2px) scale(1.03);
        }
        .back-link {
            color: #1667c1;
            background: none;
            border: none;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            transition: color 0.18s;
            cursor: pointer;
        }
        .back-link:hover {
            text-decoration: underline;
            color: #0b417a;
        }
        @media (max-width: 900px) {
            .container {
                max-width: 98vw;
                padding: 12px 2vw 24px 2vw;
            }
        }
        @media (max-width: 700px) {
            form {
                grid-template-columns: 1fr !important;
                gap: 0 !important;
            }
            .form-group, .form-group-full {
                width: 100%;
                grid-column: 1 / span 1 !important;
            }
            .btn-row {
                flex-direction: column;
                align-items: stretch;
                gap: 14px;
            }
            .form-spacer {
                display: none;
            }
        }
    </style>
    <script>
        // Format number as currency when typing
        function formatCurrencyInput(input) {
            let value = input.value.replace(/,/g, '').replace(/[^0-9.]/g, '');
            if (value) {
                let parts = value.split('.');
                parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                value = parts.join('.');
            }
            input.value = value;
        }
        function validateForm() {
            var costPrice = parseFloat(document.forms["productForm"]["costPrice"].value.replace(/,/g, ''));
            var retailPrice = parseFloat(document.forms["productForm"]["retailPrice"].value.replace(/,/g, ''));
            if (costPrice > retailPrice) {
                alert("Giá vốn phải nhỏ hơn hoặc bằng giá bán!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <jsp:include page="../common/header-so.jsp" />

    <div class="container">
        <h2>Chi tiết sản phẩm</h2>
        <form name="productForm" action="so-products" method="post" onsubmit="return validateForm();">
            <input type="hidden" name="action" value="update">
            <!-- Left column -->
            <div class="form-group">
                <label for="productId">Mã sản phẩm:</label>
                <input id="productId" type="text" name="productId" value="<%= product.getProductId() %>" readonly>
            </div>
            <div class="form-spacer"></div>
            <!-- Right column -->
            <div class="form-group">
                <label for="productDetailId">Mã chi tiết:</label>
                <input id="productDetailId" type="text" name="productDetailId" value="<%= product.getProductDetailId() %>" readonly>
            </div>

            <div class="form-group">
                <label for="productName">Tên sản phẩm:</label>
                <input id="productName" type="text" name="productName" value="<%= product.getProductName() %>" required>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label for="brand">Thương hiệu:</label>
                <input id="brand" type="text" name="brand" value="<%= product.getBrand() %>" readonly>
            </div>

            <div class="form-group">
                <label for="category">Danh mục:</label>
                <input id="category" type="text" name="category" value="<%= product.getCategory() %>" readonly>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label for="supplier">Nhà cung cấp:</label>
                <input id="supplier" type="text" name="supplier" value="<%= product.getSupplier() %>" readonly>
            </div>

            <div class="form-group">
                <label for="createdAt">Ngày tạo:</label>
                <input id="createdAt" type="text" name="createdAt" value="<%= Validate.formatDateTime(product.getCreatedAt()) %>" readonly>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label for="isActive">Trạng thái:</label>
                <select id="isActive" name="isActive">
                    <option value="1" <%= "1".equals(String.valueOf(product.getIsActive())) ? "selected" : "" %>>Đang kinh doanh</option>
                    <option value="0" <%= "0".equals(String.valueOf(product.getIsActive())) ? "selected" : "" %>>Không kinh doanh</option>
                </select>
            </div>

            <div class="form-group-full">
                <label for="description">Mô tả:</label>
                <textarea id="description" name="description" readonly><%= product.getDescription() %></textarea>
            </div>

            <div class="form-group">
                <label for="serialNum">Số Serial:</label>
                <input id="serialNum" type="text" name="serialNum" value="<%= product.getSerialNum() %>" readonly>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label for="warrantyPeriod">Thời hạn bảo hành:</label>
                <input id="warrantyPeriod" type="text" name="warrantyPeriod" value="<%= product.getWarrantyPeriod() %>" readonly>
            </div>

            <div class="form-group">
                <label for="costPrice">Giá vốn:</label>
                <input id="costPrice" type="text" name="costPrice" value="<%= product.getCostPrice() %>" required oninput="formatCurrencyInput(this)">
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label for="retailPrice">Giá bán:</label>
                <input id="retailPrice" type="text" name="retailPrice" value="<%= product.getRetailPrice() %>" required oninput="formatCurrencyInput(this)">
            </div>

            <div class="btn-row form-group-full">
                <button type="submit">Cập nhật</button>
                <a href="so-products" class="back-link">Quay lại</a>
            </div>
        </form>
    </div>
</body>
</html>