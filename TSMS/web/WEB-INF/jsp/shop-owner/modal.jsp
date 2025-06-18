<%-- modal.jsp --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TSMS - <c:choose><c:when test="${action == 'update'}">Chỉnh sửa khuyến mãi</c:when><c:otherwise>Tạo khuyến mãi mới</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="css/so-promotion.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../common/header-so.jsp" />

    <div class="container mt-5">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">
                    <i class="fas fa-<c:choose><c:when test="${action == 'update'}">edit</c:when><c:otherwise>plus</c:otherwise></c:choose>"></i>
                    <c:choose><c:when test="${action == 'update'}">Chỉnh sửa khuyến mãi</c:when><c:otherwise>Tạo khuyến mãi mới</c:otherwise></c:choose>
                </h5>
            </div>
            <div class="card-body">
                <form method="POST" action="so-promotions" id="promotionForm">
                    <input type="hidden" name="action" value="${action}">
                    <c:if test="${action == 'update'}">
                        <input type="hidden" name="promotionId" value="${promotion.promotionID}">
                    </c:if>
                    <div class="mb-3">
                        <label for="promoName" class="form-label">Tên khuyến mãi *</label>
                        <input type="text" class="form-control" id="promoName" name="promoName" 
                               value="${action == 'update' ? promotion.promoName : ''}" 
                               placeholder="VD: Khuyến mãi mùa hè 2024" required>
                    </div>
                    <div class="mb-3">
                        <label for="discountPercent" class="form-label">Tỷ lệ giảm giá (%) *</label>
                        <input type="number" class="form-control" id="discountPercent" name="discountPercent" 
                               value="${action == 'update' ? promotion.discountPercent : ''}" 
                               min="0" max="100" step="0.1" placeholder="VD: 15" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả</label>
                        <input type="text" class="form-control" id="description" name="description" 
                               value="${action == 'update' ? promotion.description : ''}" 
                               placeholder="Mô tả ngắn về khuyến mãi">
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="startDate" class="form-label">Ngày bắt đầu *</label>
                            <input type="date" class="form-control" id="startDate" name="startDate" 
                                   value="${action == 'update' ? promotion.startDateFormatted : ''}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="endDate" class="form-label">Ngày kết thúc *</label>
                            <input type="date" class="form-control" id="endDate" name="endDate" 
                                   value="${action == 'update' ? promotion.endDateFormatted : ''}" required>
                        </div>
                    </div>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <div class="card-footer text-end">
                        <a href="so-promotions" class="btn btn-secondary">Hủy</a>
                        <button type="submit" class="btn btn-success">
                            <c:choose><c:when test="${action == 'update'}">Cập nhật</c:when><c:otherwise>Tạo khuyến mãi</c:otherwise></c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const today = new Date().toISOString().split('T')[0];
            const startDateInput = document.getElementById('startDate');
            const endDateInput = document.getElementById('endDate');

            startDateInput.min = today;
            startDateInput.addEventListener('change', function () {
                endDateInput.min = this.value;
            });

            const form = document.getElementById('promotionForm');
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity() || new Date(startDateInput.value) > new Date(endDateInput.value)) {
                    event.preventDefault();
                    event.stopPropagation();
                    if (new Date(startDateInput.value) > new Date(endDateInput.value)) {
                        alert('Ngày kết thúc phải sau ngày bắt đầu!');
                    }
                    form.classList.add('was-validated');
                }
            });
        });
    </script>
</body>
</html>