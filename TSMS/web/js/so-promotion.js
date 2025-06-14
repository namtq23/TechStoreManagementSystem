/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


// Global variables
let currentPage = 1
const pageSize = 10
let totalPages = 0
const currentFilters = {
  search: "",
  discountFilter: "",
  statusFilter: "",
}
let isLoading = false
let promotionModal
let deleteModal

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  initializeComponents()
  loadPromotions()
  setupEventListeners()
})

// Initialize Bootstrap components
function initializeComponents() {
  promotionModal = new bootstrap.Modal(document.getElementById("promotionModal"))
  deleteModal = new bootstrap.Modal(document.getElementById("deleteModal"))
}

// Setup event listeners
function setupEventListeners() {
  // Search functionality
  document.getElementById("searchBtn").addEventListener("click", handleSearch)
  document.getElementById("mainSearch").addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      handleSearch()
    }
  })

  document.getElementById("sidebarSearch").addEventListener("keypress", function (e) {
    if (e.key === "Enter") {
      currentFilters.search = this.value
      loadPromotions()
    }
  })

  // Filter functionality
  document.querySelectorAll('input[name="discountFilter"]').forEach((radio) => {
    radio.addEventListener("change", function () {
      currentFilters.discountFilter = this.value
      currentPage = 1
      loadPromotions()
    })
  })

  document.querySelectorAll('input[name="statusFilter"]').forEach((radio) => {
    radio.addEventListener("change", function () {
      currentFilters.statusFilter = this.value
      currentPage = 1
      loadPromotions()
    })
  })

  // Modal functionality
  document.getElementById("addNewBtn").addEventListener("click", showCreateModal)
  document.getElementById("savePromotionBtn").addEventListener("click", savePromotion)
  document.getElementById("confirmDeleteBtn").addEventListener("click", confirmDelete)

  // Form functionality
  document.getElementById("applyToAllBranches").addEventListener("change", function () {
    const branchSelection = document.getElementById("branchSelection")
    branchSelection.style.display = this.checked ? "none" : "block"
  })

  // Select all functionality
  document.getElementById("selectAll").addEventListener("change", function () {
    const checkboxes = document.querySelectorAll(".promotion-checkbox")
    checkboxes.forEach((checkbox) => {
      checkbox.checked = this.checked
    })
  })

  // Product search
  document.getElementById("productSearch").addEventListener("input", function () {
    filterProducts(this.value)
  })
}

// Load promotions from API
async function loadPromotions() {
  if (isLoading) return

  isLoading = true
  showLoading()

  try {
    const params = new URLSearchParams({
      page: currentPage,
      pageSize: pageSize,
      search: currentFilters.search || "",
      discountFilter: currentFilters.discountFilter || "",
      statusFilter: currentFilters.statusFilter || "",
    })

    const response = await fetch(`/api/promotions?${params}`)
    const data = await response.json()

    if (data.success) {
      displayPromotions(data.data)
      updatePagination(data.currentPage, data.totalPages, data.totalItems)
      updateStats(data.data)
    } else {
      showError("Không thể tải danh sách khuyến mãi: " + data.message)
    }
  } catch (error) {
    console.error("Error loading promotions:", error)
    showError("Lỗi kết nối. Vui lòng thử lại sau.")
  } finally {
    isLoading = false
    hideLoading()
  }
}

// Display promotions in table
function displayPromotions(promotions) {
  const tbody = document.getElementById("promotionTableBody")
  const emptyState = document.getElementById("emptyState")

  if (!promotions || promotions.length === 0) {
    tbody.innerHTML = ""
    emptyState.style.display = "block"
    return
  }

  emptyState.style.display = "none"

  tbody.innerHTML = promotions
    .map(
      (promotion) => `
        <tr>
            <td>
                <input type="checkbox" class="form-check-input promotion-checkbox" value="${promotion.promotionID}">
            </td>
            <td>
                <div class="promotion-item">
                    <div class="promotion-icon">
                        <i class="fas fa-percentage"></i>
                    </div>
                    <div class="promotion-info">
                        <h6>${promotion.promotionID}</h6>
                    </div>
                </div>
            </td>
            <td>
                <div class="promotion-info">
                    <h6>${promotion.promoName}</h6>
                    <small class="text-muted">${promotion.description || ""}</small>
                </div>
            </td>
            <td>
                <span class="badge discount-badge">${promotion.discountPercent}%</span>
            </td>
            <td>${formatDate(promotion.startDate)}</td>
            <td>${formatDate(promotion.endDate)}</td>
            <td>
                <span class="badge ${promotion.applyToAllBranches ? "scope-all" : "scope-specific"}">
                    <i class="fas fa-store me-1"></i>
                    ${promotion.applyToAllBranches ? "Toàn bộ" : promotion.branchCount + " chi nhánh"}
                </span>
            </td>
            <td>
                <span class="badge status-${promotion.status}">
                    ${getStatusText(promotion.status)}
                </span>
            </td>
            <td>
                <div class="action-buttons">
                    <button class="btn btn-info btn-sm" onclick="viewPromotion(${promotion.promotionID})">
                        <i class="fas fa-info-circle"></i> Chi tiết
                    </button>
                    <button class="btn btn-danger btn-sm" onclick="showDeleteModal(${promotion.promotionID}, '${promotion.promoName}')">
                        <i class="fas fa-trash"></i> Xóa
                    </button>
                </div>
            </td>
        </tr>
    `,
    )
    .join("")
}

// Update pagination
function updatePagination(current, total, totalItems) {
  currentPage = current
  totalPages = total

  // Update pagination info
  const start = (current - 1) * pageSize + 1
  const end = Math.min(current * pageSize, totalItems)
  document.getElementById("paginationInfo").textContent =
    `Hiển thị ${start} - ${end} / Tổng số ${totalItems} khuyến mãi`

  // Generate pagination buttons
  const paginationNav = document.getElementById("paginationNav")
  let paginationHTML = ""

  // Previous button
  paginationHTML += `
        <li class="page-item ${current === 1 ? "disabled" : ""}">
            <a class="page-link" href="#" onclick="changePage(${current - 1})" aria-label="Previous">
                <i class="fas fa-chevron-left"></i>
            </a>
        </li>
    `

  // Page numbers
  const startPage = Math.max(1, current - 2)
  const endPage = Math.min(total, current + 2)

  if (startPage > 1) {
    paginationHTML += `<li class="page-item"><a class="page-link" href="#" onclick="changePage(1)">1</a></li>`
    if (startPage > 2) {
      paginationHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`
    }
  }

  for (let i = startPage; i <= endPage; i++) {
    paginationHTML += `
            <li class="page-item ${i === current ? "active" : ""}">
                <a class="page-link" href="#" onclick="changePage(${i})">${i}</a>
            </li>
        `
  }

  if (endPage < total) {
    if (endPage < total - 1) {
      paginationHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`
    }
    paginationHTML += `<li class="page-item"><a class="page-link" href="#" onclick="changePage(${total})">${total}</a></li>`
  }

  // Next button
  paginationHTML += `
        <li class="page-item ${current === total ? "disabled" : ""}">
            <a class="page-link" href="#" onclick="changePage(${current + 1})" aria-label="Next">
                <i class="fas fa-chevron-right"></i>
            </a>
        </li>
    `

  paginationNav.innerHTML = paginationHTML
}

// Update statistics
function updateStats(promotions) {
  const total = promotions.length
  const active = promotions.filter((p) => p.status === "active").length
  const scheduled = promotions.filter((p) => p.status === "scheduled").length
  const expired = promotions.filter((p) => p.status === "expired").length

  document.getElementById("totalPromotions").textContent = total
  document.getElementById("activePromotions").textContent = active
  document.getElementById("scheduledPromotions").textContent = scheduled
  document.getElementById("expiredPromotions").textContent = expired
}

// Handle search
function handleSearch() {
  const searchTerm = document.getElementById("mainSearch").value
  currentFilters.search = searchTerm
  currentPage = 1
  loadPromotions()
}

// Change page
function changePage(page) {
  if (page < 1 || page > totalPages || page === currentPage) return
  currentPage = page
  loadPromotions()
}

// Show create modal
function showCreateModal() {
  document.getElementById("modalTitle").textContent = "Tạo khuyến mãi mới"
  document.getElementById("promotionForm").reset()
  document.getElementById("promotionId").value = ""
  document.getElementById("branchSelection").style.display = "none"

  loadBranches()
  loadProducts()

  promotionModal.show()
}

// View promotion details
async function viewPromotion(promotionId) {
  try {
    const response = await fetch(`/api/promotions/${promotionId}`)
    const data = await response.json()

    if (data.success) {
      const promotion = data.data

      document.getElementById("modalTitle").textContent = "Chỉnh sửa khuyến mãi"
      document.getElementById("promotionId").value = promotion.promotionID
      document.getElementById("promoCode").value = promotion.promotionID
      document.getElementById("promoName").value = promotion.promoName
      document.getElementById("discountPercent").value = promotion.discountPercent
      document.getElementById("startDate").value = formatDateForInput(promotion.startDate)
      document.getElementById("endDate").value = formatDateForInput(promotion.endDate)
      document.getElementById("applyToAllBranches").checked = promotion.applyToAllBranches
      document.getElementById("description").value = promotion.description || ""

      // Show/hide branch selection
      const branchSelection = document.getElementById("branchSelection")
      branchSelection.style.display = promotion.applyToAllBranches ? "none" : "block"

      loadBranches(promotion.branchIDs)
      loadProducts(promotion.productIDs)

      promotionModal.show()
    } else {
      showError("Không thể tải thông tin khuyến mãi: " + data.message)
    }
  } catch (error) {
    console.error("Error loading promotion:", error)
    showError("Lỗi kết nối. Vui lòng thử lại sau.")
  }
}

// Save promotion
async function savePromotion() {
  const form = document.getElementById("promotionForm")
  const formData = new FormData(form)

  // Validate form
  if (!validateForm()) {
    return
  }

  const promotionData = {
    promotionID: formData.get("promotionId") ? Number.parseInt(formData.get("promotionId")) : generatePromotionId(),
    promoName: formData.get("promoName"),
    discountPercent: Number.parseFloat(formData.get("discountPercent")),
    startDate: formData.get("startDate"),
    endDate: formData.get("endDate"),
    applyToAllBranches: document.getElementById("applyToAllBranches").checked,
    branchIDs: getSelectedBranches(),
    productIDs: getSelectedProducts(),
    description: formData.get("description"),
  }

  try {
    const isEdit = !!formData.get("promotionId")
    const url = isEdit ? `/api/promotions/${promotionData.promotionID}` : "/api/promotions"
    const method = isEdit ? "PUT" : "POST"

    const response = await fetch(url, {
      method: method,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(promotionData),
    })

    const data = await response.json()

    if (data.success) {
      showSuccess(data.message)
      promotionModal.hide()
      loadPromotions()
    } else {
      showError(data.message)
    }
  } catch (error) {
    console.error("Error saving promotion:", error)
    showError("Lỗi kết nối. Vui lòng thử lại sau.")
  }
}

// Show delete modal
function showDeleteModal(promotionId, promotionName) {
  document.getElementById("deletePromotionName").textContent = promotionName
  document.getElementById("confirmDeleteBtn").setAttribute("data-promotion-id", promotionId)
  deleteModal.show()
}

// Confirm delete
async function confirmDelete() {
  const promotionId = document.getElementById("confirmDeleteBtn").getAttribute("data-promotion-id")

  try {
    const response = await fetch(`/api/promotions/${promotionId}`, {
      method: "DELETE",
    })

    const data = await response.json()

    if (data.success) {
      showSuccess(data.message)
      deleteModal.hide()
      loadPromotions()
    } else {
      showError(data.message)
    }
  } catch (error) {
    console.error("Error deleting promotion:", error)
    showError("Lỗi kết nối. Vui lòng thử lại sau.")
  }
}

// Load branches
async function loadBranches(selectedBranches = []) {
  try {
    const response = await fetch("/api/branches")
    const data = await response.json()

    if (data.success) {
      const container = document.querySelector(".branch-checkboxes")
      container.innerHTML = data.data
        .map(
          (branch) => `
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="${branch.branchID}" 
                           id="branch${branch.branchID}" ${selectedBranches.includes(branch.branchID) ? "checked" : ""}>
                    <label class="form-check-label" for="branch${branch.branchID}">
                        ${branch.branchName}
                    </label>
                </div>
            `,
        )
        .join("")
    }
  } catch (error) {
    console.error("Error loading branches:", error)
  }
}

// Load products
async function loadProducts(selectedProducts = []) {
  try {
    const response = await fetch("/api/products")
    const data = await response.json()

    if (data.success) {
      const container = document.querySelector(".product-checkboxes")
      container.innerHTML = data.data
        .map(
          (product) => `
                <div class="form-check">
                    <input class="form-check-input" type="checkbox" value="${product.productID}" 
                           id="product${product.productID}" ${selectedProducts.includes(product.productID) ? "checked" : ""}>
                    <label class="form-check-label" for="product${product.productID}">
                        ${product.productName}
                    </label>
                </div>
            `,
        )
        .join("")
    }
  } catch (error) {
    console.error("Error loading products:", error)
  }
}

// Filter products
function filterProducts(searchTerm) {
  const checkboxes = document.querySelectorAll(".product-checkboxes .form-check")
  checkboxes.forEach((checkbox) => {
    const label = checkbox.querySelector("label").textContent.toLowerCase()
    const matches = label.includes(searchTerm.toLowerCase())
    checkbox.style.display = matches ? "block" : "none"
  })
}

// Get selected branches
function getSelectedBranches() {
  const checkboxes = document.querySelectorAll('.branch-checkboxes input[type="checkbox"]:checked')
  return Array.from(checkboxes).map((cb) => Number.parseInt(cb.value))
}

// Get selected products
function getSelectedProducts() {
  const checkboxes = document.querySelectorAll('.product-checkboxes input[type="checkbox"]:checked')
  return Array.from(checkboxes).map((cb) => Number.parseInt(cb.value))
}

// Validate form
function validateForm() {
  let isValid = true
  const form = document.getElementById("promotionForm")

  // Clear previous validation
  form.querySelectorAll(".is-invalid").forEach((el) => el.classList.remove("is-invalid"))
  form.querySelectorAll(".invalid-feedback").forEach((el) => (el.textContent = ""))

  // Validate required fields
  const requiredFields = ["promoCode", "promoName", "discountPercent", "startDate", "endDate"]
  requiredFields.forEach((fieldName) => {
    const field = document.getElementById(fieldName)
    if (!field.value.trim()) {
      field.classList.add("is-invalid")
      field.nextElementSibling.textContent = "Trường này là bắt buộc"
      isValid = false
    }
  })

  // Validate discount percent
  const discountPercent = document.getElementById("discountPercent")
  const discountValue = Number.parseFloat(discountPercent.value)
  if (discountValue < 0 || discountValue > 100) {
    discountPercent.classList.add("is-invalid")
    discountPercent.nextElementSibling.textContent = "Tỷ lệ giảm giá phải từ 0 đến 100"
    isValid = false
  }

  // Validate dates
  const startDate = new Date(document.getElementById("startDate").value)
  const endDate = new Date(document.getElementById("endDate").value)
  if (startDate >= endDate) {
    document.getElementById("endDate").classList.add("is-invalid")
    document.getElementById("endDate").nextElementSibling.textContent = "Ngày kết thúc phải sau ngày bắt đầu"
    isValid = false
  }

  return isValid
}

// Utility functions
function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleDateString("vi-VN")
}

function formatDateForInput(dateString) {
  const date = new Date(dateString)
  return date.toISOString().split("T")[0]
}

function getStatusText(status) {
  switch (status) {
    case "active":
      return "Đang hoạt động"
    case "scheduled":
      return "Đã lên lịch"
    case "expired":
      return "Đã hết hạn"
    default:
      return status
  }
}

function generatePromotionId() {
  return Date.now() // Simple ID generation, replace with proper logic
}

function showLoading() {
  document.getElementById("loadingSpinner").style.display = "block"
  document.getElementById("promotionTableBody").style.display = "none"
}

function hideLoading() {
  document.getElementById("loadingSpinner").style.display = "none"
  document.getElementById("promotionTableBody").style.display = "table-row-group"
}

function showSuccess(message) {
  document.getElementById("successMessage").textContent = message
  const toast = new bootstrap.Toast(document.getElementById("successToast"))
  toast.show()
}

function showError(message) {
  document.getElementById("errorMessage").textContent = message
  const toast = new bootstrap.Toast(document.getElementById("errorToast"))
  toast.show()
}
