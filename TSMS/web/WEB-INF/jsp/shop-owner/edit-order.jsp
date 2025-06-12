<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.OrdersDTO, java.text.SimpleDateFormat, java.text.NumberFormat, java.util.Locale" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Chi tiết đơn hàng</title>
        <link rel="stylesheet" href="css/so-products.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                margin: 0;
                background: #f5f7fa;
            }

            .main-container {
                padding: 30px;
                max-width: 900px;
                margin: auto;
            }

            .page-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
            }

            .page-header h1 {
                font-size: 26px;
                color: #333;
            }

            .btn {
                padding: 10px 18px;
                border: none;
                border-radius: 6px;
                color: white;
                font-size: 14px;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .btn-success {
                background-color: #2196F3;
            }

            .btn-success:hover {
                background-color: #1976D2;
            }

            .btn-danger {
                background-color: #f44336;
            }

            .btn-danger:hover {
                background-color: #d32f2f;
            }

            .form-container {
                background: white;
                padding: 25px 30px;
                border-radius: 12px;
                box-shadow: 0 6px 18px rgba(0, 0, 0, 0.06);
            }

            .form-group {
                display: flex;
                flex-direction: column;
                margin-bottom: 18px;
            }

            .form-group label {
                font-weight: 600;
                margin-bottom: 6px;
                color: #555;
            }

            .form-group input,
            .form-group textarea,
            .form-group select {
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 15px;
                background: #fafafa;
            }

            .form-group input[readonly] {
                background-color: #eee;
                color: #666;
                cursor: not-allowed;
            }

            .form-actions {
                display: flex;
                gap: 12px;
                justify-content: flex-end;
                margin-top: 30px;
            }

            textarea {
                resize: vertical;
            }

            .error-message {
                color: #f44336;
                text-align: center;
                margin-bottom: 20px;
                font-weight: 500;
            }

            .success-message {
                color: #4CAF50;
                text-align: center;
                margin-bottom: 20px;
                font-weight: 500;
            }

            @media (max-width: 768px) {
                .main-container {
                    padding: 20px;
                }

                .form-actions {
                    flex-direction: column;
                    align-items: stretch;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="../common/header-so.jsp" />

        <div class="main-container">
            <main class="main-content">
                <div class="page-header">
                    <h1>Chi tiết đơn hàng</h1>
                    <a href="so-orders" class="btn btn-success">← Quay lại</a>
                </div>

                <div class="form-container">

                    <c:choose>
                        <c:when test="${order != null}">
                            <form action="so-orders" method="post" class="order-form">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="orderID" value="${order.orderID}">

                                <!-- Read-only Fields -->
                                <div class="form-group">
                                    <label>Mã đơn hàng:</label>
                                    <input type="text" value="${order.orderID}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Số lượng:</label>
                                    <input type="text" value="${order.quantity == 0 ? 'N/A' : order.quantity}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Tên sản phẩm:</label>
                                    <input type="text" value="${order.productName != null ? order.productName : 'N/A'}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Chi nhánh:</label>
                                    <input type="text" value="${order.branchName != null ? order.branchName : 'N/A'}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Khách hàng:</label>
                                    <input type="text" value="${order.customerName != null ? order.customerName : 'N/A'}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Nhân viên tạo:</label>
                                    <input type="text" value="${order.createdByName != null ? order.createdByName : 'N/A'}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Thời gian tạo:</label>
                                    <input type="text" value="${order.createdAt != null ? order.createdAt.toString() : 'N/A'}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Tổng tiền:</label>
                                    <input type="text" value="${order.grandTotal}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Khách trả:</label>
                                    <input type="text" value="${order.customerPay}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Tiền thừa:</label>
                                    <input type="text" value="${order.change}" readonly>
                                </div>
                                <div class="form-group">
                                    <label>Phương thức thanh toán:</label>
                                    <input type="text" value="${order.paymentMethod != null ? order.paymentMethod : 'N/A'}" readonly>
                                </div>

                                <!-- Editable Fields -->
                                <div class="form-group">
                                    <label>Trạng thái đơn:</label>
                                    <select name="orderStatus" required>
                                        <option value="Pending" ${order.orderStatus == 'Pending' ? 'selected' : ''}>Pending</option>
                                        <option value="Processing" ${order.orderStatus == 'Processing' ? 'selected' : ''}>Processing</option>
                                        <option value="Completed" ${order.orderStatus == 'Completed' ? 'selected' : ''}>Completed</option>
                                        <option value="Cancelled" ${order.orderStatus == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Ghi chú:</label>
                                    <textarea name="notes" rows="4">${order.notes != null ? order.notes : ''}</textarea>
                                </div>

                                <!-- Form Actions -->
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-success">Cập nhật</button>
                                    <a href="so-orders" class="btn btn-danger">Quay lại</a>
                                </div>
                            </form>
                        </c:when>
                    </c:choose>
                </div>
            </main>
        </div>
    </body>
</html>