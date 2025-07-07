// Global variables
let products = [];
let productCounter = 0;

// DOM elements
const uploadSection = document.getElementById('uploadSection');
const productsSection = document.getElementById('productsSection');
const uploadBtn = document.getElementById('uploadBtn');
const fileInput = document.getElementById('fileInput');
const uploadArea = document.getElementById('uploadArea');
const addProductBtn = document.getElementById('addProductBtn');
const addProductModal = document.getElementById('addProductModal');
const searchInput = document.getElementById('searchInput');

// Initialize when page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeEventListeners();
    setupDragAndDrop();
    setupKeyboardShortcuts();
    showUploadSection();
});

// Event listeners
function initializeEventListeners() {
    // Upload functionality
    document.getElementById('uploadBtn').addEventListener('click', () => {
        document.getElementById('fileInput').click();
    });
    
    document.getElementById('fileInput').addEventListener('change', handleFileUpload);
    document.getElementById('downloadTemplate').addEventListener('click', downloadTemplate);
    
    // Product management
    document.getElementById('addProductBtn').addEventListener('click', openAddProductModal);
    
    // Modal events
    document.getElementById('addProductModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeAddProductModal();
        }
    });
    
    // Actions
    document.getElementById('saveBtn').addEventListener('click', saveRequest);
    document.getElementById('submitBtn').addEventListener('click', submitRequest);
    document.getElementById('searchInput').addEventListener('input', handleSearch);
    document.getElementById('selectAll').addEventListener('change', handleSelectAll);
    document.getElementById('deleteSelected').addEventListener('click', deleteSelectedProducts);
    
    // Discount calculation
    document.getElementById('discountAmount').addEventListener('input', updateSummary);
}

// Drag and drop setup
function setupDragAndDrop() {
    const uploadArea = document.getElementById('uploadArea');
    
    uploadArea.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.classList.add('dragover');
    });
    
    uploadArea.addEventListener('dragleave', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
    });
    
    uploadArea.addEventListener('drop', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
        
        const files = e.dataTransfer.files;
        if (files.length > 0 && isExcelFile(files[0])) {
            processExcelFile(files[0]);
        } else {
            showNotification('Vui lòng chọn file Excel (.xlsx, .xls)', 'error');
        }
    });
}

// Keyboard shortcuts
function setupKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        if (e.key === 'F3') {
            e.preventDefault();
            document.getElementById('searchInput').focus();
        }
        
        if (e.ctrlKey && e.key === 's') {
            e.preventDefault();
            saveRequest();
        }
        
        if (e.key === 'Escape') {
            closeAddProductModal();
        }
    });
}

// File upload handling
function handleFileUpload(e) {
    const file = e.target.files[0];
    if (file && isExcelFile(file)) {
        processExcelFile(file);
    } else {
        showNotification('Vui lòng chọn file Excel (.xlsx, .xls)', 'error');
    }
}

function isExcelFile(file) {
    const allowedTypes = [
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'application/vnd.ms-excel'
    ];
    return allowedTypes.includes(file.type) || 
           file.name.endsWith('.xlsx') || 
           file.name.endsWith('.xls');
}

function processExcelFile(file) {
    showNotification('Đang xử lý file Excel...', 'info');
    
    // Simulate processing delay
    setTimeout(() => {
        const sampleProducts = [
            {
                id: ++productCounter,
                code: 'IP001',
                name: 'iPhone 15 Pro Max 256GB',
                unit: 'Cái',
                quantity: 5,
                price: 25000000,
                discount: 0
            },
            {
                id: ++productCounter,
                code: 'SM001',
                name: 'Samsung Galaxy S24 Ultra 512GB',
                unit: 'Cái',
                quantity: 3,
                price: 22000000,
                discount: 0
            },
            {
                id: ++productCounter,
                code: 'AW001',
                name: 'Apple Watch Ultra 2',
                unit: 'Cái',
                quantity: 2,
                price: 18000000,
                discount: 0
            },
            {
                id: ++productCounter,
                code: 'MB001',
                name: 'MacBook Pro 14 inch M3 Pro',
                unit: 'Cái',
                quantity: 1,
                price: 45000000,
                discount: 0
            }
        ];
        
        products = sampleProducts;
        showProductsSection();
        updateProductsTable();
        updateSummary();
        showNotification(`Đã thêm ${sampleProducts.length} sản phẩm từ file Excel`, 'success');
    }, 1500);
}

// UI state management
function showUploadSection() {
    document.getElementById('uploadSection').style.display = 'block';
    document.getElementById('productsSection').style.display = 'none';
}

function showProductsSection() {
    document.getElementById('uploadSection').style.display = 'none';
    document.getElementById('productsSection').style.display = 'block';
}

// Product modal management
function openAddProductModal() {
    const modal = document.getElementById('addProductModal');
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
    
    // Clear form
    document.getElementById('productCode').value = '';
    document.getElementById('productName').value = '';
    document.getElementById('productUnit').value = 'Cái';
    document.getElementById('productQuantity').value = '';
    document.getElementById('productPrice').value = '';
    document.getElementById('productDiscount').value = '';
    
    // Focus first input
    document.getElementById('productCode').focus();
}

function closeAddProductModal() {
    const modal = document.getElementById('addProductModal');
    modal.classList.remove('show');
    document.body.style.overflow = 'auto';
    
    // Reset modal state
    document.querySelector('#addProductModal .modal-header h3').textContent = 'Thêm sản phẩm vào yêu cầu';
    document.querySelector('#addProductModal .btn-add').textContent = 'Thêm vào yêu cầu';
    document.querySelector('#addProductModal .btn-add').onclick = addProduct;
}

function addProduct() {
    const code = document.getElementById('productCode').value.trim();
    const name = document.getElementById('productName').value.trim();
    const unit = document.getElementById('productUnit').value;
    const quantity = parseInt(document.getElementById('productQuantity').value) || 0;
    const price = parseFloat(document.getElementById('productPrice').value) || 0;
    const discount = parseFloat(document.getElementById('productDiscount').value) || 0;
    
    // Validation
    if (!code || !name || quantity <= 0) {
        showNotification('Vui lòng điền đầy đủ thông tin bắt buộc', 'error');
        return;
    }
    
    // Check duplicate code
    if (products.some(p => p.code === code)) {
        showNotification('Mã hàng đã tồn tại trong yêu cầu', 'error');
        return;
    }
    
    const newProduct = {
        id: ++productCounter,
        code,
        name,
        unit,
        quantity,
        price,
        discount
    };
    
    products.push(newProduct);
    
    if (products.length === 1) {
        showProductsSection();
    }
    
    updateProductsTable();
    updateSummary();
    closeAddProductModal();
    showNotification('Đã thêm sản phẩm vào yêu cầu thành công', 'success');
}

function editProduct(id) {
    const product = products.find(p => p.id === id);
    if (!product) return;
    
    // Fill form
    document.getElementById('productCode').value = product.code;
    document.getElementById('productName').value = product.name;
    document.getElementById('productUnit').value = product.unit;
    document.getElementById('productQuantity').value = product.quantity;
    document.getElementById('productPrice').value = product.price;
    document.getElementById('productDiscount').value = product.discount;
    
    // Change modal title and button
    document.querySelector('#addProductModal .modal-header h3').textContent = 'Sửa sản phẩm trong yêu cầu';
    document.querySelector('#addProductModal .btn-add').textContent = 'Cập nhật';
    document.querySelector('#addProductModal .btn-add').onclick = () => updateProduct(id);
    
    openAddProductModal();
}

function updateProduct(id) {
    const code = document.getElementById('productCode').value.trim();
    const name = document.getElementById('productName').value.trim();
    const unit = document.getElementById('productUnit').value;
    const quantity = parseInt(document.getElementById('productQuantity').value) || 0;
    const price = parseFloat(document.getElementById('productPrice').value) || 0;
    const discount = parseFloat(document.getElementById('productDiscount').value) || 0;
    
    // Validation
    if (!code || !name || quantity <= 0) {
        showNotification('Vui lòng điền đầy đủ thông tin bắt buộc', 'error');
        return;
    }
    
    // Check duplicate code (except current)
    if (products.some(p => p.code === code && p.id !== id)) {
        showNotification('Mã hàng đã tồn tại trong yêu cầu', 'error');
        return;
    }
    
    const productIndex = products.findIndex(p => p.id === id);
    if (productIndex !== -1) {
        products[productIndex] = {
            ...products[productIndex],
            code, name, unit, quantity, price, discount
        };
        
        updateProductsTable();
        updateSummary();
        closeAddProductModal();
        showNotification('Đã cập nhật sản phẩm thành công', 'success');
    }
}

function deleteProduct(id) {
    if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi yêu cầu?')) {
        products = products.filter(p => p.id !== id);
        updateProductsTable();
        updateSummary();
        
        if (products.length === 0) {
            showUploadSection();
        }
        
        showNotification('Đã xóa sản phẩm khỏi yêu cầu thành công', 'success');
    }
}

// Table management
function updateProductsTable() {
    const tbody = document.getElementById('productsTableBody');
    
    if (products.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="10" class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>Chưa có sản phẩm nào trong yêu cầu</h3>
                    <p>Thêm sản phẩm từ file Excel hoặc thêm thủ công</p>
                </td>
            </tr>
        `;
        return;
    }
    
    tbody.innerHTML = products.map((product, index) => `
        <tr>
            <td class="checkbox-col">
                <input type="checkbox" class="product-checkbox" value="${product.id}">
            </td>
            <td>${index + 1}</td>
            <td>${product.code}</td>
            <td>${product.name}</td>
            <td>${product.unit}</td>
            <td>
                <input type="number" value="${product.quantity}" min="1" 
                       onchange="updateProductQuantity(${product.id}, this.value)"
                       style="width: 80px; padding: 4px; border: 1px solid #e2e8f0; border-radius: 4px;">
            </td>
            <td>
                <input type="number" value="${product.price}" min="0" 
                       onchange="updateProductPrice(${product.id}, this.value)"
                       style="width: 120px; padding: 4px; border: 1px solid #e2e8f0; border-radius: 4px;"
                       placeholder="Kho sẽ điền giá">
            </td>
            <td>
                <input type="number" value="${product.discount}" min="0" 
                       onchange="updateProductDiscount(${product.id}, this.value)"
                       style="width: 80px; padding: 4px; border: 1px solid #e2e8f0; border-radius: 4px;">
            </td>
            <td><strong>${formatCurrency(calculateProductTotal(product))}</strong></td>
            <td class="action-col">
                <button class="action-btn btn-edit" onclick="editProduct(${product.id})" title="Sửa">
                    <i class="fas fa-edit"></i>
                </button>
                <button class="action-btn btn-delete" onclick="deleteProduct(${product.id})" title="Xóa">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
    
    document.getElementById('totalProducts').textContent = products.length;
}

// Product value updates
function updateProductQuantity(id, value) {
    const product = products.find(p => p.id === id);
    if (product) {
        product.quantity = parseInt(value) || 1;
        updateProductsTable();
        updateSummary();
    }
}

function updateProductPrice(id, value) {
    const product = products.find(p => p.id === id);
    if (product) {
        product.price = parseFloat(value) || 0;
        updateProductsTable();
        updateSummary();
    }
}

function updateProductDiscount(id, value) {
    const product = products.find(p => p.id === id);
    if (product) {
        product.discount = parseFloat(value) || 0;
        updateProductsTable();
        updateSummary();
    }
}

function calculateProductTotal(product) {
    const subtotal = product.quantity * product.price;
    return subtotal - product.discount;
}

function updateSummary() {
    const subtotal = products.reduce((sum, product) => sum + calculateProductTotal(product), 0);
    const discountAmount = parseFloat(document.getElementById('discountAmount').value) || 0;
    const totalAmount = subtotal - discountAmount;
    
    document.getElementById('totalAmount').textContent = formatCurrency(subtotal);
    document.getElementById('sidebarTotal').textContent = formatCurrency(subtotal);
    document.getElementById('totalPayable').textContent = formatCurrency(totalAmount);
}

// Search functionality
function handleSearch(e) {
    const searchTerm = e.target.value.toLowerCase().trim();
    
    if (!searchTerm) {
        updateProductsTable();
        return;
    }
    
    const filteredProducts = products.filter(product => 
        product.code.toLowerCase().includes(searchTerm) ||
        product.name.toLowerCase().includes(searchTerm)
    );
    
    // Show filtered results
    const originalProducts = [...products];
    products = filteredProducts;
    updateProductsTable();
    products = originalProducts;
}

// Select all functionality
function handleSelectAll(e) {
    const checkboxes = document.querySelectorAll('.product-checkbox');
    checkboxes.forEach(checkbox => {
        checkbox.checked = e.target.checked;
    });
}

function deleteSelectedProducts() {
    const selectedCheckboxes = document.querySelectorAll('.product-checkbox:checked');
    if (selectedCheckboxes.length === 0) {
        showNotification('Vui lòng chọn sản phẩm cần xóa', 'warning');
        return;
    }
    
    if (confirm(`Bạn có chắc muốn xóa ${selectedCheckboxes.length} sản phẩm đã chọn khỏi yêu cầu?`)) {
        const selectedIds = Array.from(selectedCheckboxes).map(cb => parseInt(cb.value));
        products = products.filter(p => !selectedIds.includes(p.id));
        
        updateProductsTable();
        updateSummary();
        
        if (products.length === 0) {
            showUploadSection();
        }
        
        showNotification(`Đã xóa ${selectedCheckboxes.length} sản phẩm khỏi yêu cầu thành công`, 'success');
    }
}

// Request actions
function saveRequest() {
    if (products.length === 0) {
        showNotification('Vui lòng thêm ít nhất một sản phẩm vào yêu cầu', 'warning');
        return;
    }
    
    const warehouseId = document.getElementById('warehouseId').value;
    if (!warehouseId) {
        showNotification('Vui lòng chọn kho nhận hàng', 'warning');
        return;
    }
    
    const supplierId = document.getElementById('supplierId').value;
    if (!supplierId) {
        showNotification('Vui lòng chọn nhà cung cấp', 'warning');
        return;
    }
    
    // Prepare form data
    const formData = new FormData();
    formData.append('action', 'save');
    formData.append('warehouseId', warehouseId);
    formData.append('supplierId', supplierId);
    formData.append('orderCode', document.querySelector('input[name="orderCode"]').value);
    formData.append('notes', document.querySelector('textarea[name="notes"]').value);
    formData.append('priority', document.querySelector('select[name="priority"]').value);
    formData.append('discountAmount', document.getElementById('discountAmount').value);
    formData.append('products', JSON.stringify(products));
    
    showNotification('Đang lưu nháp yêu cầu nhập hàng...', 'info');
    
    // Submit to server
    fetch('nhap-hang', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showNotification('Đã lưu nháp yêu cầu nhập hàng thành công', 'success');
        } else {
            showNotification(data.message || 'Có lỗi xảy ra khi lưu yêu cầu', 'error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        showNotification('Có lỗi xảy ra khi lưu yêu cầu', 'error');
    });
}

function submitRequest() {
    if (products.length === 0) {
        showNotification('Vui lòng thêm ít nhất một sản phẩm vào yêu cầu', 'warning');
        return;
    }
    
    const warehouseId = document.getElementById('warehouseId').value;
    if (!warehouseId) {
        showNotification('Vui lòng chọn kho nhận hàng', 'warning');
        return;
    }
    
    const supplierId = document.getElementById('supplierId').value;
    if (!supplierId) {
        showNotification('Vui lòng chọn nhà cung cấp', 'warning');
        return;
    }
    
    if (confirm('Bạn có chắc muốn gửi yêu cầu nhập hàng này đến kho? Sau khi gửi sẽ không thể chỉnh sửa.')) {
        const formData = new FormData();
        formData.append('action', 'submit');
        formData.append('warehouseId', warehouseId);
        formData.append('supplierId', supplierId);
        formData.append('orderCode', document.querySelector('input[name="orderCode"]').value);
        formData.append('notes', document.querySelector('textarea[name="notes"]').value);
        formData.append('priority', document.querySelector('select[name="priority"]').value);
        formData.append('discountAmount', document.getElementById('discountAmount').value);
        formData.append('products', JSON.stringify(products));
        
        showNotification('Đang gửi yêu cầu nhập hàng...', 'info');
        
        fetch('nhap-hang', {
            method: 'POST',
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                showNotification('Đã gửi yêu cầu nhập hàng thành công', 'success');
                setTimeout(() => {
                    window.location.href = 'so-overview'; // Redirect to overview
                }, 2000);
            } else {
                showNotification(data.message || 'Có lỗi xảy ra khi gửi yêu cầu', 'error');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification('Có lỗi xảy ra khi gửi yêu cầu', 'error');
        });
    }
}

// Download template
function downloadTemplate(e) {
    e.preventDefault();
    
    const csvContent = `STT,Mã hàng,Tên hàng,Đơn vị tính,Số lượng yêu cầu,Đơn giá dự kiến,Giảm giá
1,IP001,iPhone 15 Pro Max 256GB,Cái,5,25000000,0
2,SM001,Samsung Galaxy S24 Ultra 512GB,Cái,3,22000000,0
3,AW001,Apple Watch Ultra 2,Cái,2,18000000,0`;
    
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', 'mau_yeu_cau_nhap_hang.csv');
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('Đã tải file mẫu yêu cầu nhập hàng thành công', 'success');
}

// Priority display
function getPriorityBadge(priority) {
    const badges = {
        'normal': '<span class="priority-badge priority-normal">Bình thường</span>',
        'high': '<span class="priority-badge priority-high">Cao</span>',
        'urgent': '<span class="priority-badge priority-urgent">Khẩn cấp</span>'
    };
    return badges[priority] || badges['normal'];
}

// Utility functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND'
    }).format(amount);
}

function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    
    const icons = {
        'success': 'check-circle',
        'error': 'exclamation-circle',
        'warning': 'exclamation-triangle',
        'info': 'info-circle'
    };
    
    notification.innerHTML = `
        <div style="display: flex; align-items: center; gap: 8px;">
            <i class="fas fa-${icons[type] || 'info-circle'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    // Show notification
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    // Hide notification after 4 seconds (longer for import requests)
    setTimeout(() => {
        notification.classList.remove('show');
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 4000);
}

// Auto-save functionality (save draft every 2 minutes)
let autoSaveInterval;

function startAutoSave() {
    if (autoSaveInterval) {
        clearInterval(autoSaveInterval);
    }
    
    autoSaveInterval = setInterval(() => {
        if (products.length > 0) {
            const warehouseId = document.getElementById('warehouseId').value;
            const supplierId = document.getElementById('supplierId').value;
            
            if (warehouseId && supplierId) {
                // Silent auto-save
                const formData = new FormData();
                formData.append('action', 'autosave');
                formData.append('warehouseId', warehouseId);
                formData.append('supplierId', supplierId);
                formData.append('orderCode', document.querySelector('input[name="orderCode"]').value);
                formData.append('notes', document.querySelector('textarea[name="notes"]').value);
                formData.append('priority', document.querySelector('select[name="priority"]').value);
                formData.append('discountAmount', document.getElementById('discountAmount').value);
                formData.append('products', JSON.stringify(products));
                
                fetch('nhap-hang', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        console.log('Auto-saved draft successfully');
                    }
                })
                .catch(error => {
                    console.error('Auto-save error:', error);
                });
            }
        }
    }, 120000); // Auto-save every 2 minutes
}

// Start auto-save when products are added
function enableAutoSave() {
    if (products.length > 0 && !autoSaveInterval) {
        startAutoSave();
    }
}

// Modify the addProduct and other functions to enable auto-save
const originalAddProduct = addProduct;
addProduct = function() {
    const result = originalAddProduct.apply(this, arguments);
    enableAutoSave();
    return result;
};