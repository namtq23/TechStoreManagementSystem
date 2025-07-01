<%-- 
    Document   : subscribe
    Created on : Jul 1, 2025, 8:41:44 AM
    Author     : admin
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Mua Gói hỗ trợ - TSMS</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="css/login.css"/>
        <style>
            .main-content {
                min-height: calc(100vh - 160px);
                padding: 20px;
                background-color: #f5f5f5;
                display: flex;
                justify-content: center;
            }
            
            .container {
                width: 100%;
                max-width: 1400px;
                display: flex;
                gap: 24px;
                align-items: flex-start;
            }
            
            .sidebar {
                width: 280px;
                flex-shrink: 0;
            }
            
            .main-form {
                flex: 1;
                max-width: 800px;
            }
            
            .summary-card {
                width: 320px;
                flex-shrink: 0;
            }
            
            .sidebar {
                background: white;
                border-radius: 8px;
                padding: 20px;
                height: fit-content;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
            }
            
            .sidebar h3 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }
            
            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
            }
            
            .sidebar-menu li {
                margin-bottom: 8px;
            }
            
            .sidebar-menu a {
                display: flex;
                align-items: center;
                padding: 12px 16px;
                text-decoration: none;
                color: #666;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            
            .sidebar-menu a:hover,
            .sidebar-menu a.active {
                background-color: #e3f2fd;
                color: #1976d2;
            }
            
            .sidebar-menu i {
                margin-right: 12px;
                width: 20px;
                font-size: 16px;
            }
            
            .main-form {
                background: white;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                overflow: hidden;
            }
            
            .form-header {
                background: #f8f9fa;
                padding: 20px 30px;
                border-bottom: 1px solid #e9ecef;
                display: flex;
                align-items: center;
            }
            
            .form-header i {
                margin-right: 10px;
                color: #1976d2;
            }
            
            .form-header h2 {
                margin: 0;
                font-size: 20px;
                font-weight: 600;
                color: #333;
            }
            
            .form-content {
                padding: 30px;
            }
            
            .plan-options {
                margin-bottom: 30px;
            }
            
            .plan-option {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 12px 16px;
                border: 1px solid #d1ecf1;
                border-radius: 6px;
                margin-bottom: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                background-color: #f8f9fa;
            }
            
            .plan-option:hover {
                border-color: #17a2b8;
                background-color: #e3f2fd;
            }
            
            .plan-option.selected {
                border-color: #17a2b8;
                background-color: #d1ecf1;
                box-shadow: 0 0 0 1px #17a2b8;
            }
            
            .plan-option input[type="radio"] {
                margin-right: 12px;
            }
            
            .plan-duration {
                font-weight: 500;
                color: #333;
            }
            
            .plan-price {
                font-weight: 600;
                color: #17a2b8;
                font-size: 14px;
            }
            
            .form-tabs {
                display: flex;
                border-bottom: 2px solid #e9ecef;
                margin-bottom: 24px;
            }
            
            .tab-button {
                padding: 12px 24px;
                background: none;
                border: none;
                cursor: pointer;
                font-weight: 500;
                color: #666;
                border-bottom: 2px solid transparent;
                transition: all 0.3s ease;
            }
            
            .tab-button.active {
                color: #17a2b8;
                border-bottom-color: #17a2b8;
            }
            
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 20px;
            }
            
            .form-group {
                display: flex;
                flex-direction: column;
            }
            
            .form-group.full-width {
                grid-column: 1 / -1;
            }
            
            .form-group label {
                margin-bottom: 6px;
                font-weight: 500;
                color: #333;
            }
            
            .form-group label.required::after {
                content: "*";
                color: #e74c3c;
                margin-left: 4px;
            }
            
            .form-group input,
            .form-group select {
                padding: 12px 16px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                transition: border-color 0.3s ease;
            }
            
            .form-group input:focus,
            .form-group select:focus {
                outline: none;
                border-color: #17a2b8;
                box-shadow: 0 0 0 2px rgba(23, 162, 184, 0.2);
            }
            
            .phone-input {
                display: flex;
                gap: 8px;
            }
            
            .phone-input select {
                width: 80px;
                flex-shrink: 0;
            }
            
            .gender-options {
                display: flex;
                gap: 20px;
                margin-top: 6px;
            }
            
            .gender-option {
                display: flex;
                align-items: center;
                gap: 6px;
            }
            
            .gender-option input[type="radio"] {
                margin: 0;
            }
            
            .summary-card {
                background: white;
                border-radius: 8px;
                padding: 20px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.1);
                border: 1px solid #e9ecef;
                height: fit-content;
            }
            
            .summary-card h3 {
                margin: 0 0 20px 0;
                font-size: 18px;
                font-weight: 600;
                color: #333;
            }
            
            .summary-item {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                padding-bottom: 12px;
                border-bottom: 1px solid #f0f0f0;
            }
            
            .summary-item:last-child {
                border-bottom: none;
                margin-bottom: 0;
                padding-bottom: 0;
            }
            
            .summary-item.total {
                font-weight: 600;
                font-size: 16px;
                color: #17a2b8;
                border-top: 2px solid #e9ecef;
                padding-top: 12px;
                margin-top: 12px;
            }
            
            .summary-note {
                background: #f8f9fa;
                padding: 12px;
                border-radius: 6px;
                font-size: 12px;
                color: #666;
                margin-bottom: 20px;
            }
            
            .btn-primary {
                width: 100%;
                padding: 12px;
                background: #17a2b8;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
                transition: background-color 0.3s ease;
            }
            
            .btn-primary:hover {
                background: #138496;
            }
            
            .sms-note {
                text-align: center;
                color: #666;
                font-size: 12px;
                margin-top: 12px;
            }
            
            .help-button {
                position: fixed;
                bottom: 20px;
                right: 20px;
                width: 50px;
                height: 50px;
                background: #17a2b8;
                color: white;
                border: none;
                border-radius: 50%;
                font-size: 18px;
                cursor: pointer;
                box-shadow: 0 2px 12px rgba(0,0,0,0.15);
                transition: all 0.3s ease;
            }
            
            .help-button:hover {
                background: #138496;
                transform: scale(1.1);
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header" id="header">
            <div class="header-content">
                <a href="starting" class="logo">
                    <div class="logo-icon">T</div>
                    <span class="logo-text">TSMS</span>
                </a>
            </div>
        </header>
        
        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <!-- Left Sidebar -->
                <div class="sidebar">
                    <h3>Gian hàng</h3>
                    <ul class="sidebar-menu">
                        <li><a href="#"><i class="fas fa-info-circle"></i> Thông tin gian hàng</a></li>
                        <li><a href="#" class="active"><i class="fas fa-shopping-cart"></i> Gói dịch vụ</a></li>
                        <li><a href="#"><i class="fas fa-history"></i> Lịch sử mua hàng</a></li>
                        <li><a href="#"><i class="fas fa-check-circle"></i> Bản xác nhận dịch vụ</a></li>
                    </ul>
                    
                    <h3 style="margin-top: 30px;">Khác</h3>
                    <ul class="sidebar-menu">
                        <li><a href="#"><i class="fas fa-cog"></i> Điều khoản sử dụng</a></li>
                        <li><a href="#"><i class="fas fa-credit-card"></i> Thanh toán</a></li>
                    </ul>
                </div>
                
                <!-- Main Form -->
                <div class="main-form">
                    <div class="form-header">
                        <i class="fas fa-arrow-left"></i>
                        <h2>Mua Gói hỗ trợ</h2>
                    </div>
                    
                    <div class="form-content">
                        <!-- Plan Selection -->
                        <div class="plan-options">
                            <div class="plan-option">
                                <div style="display: flex; align-items: center;">
                                    <input type="radio" name="plan" value="1" id="plan1">
                                    <label for="plan1" class="plan-duration">1 năm</label>
                                </div>
                                <div class="plan-price">2,100,000đ</div>
                            </div>
                            
                            <div class="plan-option selected">
                                <div style="display: flex; align-items: center;">
                                    <input type="radio" name="plan" value="2" id="plan2" checked>
                                    <label for="plan2" class="plan-duration">2 năm</label>
                                </div>
                                <div class="plan-price">4,200,000đ</div>
                            </div>
                            
                            <div class="plan-option">
                                <div style="display: flex; align-items: center;">
                                    <input type="radio" name="plan" value="3" id="plan3">
                                    <label for="plan3" class="plan-duration">3 năm</label>
                                </div>
                                <div class="plan-price">6,300,000đ</div>
                            </div>
                            
                            <div class="plan-option">
                                <div style="display: flex; align-items: center;">
                                    <input type="radio" name="plan" value="5" id="plan5">
                                    <label for="plan5" class="plan-duration">5 năm</label>
                                </div>
                                <div class="plan-price">10,500,000đ</div>
                            </div>
                        </div>
                        
                        <!-- Form Tabs -->
                        <div class="form-tabs">
                            <button class="tab-button active">Cá nhân</button>
                            <button class="tab-button">Hộ kinh doanh</button>
                            <button class="tab-button">Doanh nghiệp</button>
                        </div>
                        
                        <!-- Form Fields -->
                        <form>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="fullname" class="required">Người đại diện</label>
                                    <input type="text" id="fullname" name="fullname" value="nguyen phuong" required>
                                </div>
                                
                                <div class="form-group">
                                    <label>Giới tính</label>
                                    <div class="gender-options">
                                        <div class="gender-option">
                                            <input type="radio" name="gender" value="male" id="male" checked>
                                            <label for="male">Nam</label>
                                        </div>
                                        <div class="gender-option">
                                            <input type="radio" name="gender" value="female" id="female">
                                            <label for="female">Nữ</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="phone" class="required">Số điện thoại</label>
                                    <div class="phone-input">
                                        <select name="country_code">
                                            <option value="+84">🇻🇳</option>
                                        </select>
                                        <input type="tel" id="phone" name="phone" value="+84989167760" required>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input type="email" id="email" name="email" value="ndpp.work@gmail.com">
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="cccd" class="required">CCCD/Hộ chiếu</label>
                                    <input type="text" id="cccd" name="cccd" value="024205000015" required>
                                </div>
                                
                                <div class="form-group">
                                    <label for="address" class="required">Địa chỉ</label>
                                    <input type="text" id="address" name="address" value="Hoa Lac High Park" required>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Right Summary -->
                <div class="summary-card">
                    <h3>Chi tiết hóa đơn</h3>
                    
                    <div class="summary-item">
                        <span>Gói hỗ trợ x 2 năm</span>
                        <span>4,200,000đ</span>
                    </div>
                    
                    <div class="summary-item total">
                        <span>Tổng tiền thanh toán</span>
                        <span>4,200,000đ</span>
                    </div>
                    
                    <div class="summary-note">
                        Bằng cách tra chọn Tiếp tục thanh toán, bạn đã đồng ý với các <a href="#" style="color: #17a2b8;">Điều khoản dịch vụ</a> của KiotViet
                    </div>
                    
                    <button class="btn-primary">Tiếp tục thanh toán</button>
                    
                    <div class="sms-note">
                        Gửi thông tin thanh toán qua SMS
                    </div>
                </div>
            </div>
            
            <!-- Help Button -->
            <button class="help-button">
                <i class="fas fa-phone"></i>
            </button>
        </main>
        
        <!-- Footer -->
        <footer class="footer">
            <div class="footer-content">
                <div class="footer-copyright">
                    © 2025 TSMS. Tất cả quyền được bảo lưu.
                </div>
                <div class="footer-links">
                    <a href="#">Điều khoản sử dụng</a>
                    <a href="#">Chính sách bảo mật</a>
                    <a href="#">Trợ giúp</a>
                    <a href="#">Liên hệ</a>
                </div>
            </div>
        </footer>
        
        <script>
            // Handle plan selection
            document.querySelectorAll('.plan-option').forEach(option => {
                option.addEventListener('click', function() {
                    document.querySelectorAll('.plan-option').forEach(o => o.classList.remove('selected'));
                    this.classList.add('selected');
                    this.querySelector('input[type="radio"]').checked = true;
                    
                    // Update price in summary
                    const price = this.querySelector('.plan-price').textContent;
                    const duration = this.querySelector('.plan-duration').textContent;
                    document.querySelector('.summary-item span:first-child').textContent = `Gói hỗ trợ x ${duration}`;
                    document.querySelector('.summary-item span:last-child').textContent = price;
                    document.querySelector('.summary-item.total span:last-child').textContent = price;
                });
            });
            
            // Handle tab switching
            document.querySelectorAll('.tab-button').forEach(tab => {
                tab.addEventListener('click', function() {
                    document.querySelectorAll('.tab-button').forEach(t => t.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        </script>
    </body>
</html>