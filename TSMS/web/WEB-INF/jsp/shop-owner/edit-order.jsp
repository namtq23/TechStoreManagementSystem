<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.OrdersDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    OrdersDTO order = (OrdersDTO) request.getAttribute("order");
    List<OrdersDTO> orderDetails = (List<OrdersDTO>) request.getAttribute("orderDetails");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
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
        .order-form {
            display: grid;
            grid-template-columns: 1fr 40px 1fr;
            gap: 18px 40px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 0;
        }
        .form-spacer { }
        .form-group-full {
            grid-column: 1 / span 3;
        }
        label {
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
        textarea {
            min-height: 65px;
            max-height: 130px;
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
        .products-table {
            width: 100%;
            border-collapse: collapse;
            margin: 18px 0 0 0;
            font-size: 1rem;
        }
        .products-table th, .products-table td {
            border: 1px solid #e0eaf3;
            padding: 8px 12px;
            text-align: left;
        }
        .products-table th {
            background: #f5f9ff;
            color: #1667c1;
        }
        .products-table td {
            background: #f7fbff;
        }
        @media (max-width: 900px) {
            .container {
                max-width: 98vw;
                padding: 12px 2vw 24px 2vw;
            }
        }
        @media (max-width: 700px) {
            .order-form {
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
</head>
<body>
    <jsp:include page="../common/header-so.jsp" />

    <div class="container">
        <h2>Chi tiết đơn hàng</h2>
        <form class="order-form" action="so-orders" method="post">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="OrderID" value="<%= order.getOrderID() %>"/>

            <div class="form-group">
                <label>Mã đơn hàng:</label>
                <input type="text" readonly value="<%= order.getOrderID() %>"/>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label>Chi nhánh:</label>
                <input type="text" readonly value="<%= order.getBranchName() %>"/>
            </div>

            <div class="form-group">
                <label>Khách hàng:</label>
                <input type="text" readonly value="<%= order.getCustomerName() %>"/>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label>Người tạo:</label>
                <input type="text" readonly value="<%= order.getCreatedByName() %>"/>
            </div>

            <div class="form-group">
                <label>Thời gian tạo:</label>
                <input type="text" readonly value="<%= order.getCreatedAt() != null ? sdf.format(order.getCreatedAt()) : "" %>"/>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label>Trạng thái đơn:</label>
                <select name="OrderStatus" required>
                    <option value="Chờ xác nhận" <%= "Chờ xác nhận".equals(order.getOrderStatus()) ? "selected" : "" %>>Chờ xác nhận</option>
                    <option value="Đã xác nhận" <%= "Đã xác nhận".equals(order.getOrderStatus()) ? "selected" : "" %>>Đã xác nhận</option>
                    <option value="Đã giao hàng" <%= "Đã giao hàng".equals(order.getOrderStatus()) ? "selected" : "" %>>Đã giao hàng</option>
                    <option value="Đã huỷ" <%= "Đã huỷ".equals(order.getOrderStatus()) ? "selected" : "" %>>Đã huỷ</option>
                </select>
            </div>

            <div class="form-group">
                <label>Tổng tiền:</label>
                <input type="text" readonly value="<%= order.getGrandTotal() %>"/>
            </div>
            <div class="form-spacer"></div>
            <div class="form-group">
                <label>Phương thức thanh toán:</label>
                <input type="text" readonly value="<%= order.getPaymentMethod() %>"/>
            </div>

            <div class="form-group-full">
                <label>Ghi chú:</label>
                <textarea name="Notes"><%= order.getNotes() != null ? order.getNotes() : "" %></textarea>
            </div>

            <div class="form-group-full">
                <label>Chi tiết sản phẩm</label>
                <table class="products-table">
                    <thead>
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>Số lượng</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if (orderDetails != null && !orderDetails.isEmpty()) {
                            for (OrdersDTO detail : orderDetails) {
                        %>
                            <tr>
                                <td><%= detail.getProductName() %></td>
                                <td><%= detail.getQuantity() %></td>
                            </tr>
                        <%
                            }
                        }
                        %>
                    </tbody>
                </table>
            </div>

            <div class="btn-row form-group-full">
                <button type="submit">Cập nhật</button>
                <a href="so-orders" class="back-link">Quay lại</a>
            </div>
        </form>
    </div>
</body>
</html>