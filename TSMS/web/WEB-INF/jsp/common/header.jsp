<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>JSP Page</title>

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

  <!-- Custom CSS -->
  <link rel="stylesheet" href="css/header.css">
</head>
<body>

  <!-- Top toolbar -->
  <div class="top-toolbar d-flex justify-content-between align-items-center px-4 py-2 bg-dark text-white">
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

  <!-- Navbar -->
  <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid px-4">
      <!-- Logo -->
      <a class="navbar-brand fw-bold" href="#"><i class="fas fa-store"></i> Tên Shop</a>

      <!-- Toggle button for mobile -->
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar">
        <span class="navbar-toggler-icon"></span>
      </button>

      <!-- Navbar links -->
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

  <!-- Bootstrap Script -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
