<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản Lý Kho Tổng</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/quanlykhotong.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css">
    </head>
    <body>
        <!-- Navbar top -->
        <div class="navbar">
            <div class="logo">
                <img src="https://posapp.vn/wp-content/uploads/2022/06/logo-kiotviet.png" alt="KiotViet">
            </div>
            <ul class="nav-menu">
                <li class="dropdown">
                    <a href="#">Hàng hóa</a>
                    <div class="mega-menu">
                        <div class="mega-column">
                            <h4>Hàng hóa</h4>
                            <a href="#">Danh sách hàng hóa</a>
                            <a href="#">Kiểm kho</a>
                            <a href="#">Xuất hủy</a>
                        </div>
                        <div class="mega-column">
                            <h4>Kho hàng</h4>
                            
                        </div>
                        <div class="mega-column">
                            <h4>Nhập hàng</h4>
                            <a href="#">Nhà cung cấp</a>
                            <a href="#">Nhập hàng</a>
                            <a href="#">Trả hàng nhập</a>
                        </div>
                    </div>
                </li>
                <li><a href="#">Đơn hàng</a></li>
                <li><a href="#">Khách hàng</a></li>
                <li><a href="#">Nhân viên</a></li>
            </ul>
        </div>

        <!-- Nội dung chính -->
        <div class="container">
            <div class="sidebar">
                <h3>Quản Lý Kho Tổng</h3>
                <div class="filter">
                    <label>Ngày tạo</label>
                    <div>
                        <input type="radio" name="date" checked> Tháng này<br>
                        <input type="radio" name="date"> Tùy chỉnh
                    </div>
                    <label>Trạng thái</label>
                    <div>
                        <input type="checkbox" checked> Phiếu tạm<br>
                        <input type="checkbox" checked> Đã cân bằng kho<br>
                        <input type="checkbox"> Đã hủy
                    </div>
                    <label>Người tạo</label>
                    <select>
                        <option value="">Chọn người tạo</option>
                        <option value="nv1">Nguyễn Văn A</option>
                        <option value="nv2">Trần Thị B</option>
                        <option value="nv3">Lê Văn C</option>
                    </select>
                </div>
            </div>

            <div class="main-content">
                <div class="search-bar">
                    <input type="text" placeholder="Tìm mã phiếu kiểm">
                    <button><i class="ri-equalizer-line"></i></button>
                </div>
                <div class="table-header">
                    <button class="btn-blue"><i class="ri-add-line"></i> Kiểm kho</button>
                    <button class="btn-white"><i class="ri-download-line"></i> Xuất file</button>
                    <button class="btn-icon"><i class="ri-equalizer-line"></i></button>
                    <button class="btn-icon"><i class="ri-settings-3-line"></i></button>
                </div>
                <table class="table">
                    <thead>
                        <tr>
                            <th></th>
                            <th>Mã kiểm kho</th>
                            <th>Thời gian</th>
                            <th>Người tạo</th>
                            <th>Người cân bằng</th>
                            <th>Ngày cân bằng</th>
                            <th>SL thực tế</th>
                            <th>Tổng thực tế</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="no-result">
                            <td colspan="8">
                                <div class="empty-box">
                                    <img src="https://cdn-icons-png.flaticon.com/512/4076/4076549.png" width="64">
                                    <p><strong>Không tìm thấy kết quả</strong><br>Không tìm thấy giao dịch nào phù hợp trong tháng này.<br>
                                        Nhấn <a href="#">vào đây</a> để tiếp tục tìm kiếm.</p>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
