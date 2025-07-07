// Global variables
let products = [];
let productCounter = 0;

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
    document.getElementById('saveBtn').addEventListener('click', saveInvoice);
    document.getElementById('completeBtn').addEventListener('click', completeInvoice);
    document.getElementById('searchInput').addEventListener('input', handleSearch);
    document.getElementById('selectAll').addEventListener('change', handleSelectAll);
    document.getElementById('deleteSelected').addEventListener('click', deleteSelectedProducts);
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
            saveInvoice();
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
                code: 'DH000002',
                name: 'Apple Watch Series 9 GPS + Cellular 45mm',
                unit: 'Cái',
                quantity: 1,
                price: 0,
                discount: 0
            },
            {
                id: ++productCounter,
                code: 'DH000003',
                name: 'Apple Watch Series 9 GPS + Cellular 45mm',
                unit: 'Cái',
                quantity: 1,
                price: 0,
                discount: 0
            },
            {
                id: ++productCounter,
                code: 'LT000001',
                name: 'Macbook Air 13 inch M2 256GB',
                unit: 'Cái',
                quantity: 1,
                price: 0,
                discount: 0
            },
            {
                id: ++productCounter,
                code: 'PK000004',
                name: 'Tai nghe AirPods Max Fullbox',
                unit: 'Cái',
                quantity: 1,
                price: 0,
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
    document.querySelector('#addProductModal .modal-header h3').textContent = 'Thêm sản phẩm';
    document.querySelector('#addProductModal .btn-add').textContent = 'Thêm';
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
        showNotification('Mã hàng đã tồn tại', 'error');
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
    showNotification('Đã thêm sản phẩm thành công', 'success');
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
    document.querySelector('#addProductModal .modal-header h3').textContent = 'Sửa sản phẩm';
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
        showNotification('Mã hàng đã tồn tại', 'error');
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
    if (confirm('Bạn có chắc muốn xóa sản phẩm này?')) {
        products = products.filter(p => p.id !== id);
        updateProductsTable();
        updateSummary();
        
        if (products.length === 0) {
            showUploadSection();
        }
        
        showNotification('Đã xóa sản phẩm thành công', 'success');
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
                    <h3>Chưa có sản phẩm nào</h3>
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
                       style="width: 100px; padding: 4px; border: 1px solid #e2e8f0; border-radius: 4px;">
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
    const totalAmount = products.reduce((sum, product) => sum + calculateProductTotal(product), 0);
    
    document.getElementById('totalAmount').textContent = formatCurrency(totalAmount);
    document.getElementById('sidebarTotal').textContent = formatCurrency(totalAmount);
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
    
    if (confirm(`Bạn có chắc muốn xóa ${selectedCheckboxes.length} sản phẩm đã chọn?`)) {
        const selectedIds = Array.from(selectedCheckboxes).map(cb => parseInt(cb.value));
        products = products.filter(p => !selectedIds.includes(p.id));
        
        updateProductsTable();
        updateSummary();
        
        if (products.length === 0) {
            showUploadSection();
        }
        
        showNotification(`Đã xóa ${selectedCheckboxes.length} sản phẩm thành công`, 'success');
    }
}

// Invoice actions
function saveInvoice() {
    if (products.length === 0) {
        showNotification('Vui lòng thêm ít nhất một sản phẩm', 'warning');
        return;
    }
    
    showNotification('Đang lưu phiếu nhập...', 'info');
    
    setTimeout(() => {
        showNotification('Đã lưu phiếu nhập thành công', 'success');
    }, 1000);
}

function completeInvoice() {
    if (products.length === 0) {
        showNotification('Vui lòng thêm ít nhất một sản phẩm', 'warning');
        return;
    }
    
    const productsWithoutPrice = products.filter(p => p.price <= 0);
    if (productsWithoutPrice.length > 0) {
        showNotification('Vui lòng nhập đơn giá cho tất cả sản phẩm', 'warning');
        return;
    }
    
    if (confirm('Bạn có chắc muốn hoàn thành phiếu nhập này?')) {
        showNotification('Đang hoàn thành phiếu nhập...', 'info');
        
        setTimeout(() => {
            showNotification('Đã hoàn thành phiếu nhập thành công', 'success');
        }, 1500);
    }
}

// Download template
function downloadTemplate(e) {
    e.preventDefault();
    
    const csvContent = `STT,Mã hàng,Tên hàng,Đơn vị tính,Số lượng,Đơn giá,Giảm giá
1,SP001,Sản phẩm mẫu 1,Cái,10,100000,0
2,SP002,Sản phẩm mẫu 2,Chiếc,5,200000,10000`;
    
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    link.setAttribute('href', url);
    link.setAttribute('download', 'mau_nhap_hang.csv');
    link.style.visibility = 'hidden';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('Đã tải file mẫu thành công', 'success');
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
    notification.className = `notification notification-${type}`;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 12px 20px;
        background: ${type === 'success' ? '#22c55e' : type === 'error' ? '#ef4444' : type === 'warning' ? '#f59e0b' : '#3b82f6'};
        color: white;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        z-index: 1001;
        transform: translateX(100%);
        transition: transform 0.3s ease;
        max-width: 300px;
        font-size: 14px;
    `;
    
    notification.innerHTML = `
        <div style="display: flex; align-items: center; gap: 8px;">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : type === 'warning' ? 'exclamation-triangle' : 'info-circle'}"></i>
            <span>${message}</span>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.transform = 'translateX(0)';
    }, 100);
    
    setTimeout(() => {
        notification.style.transform = 'translateX(100%)';
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 300);
    }, 3000);
}