<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, model.*" %>
<html>
<head>
    <title>Thêm sản phẩm</title>
</head>
<body>
<h2>Thêm sản phẩm mới</h2>

<% String error = (String) request.getAttribute("error");
   if (error != null) { %>
    <p style="color: red;"><%= error %></p>
<% } %>

<form action="so-products" method="post">
    <input type="hidden" name="action" value="create">
    Tên sản phẩm: <input type="text" name="productName" required><br>
    Thương hiệu (ID): <input type="number" name="brandId" required><br>
    Danh mục (ID): <input type="number" name="categoryId" required><br>
    Nhà cung cấp (ID): <input type="number" name="supplierId" required><br>
    Giá vốn: <input type="number" step="0.01" name="costPrice" required><br>
    Giá bán: <input type="number" step="0.01" name="retailPrice" required><br>
    Mô tả: <input type="text" name="description"><br>
    Serial Number: <input type="text" name="serialNumber"><br>
    Thời gian bảo hành: <input type="text" name="warrantyPeriod"><br>
    Số lượng nhập kho: <input type="number" name="quantity" required><br>
    <button type="submit">Lưu</button>
</form>
</body>
</html>
