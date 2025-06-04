// TSMS Cashier POS System JavaScript

class TSMSCashier {
    constructor() {
        this.cart = [];
        this.products = [];
        this.currentCustomer = null;
        this.init();
    }

    async init() {
        await this.fetchProducts();
        this.bindEvents();
        this.updateSummary();
        this.loadProducts();
    }

    async fetchProducts() {
        try {
            const response = await fetch('/TSMS/products-json'); 
            if (!response.ok)
                throw new Error("Lỗi khi fecth");

            const data = await response.json();
            this.products = data;

            console.log("Loaded products:", this.products);
        } catch (error) {
            console.error("Error fetching products:", error);
        }
    }

    bindEvents() {
        // Product card click events
        document.addEventListener('click', (e) => {
            if (e.target.closest('.add-to-cart')) {
                e.preventDefault();
                const productCard = e.target.closest('.product-card');
                const productId = parseInt(productCard.dataset.productId);
                console.log(productId);
                this.addToCart(productId);
            }
        });

        // Quantity control events
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('qty-btn')) {
                const isIncrement = e.target.textContent === '+';
                const row = e.target.closest('.item-row');
                const quantitySpan = row.querySelector('.quantity');
                let quantity = parseInt(quantitySpan.textContent);

                if (isIncrement) {
                    quantity++;
                } else if (quantity > 1) {
                    quantity--;
                }

                quantitySpan.textContent = quantity;
                this.updateRowTotal(row);
                this.updateSummary();
            }
        });

        // Delete item events
        document.addEventListener('click', (e) => {
            if (e.target.closest('.delete-btn')) {
                const row = e.target.closest('.item-row');
                this.showDeleteConfirmation(() => {
                    row.remove();
                    this.updateSummary();
                });
            }
        });

        // Search functionality
        const searchInput = document.querySelector('.search-input');
        if (searchInput) {
            searchInput.addEventListener('input', (e) => {
                this.searchProducts(e.target.value);
            });
        }

        // Customer search
        const customerInput = document.querySelector('.customer-input');
        if (customerInput) {
            customerInput.addEventListener('input', (e) => {
                this.searchCustomer(e.target.value);
            });
        }

        // Complete transaction
        const completeBtn = document.querySelector('.complete-btn');
        if (completeBtn) {
            completeBtn.addEventListener('click', () => {
                this.completeTransaction();
            });
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', (e) => {
            if (e.key === 'F3') {
                e.preventDefault();
                document.querySelector('.search-input')?.focus();
            } else if (e.key === 'F4') {
                e.preventDefault();
                document.querySelector('.customer-input')?.focus();
            }
        });
    }

    addToCart(productId) {
        const product = this.products.find(p => p.productDetailId === productId);
        if (!product)
            return;

        // Check if product already exists in invoice table
        const existingRow = Array.from(document.querySelectorAll('.item-row')).find(row => {
            const code = row.cells[1].textContent;
            return code === product.code;
        });

        if (existingRow) {
            // Increase quantity
            const quantitySpan = existingRow.querySelector('.quantity');
            const currentQty = parseInt(quantitySpan.textContent);
            quantitySpan.textContent = currentQty + 1;
            this.updateRowTotal(existingRow);
        } else {
            // Add new row
            this.addNewInvoiceRow(product);
        }

        this.updateSummary();
        this.showNotification(`Đã thêm ${product.name} vào hóa đơn`);
    }

    addNewInvoiceRow(product) {
        const tbody = document.querySelector('.invoice-table tbody');
        const rowCount = tbody.children.length;

        const row = document.createElement('tr');
        row.className = 'item-row';
        row.innerHTML = `
            <td>${rowCount + 1}</td>
            <td>${product.serialNum}</td>
            <td>${product.description}</td>
            <td>
                <div class="quantity-controls">
                    <button class="qty-btn">-</button>
                    <span class="quantity">1</span>
                    <button class="qty-btn">+</button>
                </div>
            </td>
            <td class="price">${this.formatCurrency(product.retailPrice)}</td>
            <td class="total">${this.formatCurrency(product.retailPrice)}</td>
            <td>
                <button class="delete-btn">
                    <i class="fas fa-trash"></i>
                </button>
            </td>
        `;

        tbody.appendChild(row);
    }

    updateRowTotal(row) {
        const quantity = parseInt(row.querySelector('.quantity').textContent);
        const priceText = row.querySelector('.price').textContent;
        const price = this.parseCurrency(priceText);
        const total = quantity * price;

        row.querySelector('.total').textContent = this.formatCurrency(total);
    }

    updateSummary() {
        let totalQuantity = 0;
        let subtotal = 0;

        document.querySelectorAll('.item-row').forEach(row => {
            const quantity = parseInt(row.querySelector('.quantity').textContent);
            const total = this.parseCurrency(row.querySelector('.total').textContent);

            totalQuantity += quantity;
            subtotal += total;
        });

        // Update summary display
        const summaryRows = document.querySelectorAll('.summary-row');
        if (summaryRows[0]) {
            summaryRows[0].querySelector('.summary-value').textContent = `${totalQuantity} sản phẩm`;
        }
        if (summaryRows[1]) {
            summaryRows[1].querySelector('.summary-value').textContent = this.formatCurrency(subtotal);
        }
        if (summaryRows[3]) {
            summaryRows[3].querySelector('.summary-value').textContent = this.formatCurrency(subtotal);
        }
    }

    searchProducts(query) {
        const productCards = document.querySelectorAll('.product-card');

        productCards.forEach(card => {
            const productName = card.querySelector('h4').textContent.toLowerCase();
            const isVisible = productName.includes(query.toLowerCase());
            card.style.display = isVisible ? 'block' : 'none';
        });
    }

    searchCustomer(query) {
        // Implement customer search logic
        console.log(`Tìm kiếm khách hàng: ${query}`);
        // You can add customer search functionality here
    }

    completeTransaction() {
        const rows = document.querySelectorAll('.item-row');
        if (rows.length === 0) {
            this.showNotification('Chưa có sản phẩm nào trong hóa đơn!', 'error');
            return;
        }

        const total = this.parseCurrency(document.querySelector('.total-row .summary-value').textContent);

        this.showPaymentModal(total);
    }

    showPaymentModal(total) {
        const confirmed = confirm(`Xác nhận thanh toán ${this.formatCurrency(total)}?`);
        if (confirmed) {
            this.processPayment(total);
        }
    }

    processPayment(total) {
        // Simulate payment processing
        this.showNotification('Đang xử lý thanh toán...', 'info');

        setTimeout(() => {
            this.showNotification('Thanh toán thành công!', 'success');
            this.printReceipt();
            this.clearInvoice();
        }, 1500);
    }

    printReceipt() {
        // Implement receipt printing logic
        console.log('In hóa đơn...');
        // You can add receipt printing functionality here
    }

    clearInvoice() {
        document.querySelector('.invoice-table tbody').innerHTML = '';
        this.updateSummary();
    }

    showDeleteConfirmation(callback) {
        const confirmed = confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');
        if (confirmed) {
            callback();
        }
    }

    showNotification(message, type = 'success') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check' : type === 'error' ? 'times' : 'info'}"></i>
            <span>${message}</span>
        `;

        // Add to page
        document.body.appendChild(notification);

        // Auto remove after 3 seconds
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    loadProducts() {
        // This would typically load products from your Java backend
        console.log('Đã tải danh sách sản phẩm');
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN').format(amount) + ' ₫';
    }

    parseCurrency(currencyText) {
        return parseInt(currencyText.replace(/[^\d]/g, '')) || 0;
    }
}



// Initialize the TSMS Cashier system
document.addEventListener('DOMContentLoaded', () => {
    new TSMSCashier();
});

// Add notification styles
const notificationStyles = `
.notification {
    position: fixed;
    top: 20px;
    right: 20px;
    padding: 12px 16px;
    border-radius: 8px;
    color: white;
    font-weight: 500;
    z-index: 1000;
    display: flex;
    align-items: center;
    gap: 8px;
    animation: slideIn 0.3s ease;
}

.notification-success {
    background: #059669;
}

.notification-error {
    background: #dc2626;
}

.notification-info {
    background: #2563eb;
}

@keyframes slideIn {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}
`;

// Add styles to head
const styleSheet = document.createElement('style');
styleSheet.textContent = notificationStyles;
document.head.appendChild(styleSheet);

