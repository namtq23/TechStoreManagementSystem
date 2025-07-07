# 📦 Trang Tạo Phiếu Nhập Hàng - TSMS

## 🌟 Tổng quan

Trang **Tạo phiếu nhập hàng** được thiết kế với giao diện hiện đại tương tự **KiotViet**, mang đến trải nghiệm người dùng tốt nhất cho việc quản lý nhập hàng trong hệ thống TSMS.

## 🎯 Tính năng chính

### ✨ Giao diện người dùng
- **Thiết kế hiện đại**: Giao diện clean, professional với font Inter
- **Responsive**: Tối ưu cho cả desktop và mobile
- **Color scheme**: Sử dụng màu xanh (#3b82f6) và xanh lá (#22c55e) theo phong cách KiotViet
- **Animation**: Smooth transitions và hover effects

### 📤 Upload Excel
- **Drag & Drop**: Kéo thả file Excel trực tiếp
- **File validation**: Kiểm tra định dạng .xlsx, .xls
- **Template download**: Tải file mẫu Excel
- **Progress indicator**: Hiển thị tiến trình xử lý

### 📋 Quản lý sản phẩm
- **Thêm từ Excel**: Import hàng loạt từ file Excel
- **Thêm thủ công**: Modal thêm sản phẩm với validation
- **Inline editing**: Chỉnh sửa trực tiếp trong bảng
- **Bulk actions**: Xóa nhiều sản phẩm cùng lúc
- **Search**: Tìm kiếm theo mã hoặc tên hàng

### 💰 Tính toán tự động
- **Real-time calculation**: Tính toán thành tiền tự động
- **Discount handling**: Hỗ trợ giảm giá từng sản phẩm và tổng đơn
- **Currency formatting**: Định dạng tiền tệ Việt Nam

### 🎨 UI Components
- **Sidebar thông tin**: Nhà cung cấp, ghi chú, tổng tiền
- **Status indicators**: Hiển thị trạng thái phiếu nhập
- **Action buttons**: Lưu tạm / Hoàn thành
- **Toast notifications**: Thông báo trạng thái

## 🔧 Cấu trúc Files

```
TSMS/
├── web/
│   ├── WEB-INF/jsp/warehouse-manager/
│   │   ├── create-import.jsp          # JSP page chính
│   │   └── import.jsp                 # Cập nhật link
│   ├── css/
│   │   └── create-import.css          # Styling riêng
│   └── js/
│       └── create-import.js           # JavaScript logic
└── src/java/controller/
    └── WHCreateImport.java            # Servlet controller
```

## 🚀 Cách sử dụng

### 1. Truy cập trang
- **URL**: `/wh-create-import`
- **Từ danh sách**: Click nút "Tạo phiếu nhập" trong trang danh sách
- **Từ navigation**: Click "Yêu cầu nhập hàng" trong menu

### 2. Thêm sản phẩm

#### Từ Excel file:
1. Click "Chọn file dữ liệu" hoặc kéo thả file Excel
2. Hệ thống sẽ đọc và hiển thị danh sách sản phẩm
3. Chỉnh sửa số lượng, đơn giá nếu cần

#### Thêm thủ công:
1. Click nút "Thêm sản phẩm"
2. Điền thông tin trong modal
3. Click "Thêm" để thêm vào danh sách

### 3. Cấu hình đơn hàng
- **Chọn nhà cung cấp**: Bắt buộc
- **Mã đặt hàng**: Tùy chọn
- **Ghi chú**: Tùy chọn
- **Giảm giá tổng**: Tùy chọn

### 4. Hoàn thành
- **Lưu tạm**: Lưu phiếu ở trạng thái draft
- **Hoàn thành**: Tạo phiếu nhập chính thức

## ⌨️ Keyboard Shortcuts

| Phím | Chức năng |
|------|-----------|
| `F3` | Focus vào ô tìm kiếm |
| `Ctrl + S` | Lưu phiếu nhập |
| `Esc` | Đóng modal |

## 🔄 API Endpoints

### GET `/wh-create-import`
- Hiển thị trang tạo phiếu nhập
- Load danh sách nhà cung cấp

### POST `/wh-create-import`
- Tạo phiếu nhập mới
- Parameters:
  - `action`: "save" hoặc "complete"
  - `supplierId`: ID nhà cung cấp
  - `orderCode`: Mã đặt hàng
  - `notes`: Ghi chú
  - `discountAmount`: Giảm giá tổng
  - `products`: JSON danh sách sản phẩm

## 📱 Responsive Design

### Desktop (≥1024px)
- Layout 2 cột: Nội dung chính + Sidebar
- Table đầy đủ các cột
- Dropdown và modal full size

### Tablet (768px - 1023px)
- Layout stack dọc
- Table responsive với scroll ngang
- Sidebar full width

### Mobile (<768px)
- Single column layout
- Compact table view
- Touch-friendly buttons

## 🎨 Design System

### Colors
```css
Primary Blue: #3b82f6
Success Green: #22c55e
Gray Scale: #f8fafc, #e2e8f0, #64748b, #334155
Warning: #f59e0b
Error: #ef4444
```

### Typography
- **Font**: Inter (Google Fonts)
- **Weights**: 300, 400, 500, 600, 700

### Spacing
- **Base unit**: 4px
- **Common spacing**: 8px, 12px, 16px, 24px

## 🔒 Validation

### Client-side
- Required fields validation
- Numeric input validation
- Duplicate product code check
- File type validation

### Server-side
- Supplier selection validation
- Product list validation
- Price validation for completed orders
- Session authentication

## 🐛 Error Handling

### Upload errors
- Invalid file format
- File size limits
- Processing errors

### Form errors
- Missing required fields
- Invalid numeric values
- Duplicate entries

### Server errors
- Database connection issues
- Authentication problems
- System errors

## 🚀 Performance

### Optimizations
- Lazy loading for large product lists
- Debounced search input
- Minimal DOM manipulation
- Efficient CSS animations

### Browser support
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 🔧 Customization

### Styling
Chỉnh sửa `create-import.css` để thay đổi giao diện:
```css
/* Thay đổi màu chủ đạo */
:root {
  --primary-color: #3b82f6;
  --success-color: #22c55e;
}
```

### Functionality
Chỉnh sửa `create-import.js` để thêm/sửa tính năng:
```javascript
// Thêm validation mới
function customValidation() {
  // Custom logic here
}
```

## 📞 Hỗ trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra Console log trong Developer Tools
2. Đảm bảo session đã login
3. Kiểm tra kết nối database
4. Review server logs

---

**Phiên bản**: 1.0  
**Ngày cập nhật**: 27/12/2024  
**Tác giả**: TSMS Development Team