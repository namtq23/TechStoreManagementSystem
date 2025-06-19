/* global cart */

// TSMS Cashier POS System JavaScript

class TSMSCashier {
    constructor() {
        this.cart = [];
        this.products = [];
        this.customers = [];
        this.currentCustomer = null;
        this.init();
    }

    async init() {
        await this.fetchProducts();
        console.log("Xong fetchProducts");

        await this.fetchCustomers();
        console.log("Xong fetchCustomers");

        this.bindCreateCustomerEvents();
        this.bindEvents();
        this.bindCustomerEvents();
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

    async fetchCustomers() {
        try {
            const response = await fetch('/TSMS/customers-json');
            if (!response.ok)
                throw new Error("Lỗi khi fecth");

            const data = await response.json();
            this.customers = data;

            console.log("Loaded customers:", this.customers);
        } catch (error) {
            console.error("Error fetching customers:", error);
        }
    }

    bindEvents() {
        const productList = JSON.parse(JSON.stringify(this.products));

        document.addEventListener('click', (e) => {
            const productCard = e.target.closest('.product-card');

            if (e.target.closest('.add-to-cart')) {
                const product = productList.find(p => p.productDetailId === parseInt(productCard.dataset.productId));
                if (product.quantity === 0) {
                    this.showNotification(`Không thể thêm: chỉ còn ${product.quantity} sản phẩm trong kho`, 'error');
                    return;
                }
                e.preventDefault();
                if (productCard) {
                    const productId = parseInt(productCard.dataset.productId);
                    const existInCart = this.cart.find(p => p.productDetailId === productId);

                    if (existInCart === undefined) {
                        this.addToCart(productId);
                    } else {
                        const product = this.products.find(p => p.productDetailId === productId);
                        const row = Array.from(document.querySelectorAll('.item-row')).find(row => {
                            const code = row.cells[1].textContent;
                            return code === String(product.productDetailId);
                        });

                        if (row) {
                            const quantityInput = row.querySelector('.quantity');
                            console.log(quantityInput);
                            let quantity = parseInt(quantityInput.value);
                            const maxQty = parseInt(product.quantity);

                            if (quantity < maxQty) {
                                quantity++;
                                quantityInput.value = quantity;
                                this.updateRowTotal(row);

                                // Update cart data
                                const productInCart = this.cart.find(p => p.productCode === product.productCode);
                                if (productInCart) {
                                    productInCart.quantity = quantity;
                                }
                                this.updateSummary();
                                this.showNotification(`Đã tăng số lượng ${product.description}`);
                            } else {
                                this.showNotification(`Không thể thêm: chỉ còn ${product.quantity} sản phẩm trong kho`, 'error');
                            }
                        }
                    }
                }
                return;
            }

            if (productCard) {
                const productInfo = productCard.querySelector('.product-content');
                const productId = parseInt(productCard.dataset.productId);
                const product = this.products.find(p => p.productDetailId === productId);
                const existingDetail = productCard.querySelector('.product-detail');
                if (existingDetail) {
                    existingDetail.remove();
                    return;
                }


                const detailHTML = `
            <div class="product-detail" style="padding: 10px; background-color: #f8f8f8; border-top: 1px solid #ccc; margin-top: 5px;">
                <p><strong>Nhãn hiệu:</strong> ${product.brand}</p>
                <p><em>(Thông tin chi tiết khác nếu có...)</em></p>
            </div>
        `;

                productInfo.insertAdjacentHTML('afterend', detailHTML);
            }
        });


        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('qty-btn')) {
                const isIncrement = e.target.textContent === '+';
                const row = e.target.closest('.item-row');
                const quantityInput = row.querySelector('.quantity');
                let quantity = parseInt(quantityInput.value);
                const product = productList.find(p => p.productDetailId === parseInt(row.querySelector('.productId').textContent));
                const maxQty = parseInt(product.quantity);


                if (isNaN(quantity))
                    quantity = 1;

                if (isIncrement) {
                    if (quantity < maxQty) {
                        quantity++;
                    }
                } else if (quantity > 1) {
                    quantity--;
                }

                quantityInput.value = quantity;
                this.updateRowTotal(row);

                // Update cart data
                const code = row.cells[2].textContent;
                const productInCart = this.cart.find(p => p.productCode === code);
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
                const code = row.cells[2].textContent; // Fixed: Should be cells[2] for productCode

                this.showDeleteConfirmation(() => {
                    // Remove from cart array using productDetailId instead
                    const productId = parseInt(row.cells[1].textContent); // productDetailId
                    this.cart = this.cart.filter(item => item.productDetailId !== productId);
                    row.remove();
                    this.updateSummary();
                    this.showNotification('Đã xóa sản phẩm khỏi hóa đơn', 'error');
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

        document.addEventListener('input', (e) => {
            if (e.target.classList.contains('quantity')) {
                const input = e.target;
                const row = input.closest('.item-row');
                const product = productList.find(p => p.productDetailId === parseInt(row.querySelector('.productId').textContent));
                const maxQty = parseInt(product.quantity);
                let value = parseInt(input.value);

                if (isNaN(value) || value < 1) {
                    value = 1;
                } else if (value > maxQty) {
                    value = maxQty;
                }

                input.value = value;

                const code = row.cells[1].textContent;
                const productInCart = this.cart.find(p => p.productCode === code);
                if (productInCart) {
                    productInCart.quantity = value;
                }

                this.updateRowTotal(row);
                this.updateSummary();
            }
        });


        document.querySelector("#processPayment").addEventListener("click", (e) => {
            const hiddenInput = document.getElementById("cartDataInput");
            hiddenInput.value = JSON.stringify(this.cart);
            console.log(JSON.stringify(this.cart));
        });
    }

    bindCustomerEvents() {
        const input = document.querySelector(".customer-input");
        const resultsBox = document.querySelector(".customer-search-results");

        input.addEventListener("input", (e) => {
            const keyword = e.target.value.trim().toLowerCase();
            resultsBox.innerHTML = "";

            if (keyword.length === 0) {
                resultsBox.style.display = "none";
                return;
            }

            const matches = this.customers.filter(cus =>
                cus.fullName.toLowerCase().includes(keyword) ||
                        cus.phoneNumber.includes(keyword)
            );

            if (matches.length === 0) {
                resultsBox.style.display = "none";
                return;
            }

            matches.forEach(cus => {
                const div = document.createElement("div");
                div.classList.add("suggestion-item");
                div.innerHTML = `
                <strong>${cus.fullName}</strong><br>
                <small>${cus.phoneNumber} - ${cus.address}</small>
            `;
                div.addEventListener("click", () => {
                    this.currentCustomer = cus;
                    this.fillCustomerForm(cus);
                    resultsBox.style.display = "none";
                    input.value = cus.fullName;
                });
                resultsBox.appendChild(div);
            });

            resultsBox.style.display = "block";
        });

        // Click ra ngoài để ẩn ô gợi ý
        document.addEventListener("click", (e) => {
            if (!resultsBox.contains(e.target) && e.target !== input) {
                resultsBox.style.display = "none";
            }
        });
    }

    bindCreateCustomerEvents() {
        const addBtn = document.getElementById("addCustomerBtn");
        const createForm = document.getElementById("createCustomerForm");
        const closeBtn = document.getElementById("closeCustomerSubmit");
        const submitBtn = document.getElementById("createCustomerSubmit");

        const mainForm = document.getElementById("mainCustomerForm");
        const input = document.querySelector(".customer-input");

        // 1. Hiện form tạo KH
        addBtn.addEventListener("click", () => {
            createForm.classList.remove("hidden");
        });

        // 2. Đóng form tạo KH
        closeBtn.addEventListener("click", () => {
            createForm.classList.add("hidden");
        });

        // 3. Khi ấn nút "Thêm" trong form tạo KH
        submitBtn.addEventListener("click", () => {
            const fullName = createForm.querySelector("input[name='fullName']").value;
            const phone = createForm.querySelector("input[name='phone']").value;
            const gender = createForm.querySelector("select[name='gender']").value;
            const address = createForm.querySelector("input[name='address']").value;
            const email = createForm.querySelector("input[name='email']").value;
            const dob = createForm.querySelector("input[name='dob']").value;

            input.value = fullName;

            // Đẩy dữ liệu vào form chính
            mainForm.querySelector("input[name='fullName']").value = fullName;
            mainForm.querySelector("input[name='phone']").value = phone;
            mainForm.querySelector("select[name='gender']").value = gender;
            mainForm.querySelector("input[name='address']").value = address;
            mainForm.querySelector("input[name='email']").value = email;
            mainForm.querySelector("input[name='dob']").value = dob;

            // Ẩn form tạo KH sau khi gán xong
            createForm.classList.add("hidden");
        });
    }

    fillCustomerForm(customer) {
        const form = document.getElementById("mainCustomerForm");
        form.querySelector("input[name='fullName']").value = customer.fullName || '';
        form.querySelector("input[name='phone']").value = customer.phoneNumber || '';
        form.querySelector("select[name='gender']").value = customer.gender ? "1" : "0";
        form.querySelector("input[name='address']").value = customer.address || '';
        form.querySelector("input[name='email']").value = customer.email || '';
        form.querySelector("input[name='dob']").value = customer.dateOfBirth || '';
    }

    addToCart(productId) {
        const product = this.products.find(p => p.productDetailId === productId);
        if (!product)
            return;

        const existingRow = Array.from(document.querySelectorAll('.item-row')).find(row => {
            const code = row.cells[1].textContent;
            return code === product.productCode;
        });

        if (existingRow) {
            const quantitySpan = existingRow.querySelector('.quantity');
            const currentQty = parseInt(quantitySpan.value);
            if (currentQty < product.quantity) {
                quantitySpan.value = currentQty + 1;
                this.updateRowTotal(existingRow);
                const item = this.cart.find(item => item.productCode === product.productCode);
                if (item && (item.quantity < product.quantity)) {
                    item.quantity = currentQty + 1;
                }
                this.updateSummary();
                this.showNotification(`Đã thêm ${product.description} vào hóa đơn`);
            } else {
                this.showNotification(`Không thể thêm: chỉ còn ${product.quantity} sản phẩm trong kho`, 'error');
            }
        } else {
            const productCart = {
                ...product,
                quantity: 1
            };
            this.addNewInvoiceRow(productCart);
            this.updateSummary();
            this.showNotification(`Đã thêm ${product.description} vào hóa đơn`);
        }
    }

    addNewInvoiceRow(product) {
        this.cart.push(product);
        const productInCart = this.cart.find(p => p.productDetailId === product.productDetailId);
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
        <td style="">${rowCount + 1}</td>
        <td class="productId">${product.productDetailId}</td>
        <td>${product.productCode || 'N/A'}</td>
        <td>${product.description || 'N/A'}</td>
        <td>
            <div class="quantity-controls">
                <button class="qty-btn"">-</button>
                <input type="text" class="quantity" value="1" min="1" max="${productInCart.quantity}">
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
        const quantity = parseInt(row.querySelector('.quantity').value);
        const priceText = row.querySelector('.discounted-price').textContent;
        const price = this.parseCurrency(priceText);
        const total = quantity * price;
        row.querySelector('.total').textContent = this.formatCurrency(total);
    }

    updateSummary() {
        let totalQuantity = 0;
        let subtotal = 0;
        this.cart.forEach(item => {
            totalQuantity += item.quantity;

            let itemPrice = 0;
            if (item.retailPrice && !isNaN(parseFloat(item.retailPrice))) {
                itemPrice = parseFloat(item.retailPrice);
                if (item.discountPercent && item.discountPercent > 0) {
                    itemPrice = itemPrice * (1 - item.discountPercent / 100.0);
                }
            }

            subtotal += itemPrice * item.quantity;
        });

        const discountInput = document.querySelector('#discountPercent');
        const discountPercent = parseFloat(discountInput.value) || 0;
        const discountTotal = (subtotal * (1 - discountPercent / 100) * (110 / 100));
        const vatValue = discountTotal * (10 / 100);

        const cashGiven = getCashGivenValue();
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

        const totalAmountEl = document.querySelector('#totalAmount');
        const amountDueEl = document.querySelector('#amountDue');
        const changeDueEl = document.querySelector('#changeDue');
        const vat = document.querySelector('#vat');


        if (totalAmountEl)
            totalAmountEl.value = this.formatCurrency(subtotal);
        if (amountDueEl)
            amountDueEl.value = this.formatCurrency(discountTotal);
        if (changeDueEl)
            changeDueEl.value = this.formatCurrency(changeDue);
        if (vat)
            vat.value = this.formatCurrency(vatValue);
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

