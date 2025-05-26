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
                        <a href="#" class="nav-link active">
                            <i class="fas fa-boxes"></i>
                            Danh sách hàng hóa
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">
                            <i class="fas fa-arrow-down"></i>
                            Trang Nhập Hàng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">
                            <i class="fas fa-arrow-up"></i>
                            Trang Xuất Hàng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link">
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
                        <button class="notification-btn" onclick="showNotifications()">
                            <i class="fas fa-bell"></i>
                        </button>
                    </div>
                </header>

                <!-- Content -->
                <div class="content">
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

                        <!-- Pagination -->
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
                </div>
            </main>
        </div>

        <!-- Support Button -->
        <button class="support-btn" onclick="showSupport()">
            <i class="fas fa-headset"></i>
        </button>

        <script>
            // Global variables
            let currentLanguage = 'vi';
            let currentPage = 1;
            let itemsPerPage = 15;
            let allProducts = [];

            // Initialize the application
            document.addEventListener('DOMContentLoaded', function () {
                initializeApp();
            });

            function initializeApp() {
                // Setup event listeners
                setupEventListeners();

                // Load initial data
                loadProducts();

                // Setup search functionality
                setupSearch();
            }

            function setupEventListeners() {
                // Select all checkbox
                document.getElementById('selectAll').addEventListener('change', function () {
                    const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
                    checkboxes.forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });

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
                // This would typically load from a server
                // For demo purposes, products are already in the HTML
                console.log('Products loaded');
            }

            function toggleLanguageDropdown() {
                const dropdown = document.getElementById('languageDropdown');
                dropdown.classList.toggle('show');
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
                // This would update all UI text based on language
                // Implementation would depend on your internationalization approach
                console.log('Language changed to:', lang);
            }

            function showNotifications() {
                alert('Thông báo:\n- Có 3 sản phẩm mới cần nhập kho\n- 2 đơn hàng đang chờ xuất\n- Báo cáo tồn kho tuần này đã sẵn sàng');
            }

            function changePage(direction) {
                // Handle pagination
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
                        currentPage = Math.ceil(30 / itemsPerPage); // 30 is total items
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
                // Update pagination display
                const activeBtn = document.querySelector('.pagination button.active');
                if (activeBtn) {
                    activeBtn.textContent = currentPage;
                }
                console.log(`Page ${currentPage}, ${itemsPerPage} items per page`);
            }

            function showSupport() {
                alert('Hỗ trợ kỹ thuật 24/7\nHotline: 1900-xxxx\nEmail: support@tsms.com');
            }

            // Close dropdown when clicking outside
            document.addEventListener('click', function (event) {
                const dropdown = document.getElementById('languageDropdown');
                const languageSelector = document.querySelector('.language-selector');

                if (!languageSelector.contains(event.target)) {
                    dropdown.classList.remove('show');
                }
            });

            // Add smooth scrolling for better UX
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth'
                        });
                    }
                });
            });

            // Add loading states for better UX
            function showLoading() {
                // Show loading spinner or message
                console.log('Loading...');
            }

            function hideLoading() {
                // Hide loading spinner or message
                console.log('Loading complete');
            }

            // Export/Import functionality
            function exportData() {
                // Export table data to CSV or Excel
                console.log('Exporting data...');
            }

            function importData() {
                // Import data from file
                console.log('Importing data...');
            }

            // Print functionality
            function printTable() {
                window.print();
            }

            // Add keyboard shortcuts
            document.addEventListener('keydown', function (e) {
                // Ctrl+F for search
                if (e.ctrlKey && e.key === 'f') {
                    e.preventDefault();
                    document.getElementById('searchInput').focus();
                }

                // Ctrl+A for select all
                if (e.ctrlKey && e.key === 'a' && e.target.tagName !== 'INPUT') {
                    e.preventDefault();
                    document.getElementById('selectAll').click();
                }
            });
        </script>
    </body>
</html>