<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Quản lý khuyến mãi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/so-promotion.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="../common/header-so.jsp" />
    
    <div class="main-container">
        <div class="row g-0">
            <!-- Sidebar -->
            <div class="col-md-3">
                <div class="sidebar">
                    <div class="sidebar-header">
                        <i class="fas fa-percentage"></i>
                        <span>Bộ lọc khuyến mãi</span>
                    </div>
                    
                    <!-- Search Box -->
                    <div class="filter-section">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="sidebarSearch" placeholder="Tìm kiếm khuyến mãi" class="form-control">
                        </div>
                    </div>
                    
                    <!-- Discount Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <i class="fas fa-filter"></i>
                            <span>Tỷ lệ giảm</span>
                        </div>
                        <div class="filter-options">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="discountFilter" id="discountAll" value="" checked>
                                <label class="form-check-label" for="discountAll">Tất cả</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="discountFilter" id="discountLow" value="low">
                                <label class="form-check-label" for="discountLow">Dưới 15%</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="discountFilter" id="discountMedium" value="medium">
                                <label class="form-check-label" for="discountMedium">15% - 24%</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="discountFilter" id="discountHigh" value="high">
                                <label class="form-check-label" for="discountHigh">25% trở lên</label>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Status Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <i class="fas fa-calendar-alt"></i>
                            <span>Trạng thái</span>
                        </div>
                        <div class="filter-options">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusFilter" id="statusAll" value="" checked>
                                <label class="form-check-label" for="statusAll">Tất cả trạng thái</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusFilter" id="statusActive" value="active">
                                <label class="form-check-label" for="statusActive">Đang hoạt động</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusFilter" id="statusScheduled" value="scheduled">
                                <label class="form-check-label" for="statusScheduled">Đã lên lịch</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusFilter" id="statusExpired" value="expired">
                                <label class="form-check-label" for="statusExpired">Đã hết hạn</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9">
                <div class="main-content">
                    <!-- Header Actions -->
                    <div class="content-header">
                        <h4 class="page-title">Khuyến mãi</h4>
                        <div class="header-actions">
                            <div class="search-group">
                                <input type="text" id="mainSearch" class="form-control" placeholder="Theo tên khuyến mãi">
                                <button class="btn btn-success" id="searchBtn">
                                    <i class="fas fa-search"></i> Tìm Kiếm
                                </button>
                            </div>
                            <button class="btn btn-success" id="addNewBtn">
                                <i class="fas fa-plus"></i> Thêm mới
                            </button>
                            <button class="btn btn-outline-success" id="filterToggle">
                                <i class="fas fa-filter"></i>
                            </button>
                        </div>
                    </div>
                    
                    <!-- Stats Cards -->
                    <div class="stats-row">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-percentage"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number" id="totalPromotions">0</div>
                                <div class="stat-label">Tổng khuyến mãi</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon active">
                                <i class="fas fa-store"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number active" id="activePromotions">0</div>
                                <div class="stat-label">Đang hoạt động</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon scheduled">
                                <i class="fas fa-calendar-alt"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number scheduled" id="scheduledPromotions">0</div>
                                <div class="stat-label">Đã lên lịch</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon expired">
                                <i class="fas fa-archive"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number expired" id="expiredPromotions">0</div>
                                <div class="stat-label">Đã hết hạn</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Data Table -->
                    <div class="table-container">
                        <div class="table-responsive">
                            <table class="table promotion-table">
                                <thead>
                                    <tr>
                                        <th width="50">
                                            <input type="checkbox" id="selectAll" class="form-check-input">
                                        </th>
                                        <th>Mã khuyến mãi</th>
                                        <th>Tên khuyến mãi</th>
                                        <th>Giảm giá</th>
                                        <th>Ngày bắt đầu</th>
                                        <th>Ngày kết thúc</th>
                                        <th>Phạm vi</th>
                                        <th>Trạng thái</th>
                                        <th width="150">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody id="promotionTableBody">
                                    <!-- Data will be loaded here via AJAX -->
                                </tbody>
                            </table>
                        </div>
                        
                        <!-- Loading Spinner -->
                        <div class="loading-spinner" id="loadingSpinner">
                            <div class="spinner-border text-success" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>
                        
                        <!-- Empty State -->
                        <div class="empty-state" id="emptyState" style="display: none;">
                            <i class="fas fa-percentage"></i>
                            <h5>Không có khuyến mãi nào</h5>
                            <p>Chưa có khuyến mãi nào được tạo hoặc không tìm thấy kết quả phù hợp.</p>
                            <button class="btn btn-success" onclick="showCreateModal()">
                                <i class="fas fa-plus"></i> Tạo khuyến mãi đầu tiên
                            </button>
                        </div>
                    </div>
                    
                    <!-- Pagination -->
                    <div class="pagination-container">
                        <div class="pagination-info">
                            <span id="paginationInfo">Hiển thị 0 - 0 / Tổng số 0 khuyến mãi</span>
                        </div>
                        <nav aria-label="Pagination">
                            <ul class="pagination" id="paginationNav">
                                <!-- Pagination will be generated here -->
                            </ul>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Create/Edit Modal -->
    <div class="modal fade" id="promotionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalTitle">Tạo khuyến mãi mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="promotionForm">
                        <input type="hidden" id="promotionId" name="promotionId">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="promoCode" class="form-label">Mã khuyến mãi <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="promoCode" name="promoCode" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="discountPercent" class="form-label">Tỷ lệ giảm giá (%) <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" id="discountPercent" name="discountPercent" min="0" max="100" step="0.01" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="promoName" class="form-label">Tên khuyến mãi <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="promoName" name="promoName" required>
                            <div class="invalid-feedback"></div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="startDate" class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="endDate" class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="applyToAllBranches" name="applyToAllBranches" checked>
                                <label class="form-check-label" for="applyToAllBranches">
                                    Áp dụng cho tất cả chi nhánh
                                </label>
                            </div>
                        </div>
                        
                        <div class="mb-3" id="branchSelection" style="display: none;">
                            <label class="form-label">Chọn chi nhánh áp dụng</label>
                            <div class="branch-checkboxes">
                                <!-- Branch checkboxes will be loaded here -->
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Sản phẩm áp dụng</label>
                            <div class="product-selection">
                                <input type="text" class="form-control mb-2" id="productSearch" placeholder="Tìm kiếm sản phẩm...">
                                <div class="product-checkboxes" style="max-height: 200px; overflow-y: auto;">
                                    <!-- Product checkboxes will be loaded here -->
                                </div>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="description" class="form-label">Mô tả (tùy chọn)</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-success" id="savePromotionBtn">
                        <i class="fas fa-save"></i> Lưu khuyến mãi
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa khuyến mãi "<span id="deletePromotionName"></span>"?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Toast Container -->
    <div class="toast-container position-fixed top-0 end-0 p-3">
        <div id="successToast" class="toast" role="alert">
            <div class="toast-header bg-success text-white">
                <i class="fas fa-check-circle me-2"></i>
                <strong class="me-auto">Thành công</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body" id="successMessage"></div>
        </div>
        
        <div id="errorToast" class="toast" role="alert">
            <div class="toast-header bg-danger text-white">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong class="me-auto">Lỗi</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body" id="errorMessage"></div>
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/sopromotion.js"></script>
</body>
</html>
