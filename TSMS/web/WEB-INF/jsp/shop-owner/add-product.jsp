<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.*" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Thêm sản phẩm mới</title>
    <link rel="stylesheet" href="css/bm-products.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2ecc71;
            --secondary: #6c757d;
            --background: #f8f9fa;
            --white: #ffffff;
            --text: #2d3748;
            --border: #e9ecef;
            --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--background);
            min-height: 100vh;
            color: var(--text);
            line-height: 1.6;
        }

        .main-container {
            max-width: 1200px;
            margin: 20px auto;
            background: var(--white);
            border-radius: 12px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .header-section {
            background: var(--white);
            padding: 20px 30px;
            border-bottom: 1px solid var(--border);
        }

        .header-title {
            color: var(--text);
            font-size: 20px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .tabs-container {
            background: var(--white);
            border-bottom: 1px solid var(--border);
        }

        .tabs {
            display: flex;
            padding: 0 30px;
        }

        .tab {
            padding: 15px 25px;
            cursor: pointer;
            color: var(--secondary);
            font-weight: 500;
            border-bottom: 3px solid transparent;
            transition: var(--transition);
            position: relative;
        }

        .tab:hover {
            color: var(--primary);
        }

        .tab.active {
            color: var(--primary);
            border-bottom-color: var(--primary);
            background: rgba(46, 204, 113, 0.05);
        }

        .form-container {
            padding: 30px;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 25px;
        }

        .form-row.single {
            grid-template-columns: 1fr;
        }

        .form-group {
            position: relative;
        }

        .form-group label {
            font-weight: 500;
            display: block;
            margin-bottom: 8px;
            color: var(--text);
            font-size: 14px;
        }

        .required {
            color: #e74c3c;
            margin-left: 2px;
        }

        .form-group input, 
        .form-group select, 
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ddd;
            background: var(--white);
            transition: var(--transition);
            font-family: 'Poppins', sans-serif;
        }

        .form-group input:focus, 
        .form-group select:focus, 
        .form-group textarea:focus {
            border-color: var(--primary);
            outline: none;
            box-shadow: 0 0 0 3px rgba(46, 204, 113, 0.1);
        }

        .form-group input[type="file"] {
            padding: 8px 12px;
            border: 1px dashed #ddd;
            background: #fafafa;
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            width: 100%;
        }

        .file-input-display {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            border: 1px dashed #ddd;
            border-radius: 6px;
            background: #fafafa;
            cursor: pointer;
            transition: var(--transition);
        }

        .file-input-display:hover {
            border-color: var(--primary);
            background: rgba(46, 204, 113, 0.05);
        }

        .file-input-display input[type="file"] {
            position: absolute;
            left: -9999px;
            opacity: 0;
        }


        .support-info i {
            color: #ffc107;
        }

        .btn-group {
            display: flex;
            gap: 15px;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
            border: none;
            cursor: pointer;
            transition: var(--transition);
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }

        .btn-primary {
            background: var(--primary);
            color: var(--white);
        }

        .btn-primary:hover {
            background: #27ae60;
            transform: translateY(-1px);
        }

        .btn-secondary {
            background: var(--secondary);
            color: var(--white);
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
        }

        .validation-message {
            position: absolute;
            top: 100%;
            left: 0;
            background: #dc3545;
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            margin-top: 5px;
            display: none;
            z-index: 10;
        }

        .validation-message::before {
            content: '';
            position: absolute;
            top: -5px;
            left: 10px;
            width: 0;
            height: 0;
            border-left: 5px solid transparent;
            border-right: 5px solid transparent;
            border-bottom: 5px solid #dc3545;
        }

            @media (max-width: 768px) {
                .form-row {
                    grid-template-columns: 1fr;
                }
                
                .bottom-section {
                    justify-content: center;
                }
                
                .tabs {
                    flex-wrap: wrap;
                }
                
                .tab {
                    flex: 1;
                    text-align: center;
                    min-width: 120px;
                }
            }
    </style>
</head>
<body>
    <jsp:include page="../common/header-so.jsp" />

    <div class="main-container">
        <div class="header-section">
            <h2 class="header-title">
                <i class="fas fa-plus-circle"></i> Thêm sản phẩm mới
            </h2>
        </div>

        <div class="tabs-container">
            <div class="tabs">
                <div class="tab active" onclick="showTab('tab1')">Thông tin</div>
                <div class="tab" onclick="showTab('tab2')">Mô tả chi tiết</div>
                <div class="tab" onclick="showTab('tab3')">Bảo hành, bảo trì</div>
            </div>
        </div>

        <form action="so-products" method="post" enctype="multipart/form-data" id="productForm">
            <input type="hidden" name="action" value="create">

            <div class="form-container">
                <div class="tab-content active" id="tab1">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Tên sản phẩm <span class="required">*</span></label>
                            <input type="text" name="productName" id="productName" required>
                            <div class="validation-message">Vui lòng nhập tên sản phẩm</div>
                        </div>
                        <div class="form-group">
                            <label>Thương hiệu <span class="required">*</span></label>
                            <input type="text" name="brand" id="brand" required>
                            <div class="validation-message">Vui lòng nhập thương hiệu</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Danh mục <span class="required">*</span></label>
                            <input type="text" name="category" id="category" required>
                            <div class="validation-message">Vui lòng điền vào trường này.</div>
                        </div>
                        <div class="form-group">
                            <label>Nhà cung cấp <span class="required">*</span></label>
                            <input type="text" name="supplier" id="supplier" required>
                            <div class="validation-message">Vui lòng nhập nhà cung cấp</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Giá vốn (VNĐ) <span class="required">*</span></label>
                            <input type="number" id="costPrice" name="costPrice" required>
                            <div class="validation-message">Vui lòng nhập giá vốn</div>
                        </div>
                        <div class="form-group">
                            <label>Giá bán (VNĐ) <span class="required">*</span></label>
                            <input type="number" id="retailPrice" name="retailPrice" required>
                            <div class="validation-message">Vui lòng nhập giá bán</div>
                        </div>
                    </div>

                    <div class="form-row single">
                        <div class="form-group">
                            <label>Hình ảnh sản phẩm</label>
                            <div class="file-input-wrapper">
                                <div class="file-input-display" onclick="document.getElementById('imageFile').click()">
                                    <input type="file" name="imageFile" id="imageFile" accept=".jpg,.jpeg,.png,.gif,.bmp,.webp,image/jpeg,image/png,image/gif,image/bmp,image/webp">
                                    <span id="fileDisplayText">Chọn tệp</span>
                                    <span style="margin-left: auto; color: #666;">Không có tệp nào được chọn</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-content" id="tab2">
                    <div class="form-row single">
                        <div class="form-group">
                            <label>Mô tả sản phẩm</label>
                            <textarea name="description" placeholder="Nhập mô tả chi tiết về sản phẩm..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="tab-content" id="tab3">
                    <div class="form-row">
                        <div class="form-group">
                            <label>Số serial/IMEI</label>
                            <input type="text" name="serialNum" placeholder="Nhập số serial hoặc IMEI">
                        </div>
                        <div class="form-group">
                            <label>Thời gian bảo hành</label>
                            <input type="text" name="warrantyPeriod" placeholder="VD: 12 tháng, 2 năm">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Số lượng nhập kho <span class="required">*</span></label>
                            <input type="number" name="quantity" id="quantity" min="1" value="1" required>
                            <div class="validation-message">Vui lòng nhập số lượng</div>
                        </div>
                        <div class="form-group">
                            <label>Trạng thái sản phẩm</label>
                            <select name="isActive">
                                <option value="1">Đang kinh doanh</option>
                                <option value="0">Không kinh doanh</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <div class="bottom-section">
                <div class="btn-group">
                    <a href="so-products" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Hủy
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Lưu sản phẩm
                    </button>
                </div>
            </div>
        </form>
    </div>

    <script>
        function showTab(tabId) {
            // Remove active class from all tabs and contents
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            
            // Add active class to selected tab and content
            document.getElementById(tabId).classList.add('active');
            event.target.classList.add('active');
        }

        // File input handling with validation
        document.getElementById('imageFile').addEventListener('change', function() {
            const fileDisplay = document.getElementById('fileDisplayText').nextElementSibling;
            const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'];
            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/bmp', 'image/webp'];
            
            if (this.files && this.files[0]) {
                const file = this.files[0];
                const fileName = file.name.toLowerCase();
                const fileType = file.type.toLowerCase();
                
                // Check file extension and MIME type
                const hasValidExtension = allowedExtensions.some(ext => fileName.endsWith(ext));
                const hasValidType = allowedTypes.includes(fileType);
                
                if (hasValidExtension && hasValidType) {
                    // Check file size (max 5MB)
                    if (file.size > 5 * 1024 * 1024) {
                        alert('Kích thước file không được vượt quá 5MB!');
                        this.value = '';
                        fileDisplay.textContent = 'Không có tệp nào được chọn';
                        fileDisplay.style.color = '#666';
                        return;
                    }
                    
                    fileDisplay.textContent = file.name;
                    fileDisplay.style.color = '#2ecc71';
                } else {
                    alert('Chỉ cho phép các định dạng ảnh: JPG, JPEG, PNG, GIF, BMP, WEBP!');
                    this.value = '';
                    fileDisplay.textContent = 'Không có tệp nào được chọn';
                    fileDisplay.style.color = '#666';
                }
            } else {
                fileDisplay.textContent = 'Không có tệp nào được chọn';
                fileDisplay.style.color = '#666';
            }
        });

        // Form validation
        document.getElementById('productForm').addEventListener('submit', function(e) {
            let isValid = true;
            
            // Check required fields
            const requiredFields = ['productName', 'brand', 'category', 'supplier', 'costPrice', 'retailPrice', 'quantity'];
            requiredFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                const message = field.parentNode.querySelector('.validation-message');
                
                if (!field.value.trim()) {
                    message.style.display = 'block';
                    field.style.borderColor = '#dc3545';
                    isValid = false;
                } else {
                    message.style.display = 'none';
                    field.style.borderColor = '#ddd';
                }
            });

            // Check price validation
            const costPrice = parseFloat(document.getElementById('costPrice').value);
            const retailPrice = parseFloat(document.getElementById('retailPrice').value);
            const quantity = parseInt(document.getElementById('quantity').value);
            
            if (costPrice && retailPrice && costPrice >= retailPrice) {
                alert('Giá bán phải lớn hơn giá vốn!');
                isValid = false;
            }
            
            if (quantity && quantity < 1) {
                alert('Số lượng phải lớn hơn 0!');
                isValid = false;
            }

            if (!isValid) {
                e.preventDefault();
                return false;
            }
        });

        // Hide validation messages on input
        document.querySelectorAll('input[required]').forEach(input => {
            input.addEventListener('input', function() {
                const message = this.parentNode.querySelector('.validation-message');
                if (this.value.trim()) {
                    message.style.display = 'none';
                    this.style.borderColor = '#ddd';
                }
            });
        });

        // Number formatting (optional)
        function formatNumber(input) {
            let value = input.value.replace(/\D/g, '');
            if (value) {
                input.value = new Intl.NumberFormat('vi-VN').format(value);
            }
        }

        // Add event listeners for price formatting
        document.getElementById('costPrice').addEventListener('blur', function() {
            if (this.value) {
                formatNumber(this);
            }
        });

        document.getElementById('retailPrice').addEventListener('blur', function() {
            if (this.value) {
                formatNumber(this);
            }
        });
    </script>
</body>
</html>