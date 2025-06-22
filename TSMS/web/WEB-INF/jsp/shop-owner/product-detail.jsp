<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.ProductDetailDTO, util.Validate" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Chi tiết hàng hóa</title>
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
            text-decoration: none;
            display: inline-block;
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

        .btn-secondary {
            background-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
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

        .alert {
            padding: 12px 16px;
            margin-bottom: 20px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
    <div class="main-container">
        <!-- Success Message -->
        <% 
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            session.removeAttribute("successMessage");
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> <%= successMessage %>
            </div>
        <% } %>

        <!-- Error Message -->
        <% 
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> <%= errorMessage %>
            </div>
        <% } %>

        <main class="main-content">
            <div class="page-header">
                <h1>Chi tiết hàng hóa</h1>
                <a href="so-products?page=1" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <% ProductDetailDTO product = (ProductDetailDTO) request.getAttribute("product"); %>
            <% if (product != null) { %>
            
            <div class="form-container">
                <form action="so-products" method="post" class="product-form">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="productDetailId" value="<%= product.getProductDetailID() %>">

                    <!-- Read-only Fields -->
                    <div class="form-group">
                        <label>Mã sản phẩm:</label>
                        <input type="text" value="<%= product.getProductDetailID() %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Tên sản phẩm:</label>
                        <input type="text" value="<%= product.getProductName() %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Tên đầy đủ:</label>
                        <input type="text" value="<%= product.getFullName() %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Mã hàng:</label>
                        <input type="text" value="<%= product.getProductCode() %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Thương hiệu:</label>
                        <input type="text" value="<%= request.getAttribute("brandName") %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Danh mục:</label>
                        <input type="text" value="<%= request.getAttribute("categoryName") %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Nhà cung cấp:</label>
                        <input type="text" value="<%= request.getAttribute("supplierName") %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>Thời gian bảo hành:</label>
                        <input type="text" value="<%= product.getWarrantyPeriod() != null ? product.getWarrantyPeriod() : "Không có" %>" readonly>
                    </div>
                    
                    <div class="form-group">
                        <label>VAT (%):</label>
                        <input type="text" value="<%= product.getVat() %>%" readonly>
                    </div>

                    <!-- Editable Fields -->
                    <div class="form-group">
                        <label>Mô tả:</label>
                        <textarea name="description" rows="4" required><%
                            String inputDescription = (String) request.getAttribute("inputDescription");
                            if (inputDescription != null) {
                                out.print(inputDescription);
                            } else {
                                out.print(product.getDescription());
                            }
                        %></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>Giá vốn (VNĐ):</label>
                        <input type="text" name="costPrice" value="<%
                            String inputCostPrice = (String) request.getAttribute("inputCostPrice");
                            if (inputCostPrice != null) {
                                out.print(inputCostPrice);
                            } else {
                                out.print(product.getCostPrice());
                            }
                        %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Giá bán (VNĐ):</label>
                        <input type="text" name="retailPrice" value="<%
                            String inputRetailPrice = (String) request.getAttribute("inputRetailPrice");
                            if (inputRetailPrice != null) {
                                out.print(inputRetailPrice);
                            } else {
                                out.print(product.getRetailPrice());
                            }
                        %>" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Trạng thái:</label>
                        <select name="isActive" required>
                            <%
                                String inputIsActive = (String) request.getAttribute("inputIsActive");
                                boolean selectedActive;
                                if (inputIsActive != null) {
                                    selectedActive = "1".equals(inputIsActive);
                                } else {
                                    selectedActive = product.isIsActive();
                                }
                            %>
                            <option value="1" <%= selectedActive ? "selected" : "" %>>Đang bán</option>
                            <option value="0" <%= !selectedActive ? "selected" : "" %>>Ngừng bán</option>
                        </select>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Cập nhật
                        </button>
                        <a href="so-products?page=1" class="btn btn-danger">
                            <i class="fas fa-times"></i> Hủy
                        </a>
                    </div>
                </form>
            </div>
            
            <% } else { %>
                <div style="text-align: center; padding: 50px;">
                    <h3>Không tìm thấy thông tin sản phẩm!</h3>
                    <a href="so-products?page=1" class="btn btn-secondary">Quay lại danh sách</a>
                </div>
            <% } %>
        </main>
    </div>
</body>
</html>
