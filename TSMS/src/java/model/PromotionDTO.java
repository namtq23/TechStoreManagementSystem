package model;

import java.sql.Date;
import java.util.List;

public class PromotionDTO {
    private int promotionID;
    private String promoName;
    private double discountPercent;
    private Date startDate;
    private Date endDate;
    private String status; 
    private List<Integer> branchIDs;
    private List<Integer> productDetailIDs; 
    private int branchCount;
    private int productCount;
    private String description;

    // Constructors
    public PromotionDTO() {}

    public PromotionDTO(int promotionID, String promoName, double discountPercent, 
                       Date startDate, Date endDate) {
        this.promotionID = promotionID;
        this.promoName = promoName;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Getters and Setters (loại bỏ applyToAllBranches)
    public int getPromotionID() { return promotionID; }
    public void setPromotionID(int promotionID) { this.promotionID = promotionID; }

    public String getPromoName() { return promoName; }
    public void setPromoName(String promoName) { this.promoName = promoName; }

    public double getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(double discountPercent) { this.discountPercent = discountPercent; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<Integer> getBranchIDs() { return branchIDs; }
    public void setBranchIDs(List<Integer> branchIDs) { this.branchIDs = branchIDs; }

    public List<Integer> getProductDetailIDs() { return productDetailIDs; }
    public void setProductDetailIDs(List<Integer> productDetailIDs) { this.productDetailIDs = productDetailIDs; }

    public int getBranchCount() { return branchCount; }
    public void setBranchCount(int branchCount) { this.branchCount = branchCount; }

    public int getProductCount() { return productCount; }
    public void setProductCount(int productCount) { this.productCount = productCount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    // Utility methods
    public String getFormattedDiscountPercent() {
        return String.format("%.1f%%", discountPercent);
    }

    public String getStatusDisplayName() {
        switch (status) {
            case "active":
                return "Đang hoạt động";
            case "scheduled":
                return "Đã lên lịch";
            case "expired":
                return "Đã hết hạn";
            default:
                return status;
        }
    }

    // Business logic methods
    public boolean isActive() {
        return "active".equals(status);
    }

    public boolean isExpired() {
        return "expired".equals(status);
    }

    public boolean isScheduled() {
        return "scheduled".equals(status);
    }

    public boolean isValidDateRange() {
        return startDate != null && endDate != null && startDate.before(endDate);
    }

    public boolean isValidDiscountPercent() {
        return discountPercent >= 0 && discountPercent <= 100;
    }

    @Override
    public String toString() {
        return "PromotionDTO{" +
                "promotionID=" + promotionID +
                ", promoName='" + promoName + '\'' +
                ", discountPercent=" + discountPercent +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", status='" + status + '\'' +
                ", branchCount=" + branchCount +
                ", productCount=" + productCount +
                '}';
    }
}
