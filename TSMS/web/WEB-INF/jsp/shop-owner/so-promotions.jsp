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
            <!-- Sidebar -->
            <aside class="sidebar">
                <!-- Category Filter -->
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Khuyến mãi</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <div class="search-box">
                            <i class="fas fa-search"></i>
                            <input type="text" id="searchInput" placeholder="Tìm kiếm khuyến mãi" value="${searchTerm}">
                        </div>
                        <div class="category-tree">
                            <c:forEach var="category" items="${categories}">
                                <div class="category-item expandable ${selectedCategoryId == category.categoryID ? 'selected' : ''}">
                                    <i class="fas fa-plus"></i>
                                    <span class="category-label" onclick="filterPromotions(${category.categoryID})">${category.categoryName}</span>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Status Filter -->
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Trạng thái</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="all" ${selectedStatus == null || selectedStatus == 'all' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator all"></span>
                            Tất cả
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="active" ${selectedStatus == 'active' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator in-stock"></span>
                            Đang hoạt động
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="scheduled" ${selectedStatus == 'scheduled' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator out-stock"></span>
                            Đã lên lịch
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="statusFilter" value="expired" ${selectedStatus == 'expired' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator out-stock"></span>
                            Đã hết hạn
                        </label>
                    </div>
                </div>

                <!-- Discount Filter -->
                <div class="filter-section">
                    <div class="filter-header">
                        <h3>Mức giảm giá</h3>
                        <i class="fas fa-chevron-up"></i>
                    </div>
                    <div class="filter-content">
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="all" ${selectedDiscount == null || selectedDiscount == 'all' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator all"></span>
                            Tất cả
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="low" ${selectedDiscount == 'low' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator below"></span>
                            Dưới 15%
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="medium" ${selectedDiscount == 'medium' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator in-stock"></span>
                            15% - 25%
                        </label>
                        <label class="radio-item">
                            <input type="radio" name="discountFilter" value="high" ${selectedDiscount == 'high' ? 'checked' : ''} onchange="filterPromotions()">
                            <span class="radio-mark"></span>
                            <span class="status-indicator above"></span>
                            Trên 25%
                        </label>
                    </div>
                </div>
            </aside>

            <!-- Main Content -->
            <main class="main-content">
                <!-- Header -->
                <div class="page-header">
                    <h1>Khuyến mãi</h1>
                    <div class="header-actions">
                        <form action="so-promotions" method="get" class="search-form">
                            <div class="search-input-wrapper">
                                <i class="fas fa-search"></i>
                                <input type="text" name="search" placeholder="Theo tên khuyến mãi" value="${searchTerm}">
                            </div>
                            <button type="submit" class="btn btn-success">Tìm Kiếm</button>
                        </form>

                        <a href="so-promotions?action=create" class="btn btn-success">
                            <i class="fas fa-plus"></i> Thêm mới
                        </a>
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
                <div class="stats-grid">
                    <div class="stat-card total">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-percentage"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${totalPromotions}</div>
                                <div class="stat-label">Tổng khuyến mãi</div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card active">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-play-circle"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${activePromotions}</div>
                                <div class="stat-label">Đang hoạt động</div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card scheduled">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-clock"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${scheduledPromotions}</div>
                                <div class="stat-label">Đã lên lịch</div>
                            </div>
                        </div>
                    </div>
                    <div class="stat-card expired">
                        <div class="stat-card-content">
                            <div class="stat-icon">
                                <i class="fas fa-stop-circle"></i>
                            </div>
                            <div class="stat-info">
                                <div class="stat-number">${expiredPromotions}</div>
                                <div class="stat-label">Đã hết hạn</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tab Content -->
                <div id="tab-all" class="tab-content active">
                    <div class="table-container">
                        <table class="promotion-table">
                            <thead>
                                <tr>
                                    <th class="checkbox-col">
                                        <input type="checkbox" id="selectAll">
                                    </th>
                                    <th></th>
                                    <th>Mã khuyến mãi</th>
                                    <th>Tên khuyến mãi</th>
                                    <th>Giảm giá</th>
                                    <th>Thời gian</th>
                                    <th>Phạm vi</th>
                                    <th>Trạng thái</th>
                                    <th class="text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty promotions}">
                                        <tr>
                                            <td colspan="9" class="empty-state">
                                                <i class="fas fa-percentage"></i>
                                                <h5>Không tìm thấy khuyến mãi nào</h5>
                                                <p>Hãy thử thay đổi bộ lọc hoặc tạo khuyến mãi mới!</p>
                                                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createPromotionModal">
                                                    Tạo khuyến mãi mới
                                                </button>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="promotion" items="${promotions}">
                                            <tr class="promotion-row" data-status="${promotion.status}">
                                                <td><input type="checkbox" class="product-checkbox"></td>
                                                <td><div class="product-image accessory"></div></td>
                                                <td><strong>${promotion.promotionID}</strong></td>
                                                <td>
                                                    <div class="promotion-info">
                                                        <h6>${promotion.promoName}</h6>
                                                        <c:if test="${not empty promotion.description}">
                                                            <small>${promotion.description}</small>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td>
                                                    <span class="discount-badge">
                                                        ${promotion.formattedDiscountPercent}
                                                    </span>
                                                </td>
                                                <td>
                                                    <small class="date-text">
                                                        <fmt:formatDate value="${promotion.startDate}" pattern="dd/MM/yyyy" />
                                                        <br>đến<br>
                                                        <fmt:formatDate value="${promotion.endDate}" pattern="dd/MM/yyyy" />
                                                    </small>
                                                </td>
                                                <td>
                                                    <span class="scope-specific">
                                                        <i class="fas fa-map-marker-alt"></i> ${promotion.branchCount} chi nhánh
                                                    </span>
                                                    <br><small class="product-count">${promotion.productCount} sản phẩm</small>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${promotion.status == 'active'}">
                                                            <span class="status-badge status-active">
                                                                <i class="fas fa-play"></i> Đang hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${promotion.status == 'scheduled'}">
                                                            <span class="status-badge status-scheduled">
                                                                <i class="fas fa-clock"></i> Đã lên lịch
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-inactive">
                                                                <i class="fas fa-stop"></i> Đã hết hạn
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <form action="so-promotions" method="get" style="display:inline;">
                                                            <input type="hidden" name="action" value="view">
                                                            <input type="hidden" name="promotionId" value="${promotion.promotionID}">
                                                            <button type="submit" class="btn btn-success">
                                                                <i class="fas fa-eye"></i> Chi tiết
                                                            </button>
                                                        </form>
                                                        <form action="so-promotions" method="post" style="display:inline;
                                                              " onsubmit="return confirm('Bạn có chắc chắn muốn xoá khuyến mãi \"${promotion.promoName}\" không?');">
                                                            <input type="hidden" name="action" value="delete" />
                                                            <input type="hidden" name="promotionId" value="${promotion.promotionID}" />
                                                            <button type="submit" class="btn-delete">
                                                                <i class="fas fa-trash"></i> Xoá
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- Pagination -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị ${startPromotion} - ${endPromotion} / Tổng số ${totalPromotions} khuyến mãi
                    </div>
                    <div class="pagination">
                        <a href="so-promotions?page=1" class="page-btn ${currentPage == 1 ? "disabled" : ""}">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                        <a href="so-promotions?page=${currentPage - 1}" class="page-btn ${currentPage == 1 ? "disabled" : ""}">
                            <i class="fas fa-angle-left"></i>
                        </a>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="so-promotions?page=${i}" class="page-btn ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <a href="so-promotions?page=${currentPage + 1}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-right"></i>
                        </a>
                        <a href="so-promotions?page=${totalPages}" class="page-btn ${currentPage == totalPages ? "disabled" : ""}">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </div>
                </div>
            </main>
        </div>


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                  // Tab switching functionality
                                                                  function switchTab(tabName, buttonElement) {
                                                                      // Remove active class from all tab buttons
                                                                      document.querySelectorAll('.tab-button').forEach(btn => {
                                                                          btn.classList.remove('active');
                                                                      });

                                                                      // Add active class to clicked button
                                                                      buttonElement.classList.add('active');

                                                                      // Hide all tab contents
                                                                      document.querySelectorAll('.tab-content').forEach(content => {
                                                                          content.classList.remove('active');
                                                                      });

                                                                      // Show selected tab content
                                                                      document.getElementById('tab-' + tabName).classList.add('active');

                                                                      // Filter table rows based on tab
                                                                      filterTableByTab(tabName);
                                                                  }



                                                                  // Initialize page
                                                                  document.addEventListener('DOMContentLoaded', function () {
                                                                      const today = new Date().toISOString().split('T')[0];
                                                                      document.getElementById('startDate').min = today;
                                                                      document.getElementById('endDate').min = today;

                                                                      document.getElementById('startDate').addEventListener('change', function () {
                                                                          document.getElementById('endDate').min = this.value;
                                                                      });

                                                                      const form = document.getElementById('createPromotionForm');
                                                                      form.addEventListener('submit', function (event) {
                                                                          if (!form.checkValidity()) {
                                                                              event.preventDefault();
                                                                              event.stopPropagation();
                                                                          }
                                                                          form.classList.add('was-validated');
                                                                      });

                                                                      const sidebarSearch = document.getElementById('searchInput');
                                                                      const mainSearch = document.querySelector('input[name="search"]');

                                                                      if (sidebarSearch && mainSearch) {
                                                                          sidebarSearch.addEventListener('input', function () {
                                                                              mainSearch.value = this.value;
                                                                          });

                                                                          mainSearch.addEventListener('input', function () {
                                                                              sidebarSearch.value = this.value;
                                                                          });
                                                                      }

                                                                      const selectAll = document.getElementById('selectAll');
                                                                      if (selectAll) {
                                                                          selectAll.addEventListener('change', function () {
                                                                              const checkboxes = document.querySelectorAll('tbody input[type="checkbox"]');
                                                                              checkboxes.forEach(checkbox => {
                                                                                  checkbox.checked = this.checked;
                                                                              });
                                                                          });
                                                                      }

                                                                      // Initialize first tab as active
                                                                      filterTableByTab('all');
                                                                  });

                                                                  // Filter functions
                                                                  function filterPromotions(categoryId) {
                                                                      const search = document.getElementById('searchInput').value;
                                                                      const statusFilter = document.querySelector('input[name="statusFilter"]:checked') ? document.querySelector('input[name="statusFilter"]:checked').value : '';
                                                                      const discountFilter = document.querySelector('input[name="discountFilter"]:checked') ? document.querySelector('input[name="discountFilter"]:checked').value : '';
                                                                      let url = 'so-promotions?page=1&search=' + encodeURIComponent(search);

                                                                      if (categoryId !== null && categoryId !== undefined) {
                                                                          url += '&categoryId=' + encodeURIComponent(categoryId);
                                                                      }
                                                                      if (statusFilter)
                                                                          url += '&status=' + statusFilter;
                                                                      if (discountFilter)
                                                                          url += '&discount=' + discountFilter;

                                                                      window.location.href = url;
                                                                  }

                                                                  // Auto-hide alerts
                                                                  document.addEventListener('DOMContentLoaded', function () {
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
                                                                  // Điền dữ liệu vào modal chỉnh sửa
                                                                  document.querySelectorAll('.update-promotion-btn').forEach(button => {
                                                                      button.addEventListener('click', function () {
                                                                          const modal = document.getElementById('updatePromotionModal');
                                                                          modal.querySelector('#updatePromotionId').value = this.getAttribute('data-promotion-id');
                                                                          modal.querySelector('#updatePromoName').value = this.getAttribute('data-promo-name');
                                                                          modal.querySelector('#updateDiscountPercent').value = this.getAttribute('data-discount-percent');
                                                                          modal.querySelector('#updateStartDate').value = this.getAttribute('data-start-date');
                                                                          modal.querySelector('#updateEndDate').value = this.getAttribute('data-end-date');
                                                                      });
                                                                  });
        </script>

    </body>

