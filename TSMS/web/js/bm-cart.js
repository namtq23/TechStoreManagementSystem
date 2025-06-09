/* global cart */

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
        document.addEventListener('click', (e) => {
            if (e.target.closest('.add-to-cart')) {
                e.preventDefault();
                const productCard = e.target.closest('.product-card');
                const productId = parseInt(productCard.dataset.productId);
                console.log(productId);
                this.addToCart(productId);
            }
        });

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

                const code = row.cells[1].textContent;
                const productInCart = this.cart.find(p => p.serialNum === code);
                if (productInCart) {
                    productInCart.quantity = quantity;
                }

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

        const discountInput = document.querySelector('#discountPercent');
        if (discountInput) {
            discountInput.addEventListener('input', () => {
                this.updateSummary();
            });
        }

        const cashGiven = document.querySelector('#cashGiven');
        if (cashGiven) {
            cashGiven.addEventListener('input', () => {
                this.updateSummary();
            });
        }


        document.querySelector("#processPayment").addEventListener("click", (e) => {
            const hiddenInput = document.getElementById("cartDataInput");
            hiddenInput.value = JSON.stringify(this.cart);
            console.log(JSON.stringify(this.cart));
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
            const quantitySpan = existingRow.querySelector('.quantity');
            const currentQty = parseInt(quantitySpan.textContent);
            quantitySpan.textContent = currentQty + 1;
            this.updateRowTotal(existingRow);
            const item = this.cart.find(item => item.serialNum === product.code);
            if (item) {
                item.quantity = currentQty + 1;
            }
        } else {
            const productToAdd = {
                ...product,
                quantity: 1
            };
            this.addNewInvoiceRow(productToAdd);
        }

        this.updateSummary();
        this.showNotification(`Đã thêm ${product.description} vào hóa đơn`);
    }

    addNewInvoiceRow(product) {
        this.cart.push(product);
        const tbody = document.querySelector('.invoice-table tbody');
        const rowCount = tbody.children.length;
        const row = document.createElement('tr');
        row.className = 'item-row';

        // Calculate the final price (discounted or original)
        let finalPrice = 0;
        let priceDisplay = '';

        try {
            const retailPriceStr = product.retailPrice;
            const discountPercent = product.discountPercent;

            // Handle both String and numeric retailPrice
            if (retailPriceStr !== null && retailPriceStr !== undefined &&
                    String(retailPriceStr).trim() !== '') {

                let retailPrice = parseFloat(String(retailPriceStr).trim());

                if (isNaN(retailPrice)) {
                    throw new Error('Invalid price format');
                }

                // Check if discount is valid and greater than 0
                if (discountPercent !== null && discountPercent !== undefined && discountPercent > 0) {
                    finalPrice = retailPrice * (1 - discountPercent / 100.0);
                    priceDisplay = `
                    <div class="original-price" style="text-decoration: line-through; font-size: 0.9em; color: #999;">
                        ${this.formatCurrency(retailPrice)}
                    </div>
                    <div class="discounted-price">
                        ${this.formatCurrency(finalPrice)} (-${discountPercent.toFixed(1)}%)
                    </div>
                `;
                } else {
                    finalPrice = retailPrice;
                    priceDisplay = `<div class="discounted-price">
                        ${this.formatCurrency(finalPrice)}
                    </div>`;
                }
            } else {
                finalPrice = 0;
                priceDisplay = 'N/A';
            }
        } catch (error) {
            finalPrice = 0;
            priceDisplay = 'Error';
        }

        row.innerHTML = `
        <td>${rowCount + 1}</td>
        <td>${product.serialNum || 'N/A'}</td>
        <td>${product.description || 'N/A'}</td>
        <td>
            <div class="quantity-controls">
                <button class="qty-btn"">-</button>
                <span class="quantity">1</span>
                <button class="qty-btn"">+</button>
            </div>
        </td>
        <td class="price">${priceDisplay}</td>
        <td class="total" style="font-weight: bold;">${this.formatCurrency(finalPrice)}</td>
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
        const priceText = row.querySelector('.discounted-price').textContent;
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
            subtotal = subtotal + total;
        });

        const discountInput = document.querySelector('#discountPercent');
        const discountPercent = parseFloat(discountInput.value) || 0;
        const discountTotal = subtotal * (1 - discountPercent / 100);

        const cashGiven = parseFloat(document.querySelector('#cashGiven').value || 0);
        let changeDue = 0;
        if (cashGiven > discountTotal) {
            changeDue = cashGiven - discountTotal;
        }


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

        document.querySelector('#totalAmount').value = this.formatCurrency(subtotal);
        document.querySelector('#amountDue').value = this.formatCurrency(discountTotal);
        document.querySelector('#changeDue').value = this.formatCurrency(changeDue);
    }

    searchProducts(query) {
        const productCards = document.querySelectorAll('.product-card');

        productCards.forEach(card => {
            const productName = card.querySelector('h3').textContent.toLowerCase();
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
            this.showNotification('Vui lòng thêm ít nhất một sản phẩm vào hóa đơn trước khi thanh toán!', 'error');
            return;
        }
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
        let priceStr = currencyText.trim().split(' ')[0];
        let cleanPrice = priceStr.replace(/[^\d]/g, '');
        return parseInt(cleanPrice);
    }
}


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


const styleSheet = document.createElement('style');
styleSheet.textContent = notificationStyles;
document.head.appendChild(styleSheet);

