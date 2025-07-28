<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Hàng hóa</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/hanghoa.css">
</head>
<body>

<div class="sidebar">
    <h5>Loại hàng</h5>
    <div>
        <input type="checkbox" id="hanghoa"> Hàng hóa<br>
        <input type="checkbox" id="dichvu"> Dịch vụ<br>
        <input type="checkbox" id="combo"> Combo - Đóng gói
    </div>

    <h5 class="mt-4">Nhóm hàng</h5>
    <input type="text" class="form-control mb-2" placeholder="Tìm kiếm nhóm hàng">
    <ul class="list-group">
        <li class="list-group-item">Tất cả</li>
        <li class="list-group-item">Chăm sóc da</li>
        <li class="list-group-item">Dụng cụ làm đẹp</li>
        <li class="list-group-item">Trang điểm</li>
        <li class="list-group-item">Nước hoa</li>
    </ul>
</div>

<div class="content">
    <h3>Hàng hóa</h3>

    <div class="search-bar d-flex">
        <input class="form-control w-50" type="text" placeholder="🔍 Theo mã, tên hàng">
        <div class="ml-auto">
            <button class="btn btn-success">➕</button>
            <button class="btn btn-success">⏏️</button>
            <button class="btn btn-success">📄</button>
            <button class="btn btn-success">☰</button>
        </div>
    </div>

    <div class="table-wrapper">
        <table class="table table-bordered table-hover">
            <thead>
            <tr>
                <th></th>
                <th></th>
                <th>Mã hàng</th>
                <th>Tên hàng</th>
                <th>Giá bán</th>
                <th>Giá vốn</th>
                <th>Tồn kho</th>
                <th>Khách đặt</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td><input type="checkbox"></td>
                <td>☆</td>
                <td>SP000025</td>
                <td><img src="https://via.placeholder.com/40" class="product-img"> Kem nở ngực Mỹ No.1</td>
                <td>1,000,000</td>
                <td>950,000</td>
                <td>0</td>
                <td>0</td>
            </tr>
            <tr>
                <td><input type="checkbox"></td>
                <td>☆</td>
                <td>SP000024</td>
                <td><img src="https://via.placeholder.com/40" class="product-img"> Kem Touch Me</td>
                <td>550,000</td>
                <td>522,500</td>
                <td>0</td>
                <td>0</td>
            </tr>
            <!-- Có thể lặp dữ liệu bằng JSTL/Java ở đây -->
            </tbody>
        </table>
    </div>

    <nav>
        <ul class="pagination">
            <li class="page-item disabled"><a class="page-link" href="#">«</a></li>
            <li class="page-item active"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">»</a></li>
        </ul>
        <span>Hiển thị 1 - 10 / Tổng số 25 hàng hóa</span>
    </nav>

</div>

</body>
</html>
