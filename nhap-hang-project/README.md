# 🛒 Trang Nhập Hàng - TSMS

Trang web quản lý nhập hàng từ nhà cung cấp với giao diện hiện đại, tương tự KiotViet.

## 🌟 Tính năng chính

### ⚡ Upload & Quản lý file Excel
- Kéo thả file Excel để nhập sản phẩm hàng loạt
- Tải xuống file mẫu Excel
- Xử lý và hiển thị dữ liệu từ file

### 📦 Quản lý sản phẩm
- Thêm sản phẩm thủ công qua modal
- Sửa/xóa sản phẩm trực tiếp trong bảng
- Tìm kiếm sản phẩm theo mã hoặc tên
- Chọn nhiều sản phẩm để xóa hàng loạt

### 💰 Tính toán tự động
- Tự động tính thành tiền cho từng sản phẩm
- Cập nhật tổng tiền khi thay đổi số lượng, giá
- Hiển thị tổng cần trả nhà cung cấp

### 🎯 Tương tác người dùng
- Thông báo toast cho mọi hành động
- Keyboard shortcuts (F3, Ctrl+S)
- Giao diện responsive cho mobile/tablet

## 📁 Cấu trúc project

```
nhap-hang-project/
├── index.html          # Trang chính
├── css/
│   └── style.css       # Stylesheet
├── js/
│   └── script.js       # JavaScript logic
├── assets/             # Thư mục tài nguyên
└── README.md           # Hướng dẫn này
```

## 🚀 Cách chạy

### Cách 1: Sử dụng Python HTTP Server

```bash
# Di chuyển vào thư mục project
cd nhap-hang-project

# Khởi chạy server Python
python3 -m http.server 8080

# Hoặc với Python 2
python -m SimpleHTTPServer 8080
```

### Cách 2: Sử dụng Live Server (VS Code)

1. Cài extension "Live Server" trong VS Code
2. Right-click vào `index.html` → "Open with Live Server"
3. Trang sẽ tự động mở và reload khi có thay đổi

### Cách 3: Sử dụng Node.js

```bash
# Cài http-server global
npm install -g http-server

# Chạy server
http-server -p 8080
```

## 🌐 Truy cập

Sau khi khởi chạy server, truy cập:
- **Local**: `http://localhost:8080`
- **LAN**: `http://[your-ip]:8080`

## 📱 Hướng dẫn sử dụng

### 1. Thêm sản phẩm từ Excel
1. Click "Chọn file dữ liệu" hoặc kéo thả file Excel
2. File sẽ được xử lý và hiển thị danh sách sản phẩm
3. Chỉnh sửa số lượng, đơn giá trong bảng

### 2. Thêm sản phẩm thủ công
1. Click nút "Thêm sản phẩm"
2. Điền thông tin trong modal
3. Click "Thêm" để hoàn tất

### 3. Quản lý sản phẩm
- **Sửa**: Click icon ✏️ để chỉnh sửa
- **Xóa**: Click icon 🗑️ để xóa
- **Xóa nhiều**: Chọn checkbox → Click "Xóa đã chọn"

### 4. Tìm kiếm
- Nhập từ khóa vào ô tìm kiếm
- Hoặc nhấn **F3** để focus vào ô tìm kiếm

### 5. Lưu phiếu nhập
- **Lưu tạm**: Lưu nháp để chỉnh sửa sau
- **Hoàn thành**: Hoàn tất phiếu nhập

## ⌨️ Keyboard Shortcuts

| Phím | Chức năng |
|------|-----------|
| **F3** | Focus vào ô tìm kiếm |
| **Ctrl+S** | Lưu phiếu nhập |
| **Esc** | Đóng modal |

## 🎨 Thiết kế UI/UX

- **Font**: Inter (Google Fonts)
- **Color Scheme**: Blue (#3b82f6), Green (#22c55e)
- **Icons**: Font Awesome 6
- **Layout**: Responsive với CSS Grid & Flexbox

## 🔧 Tùy chỉnh

### Thay đổi màu chính
Trong `css/style.css`, tìm và thay đổi:
```css
/* Màu xanh chính */
#3b82f6 → [màu-mới]

/* Màu xanh lá */
#22c55e → [màu-mới]
```

### Thêm đơn vị tính mới
Trong `js/script.js`, tìm và thêm vào:
```html
<select id="productUnit">
    <option value="Cái">Cái</option>
    <!-- Thêm option mới ở đây -->
</select>
```

## 🐛 Troubleshooting

### Lỗi CORS khi mở file local
- Sử dụng HTTP server thay vì mở file trực tiếp
- Hoặc sử dụng `--allow-file-access-from-files` flag trong Chrome

### Không hiển thị icon
- Kiểm tra kết nối internet cho Font Awesome CDN
- Hoặc tải Font Awesome về local

### File Excel không đọc được
- Đảm bảo file có định dạng .xlsx hoặc .xls
- Kiểm tra cấu trúc dữ liệu trong file

## 📄 License

MIT License - Bạn có thể sử dụng và chỉnh sửa tự do.

## 🤝 Đóng góp

1. Fork repository
2. Tạo branch mới (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Mở Pull Request

---

**🔥 Happy Coding!** 🚀