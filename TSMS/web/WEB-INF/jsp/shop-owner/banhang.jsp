<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bán hàng</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/banhang.css">
</head>
<body>
    <div class="header">
        <div class="header-left">
            <div class="search-box">
                <span class="material-icons">search</span>
                <input type="text" placeholder="Tìm hàng hóa (F3)">
            </div>
            <button class="barcode-btn" title="Quét mã vạch">
                <span class="material-icons">qr_code_scanner</span>
            </button>
        </div>
        <div class="tabs" id="tab-list">
            <div class="tab active" data-tab="1">
                <span class="material-icons">swap_horiz</span>
                <span>Hóa đơn 1</span>
                <span class="material-icons close" title="Đóng">close</span>
            </div>
            <button class="add-tab" id="add-tab-btn" title="Thêm hóa đơn mới">
                <span class="material-icons">add</span>
                <span class="material-icons">arrow_drop_down</span>
            </button>
        </div>
        <div class="header-right">
            <button title="Giỏ hàng"><span class="material-icons">shopping_bag</span></button>
            <button title="Hoàn tác"><span class="material-icons">undo</span></button>
            <button title="Làm lại"><span class="material-icons">redo</span></button>
            <button title="Đồng bộ"><span class="material-icons">sync_alt</span></button>
            <span class="user-phone" title="Số điện thoại">0373137175</span>
        </div>
    </div>
    <div class="container">
        <div class="left-panel">
            <div class="empty"></div>
            <div class="order-note">
                <input type="text" placeholder="Ghi chú đơn hàng">
                <span class="total-label">Tổng tiền hàng</span>
                <span class="total-value" id="total-amount">0</span>
            </div>
        </div>
        <div class="right-panel">
            <div class="customer-search">
                <span class="material-icons">search</span>
                <input type="text" placeholder="Tìm khách hàng (F4)">
                <button class="add-customer" title="Thêm khách hàng"><span class="material-icons">add</span></button>
                <button class="icon-btn" title="Xem dạng lưới"><span class="material-icons">view_module</span></button>
                <button class="icon-btn" title="Lọc"><span class="material-icons">filter_list</span></button>
                <button class="icon-btn" title="Tuỳ chọn khác"><span class="material-icons">more_vert</span></button>
            </div>
            <div class="product-list" id="product-list">
                <!-- Sản phẩm sẽ render bởi JS -->
            </div>
            <div class="panel-bottom">
                <div class="paging">
                    <button id="prev-page"><span class="material-icons">chevron_left</span></button>
                    <span id="paging-label">1/2</span>
                    <button id="next-page"><span class="material-icons">chevron_right</span></button>
                </div>
                <button class="checkout-btn" id="checkout-btn">THANH TOÁN</button>
            </div>
        </div>
    </div>
    <div class="footer-menu">
        <div class="footer-item active" data-mode="normal">
            <span class="material-icons">timelapse</span>
            <span> Tạo Đơn Hàng</span>
        </div>
    </div>
    <div class="footer-right">
        <a href="#"><span class="material-icons">call</span> 1900 6522</a>
        <a href="#"><span class="material-icons">help_outline</span></a>
        <a href="#"><span class="material-icons">chat</span></a>
    </div>

    <!-- POPUP -->
    <div class="popup-overlay" id="popup-overlay" style="display:none;">
        <div class="popup-box" id="popup-box">
            <!-- Nội dung popup động -->
        </div>
    </div>

<script>
/* Sản phẩm DEMO: 2 trang, mỗi trang 12 sản phẩm */
const productsAll = [
    [
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/dong-ho-thong-minh-huawei-kids-watch-4-pro-xanh-tn-600x600.jpg",
         name:"Đồng hồ thông minh Huawei Kids...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/dong-ho-thong-minh-huawei-kids-watch-4-pro-xanh-tn-600x600.jpg",
         name:"Apple Watch Series 9 GPS + Cellular...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/dong-ho-thong-minh-huawei-kids-watch-4-pro-xanh-tn-600x600.jpg",
         name:"Apple Watch Series 9 GPS + Cellular...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/dong-ho-thong-minh-huawei-kids-watch-4-pro-xanh-tn-600x600.jpg",
         name:"Đồng hồ thông minh Huawei Kids...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/vong-tay-xiaomi-mi-band-7-pro-den-thumb-600x600.jpg",
         name:"Vòng đeo tay thông minh Xiaomi Mi...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/vong-tay-xiaomi-mi-band-7-pro-den-thumb-600x600.jpg",
         name:"Vòng đeo tay thông minh Xiaomi Mi...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/42/323477/iphone-14-plus-blue-thumb-600x600.jpg",
         name:"iPhone 14 256GB", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/42/323477/iphone-14-plus-blue-thumb-600x600.jpg",
         name:"iPhone 14 256GB", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/42/323477/samsung-galaxy-s23-ultra-thumb-xanh-600x600.jpg",
         name:"Samsung Galaxy S23 Ultra 256GB", price:"23,990,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/42/323477/xiaomi-redmi-note-13-pro-128gb-thumb-den-600x600.jpg",
         name:"Xiaomi Redmi Note 13 Pro 128GB", price:"7,290,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/42/323477/xiaomi-redmi-note-13-pro-128gb-thumb-den-600x600.jpg",
         name:"Xiaomi Redmi Note 13 Pro 128GB", price:"7,290,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/44/323477/macbook-air-m2-2022-600x600.jpg",
         name:"Macbook Air 13 inch M2 256GB", price:"23,690,000", highlight:true}
    ],
    [
        {img:"https://cdn.tgdd.vn/Products/Images/44/323477/dell-inspiron-15-3520-i5-1235u-thumb-600x600.jpg",
         name:"Dell Inspiron 15 3520 i5 1235U", price:"15,490,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/44/323477/dell-inspiron-15-3520-i5-1235u-thumb-600x600.jpg",
         name:"Dell Inspiron 15 3520 i5 1235U", price:"15,490,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/54/323477/airpods-max-600x600.jpg",
         name:"Tai nghe AirPods Max Fullbox", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/54/323477/airpods-max-600x600.jpg",
         name:"Tai nghe AirPods Max Fullbox", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/54/323477/jbl-go-3-thumb-600x600.jpg",
         name:"Loa Bluetooth JBL Go 3", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/dong-ho-thong-minh-huawei-kids-watch-4-pro-xanh-tn-600x600.jpg",
         name:"Đồng hồ thông minh Huawei Kids...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/44/323477/macbook-air-m2-2022-600x600.jpg",
         name:"Macbook Air 13 inch M2 256GB", price:"23,690,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/7077/312324/vong-tay-xiaomi-mi-band-7-pro-den-thumb-600x600.jpg",
         name:"Vòng đeo tay thông minh Xiaomi Mi...", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/42/323477/samsung-galaxy-s23-ultra-thumb-xanh-600x600.jpg",
         name:"Samsung Galaxy S23 Ultra 256GB", price:"23,990,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/42/323477/iphone-14-plus-blue-thumb-600x600.jpg",
         name:"iPhone 14 256GB", price:"0"},
        {img:"https://cdn.tgdd.vn/Products/Images/44/323477/dell-inspiron-15-3520-i5-1235u-thumb-600x600.jpg",
         name:"Dell Inspiron 15 3520 i5 1235U", price:"15,490,000", highlight:true},
        {img:"https://cdn.tgdd.vn/Products/Images/54/323477/airpods-max-600x600.jpg",
         name:"Tai nghe AirPods Max Fullbox", price:"0"}
    ]
];
let curPage = 0;
let selectedProduct = {page:0, index:0};

function renderProducts() {
    const list = document.getElementById('product-list');
    list.innerHTML = '';
    const products = productsAll[curPage];
    for(let r=0; r<Math.ceil(products.length/6); r++) {
        const row = document.createElement('div');
        row.className = 'product-row';
        for(let c=0; c<6; c++) {
            let idx = r*6 + c;
            if(idx >= products.length) break;
            let p = products[idx];
            let item = document.createElement('div');
            item.className = 'product-item';
            if(curPage===selectedProduct.page && idx===selectedProduct.index) item.classList.add('selected');
            item.setAttribute('data-idx', idx);
            item.innerHTML = `
                <img src="${p.img}" alt="">
                <div>
                    <div class="name">${p.name}</div>
                    <div class="price${p.highlight?' highlight':''}">${p.price}</div>
                </div>
            `;
            item.onclick = function() {
                selectedProduct = {page: curPage, index: idx};
                renderProducts();
            }
            row.appendChild(item);
        }
        list.appendChild(row);
    }
    document.getElementById('paging-label').innerText = `${curPage+1}/${productsAll.length}`;
}
renderProducts();

document.getElementById('prev-page').onclick = function() {
    if(curPage>0) { curPage--; selectedProduct={page:curPage,index:0}; renderProducts(); }
}
document.getElementById('next-page').onclick = function() {
    if(curPage<productsAll.length-1) { curPage++; selectedProduct={page:curPage,index:0}; renderProducts(); }
}

// --- TAB HÓA ĐƠN ---
let tabCount = 1;
function addTab(name) {
    tabCount++;
    const tab = document.createElement('div');
    tab.className = 'tab';
    tab.setAttribute('data-tab', tabCount);
    tab.innerHTML = `<span class="material-icons">swap_horiz</span>
        <span>Hóa đơn ${tabCount}</span>
        <span class="material-icons close" title="Đóng">close</span>`;
    tab.onclick = tabClick;
    tab.querySelector('.close').onclick = tabClose;
    document.getElementById('tab-list').insertBefore(tab, document.getElementById('add-tab-btn'));
    setActiveTab(tab);
}
function setActiveTab(tab) {
    document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
    tab.classList.add('active');
}
function tabClick(e) {
    if(e.target.classList.contains('close')) return;
    setActiveTab(this);
}
function tabClose(e) {
    e.stopPropagation();
    const tab = this.parentElement;
    const isActive = tab.classList.contains('active');
    tab.parentElement.removeChild(tab);
    if(isActive) {
        const tabs = document.querySelectorAll('.tab');
        if(tabs.length) setActiveTab(tabs[0]);
    }
}
document.querySelectorAll('.tab').forEach(tab=>{
    tab.onclick = tabClick;
    tab.querySelector('.close').onclick = tabClose;
});
document.getElementById('add-tab-btn').onclick = function() {
    addTab();
};

// --- FOOTER MENU ---
document.querySelectorAll('.footer-item').forEach(item=>{
    item.onclick = function() {
        document.querySelectorAll('.footer-item').forEach(i=>i.classList.remove('active'));
        this.classList.add('active');
    }
});

// --- THANH TOÁN (Popup demo) ---
document.getElementById('checkout-btn').onclick = function() {
    showPopup("Thanh toán thành công! <br><br>Cảm ơn bạn đã sử dụng dịch vụ.");
};
function showPopup(msg) {
    document.getElementById('popup-box').innerHTML = msg + '<br><button onclick="hidePopup()">Đóng</button>';
    document.getElementById('popup-overlay').style.display = 'flex';
}
function hidePopup() {
    document.getElementById('popup-overlay').style.display = 'none';
}

// --- Đóng Popup khi bấm nền ---
document.getElementById('popup-overlay').onclick = function(event) {
    if(event.target === this) hidePopup();
};

// --- Tính tổng tiền hàng khi chọn sản phẩm highlight ---
function updateTotal() {
    let total = 0;
    productsAll.forEach(page=>{
        page.forEach(p=>{
            if(p.highlight && p.price) {
                total += Number(p.price.replace(/[^0-9]/g, ''));
            }
        });
    });
    document.getElementById('total-amount').innerText = total ? total.toLocaleString() : '0';
}
updateTotal();

// --- Nếu chọn sản phẩm, highlight sẽ chỉ là hiệu ứng chọn, không cộng tổng. Nếu muốn cộng tổng khi click, bạn cần lưu số lượng và tính lại. ---

</script>
</body>
</html>