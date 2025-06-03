    <%-- 
        Document   : khachhang
        Created on : May 24, 2025, 10:19:08 AM
        Author     : Kawaii
    --%>

    <%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
    <!DOCTYPE html>
    <%-- 
        Document   : khachhang
        Created on : May 21, 2025, 4:20:38 PM
        Author     : Kawaii
    --%>
    <html>
    <head>
        <title>Quản lý khách hàng</title>

    <link rel="stylesheet" type="text/css" href="css/khachhang.css" />
    
    
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  
  
  
  
  <style>
      
/* Header Styles */
.headertop {
    background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
    color: white;
    padding: 1rem 2rem;
    box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
    position: sticky;
    top: 0;
    z-index: 100;
}

.header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 1400px;
    margin: 0 auto;
}

.logo {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-size: 1.25rem;
    font-weight: 700;
}

.logo-icon {
    width: 32px;
    height: 32px;
    background: white;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #2196F3;
    font-weight: bold;
}

.nav-menu {
    display: flex;
    gap: 2rem;
    list-style: none;
}

.nav-item {
    padding: 0.5rem 1rem;
    border-radius: 8px;
    transition: background-color 0.2s;
    cursor: pointer;
}

.nav-item:hover {
    background-color: rgba(255, 255, 255, 0.1);
}

.user-section {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.user-avatar {
    width: 32px;
    height: 32px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
}

/* Form Styles */
.form-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 1rem;
}

.form-group label {
    display: block;
    font-weight: 500;
    margin-bottom: 0.5rem;
    color: #374151;
}

.form-group label.required::after {
    content: " *";
    color: #dc2626;
}

.form-control.full-width {
    grid-column: 1 / -1;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}

/* Responsive */
@media (max-width: 1024px) {
    .main-container {
        flex-direction: column;
    }

    .sidebar {
        width: 100%;
        border-right: none;
        border-bottom: 1px solid #e2e8f0;
    }

    .nav-menu {
        display: none;
    }
}




  </style>
  
  <title>JSP Page</title>
    <header class="headertop">
        <div class="header-content">
            <div style="display: flex; align-items: center; gap: 2rem;">
                <div class="logo">
                    <div class="logo-icon">S</div>
                    <span>SWP391</span>
                </div>
                
                <nav>
                    <ul class="nav-menu">
                        <li class="nav-item">
                            <i class="fas fa-home"></i>
                            <span>Tên Shop</span>
                        </li>
                        <li class="nav-item">
                            <i class="fas fa-chart-bar"></i>
                            <span>Tổng quan</span>
                        </li>
                        <li class="nav-item">
                            <i class="fas fa-box"></i>
                            <span>Hàng hóa</span>
                        </li>
                        <li class="nav-item">
                            <i class="fas fa-shopping-cart"></i>
                            <span>Đơn hàng</span>
                        </li>
                        <li class="nav-item">
                            <i class="fas fa-users"></i>
                            <span>Nhân viên</span>
                        </li>
                        <li class="nav-item">
                            <i class="fas fa-chart-pie"></i>
                            <span>Phân tích</span>
                        </li>
                    </ul>
                </nav>
            </div>
            
            <div class="user-section">
                <button class="btn-outline" style="background: rgba(255,255,255,0.1); border: none; color: white;">
                    <i class="fas fa-bell"></i>
                </button>
                <button class="btn-outline" style="background: rgba(255,255,255,0.1); border: none; color: white;">
                    <i class="fas fa-cog"></i>
                </button>
                <span>🇻🇳 Tiếng Việt</span>
                <div class="user-avatar">A</div>
            </div>
        </div>
    </header>
  
  
  
  
  
    </head>
    <body>
        
        
        
    
  
    <div class="main";


        <!-- Sidebar trái -->
        <div class="sidebar">
                            <h2>Khách hàng</h2>

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
                    
                    
<button class="green" onclick="openModal()">+ Khách hàng</button>


                    
                    <!-- Nút File -->
                <button class="green" onclick="toggleDropdown()">📁 File</button>

                <!-- Dropdown menu -->
                <div id="fileDropdown" class="dropdown-menu">
                  <div class="dropdown-item" onclick="importFile()">
                    <i class="fas fa-file-import"></i> Import
                  </div>
                  <div class="dropdown-item" onclick="exportFile()">
                    <i class="fas fa-file-export"></i> Xuất file
                  </div>
                </div>


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
    
    



//  function openModal() {
//    const modal = document.getElementById("customerModal");
//    modal.classList.remove("d-none");
//    modal.classList.add("show");
//  }

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