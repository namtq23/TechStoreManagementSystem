package model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Entity class tương ứng với bảng Promotions trong database
 */
public class Promotions {
    private int promotionID;
    private String promoName;
    private BigDecimal discountPercent;
    private Date startDate;
    private Date endDate;
    
    // Constructor
    public Promotions() {}
    
    public Promotions(int promotionID, String promoName, BigDecimal discountPercent,
                    Date startDate, Date endDate, boolean applyToAllBranches) {
        this.promotionID = promotionID;
        this.promoName = promoName;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Getters and Setters - tên method phải khớp với tên field trong database
    public int getPromotionID() { return promotionID; }
    public void setPromotionID(int promotionID) { this.promotionID = promotionID; }
    
    public String getPromoName() { return promoName; }
    public void setPromoName(String promoName) { this.promoName = promoName; }
    
    public BigDecimal getDiscountPercent() { return discountPercent; }
    public void setDiscountPercent(BigDecimal discountPercent) { this.discountPercent = discountPercent; }
    
    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }
    
    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }
    
    
    @Override
    public String toString() {
        return "Promotion{" +
                "promotionID=" + promotionID +
                ", promoName='" + promoName + '\'' +
                ", discountPercent=" + discountPercent +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                '}';
    }
}
