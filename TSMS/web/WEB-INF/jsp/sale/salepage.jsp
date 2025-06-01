<%-- 
        Document   : khachhang
        Created on : May 24, 2025, 10:19:08 AM
        Author     : phung
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Thông tin cá nhân - Sale</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/sale.css">

            <div class="top-bar">
                <div class="header-icons">
                    <select class="lang-select">
                        <option>🌐 Tiếng Việt</option>
                        <option>English</option>
                    </select>
                    <span class="icon">🔔</span>
                    <span class="icon">👤</span>
                </div>
            </div>
            <div class="nav-bar">
                <span class="shop-name">🛒 Tên Shop</span>
                <a href="#">Thông tin cá nhân</a>
                <a href="#">Hàng hóa</a>
                <a href="#">Đơn hàng</a>
            </div>
        </div>

        <div class="profile-container">
            <div class="profile-content">
                <div class="avatar-section">
                    <div class="avatar-placeholder">
                        AVATAR CÁ NHÂN
                    </div>
                </div>

                <div class="info-section">
                    <div class="info-group">
                        <div class="info-label">Mã nhân viên</div>
                        <div class="info-value">NV000001</div>
                    </div>
                    <!-- Other info groups remain unchanged -->
                    <div class="info-group">
                        <div class="info-label">Tên nhân viên</div>
                        <div class="info-value">Phan Đình Phùng</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Ngày sinh</div>
                        <div class="info-value">27/01/2004</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Giới tính</div>
                        <div class="info-value">Nam</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Số CMND/CCCD</div>
                        <div class="info-value">0123 4567 9123</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Ngày bắt đầu làm việc</div>
                        <div class="info-value">20/05/2025</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Chi nhánh trả lương</div>
                        <div class="info-value">Chi nhánh trung tâm</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Chi nhánh làm việc</div>
                        <div class="info-value">Kho hàng tổng</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Số điện thoại</div>
                        <div class="info-value">0123456789</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Email</div>
                        <div class="info-value">phungpdhe189026@fpt.edu.vn</div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Facebook</div>
                        <div class="info-value"></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">Địa chỉ</div>
                        <div class="info-value"></div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function toggleDropdown() {
            const dropdown = document.getElementById('dropdownMenu');
            dropdown.classList.toggle('show');
        }

        function handleKey(event) {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                toggleDropdown();
            }
        }

        function handleLogout(event) {
            event.preventDefault();
            if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                alert('Đăng xuất thành công!');
                // Simulate redirect to login page (replace with actual login page URL)
                window.location.href = '/login.html';
            }
        }

        // Close dropdown when clicking outside
        document.addEventListener('click', function(event) {
            const dropdown = document.getElementById('dropdownMenu');
            const avatar = document.querySelector('.user-avatar');
            
            if (!avatar.contains(event.target) && !dropdown.contains(event.target)) {
                dropdown.classList.remove('show');
            }
        });

        // Keyboard navigation for dropdown items
        document.querySelectorAll('.dropdown-item').forEach(item => {
            item.addEventListener('keydown', function(event) {
                if (event.key === 'Enter' || event.key === ' ') {
                    event.preventDefault();
                    if (item.classList.contains('logout')) {
                        handleLogout(event);
                    } else {
                        // Simulate click for other items
                        item.click();
                    }
                }
            });
        });
    </script>
</body>
</html>