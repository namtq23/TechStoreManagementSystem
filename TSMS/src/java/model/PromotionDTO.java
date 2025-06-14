package model;

import java.math.BigDecimal;
import java.util.Date;

/*
DTO class kế thừa từ Promotion - có thêm logic hiển thị và tính toán
 */
public class PromotionDTO extends Promotions {
    private String status;              // Trạng thái tính toán (Đang áp dụng/Hết hạn/Chưa áp dụng)
    private String description;         // Mô tả tự động tạo
    private String displayBadge;        // Text hiển thị trên badge (10%, Khuyến mãi)
    private boolean isActive;           // Có đang hoạt động không
    private String statusClass;         // CSS class cho status
    
    // Constructor
    public PromotionDTO() {
        super();
    }
    
    public PromotionDTO(int promotionID, String promoName, BigDecimal discountPercent,
                       Date startDate, Date endDate, boolean applyToAllBranches) {
        // Gọi constructor của class cha (Promotion)
        super(promotionID, promoName, discountPercent, startDate, endDate, applyToAllBranches);
        
        // Tính toán các giá trị bổ sung cho hiển thị
        calculateStatus();
        generateDescription();
        generateDisplayBadge();
        generateStatusClass();
    }
    
    /*
     Tính toán trạng thái dựa trên ngày hiện tại
     */
    private void calculateStatus() {
        Date now = new Date();
        
        if (super.getStartDate() != null && now.before(super.getStartDate())) {
            this.status = "Chưa áp dụng";
            this.isActive = false;
        } else if (super.getEndDate() != null && now.after(super.getEndDate())) {
            this.status = "Hết hạn";
            this.isActive = false;
        } else {
            this.status = "Đang áp dụng";
            this.isActive = true;
        }
    }
    
    /**
     * Tạo mô tả tự động dựa trên thông tin khuyến mãi
     */
    private void generateDescription() {
        StringBuilder desc = new StringBuilder();
        
        if (super.getDiscountPercent() != null && super.getDiscountPercent().compareTo(BigDecimal.ZERO) > 0) {
            desc.append("Giảm ").append(super.getDiscountPercent()).append("% ");
        }
        
        if (super.isApplyToAllBranches()) {
            desc.append("áp dụng toàn hệ thống. ");
        } else {
            desc.append("áp dụng cho chi nhánh được chỉ định. ");
        }
        
        desc.append("Chương trình khuyến mãi đặc biệt dành cho khách hàng.");
        
        this.description = desc.toString();
    }
    
    /**
     * Tạo text hiển thị trên badge
     */
    private void generateDisplayBadge() {
        if (super.getDiscountPercent() != null && super.getDiscountPercent().compareTo(BigDecimal.ZERO) > 0) {
            // Hiển thị phần trăm (ví dụ: "10%")
            this.displayBadge = super.getDiscountPercent().stripTrailingZeros().toPlainString() + "%";
        } else {
            // Hiển thị text chung
            this.displayBadge = "Khuyến mãi";
        }
    }
    
    /**
     * Tạo CSS class cho status
     */
    private void generateStatusClass() {
        switch (this.status) {
            case "Đang áp dụng":
                this.statusClass = "active";
                break;
            case "Hết hạn":
                this.statusClass = "expired";
                break;
            case "Chưa áp dụng":
                this.statusClass = "pending";
                break;
            default:
                this.statusClass = "inactive";
        }
    }
    
    // Getters cho các thuộc tính bổ sung
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getDisplayBadge() { return displayBadge; }
    public void setDisplayBadge(String displayBadge) { this.displayBadge = displayBadge; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public String getStatusClass() { return statusClass; }
    public void setStatusClass(String statusClass) { this.statusClass = statusClass; }
    
    // Override các setter để tự động cập nhật các giá trị tính toán
    @Override
    public void setStartDate(Date startDate) {
        super.setStartDate(startDate);
        calculateStatus();
        generateStatusClass();
    }
    
    @Override
    public void setEndDate(Date endDate) {
        super.setEndDate(endDate);
        calculateStatus();
        generateStatusClass();
    }
    
    @Override
    public void setDiscountPercent(BigDecimal discountPercent) {
        super.setDiscountPercent(discountPercent);
        generateDescription();
        generateDisplayBadge();
    }
    
    @Override
    public void setApplyToAllBranches(boolean applyToAllBranches) {
        super.setApplyToAllBranches(applyToAllBranches);
        generateDescription();
    }
    
    @Override
    public String toString() {
        return "PromotionDTO{" +
                "promotionID=" + super.getPromotionID() +
                ", promoName='" + super.getPromoName() + '\'' +
                ", discountPercent=" + super.getDiscountPercent() +
                ", startDate=" + super.getStartDate() +
                ", endDate=" + super.getEndDate() +
                ", applyToAllBranches=" + super.isApplyToAllBranches() +
                ", status='" + status + '\'' +
                ", displayBadge='" + displayBadge + '\'' +
                ", isActive=" + isActive +
                ", statusClass='" + statusClass + '\'' +
                '}';
    }
}
