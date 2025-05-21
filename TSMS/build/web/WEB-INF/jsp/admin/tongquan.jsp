<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>KiotViet Dashboard</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f5f7fa;
      margin: 0;
      padding: 0;
    }

    .top-toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: white;
      border-bottom: 1px solid #ccc;
      padding: 5px 20px;
      font-size: 14px;
    }

    .toolbar-right {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
    }

    .toolbar-right button {
      margin-left: 10px;
      cursor: pointer;
      background: none;
      border: none;
      font-size: 14px;
      background-color: #eee;
      padding: 5px 10px;
      border-radius: 5px;
    }

    header {
      background-color: #007bff;
      color: white;
      padding: 15px;
      text-align: center;
      font-size: 22px;
    }

    
    
    nav {
      background-color: #007bff;
      padding: 10px;
      display: flex;

    }

    
    
    
    .nav-btn {
      background: none;
      border: none;
      color: white;
      font-size: 16px;
      cursor: pointer;
      padding: 8px 12px;
      border-radius: 5px;
      transition: background-color 0.3s;
    }

    .nav-btn:hover {
      background-color: rgba(255, 255, 255, 0.2);
    }

    .main {
      display: flex;
      padding: 20px;
    }

    .container {
      flex: 3;
      padding-right: 20px;
    }

    .sidebar-right {
      flex: 1;
      background-color: white;
      padding: 15px;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      max-height: 70vh;
      overflow-y: auto;
    }
        .sidebar-right1 {
      flex: 1;
/*      background-color: white;*/
      padding: 15px;
      border-radius: 10px;
/*      box-shadow: 0 2px 5px rgba(0,0,0,0.1);*/
      max-height: 90vh;
      overflow-y: auto;
    }
        .sidebar-right2 {
      flex: 1;
      background-color: white;
      padding: 15px;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      max-height: 70vh;
      overflow-y: auto;
    }


    .cards {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
    }

    .card {
      background-color: white;
      padding: 20px;
      border-radius: 10px;
      width: 24%;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      text-align: center;
    }

    .chart-container {  
      background-color: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      margin-bottom: 20px;
    }

    .flex-box {
      display: flex;
      justify-content: space-between;
    }

    .list-box {
      background-color: white;
      padding: 15px;
      border-radius: 10px;
      width: 48%;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }

    h3 {
      margin-bottom: 10px;
    }

    ul {
      padding-left: 20px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
    }

    .notification {
      margin-bottom: 15px;
    }

    .activity {
      margin-bottom: 10px;
      font-size: 14px;
    }

    .activity strong {
      color: #007bff;
    }

    .activity small {
      display: block;
      color: #777;
      font-size: 12px;
    }

    .ad-banner img {
      width: 100%;
      border-radius: 10px;
      margin-bottom: 15px;
    }
    
    
    
    .sidebar-right h3 {
  font-size: 18px;
  margin-bottom: 10px;
}

.sidebar-right table {
  width: 100%;
  border-collapse: collapse;
}

.sidebar-right table img {
  width: 100%;
  border-radius: 10px;
  margin-bottom: 10px;
}

.sidebar-right table tr {
  margin-bottom: 15px;
}

.dropdown-panel {
  display: none;
  position: absolute;
  background-color: white;
  color: black;
  min-width: 180px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.15);
  z-index: 999;
  padding: 10px;
  border-radius: 6px;
  margin-top: 40px;
}

.dropdown-panel a {
  display: block;
  padding: 8px 10px;
  text-decoration: none;
  color: #333;
}

.dropdown-panel a:hover {
  background-color: #f1f1f1;
}


    .navbar-custom {
      background-color: #007bff;
      border: none;
      border-radius: 0;
    }

    .navbar-custom .navbar-nav > li > a {
      color: #fff;
      font-weight: 600;
      padding: 14px 20px;
    }

    .navbar-custom .navbar-nav > li > a:hover,
    .navbar-custom .navbar-nav > .open > a {
      background-color: #0056d2;
      color: white;
    }

    /* Dropdown menu */
    .navbar-custom .dropdown-menu {
      background-color: #0056d2;
      border-radius: 10px;
      border: none;
      padding: 10px 0;
      margin-top: 10px;
      min-width: 200px;
    }

    .navbar-custom .dropdown-menu > li > a {
      color: white;
      padding: 10px 20px;
      font-size: 15px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .navbar-custom .dropdown-menu > li > a:hover {
      background-color: #007bff;
      color: white;
    }

    .navbar-custom .dropdown-menu > li > a i {
      width: 20px;
      text-align: center;
    }


  </style>
</head>
<body>

<!-- Toolbar -->
<div class="top-toolbar">
  <div class="toolbar-left">
    <strong>SWP391</strong>
  </div>
  <div class="toolbar-right">
<!--    <button>🚚 Giao hàng</button>
    <button>💰 Vay vốn</button>
    <button>💳 Thanh toán</button>
    <button>💡 Nguồn hàng giá tốt</button>
    <button>🎨 Chủ đề</button>
    <button>💬 Hỗ trợ</button>
    <button>📝 Góp ý</button>
    <button>🖥️ Giao diện cũ</button>-->
    <button>🇻🇳 Tiếng Việt</button>
    <button>📧</button>
    <button>⚙️</button>
    <button>👤</button>
  </div>
</div>



<nav class="navbar navbar-custom">
  <div class="container-fluid">
    <ul class="nav navbar-nav">
      <li><a href="#">Tổng quan</a></li>

      <!-- Dropdown menu -->
      <li class="dropdown">
        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Hàng hóa <span class="caret"></span></a>
        <ul class="dropdown-menu">
          <li><a href="#">Tổng quan chung</a></li>
          <li><a href="#">Hiệu suất bán hàng</a></li>
          <li><a href="#">Hoạt động nhân viên</a></li>
        </ul>
      </li>
       <li><a href="#">Kho hàng</a></li>
      
      <li><a href="/TSMS/admin-products" target="target">Đơn hàng</a></li>
      <li><a href="#">Nhân viên</a></li>
      <li><a href="#">Phân tích</a></li>
    </ul>
  </div>
</nav>



<!-- Main Content -->
<div class="main">
  <div class="container">
    <!-- Thống kê -->
    <div class="cards">
      <div class="card">
        <strong>Doanh thu</strong>
        <div>0</div>
      </div>
      <div class="card">
        <strong>Trả hàng</strong>
        <div>0</div>
      </div>
      <div class="card">
        <strong>So với hôm qua</strong>
        <div>0</div>
      </div>
      <div class="card">
        <strong>Doanh thu thuần</strong>
        <div style="color: red;">-5.72%</div>
      </div>
    </div>

    <!-- Biểu đồ doanh thu -->
    <div class="chart-container">
      <h3>Doanh thu thuần (Tháng trước)</h3>
      <canvas id="revenueChart" width="700" height="300"></canvas>
    </div>



<!--
 Biểu đồ top sản phẩm chia 2 phần 
-->

<div class="flex-box">
  <div class="chart-container" style="width: 49%;">
    <h3>TOP 5 HÀNG BÁN CHẠY NHẤT</h3>
    <canvas id="topProductChart1" height="300"></canvas>
  </div>
  <div class="chart-container" style="width: 49%;">
    <h3>TOP 5 HÀNG BÁN CHẠY TIẾP THEO</h3>
    <canvas id="topProductChart2" height="300"></canvas>
  </div>
</div>


    <!-- Danh sách top -->
    <div class="flex-box">
      <div class="list-box">
        <h3>Top 10 hàng bán chạy</h3>
        <ul>
          <li>Micro không dây Zenbos MZ-201 - 50.1 triệu</li>
          <li>...</li>
        </ul>
      </div>


      <div class="list-box">
        <h3>Top 10 khách mua nhiều nhất</h3>
        <ul>
          <li>Mr Hoàng - Sài Gòn - 58.2 triệu</li>
          <li>...</li>
        </ul>
      </div>
    </div>
  </div>




<div class="sidebar-right1">


<div class="sidebar-right">

  <!-- BẢNG QUẢNG CÁO -->
  <div class="section-box" style="margin-bottom: 30px ">
    <h3>BẢNG QUẢNG CÁO</h3>
    <table style="width: 100%;">
      <tr>
        <td><img src="https://via.placeholder.com/300x100" alt="Quảng cáo 1" style="width: 100%;"></td>
      </tr>
      <tr>
        <td><img src="https://via.placeholder.com/300x100" alt="Quảng cáo 2" style="width: 100%;"></td>
      </tr>
    </table>
  </div>
  </div>
  
<div class="sidebar-right2">
  <!-- THÔNG BÁO -->
  <div class="section-box" style="margin-bottom: 30px;"> 
    <h3>THÔNG BÁO</h3>
   <table style="width: 100%;"> 
      <tr style="background-color: #fff3f3;">
        <td style="color: red; padding: 10px; border-radius: 10px; overflow: hidden; ">
          🔴 Có <strong>1 hoạt động đăng nhập khác thường</strong> cần kiểm tra.
          <br>
          <button onclick="toggleDetails()" style="margin-top: 8px; padding: 5px 10px;">Hiển thị thêm</button>
          <div id="login-details" style="display: none; margin-top: 10px; color: black;">
            <div><strong>0559049285</strong> đã đăng nhập trên <strong>Máy tính Windows</strong></div>
            <div>Thời gian: <strong>15/05/2025 14:08</strong></div>
            <div><a href="#" style="color: blue;">Kiểm tra</a></div>
          </div>
        </td>
      </tr>
    </table>
  </div>

  <!-- HOẠT ĐỘNG GẦN ĐÂY -->
  <div class="section-box">
    <h3>CÁC HOẠT ĐỘNG GẦN ĐÂY</h3>
    <table style="width: 100%;">
      <tr>
        <td style="width: 30px;">📦</td>
        <td><strong>Phượng Nguyễn</strong> vừa nhập hàng<br><small>Giá trị: 0 - 2 ngày trước</small></td>
      </tr>
      <tr>
        <td>📦</td>
        <td><strong>Hoàng Nam Quang</strong> bán đơn giao hàng<br><small>15,000,000 - 2 ngày trước</small></td>
      </tr>
      <tr>
        <td>🔄</td>
        <td><strong>Phượng Nguyễn</strong> kiểm hàng<br><small>2 ngày trước</small></td>
      </tr>
      <tr>
        <td>📦</td>
        <td><strong>Phượng Nguyễn</strong> bán đơn hàng<br><small>6,760,000 - 3 ngày trước</small></td>
      </tr>
    </table>
  </div>

  </div>

  </div>




<!-- Toggle JS -->
<script>
  function toggleDetails() {
    const details = document.getElementById('login-details');
    details.style.display = (details.style.display === 'none') ? 'block' : 'none';
  }
</script>


<script>
  function toggleDetails1() {
    const panel = document.getElementById('hang-hoa-panel');
    panel.style.display = (panel.style.display === 'block') ? 'none' : 'block';
  }

  // Ẩn bảng chọn nếu click ra ngoài
  window.addEventListener('click', function(event) {
    const panel = document.getElementById('hang-hoa-panel');
    const button = document.querySelector('hang-hoa-btn');
    if (!panel.contains(event.target) && event.target !== button) {
      panel.style.display = 'none';
    }
  });
</script>


<!-- Chart.js scripts -->
<script>
  const ctx1 = document.getElementById('revenueChart').getContext('2d');
  new Chart(ctx1, {
    type: 'bar',
    data: {
      labels: [...Array(30).keys()].map(i => (i+1).toString().padStart(2, '0')),
      datasets: [{
        label: 'Doanh thu (triệu)',
        data: [24, 8, 21, 22, 9, 24, 5, 11, 7, 28, 10, 9, 8, 24, 20, 13, 18, 14, 6, 7, 22, 22, 19, 17, 14, 26, 9, 10, 25, 21],
        backgroundColor: '#007bff'
      }]
    },
    options: {
      scales: {
        y: {
          beginAtZero: true,
          ticks: {
            callback: value => value + ' tr'
          }
        }
      }
    }
  });


  const ctx2 = document.getElementById('topProductChart').getContext('2d');
  new Chart(ctx2, {
    type: 'bar',
    data: {
      labels: [
        "Dell Inspiron 15 3520 i5 1235U", "MacBook Pro M2", "Lenovo ThinkPad X1",
        "HP Envy 13", "Acer Aspire 7", "Asus Zenbook UX425",
        "MSI GF63", "Huawei MateBook D15", "Gigabyte G5", "LG Gram 16"
      ],
      datasets: [{
        label: "Doanh thu (tỷ)",
        data: [2.15, 1.85, 1.65, 1.5, 1.3, 1.25, 1.1, 1.0, 0.95, 0.85],
        backgroundColor: '#007bff'
      }]
    },
    options: {
      indexAxis: 'y',
      scales: {
        x: {
          beginAtZero: true,
          ticks: {
            callback: value => value + ' tỷ'
          }
        }
      }
    }
  });
</script>

</body>
</html>
