<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Hệ Thống Quản Lý Kho</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/quanlykhotong.css">
    </head>
    <body>
        <div class="container">
            <!-- Sidebar -->
            <nav class="sidebar">
                <div class="logo">TSMS</div>
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="#" class="nav-link active" onclick="loadContent('productList', this)">
                            <i class="fas fa-boxes"></i>
                            Danh sách hàng hóa
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link" onclick="loadContent('import', this)">
                            <i class="fas fa-arrow-down"></i>
                            Trang Nhập Hàng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link" onclick="loadContent('export', this)">
                            <i class="fas fa-arrow-up"></i>
                            Trang Xuất Hàng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link" onclick="loadContent('notifications', this)">
                            <i class="fas fa-bell"></i>
                            Thông báo nhập/xuất
                            <span class="notification-badge">3</span>
                        </a>
                    </li>
                </ul>
            </nav>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Header -->
                <header class="header">
                    <div class="search-container">
                        <input type="text" class="search-box" placeholder="Tìm kiếm sản phẩm..." id="searchInput">
                        <i class="fas fa-search search-icon"></i>
                    </div>
                    <div class="header-right">
                        <div class="language-selector">
                            <button class="language-btn" onclick="toggleLanguageDropdown()">
                                <i class="fas fa-globe"></i>
                                Tiếng Việt
                                <i class="fas fa-chevron-down"></i>
                            </button>
                            <div class="language-dropdown" id="languageDropdown">
                                <div class="language-option" onclick="changeLanguage('vi')">
                                    <i class="fas fa-flag"></i>
                                    Tiếng Việt
                                </div>
                                <div class="language-option" onclick="changeLanguage('en')">
                                    <i class="fas fa-flag"></i>
                                    English
                                </div>
                            </div>
                        </div>
                        
                        <!-- User Dropdown -->
                        <div class="user-dropdown">
                            <div class="user-icon" id="userDropdown">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="dropdown-menu" id="dropdownMenu">
                                <a href="#" class="dropdown-item">Thông tin cá nhân</a>
                                <a href="#" class="dropdown-item" id="logoutBtn">Đăng xuất</a>
                            </div>
                        </div>
                    </div>
                </header>

                <!-- Content -->
                <div class="content" id="contentArea">
                    <!-- Nội dung sẽ được tải động tại đây -->
                </div>
            </main>
        </div>

        <!-- Support Button -->
        <button class="support-btn" onclick="showSupport()">
            <i class="fas fa-headset"></i>
        </button>

        <script>
            // Nội dung tĩnh (sẽ thay bằng AJAX call để lấy từ backend sau)
            const contentMap = {
                productList: `
                    <div class="table-container">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th><input type="checkbox" class="checkbox" id="selectAll"></th>
                                    <th>⭐</th>
                                    <th>Mã hàng</th>
                                    <th>Tên hàng</th>
                                    <th>Giá bán</th>
                                    <th>Giá vốn</th>
                                    <th>Tồn kho</th>
                                    <th>Khách đặt</th>
                                    <th>Thời gian tạo</th>
                                </tr>
                            </thead>
                            <tbody id="productTable">
                                <tr>
                                    <td><input type="checkbox" class="checkbox"></td>
                                    <td>⭐</td>
                                    <td><span class="status-indicator status-active"></span>PK000016</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="product-icon icon-mouse">
                                                <i class="fas fa-mouse"></i>
                                            </div>
                                            <div>
                                                <div>Chuột không dây</div>
                                                <small style="color: #666;">Logitech M331</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>349,000</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>24/05/2025 19:50</td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox" class="checkbox"></td>
                                    <td>⭐</td>
                                    <td><span class="status-indicator status-active"></span>PK000015</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="product-icon icon-mouse">
                                                <i class="fas fa-mouse"></i>
                                            </div>
                                            <div>
                                                <div>Chuột không dây</div>
                                                <small style="color: #666;">Logitech M331</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>349,000</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>24/05/2025 19:50</td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox" class="checkbox"></td>
                                    <td>⭐</td>
                                    <td><span class="status-indicator status-pending"></span>PK000013</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="product-icon icon-mouse">
                                                <i class="fas fa-mouse"></i>
                                            </div>
                                            <div>
                                                <div>Micro không dây</div>
                                                <small style="color: #666;">Zenbos MZ-201</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>1,090,000</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>24/05/2025 19:50</td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox" class="checkbox"></td>
                                    <td>⭐</td>
                                    <td><span class="status-indicator status-active"></span>PK000011</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="product-icon icon-speaker">
                                                <i class="fas fa-volume-up"></i>
                                            </div>
                                            <div>
                                                <div>Loa Bluetooth JBL Go 3</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>24/05/2025 19:50</td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox" class="checkbox"></td>
                                    <td>⭐</td>
                                    <td><span class="status-indicator status-active"></span>PK000010</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="product-icon icon-speaker">
                                                <i class="fas fa-volume-up"></i>
                                            </div>
                                            <div>
                                                <div>Loa Bluetooth JBL Go 3</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>24/05/2025 19:50</td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox" class="checkbox"></td>
                                    <td>⭐</td>
                                    <td><span class="status-indicator status-inactive"></span>PK000005</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="product-icon icon-headphone">
                                                <i class="fas fa-headphones"></i>
                                            </div>
                                            <div>
                                                <div>Tai nghe AirPods Max</div>
                                                <small style="color: #666;">Fullbox</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>92</td>
                                    <td>0</td>
                                    <td>24/05/2025 19:50</td>
                                </tr>
                                <tr>
                                    <td><input type="checkbox" class="checkbox"></td>
                                    <td>⭐</td>
                                    <td><span class="status-indicator status-inactive"></span>PK000004</td>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="product-icon icon-headphone">
                                                <i class="fas fa-headphones"></i>
                                            </div>
                                            <div>
                                                <div>Tai nghe AirPods Max</div>
                                                <small style="color: #666;">Fullbox</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>0</td>
                                    <td>0</td>
                                    <td>92</td>
                                    <td>0</td>
                                    <td>24/05/2025 19:50</td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="pagination-container">
                            <div class="items-per-page">
                                <span>Hiển thị</span>
                                <select id="itemsPerPage" onchange="changeItemsPerPage()">
                                    <option value="15">15 dòng</option>
                                    <option value="25">25 dòng</option>
                                    <option value="50">50 dòng</option>
                                    <option value="100">100 dòng</option>
                                </select>
                            </div>
                            <div class="pagination">
                                <button onclick="changePage('first')">⏮</button>
                                <button onclick="changePage('prev')">⏪</button>
                                <button class="active">1</button>
                                <button onclick="changePage('next')">⏩</button>
                                <button onclick="changePage('last')">⏭</button>
                            </div>
                            <div class="pagination-info">
                                <span>1 - 15 trong 30 hàng hóa</span>
                            </div>
                        </div>
                    </div>
                `,
                import: `
                    <div class="content">
                        <h2>Nhập Hàng</h2>
                        <form id="importForm" onsubmit="submitImport(event)">
                            <label for="productId">Mã sản phẩm:</label>
                            <input type="text" id="productId" name="productId" required><br><br>
                            <label for="quantity">Số lượng:</label>
                            <input type="number" id="quantity" name="quantity" required><br><br>
                            <button type="submit">Nhập hàng</button>
                        </form>
                    </div>
                `,
                export: `
                    <div class="content">
                        <h2>Xuất Hàng</h2>
                        <form id="exportForm" onsubmit="submitExport(event)">
                            <label for="productId">Mã sản phẩm:</label>
                            <input type="text" id="productId" name="productId" required><br><br>
                            <label for="quantity">Số lượng:</label>
                            <input type="number" id="quantity" name="quantity" required><br><br>
                            <button type="submit">Xuất hàng</button>
                        </form>
                    </div>
                `,
                notifications: `
                    <div class="content">
                        <h2>Thông báo</h2>
                        <ul id="notificationList">
                            <li>Có 3 sản phẩm mới cần nhập kho</li>
                            <li>2 đơn hàng đang chờ xuất</li>
                            <li>Báo cáo tồn kho tuần này đã sẵn sàng</li>
                        </ul>
                    </div>
                `
            };

            // Global variables
            let currentLanguage = 'vi';
            let currentPage = 1;
            let itemsPerPage = 15;
            let allProducts = [];

            // Initialize the application
            document.addEventListener('DOMContentLoaded', function () {
                initializeApp();
                // Tự động hiển thị danh sách hàng hóa khi trang được tải
                const productListLink = document.querySelector('.nav-link.active');
                loadContent('productList', productListLink);
            });

            function initializeApp() {
                setupEventListeners();
                loadProducts();
                setupSearch();
                setupUserDropdown();
            }

            function setupEventListeners() {
                // Select all checkbox
                const selectAll = document.getElementById('selectAll');
                if (selectAll) {
                    selectAll.addEventListener('change', function () {
                        const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
                        checkboxes.forEach(checkbox => {
                            checkbox.checked = this.checked;
                        });
                    });
                }

                // Navigation links
                document.querySelectorAll('.nav-link').forEach(link => {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
                        this.classList.add('active');
                    });
                });
            }

            function setupSearch() {
                const searchInput = document.getElementById('searchInput');
                searchInput.addEventListener('input', function () {
                    const searchTerm = this.value.toLowerCase();
                    filterProducts(searchTerm);
                });
            }

            function filterProducts(searchTerm) {
                const rows = document.querySelectorAll('#productTable tr');
                if (rows.length === 0) return; // Kiểm tra nếu không có bảng sản phẩm
                rows.forEach(row => {
                    const productName = row.querySelector('td:nth-child(4)').textContent.toLowerCase();
                    const productCode = row.querySelector('td:nth-child(3)').textContent.toLowerCase();

                    if (productName.includes(searchTerm) || productCode.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            }

            function loadProducts() {
                console.log('Products loaded');
            }

            function loadContent(section, element) {
                // Cập nhật lớp 'active' cho sidebar
                document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                if (element) {
                    element.classList.add('active');
                } else {
                    // Nếu không có element (trường hợp tải mặc định), đặt active cho mục "Danh sách hàng hóa"
                    document.querySelector('.nav-link[href="#"][onclick*="productList"]').classList.add('active');
                }

                // Cập nhật nội dung
                const contentArea = document.getElementById('contentArea');
                contentArea.innerHTML = contentMap[section];

                // Khởi tạo lại các sự kiện nếu cần
                if (section === 'productList') {
                    setupSearch();
                    setupEventListeners();
                }
            }

            function toggleLanguageDropdown() {
                const languageDropdown = document.getElementById('languageDropdown');
                const userDropdown = document.getElementById('dropdownMenu');
                const isLanguageVisible = languageDropdown.classList.contains('show');
                
                userDropdown.classList.remove('show');
                languageDropdown.classList.toggle('show', !isLanguageVisible);
            }

            function changeLanguage(lang) {
                currentLanguage = lang;
                const languageBtn = document.querySelector('.language-btn');
                const dropdown = document.getElementById('languageDropdown');

                if (lang === 'en') {
                    languageBtn.innerHTML = '<i class="fas fa-globe"></i> English <i class="fas fa-chevron-down"></i>';
                    updateUILanguage('en');
                } else {
                    languageBtn.innerHTML = '<i class="fas fa-globe"></i> Tiếng Việt <i class="fas fa-chevron-down"></i>';
                    updateUILanguage('vi');
                }

                dropdown.classList.remove('show');
            }

            function updateUILanguage(lang) {
                console.log('Language changed to:', lang);
            }

            function setupUserDropdown() {
                document.getElementById('userDropdown').addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    const userDropdown = document.getElementById('dropdownMenu');
                    const languageDropdown = document.getElementById('languageDropdown');
                    const isUserVisible = userDropdown.classList.contains('show');
                    
                    languageDropdown.classList.remove('show');
                    userDropdown.classList.toggle('show', !isUserVisible);
                });

                document.addEventListener('click', function(e) {
                    const userDropdown = document.querySelector('.user-dropdown');
                    const dropdown = document.getElementById('dropdownMenu');
                    
                    if (!userDropdown.contains(e.target)) {
                        dropdown.classList.remove('show');
                    }
                });

                document.getElementById('logoutBtn').addEventListener('click', function(e) {
                    e.preventDefault();
                    handleInstantLogout();
                });
            }

            function handleInstantLogout() {
                document.getElementById('dropdownMenu').classList.remove('show');
                const overlay = createLogoutOverlay();
                
                try {
                    localStorage.clear();
                    sessionStorage.clear();
                } catch (e) {
                    console.log('Storage clear failed:', e);
                }
                
                setTimeout(() => {
                    window.location.href = 'http://localhost:9999/TSMS/starting';
                }, 800);
            }

            function createLogoutOverlay() {
                const overlay = document.createElement('div');
                overlay.style.cssText = `
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.8);
                    backdrop-filter: blur(10px);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 9999;
                    opacity: 0;
                    transition: opacity 0.3s ease;
                `;
                
                const content = document.createElement('div');
                content.style.cssText = `
                    background: rgba(255, 255, 255, 0.95);
                    backdrop-filter: blur(20px);
                    padding: 40px;
                    border-radius: 20px;
                    text-align: center;
                    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                    border: 1px solid rgba(14, 165, 233, 0.1);
                `;
                
                content.innerHTML = `
                    <div style="
                        width: 60px;
                        height: 60px;
                        border: 4px solid rgba(14, 165, 233, 0.2);
                        border-top: 4px solid #0ea5e9;
                        border-radius: 50%;
                        animation: spin 1s linear infinite;
                        margin: 0 auto 20px;
                    "></div>
                    <h3 style="
                        color: #1e293b;
                        font-size: 18px;
                        font-weight: 600;
                        margin-bottom: 10px;
                    ">Đang đăng xuất...</h3>
                    <p style="
                        color: #64748b;
                        font-size: 14px;
                    ">Chuyển hướng đến trang chủ</p>
                `;
                
                const style = document.createElement('style');
                style.textContent = `
                    @keyframes spin {
                        0% { transform: rotate(0deg); }
                        100% { transform: rotate(360deg); }
                    }
                `;
                document.head.appendChild(style);
                
                overlay.appendChild(content);
                document.body.appendChild(overlay);
                
                setTimeout(() => {
                    overlay.style.opacity = '1';
                }, 10);
                
                return overlay;
            }

            function showNotifications() {
                alert('Thông báo:\n- Có 3 sản phẩm mới cần nhập kho\n- 2 đơn hàng đang chờ xuất\n- Báo cáo tồn kho tuần này đã sẵn sàng');
            }

            function changePage(direction) {
                console.log('Changing page:', direction);

                switch (direction) {
                    case 'first':
                        currentPage = 1;
                        break;
                    case 'prev':
                        if (currentPage > 1)
                            currentPage--;
                        break;
                    case 'next':
                        currentPage++;
                        break;
                    case 'last':
                        currentPage = Math.ceil(30 / itemsPerPage);
                        break;
                }

                updatePagination();
            }

            function changeItemsPerPage() {
                const select = document.getElementById('itemsPerPage');
                itemsPerPage = parseInt(select.value);
                currentPage = 1;
                updatePagination();
            }

            function updatePagination() {
                const activeBtn = document.querySelector('.pagination button.active');
                if (activeBtn) {
                    activeBtn.textContent = currentPage;
                }
                console.log(`Page ${currentPage}, ${itemsPerPage} items per page`);
            }

            function showSupport() {
                alert('Hỗ trợ kỹ thuật 24/7\nHotline: 1900-xxxx\nEmail: support@tsms.com');
            }

            document.addEventListener('click', function (event) {
                const dropdown = document.getElementById('languageDropdown');
                const languageSelector = document.querySelector('.language-selector');

                if (!languageSelector.contains(event.target)) {
                    dropdown.classList.remove('show');
                }
            });

            document.addEventListener('keydown', function (e) {
                if (e.ctrlKey && e.key === 'f') {
                    e.preventDefault();
                    document.getElementById('searchInput').focus();
                }

                if (e.ctrlKey && e.key === 'a' && e.target.tagName !== 'INPUT') {
                    e.preventDefault();
                    const selectAll = document.getElementById('selectAll');
                    if (selectAll) selectAll.click();
                }

                if (e.ctrlKey && e.shiftKey && e.key === 'L') {
                    e.preventDefault();
                    handleInstantLogout();
                }
            });

            // Hàm xử lý form nhập/xuất hàng
            function submitImport(event) {
                event.preventDefault();
                alert('Chức năng nhập hàng sẽ được tích hợp với backend!');
            }

            function submitExport(event) {
                event.preventDefault();
                alert('Chức năng xuất hàng sẽ được tích hợp với backend!');
            }
        </script>
    </body>
</html>