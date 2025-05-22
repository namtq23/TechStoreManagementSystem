<%-- 
    Document   : khachhang
    Created on : May 21, 2025, 4:20:38 PM
    Author     : Kawaii
--%>
    
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quản lý khách hàng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f3f4f6;
            margin: 0;
            padding: 0;
        }

        .main {
            display: flex;
            padding: 20px;
        }

        .sidebar {
            width: 250px;
            margin-right: 20px;
        }

        .filter-box {
            background: white;
            margin-bottom: 15px;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
        }

        .filter-box h4 {
            margin: 0 0 10px 0;
            font-size: 16px;
        }

        .content {
            flex: 1;
            background: white;
            padding: 20px;
            border-radius: 16px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .header h2 {
            margin: 0;
        }

        .actions button {
            margin-left: 10px;
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .actions button.green {
            background-color: #10b981;
            color: white;
        }

        .actions button.gray {
            background-color: #e5e7eb;
        }

        input[type="text"] {
            width: 300px;
            padding: 6px;
            margin-bottom: 20px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border: 1px solid #e5e7eb;
            text-align: left;
        }

        th {
            background-color: #f9fafb;
        }

        tr.highlight {
            background-color: #fff7ed;
        }
    </style>
</head>
<body>
<div class="main">
    <!-- Sidebar trái -->
    <div class="sidebar">
        <div class="filter-box">
            <h4>Nhóm khách hàng</h4>
            <p>Tất cả các nhóm</p>
        </div>
        <div class="filter-box">
            <h4>Ngày tạo</h4>
            <input type="radio" name="ngaytao" checked> Toàn thời gian<br>
            <input type="radio" name="ngaytao"> Lựa chọn khác
        </div>
        <div class="filter-box">
            <h4>Người tạo</h4>
            <select style="width: 100%; padding: 4px;">
                <option>Chọn người tạo</option>
            </select>
        </div>
        <div class="filter-box">
            <h4>Sinh nhật</h4>
            <input type="radio" name="sinhnhat" checked> Toàn thời gian<br>
            <input type="radio" name="sinhnhat"> Lựa chọn khác
        </div>
        <div class="filter-box">
            <h4>Ngày giao dịch cuối</h4>
            <input type="radio" name="giaodichcuoi" checked> Toàn thời gian<br>
            <input type="radio" name="giaodichcuoi"> Lựa chọn khác
        </div>
    </div>

    <!-- Nội dung chính bên phải -->
    <div class="content">
        <div class="header">
            <h2>Khách hàng</h2>
            <div class="actions">
                <button class="green">+ Khách hàng</button>
                <button class="gray">File</button>
                <button class="gray">Lọc</button>
            </div>
        </div>

        <input type="text" placeholder="Theo mã, tên, điện thoại" />

        <table>
            <thead>
            <tr>
                <th><input type="checkbox" /></th>
                <th>Mã khách hàng</th>
                <th>Tên khách hàng</th>
                <th>Điện thoại</th>
                <th>Nợ hiện tại</th>
                <th>Tổng bán</th>
                <th>Tổng bán trừ trả hàng</th>
            </tr>
            </thead>
            <tbody>
            <tr class="highlight">
                <td><input type="checkbox" /></td>
                <td>KH000005</td>
                <td>Chị Lý - Kim Mã</td>
                <td></td>
                <td>0</td>
                <td>14,839,420,000</td>
                <td>14,839,420,000</td>
            </tr>
            <tr>
                <td><input type="checkbox" /></td>
                <td>KH000004</td>
                <td>Mr Hoàng - Sài Gòn</td>
                <td></td>
                <td>0</td>
                <td>3,268,390,000</td>
                <td>3,268,390,000</td>
            </tr>
            <tr>
                <td><input type="checkbox" /></td>
                <td>KH000003</td>
                <td>Trần Cao Văn</td>
                <td></td>
                <td>0</td>
                <td>2,075,660,000</td>
                <td>2,075,660,000</td>
            </tr>
            <tr>
                <td><input type="checkbox" /></td>
                <td>KH000002</td>
                <td>Phạm Văn Bạch</td>
                <td></td>
                <td>0</td>
                <td>4,306,220,000</td>
                <td>4,306,220,000</td>
            </tr>
            <tr>
                <td><input type="checkbox" /></td>
                <td>KH000001</td>
                <td>Nguyễn Tuấn Minh</td>
                <td></td>
                <td>0</td>
                <td>3,485,250,000</td>
                <td>3,485,250,000</td>
            </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
