<%-- 
    Document   : hoadon
    Created on : May 26, 2025, 10:21:19 PM
    Author     : Kawaii
--%>



<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
 <html>



    <head>
        <title>Quản lý khách hàng</title>

    <link rel="stylesheet" type="text/css" href="css/khachhang.css" />
    
    
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>JSP Page</title><!--
-->
<!--   Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!--   Font Awesome 
--> 



<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<!--   Custom CSS -->
  <link rel="stylesheet" href="css/header.css">
</head><!--
--><body>



<!--   Top toolbar -->
  <div class=" top-toolbar d-flex justify-content-between align-items-center px-4 py-2 bg-dark text-white">
    <div class="toolbar-left">
      <strong>SWP391</strong>
    </div>
    <div class="toolbar-right">
      <button class="btn btn-sm btn-outline-light me-2">🇻🇳 Tiếng Việt</button>
      <button class="btn btn-sm btn-outline-light me-2">📧</button>
      <button class="btn btn-sm btn-outline-light me-2">⚙️</button>
      <button class="btn btn-sm btn-outline-light">👤</button>
    </div>
  </div>
<!--
   Navbar -->
  <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid px-4">
<!--       Logo -->
      <a class="navbar-brand fw-bold" href="#"><i class="fas fa-store"></i> Tên Shop</a>

<!--       Toggle button for mobile -->
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
        <span class="navbar-toggler-icon"></span>
      </button>
<!--
       Navbar links -->
      <div class="collapse navbar-collapse" id="mainNavbar">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link text-white" href="#">Tổng quan</a>
          </li>
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle text-white" href="#" id="hangHoaDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
              Hàng hóa
            </a>
            <ul class="dropdown-menu" aria-labelledby="hangHoaDropdown">
              <li><a class="dropdown-item" href="#">Tổng quan chung</a></li>
              <li><a class="dropdown-item" href="#">Hiệu suất bán hàng</a></li>
              <li><a class="dropdown-item" href="#">Hoạt động nhân viên</a></li>
            </ul>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white" href="/TSMS/brandOwnerHangHoa">Hàng Hóa</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white" href="/TSMS/admin-products" target="target">Đơn hàng</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white" href="#">Nhân viên</a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white" href="#">Phân tích</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>


  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


  
  


    <div class="main"  background-color: #f5f6fa !important;


        <!-- Sidebar trái -->
        <div class="sidebar">
                            <h2>Hóa đơn</h2>

            <div class="filter-box">
                <h4>Ngày tạo</h4>
                <input type="radio" name="ngaytao" checked> tháng này<br>
                <input type="radio" name="ngaytao"> Lựa chọn khác
                <input type="date" class="form-control">
            </div>
<!--        <div class="filter-box">
                <h4>Trạng thái</h4>
                <select style="width: 100%; padding: 4px;">
                    <option>Chọn phương thức bán hàng...</option>
                    <option>Chọn phương thức bán hàng...</option>
                </select>
            </div> -->
                            
  <div class="filter-box">
    <h4>Trạng thái</h4>
    <div class="subtext">Chọn phương thức bán hàng...</div>
    <div class="checkbox-group">
      <label><input type="checkbox"> Đang xử lý</label>
      <label><input type="checkbox"> Hoàn thành</label>
      <label><input type="checkbox"> Không giao được</label>
      <label><input type="checkbox"> Đã huỷ</label>
    </div>
  </div>
   
                            
                    <div class="filter-box">
                <h4>Người tạo</h4>
                <input class="form-control">
            </div>  
                            
                    <div class="filter-box">
                <h4>Người bán</h4>
                <input class="form-control">
            </div>  
                            
            <div class="filter-box">
                <h4>Trạng thái giao hàng</h4>
                <label><input type="checkbox"/>Chờ xử lý </label><br>
                <label><input type="checkbox"/>Lấy hàng </label><br>
                <label><input type="checkbox"/>Giao hàng </label><br>
                <label><input type="checkbox"/>Giao thành công </label><br>
                <label><input type="checkbox"/>Chuyển hoàn </label><br>
                <label><input type="checkbox"/>Đã chuyển hoàn </label><br>
                <label><input type="checkbox"/>Đã hủy </label><br>
                
            </div>
<div class="filter-box">
                <h4>Kênh bán</h4>
                <input class="form-control">
            </div>
<!--            <div class="filter-box">
                <h4>Đối tác giao hàng</h4>
                <input class="form-control">
            </div>
            <div class="filter-box">
                  <h4>Thời gian giao hàng</h4>
                <input class="form-control">
            </div>-->
<!--            <div class="filter-box">
                    <h4>Khu vực giao hàng</h4>
                <input class="form-control">
            </div>-->
<!--            <div class="filter-box">
                    <h4>Phương thức</h4>
                <input class="form-control">
            </div>-->
            <div class="filter-box">
                <h4>Bảng giá</h4>
                    <input class="filter-input" type="text" placeholder="Chọn người tạo">
            </div>     




<div class="bottom-fixed">
    
    

        <div class="record-selector">
  <label for="records">Số bản ghi:</label>
  <select id="records" name="records">
    <option value="10">10</option>
    <option value="30" selected>30</option>
    <option value="50">50</option>
    <option value="100">100</option>
  </select>
</div>
</div>
        </div>

        
        
        
        <!-- Nội dung chính bên phải -->
 
        <div class="content">
            <div class="header">
                <h2>     </h2>
                <div class="actions">
<!--                    
                    
<button class="green" onclick="openModal()">+ Thêm mới</button>
                -->
                <button class="green" onclick="toggleDropdown001()">+ Thêm mới</button>
                                <div id="fileDropdown001" class="dropdown-menu">
                  <div class="dropdown-item" onclick="importFile()">
                    <i class="fas fa-file-import"></i>+ Vận đơn qua KShip
                  </div>
                  <div class="dropdown-item" onclick="exportFile()">
                    <i class="fas fa-file-export"></i> + Bán hàng
                  </div>

                </div>



                    
                    <!-- Nút File -->
                <button class="green" onclick="toggleDropdown()">📁 File</button>

                <!-- Dropdown menu -->
                <div id="fileDropdown" class="dropdown-menu">
                  <div class="dropdown-item" onclick="importFile()">
                    <i class="fas fa-file-import"></i> Import
                  </div>
                  <div class="dropdown-item" onclick="exportFile()">
                    <i class="fas fa-file-export"></i> Xuất file danh sách tổng quan
                  </div>
                  <div class="dropdown-item" onclick="exportFile()">
                    <i class="fas fa-file-export"></i> Xuất file danh sách chi tiết
                  </div>
                </div>


                </div>
            </div>

            <input type="text" placeholder="Theo mã, tên, điện thoại" />
            <div class="fixed-table ">
            <table>
                <thead>
                <tr>
                    <th><input type="checkbox" /></th>
                   <th>Mã hóa đơn</th>
                    <th>Thời gian</th>
                    <th>Mã trả hàng</th>
                    <th>Khách hàng</th>
                    <th>Tổng tiền hàng</th>
                    <th>Giảm giá</th>
                    <th>Khách đã trả</th>
                </tr>
                </thead>
                <tbody>
                <tr >
                    <td><input type="checkbox" /></td>
                    <td>KH000005</td>
                    <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Chị Lý - Kim Mã</td>
                    <td>14,839,420,000</td>
                    <td>0</td>
                    <td>14,839,420,000</td>
                </tr>
                                <tr >
                    <td><input type="checkbox" /></td>
                    <td>KH000005</td>
                    <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Chị Lý - Kim Mã</td>
                    <td>14,839,420,000</td>
                    <td>0</td>
                    <td>14,839,420,000</td>
                </tr>
                <tr>
                    <td><input type="checkbox" /></td>
                    <td>KH000004</td>
                                        <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Mr Hoàng - Sài Gòn</td>


                    <td>3,268,390,000</td>
                    <td>0</td>
                    <td>3,268,390,000</td>
                </tr>
                                <tr>
                    <td><input type="checkbox" /></td>
                    <td>KH000004</td>
                                        <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Mr Hoàng - Sài Gòn</td>


                    <td>3,268,390,000</td>
                    <td>0</td>
                    <td>3,268,390,000</td>
                </tr>
                <tr>
                    <td><input type="checkbox" /></td>
                    <td>KH000003</td>
                                        <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Phạm Nhật Vượng</td>


                    <td>2,075,660,000</td>
                    <td>0</td>
                    <td>2,075,660,000</td>
                </tr>
                                <tr>
                    <td><input type="checkbox" /></td>
                    <td>KH000003</td>
                                        <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Trần Cao Văn</td>


                    <td>2,075,660,000</td>
                    <td>0</td>
                    <td>2,075,660,000</td>
                </tr>
                <tr>
                    <td><input type="checkbox" /></td>
                    <td>KH000002</td>
                                        <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Ngô Bá Khá</td>


                    <td>4,306,220,000</td>
                    <td>0</td>
                    <td>4,306,220,000</td>
                </tr>
                                <tr>
                    <td><input type="checkbox" /></td>
                    <td>KH000002</td>
                                        <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Lê Văn Luyện</td>


                    <td>4,306,220,000</td>
                    <td>0</td>
                    <td>4,306,220,000</td>
                </tr>
                <tr>
                    <td><input type="checkbox" /></td>
                    <td>KH000001</td>
                                        <td>24/05/2025 14:56</td>
                    <td></td>
                    <td>Nguyễn Tuấn Minh</td>

                    <td>3,485,250,000</td>
                    <td>0</td>
                    <td>3,485,250,000</td>
                </tr>
                </tbody>
            </table>
            
            </div>
        </div>
        

       
    </div>
  

 
 <div class="modal fade" id="customerModal" tabindex="-1" aria-labelledby="customerModalLabel" aria-hidden="true">
  <div class="modal-dialog" style="max-width: 800px;">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="customerModalLabel">Thêm khách hàng</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <form id="addCustomerForm">
          <div class="row">
            <div class="col-md-3 text-center">
              <div class="mb-3">
                <div style="width: 100%; height: 200px; border: 1px dashed #ccc; display: flex; align-items: center; justify-content: center;">
                  <span>Hình ảnh</span>
                </div>
                <input type="file" class="form-control mt-2" id="customerImage">
              </div>
            </div>
            <div class="col-md-9">
              <div class="row">
                <div class="col-md-6 mb-3">
                  <label class="form-label">Mã khách hàng</label>
                  <input type="text" class="form-control" placeholder="Mã mặc định">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Tên khách hàng</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Điện thoại</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Email</label>
                  <input type="email" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Số CMND/CCCD</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Facebook</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Ngày sinh</label>
                  <input type="date" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Giới tính</label>
                  <div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="gender" id="male" value="Nam">
                      <label class="form-check-label" for="male">Nam</label>
                    </div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="gender" id="female" value="Nữ">
                      <label class="form-check-label" for="female">Nữ</label>
                    </div>
                  </div>
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Loại khách</label>
                  <div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="customerType" id="personal" checked>
                      <label class="form-check-label" for="personal">Cá nhân</label>
                    </div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="customerType" id="company">
                      <label class="form-check-label" for="company">Công ty</label>
                    </div>
                  </div>
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Mã số thuế</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-12 mb-3">
                  <label class="form-label">Địa chỉ</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Tỉnh/TP - Quận/Huyện</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-6 mb-3">
                  <label class="form-label">Phường/Xã</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-12 mb-3">
                  <label class="form-label">Nhóm</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-12 mb-3">
                  <label class="form-label">Ghi chú</label>
                  <textarea class="form-control" rows="2"></textarea>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success">Lưu (F9)</button>
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Bỏ qua</button>
      </div>
    </div>
  </div>
</div>

  
  
        
    </body>
    
<style>
  .modal.d-none {
    display: none !important;
  }
  .modal.show {
    display: flex !important;
  }
</style>
    
    
    
    <script>


    
    function toggleDropdown() {
  const dropdown = document.getElementById('fileDropdown');
  dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
}

    function toggleDropdown001() {
  const dropdown = document.getElementById('fileDropdown001');
  dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
}
// Tự đóng dropdown khi click ra ngoài
window.addEventListener('click', function (e) {
  const dropdown = document.getElementById('');
  const button = document.querySelector('.green');
  if (!dropdown.contains(e.target) && !button.contains(e.target)) {
    dropdown.style.display = 'none';
  }
});

// Hàm xử lý
function importFile() {
  alert("Chức năng Import được gọi!");
}

function exportFile() {
  alert("Chức năng Xuất file được gọi!");
}

    
function toggleDropdown1() {
  const filter = document.getElementById('filterDropdown');
  filter.style.display = filter.style.display === 'block' ? 'none' : 'block';
}

// Đóng khi click ngoài
window.addEventListener('click', function (e) {
  const filter = document.getElementById('');
  const button = document.querySelector('button.green');
  if (!filter.contains(e.target) && !button.contains(e.target)) {
    filter.style.display = 'none';
  }
});
    

  function toggleFilter(header) {
    const content = header.nextElementSibling;
    const arrow = header.querySelector('.arrow-icon');
    content.style.display = content.style.display === 'none' ? 'block' : 'none';
    arrow.classList.toggle('rotate');
  }


  function closeModal() {
    const modal = document.getElementById("customerModal");
    modal.classList.remove("show");
    modal.classList.add("d-none");
  }

  function openModal() {
    const modal = new bootstrap.Modal(document.getElementById('customerModal'));
    modal.show();
  }

</script>


    
    </html>