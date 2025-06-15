<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.PromotionDTO" %>
<%@ page import="util.Validate" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - Quản lý khuyến mãi</title>
    <link rel="stylesheet" href="css/so-promotion.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header-so.jsp" />
    
    <div class="main-container">
        <div class="row g-0">
            <!-- ✅ Sidebar -->
            <div class="col-md-3 col-lg-2">
                <div class="sidebar">
                    <div class="sidebar-header">
                        <i class="fas fa-percentage"></i>
                        Khuyến mãi
                    </div>
                    
                    <!-- Search Section -->
                    <div class="filter-section">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" class="form-control" id="sidebarSearch" 
                                   placeholder="Tìm kiếm khuyến mãi..." value="${param.search}">
                        </div>
                    </div>
                    
                    <!-- Status Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <i class="fas fa-filter"></i>
                            Trạng thái
                        </div>
                        <div class="filter-options">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="statusFilter" id="statusAll" value="" checked>
                                <label class="form-check-label" for="statusAll">Tất cả</label>
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
                    
                    <!-- Discount Filter -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <i class="fas fa-percentage"></i>
                            Mức giảm giá
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
                                <label class="form-check-label" for="discountMedium">15% - 25%</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="discountFilter" id="discountHigh" value="high">
                                <label class="form-check-label" for="discountHigh">Trên 25%</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- ✅ Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content">
                    <!-- Content Header -->
                    <div class="content-header">
                        <h1 class="page-title">Khuyến mãi</h1>
                        <div class="header-actions">
                            <div class="search-group">
                                <input type="text" class="form-control" id="mainSearch" 
                                       placeholder="Theo tên khuyến mãi" value="${param.search}">
                                <button type="button" class="btn btn-outline-success" onclick="performSearch()">
                                    Tìm Kiếm
                                </button>
                            </div>
                            <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createPromotionModal">
                                <i class="fas fa-plus"></i> Thêm mới
                            </button>
                        </div>
                    </div>
                    
                    <!-- Alert Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Stats Cards -->
                    <div class="stats-row">
                        <div class="stat-card">
                            <div class="stat-icon">
                                <i class="fas fa-percentage"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${totalPromotions}</div>
                                <div class="stat-label">Tổng khuyến mãi</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon active">
                                <i class="fas fa-play-circle"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number active">${activePromotions}</div>
                                <div class="stat-label">Đang hoạt động</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon scheduled">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number scheduled">${scheduledPromotions}</div>
                                <div class="stat-label">Đã lên lịch</div>
                            </div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon expired">
                                <i class="fas fa-stop-circle"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number expired">${expiredPromotions}</div>
                                <div class="stat-label">Đã hết hạn</div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Promotions Table -->
                    <div class="table-container">
                        <c:choose>
                            <c:when test="${empty promotions}">
                                <div class="empty-state">
                                    <i class="fas fa-percentage"></i>
                                    <h5>Chưa có khuyến mãi nào</h5>
                                    <p>Hãy tạo khuyến mãi đầu tiên cho cửa hàng của bạn!</p>
                                    <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createPromotionModal">
                                        <i class="fas fa-plus"></i> Tạo khuyến mãi đầu tiên
                                    </button>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="table promotion-table">
                                    <thead>
                                        <tr>
                                            <th>
                                                <input type="checkbox" class="form-check-input" id="selectAll">
                                            </th>
                                            <th>Mã khuyến mãi</th>
                                            <th>Tên khuyến mãi</th>
                                            <th>Giảm giá</th>
                                            <th>Thời gian</th>
                                            <th>Phạm vi</th>
                                            <th>Trạng thái</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="promotion" items="${promotions}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox" class="form-check-input" value="${promotion.promotionID}">
                                                </td>
                                                <td>
                                                    <div class="promotion-item">
                                                        <div class="promotion-icon">
                                                            <i class="fas fa-tag"></i>
                                                        </div>
                                                        <div class="promotion-info">
                                                            <h6>${promotion.promotionID}</h6>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div class="promotion-info">
                                                        <h6>${promotion.promoName}</h6>
                                                        <c:if test="${not empty promotion.description}">
                                                            <small>${promotion.description}</small>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="badge discount-badge">
                                                        ${promotion.formattedDiscountPercent}
                                                    </span>
                                                </td>
                                                <td>
                                                    <small>
                                                        <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy" />
                                                        <br>đến<br>
                                                        <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy" />
                                                    </small>
                                                </td>
                                                <td>
                                                    <span class="badge scope-specific">
                                                        <i class="fas fa-map-marker-alt"></i> ${promotion.branchCount} chi nhánh
                                                    </span>
                                                    <br><small>${promotion.productCount} sản phẩm</small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${promotion.status == 'active'}">
                                                            <span class="badge status-active">
                                                                <i class="fas fa-play"></i> Đang hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${promotion.status == 'scheduled'}">
                                                            <span class="badge status-scheduled">
                                                                <i class="fas fa-clock"></i> Đã lên lịch
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge status-expired">
                                                                <i class="fas fa-stop"></i> Đã hết hạn
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <button type="button" class="btn btn-info btn-sm" 
                                                                onclick="viewPromotion(${promotion.promotionID})"
                                                                title="Chi tiết">
                                                            Chi tiết
                                                        </button>
                                                        <button type="button" class="btn btn-danger btn-sm" 
                                                                onclick="deletePromotion(${promotion.promotionID}, '${promotion.promoName}')"
                                                                title="Xóa">
                                                            Xóa
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${not empty promotions}">
                        <div class="pagination-container">
                            <div class="pagination-info">
                                Hiển thị 1 - ${promotions.size()} / Tổng số ${totalPromotions} khuyến mãi
                            </div>
                            <nav aria-label="Promotion pagination">
                                <ul class="pagination">
                                    <li class="page-item disabled">
                                        <a class="page-link" href="#" aria-label="Previous">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                    </li>
                                    <li class="page-item active">
                                        <a class="page-link" href="#">1</a>
                                    </li>
                                    <li class="page-item">
                                        <a class="page-link" href="#">2</a>
                                    </li>
                                    <li class="page-item">
                                        <a class="page-link" href="#" aria-label="Next">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Create Promotion Modal -->
    <div class="modal fade" id="createPromotionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form method="POST" action="so-promotions" id="createPromotionForm">
                    <input type="hidden" name="action" value="create">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-plus"></i> Tạo khuyến mãi mới
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="mb-3">
                                    <label for="promoName" class="form-label">
                                        Tên khuyến mãi <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="promoName" name="promoName" 
                                           placeholder="VD: Khuyến mãi mùa hè 2024" required>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập tên khuyến mãi.
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="discountPercent" class="form-label">
                                        Tỷ lệ giảm giá (%) <span class="text-danger">*</span>
                                    </label>
                                    <input type="number" class="form-control" id="discountPercent" name="discountPercent" 
                                           min="0" max="100" step="0.1" placeholder="VD: 15" required>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập tỷ lệ giảm giá từ 0 đến 100%.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label">Mô tả</label>
                                    <input type="text" class="form-control" name="description" 
                                           placeholder="Mô tả ngắn về khuyến mãi">
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="startDate" class="form-label">
                                        Ngày bắt đầu <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" required>
                                    <div class="invalid-feedback">
                                        Vui lòng chọn ngày bắt đầu.
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="endDate" class="form-label">
                                        Ngày kết thúc <span class="text-danger">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="endDate" name="endDate" required>
                                    <div class="invalid-feedback">
                                        Vui lòng chọn ngày kết thúc.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fas fa-times"></i> Hủy
                        </button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save"></i> Tạo khuyến mãi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set minimum date to today
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('startDate').min = today;
            document.getElementById('endDate').min = today;
            
            // Update end date minimum when start date changes
            document.getElementById('startDate').addEventListener('change', function() {
                document.getElementById('endDate').min = this.value;
            });
            
            // Form validation
            const form = document.getElementById('createPromotionForm');
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            });
            
            // Sync search boxes
            const sidebarSearch = document.getElementById('sidebarSearch');
            const mainSearch = document.getElementById('mainSearch');
            
            sidebarSearch.addEventListener('input', function() {
                mainSearch.value = this.value;
            });
            
            mainSearch.addEventListener('input', function() {
                sidebarSearch.value = this.value;
            });
            
            // Select all checkbox
            const selectAll = document.getElementById('selectAll');
            if (selectAll) {
                selectAll.addEventListener('change', function() {
                    const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
                    checkboxes.forEach(checkbox => {
                        checkbox.checked = this.checked;
                    });
                });
            }
        });

        // Search function
        function performSearch() {
            const searchTerm = document.getElementById('mainSearch').value;
            const statusFilter = document.querySelector('input[name="statusFilter"]:checked').value;
            const discountFilter = document.querySelector('input[name="discountFilter"]:checked').value;
            
            let url = 'so-promotions?';
            if (searchTerm) url += 'search=' + encodeURIComponent(searchTerm) + '&';
            if (statusFilter) url += 'status=' + statusFilter + '&';
            if (discountFilter) url += 'discount=' + discountFilter + '&';
            
            window.location.href = url;
        }

        // Filter change handlers
        document.querySelectorAll('input[name="statusFilter"], input[name="discountFilter"]').forEach(radio => {
            radio.addEventListener('change', performSearch);
        });

        // View promotion details
        function viewPromotion(promotionId) {
            window.location.href = 'so-promotions?action=view&id=' + promotionId;
        }

        // Delete promotion
        function deletePromotion(promotionId, promotionName) {
            if (confirm('Bạn có chắc chắn muốn xóa khuyến mãi "' + promotionName + '"?\n\nHành động này không thể hoàn tác!')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'so-promotions';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'promotionId';
                idInput.value = promotionId;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                document.body.appendChild(form);
                form.submit();
            }
        }

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.style.transition = 'opacity 0.5s';
                        alert.style.opacity = '0';
                        setTimeout(() => alert.remove(), 500);
                    }
                }, 5000);
            });
        });
    </script>
</body>
</html>
