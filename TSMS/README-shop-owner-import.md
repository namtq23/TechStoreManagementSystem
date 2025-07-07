# 📦 Trang Tạo Yêu Cầu Nhập Hàng - Shop Owner TSMS

## 🌟 Tổng quan

Trang **Tạo yêu cầu nhập hàng** được thiết kế dành cho **Shop Owner** để tạo yêu cầu nhập hàng từ nhà cung cấp. Yêu cầu này sẽ được gửi đến **Warehouse Manager** để xử lý và thực hiện nhập hàng thực tế.

## 🎯 Luồng xử lý

```
Shop Owner → Tạo yêu cầu nhập hàng → Warehouse Manager → Xử lý nhập hàng
```

1. **Shop Owner**: Tạo yêu cầu nhập hàng với danh sách sản phẩm cần nhập
2. **Warehouse Manager**: Nhận yêu cầu trong trang `wh-import` và xử lý
3. **Kết quả**: Hàng được nhập vào kho và cập nhật inventory

## 🎯 Tính năng chính

### ✨ Giao diện người dùng
- **Thiết kế KiotViet**: Giao diện tương tự KiotViet với màu cam (#f59e0b) cho Shop Owner
- **Responsive**: Tối ưu cho cả desktop và mobile
- **Navigation**: Tích hợp vào dropdown "Giao dịch" của Shop Owner
- **Animation**: Smooth transitions và hover effects

### 📤 Upload Excel
- **Drag & Drop**: Kéo thả file Excel trực tiếp
- **File validation**: Kiểm tra định dạng .xlsx, .xls
- **Template download**: Tải file mẫu Excel cho yêu cầu nhập hàng
- **Sample data**: Hiển thị dữ liệu mẫu realistic (iPhone, Samsung, etc.)

### 📋 Quản lý sản phẩm yêu cầu
- **Thêm từ Excel**: Import hàng loạt từ file Excel
- **Thêm thủ công**: Modal thêm sản phẩm với validation
- **Inline editing**: Chỉnh sửa trực tiếp trong bảng
- **Bulk actions**: Xóa nhiều sản phẩm cùng lúc
- **Search**: Tìm kiếm theo mã hoặc tên hàng (F3)

### ⚙️ Cấu hình yêu cầu
- **Kho nhận hàng**: Chọn kho sẽ nhận hàng (bắt buộc)
- **Nhà cung cấp**: Chọn nhà cung cấp (bắt buộc)
- **Độ ưu tiên**: Bình thường, Cao, Khẩn cấp
- **Mã đặt hàng**: Mã tham chiếu (tùy chọn)
- **Ghi chú**: Ghi chú cho yêu cầu

### 💰 Tính toán dự kiến
- **Đơn giá dự kiến**: Shop Owner có thể nhập giá dự kiến
- **Kho điền giá thực**: Warehouse Manager sẽ điền giá thực tế
- **Giảm giá**: Hỗ trợ giảm giá từng sản phẩm và tổng đơn
- **Currency formatting**: Định dạng tiền tệ Việt Nam

### 🔄 Auto-save
- **Auto-save**: Tự động lưu nháp mỗi 2 phút
- **Draft management**: Lưu nháp để chỉnh sửa sau
- **Submit**: Gửi yêu cầu chính thức đến kho

## 🔧 Cấu trúc Files

```
TSMS/
├── web/
│   ├── WEB-INF/jsp/shop-owner/
│   │   ├── nhap-hang.jsp              # JSP page chính (Shop Owner)
│   │   └── (all other shop-owner JSPs) # Updated navigation links
│   ├── css/
│   │   └── nhap-hang.css              # Styling riêng cho SO
│   ├── js/
│   │   └── nhap-hang.js               # JavaScript logic
│   └── WEB-INF/jsp/warehouse-manager/
│       └── import.jsp                 # WH sẽ xem yêu cầu ở đây
└── src/java/controller/
    ├── SOImportController.java        # Servlet cho Shop Owner
    └── WHImport.java                  # Servlet cho Warehouse Manager
```

## 🚀 Cách sử dụng

### 🏪 Shop Owner - Tạo yêu cầu

#### 1. Truy cập trang
- **URL**: `/nhap-hang`
- **Navigation**: Giao dịch → Tạo đơn nhập hàng
- **Role**: Shop Owner

#### 2. Cấu hình yêu cầu
- **Chọn kho nhận hàng**: Bắt buộc chọn kho sẽ nhận hàng
- **Chọn nhà cung cấp**: Bắt buộc chọn nhà cung cấp
- **Độ ưu tiên**: 
  - 🟢 Bình thường
  - 🟡 Cao  
  - 🔴 Khẩn cấp

#### 3. Thêm sản phẩm
- **Từ Excel**: Upload file Excel với template
- **Thủ công**: Thêm từng sản phẩm qua modal
- **Số lượng yêu cầu**: Bắt buộc
- **Đơn giá dự kiến**: Tùy chọn (kho sẽ điền giá thực)

#### 4. Gửi yêu cầu
- **Lưu nháp**: Lưu để chỉnh sửa sau
- **Gửi yêu cầu**: Gửi chính thức đến kho (không thể sửa)

### 🏭 Warehouse Manager - Xử lý yêu cầu

#### 1. Xem yêu cầu
- **URL**: `/wh-import`
- **Hiển thị**: Tất cả yêu cầu từ Shop Owner
- **Trạng thái**: Pending, Processing, Completed, Cancelled

#### 2. Xử lý yêu cầu
- **Xem chi tiết**: Danh sách sản phẩm yêu cầu
- **Điền giá thực**: Cập nhật đơn giá thực tế
- **Xác nhận**: Hoàn thành nhập hàng

## 🔄 API Endpoints

### GET `/nhap-hang` (Shop Owner)
- **Mục đích**: Hiển thị trang tạo yêu cầu
- **Data**: Load danh sách warehouses, suppliers
- **Role**: Shop Owner

### POST `/nhap-hang` (Shop Owner)
- **Mục đích**: Tạo yêu cầu nhập hàng
- **Actions**:
  - `save`: Lưu nháp (status: draft)
  - `submit`: Gửi yêu cầu (status: pending)
  - `autosave`: Tự động lưu nháp

### Parameters:
- `warehouseId`: ID kho nhận hàng
- `supplierId`: ID nhà cung cấp  
- `orderCode`: Mã đặt hàng
- `notes`: Ghi chú
- `priority`: normal/high/urgent
- `discountAmount`: Giảm giá tổng
- `products`: JSON danh sách sản phẩm

### GET `/wh-import` (Warehouse Manager)
- **Mục đích**: Xem danh sách yêu cầu nhập hàng
- **Filter**: Theo trạng thái, ngày tháng, nhà cung cấp
- **Role**: Warehouse Manager

## 🎨 Design System

### Colors
```css
/* Shop Owner Theme */
Primary Orange: #f59e0b
Secondary Blue: #3b82f6
Success Green: #22c55e
Gray Scale: #f8fafc, #e2e8f0, #64748b, #334155
Warning: #f59e0b
Error: #ef4444
```

### Typography
- **Font**: Inter (Google Fonts)
- **Weights**: 300, 400, 500, 600, 700

### Priority Badges
- **Normal**: Gray badge
- **High**: Yellow badge  
- **Urgent**: Red badge

## 🔒 Validation & Security

### Client-side Validation
- Required fields: warehouseId, supplierId, products
- Numeric input validation
- Duplicate product code check
- File type validation for Excel

### Server-side Validation
- Session authentication (Shop Owner role)
- Warehouse and supplier existence check
- Product list validation
- Request ID generation
- XSS protection

### Business Logic
- **Draft status**: Shop Owner có thể chỉnh sửa
- **Pending status**: Gửi đến Warehouse Manager
- **Auto-save**: Mỗi 2 phút nếu có thay đổi
- **Request ID**: REQ + timestamp + random

## 🚀 Performance & UX

### Performance
- **Auto-save**: Giảm mất dữ liệu
- **Debounced search**: Tối ưu tìm kiếm
- **Lazy loading**: Chỉ load khi cần
- **Minimal DOM**: Ít thao tác DOM

### UX Features
- **Toast notifications**: Phản hồi người dùng
- **Loading states**: Hiển thị trạng thái xử lý
- **Keyboard shortcuts**: F3 (search), Ctrl+S (save)
- **Responsive design**: Mobile-friendly
- **Progress indicators**: Hiển thị tiến trình upload

## 🔧 Customization

### Styling
```css
/* Thay đổi màu chủ đạo Shop Owner */
:root {
  --so-primary-color: #f59e0b;
  --so-secondary-color: #3b82f6;
}
```

### Priority Colors
```css
.priority-normal { background: #f1f5f9; color: #64748b; }
.priority-high { background: #fef3c7; color: #92400e; }
.priority-urgent { background: #fee2e2; color: #dc2626; }
```

### JavaScript Configuration
```javascript
// Auto-save interval (milliseconds)
const AUTO_SAVE_INTERVAL = 120000; // 2 minutes

// Notification duration
const NOTIFICATION_DURATION = 4000; // 4 seconds
```

## 📊 Database Integration

### StockMovementsRequest Table
- **requestId**: Generated unique ID
- **warehouseId**: Target warehouse
- **supplierId**: Source supplier
- **requestedBy**: Shop Owner user ID
- **status**: draft/pending/processing/completed/cancelled
- **priority**: normal/high/urgent
- **estimatedTotal**: Calculated total amount
- **products**: JSON array of requested products

### Request Lifecycle
1. **Draft**: Shop Owner đang chỉnh sửa
2. **Pending**: Đã gửi, chờ Warehouse xử lý
3. **Processing**: Warehouse đang xử lý
4. **Completed**: Đã hoàn thành nhập hàng
5. **Cancelled**: Đã hủy yêu cầu

## 🐛 Troubleshooting

### Common Issues

#### Upload Excel không hoạt động
- **Kiểm tra**: File format (.xlsx, .xls)
- **Solution**: Sử dụng template được cung cấp

#### Auto-save không hoạt động
- **Kiểm tra**: Session còn valid
- **Kiểm tra**: Network connection
- **Solution**: Manual save trước khi logout

#### Không thể gửi yêu cầu
- **Kiểm tra**: Đã chọn kho và nhà cung cấp
- **Kiểm tra**: Có ít nhất 1 sản phẩm
- **Solution**: Điền đầy đủ thông tin bắt buộc

### Browser Support
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 📞 Hỗ trợ

### Development
- **Logs**: Check browser console và server logs
- **Debug**: Enable development mode
- **Testing**: Use sample data provided

### Production
- **Monitoring**: Track request success rates
- **Performance**: Monitor auto-save frequency
- **User feedback**: Collect usability feedback

---

## 🔗 Related Documentation

- [Warehouse Manager Import Processing](README-warehouse-import.md)
- [Shop Owner User Guide](README-shop-owner.md)
- [API Documentation](README-api.md)

---

**Phiên bản**: 1.0  
**Ngày cập nhật**: 27/12/2024  
**Tác giả**: TSMS Development Team  
**Workflow**: Shop Owner → Warehouse Manager