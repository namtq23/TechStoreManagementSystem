package model;
 
import java.math.BigDecimal;
import java.time.LocalDateTime;
import util.Validate;

public class CashFlowReportDTO {
    // Các field hiện tại...
    private int cashFlowID;
    private BigDecimal amount;
    private LocalDateTime createdAt;
    private String paymentMethod;
    private int relatedOrderID;
    private String description;
    private String branchName;
    private String createdByName;
    private int customerID;
    private String customerName;
    private String category;

    
    // Thêm các field formatted (tùy chọn)
    private String formattedAmount;
    private String formattedCreatedAt;
    
    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }
    // Constructor
    public CashFlowReportDTO() {
    }

    public CashFlowReportDTO(int cashFlowID, BigDecimal amount, String paymentMethod, 
                           int relatedOrderID, LocalDateTime createdAt, String description, 
                           String branchName, String createdByName, int customerID, String customerName) {
        this.cashFlowID = cashFlowID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.relatedOrderID = relatedOrderID;
        this.createdAt = createdAt;
        this.description = description;
        this.branchName = branchName;
        this.createdByName = createdByName;
        this.customerID = customerID;
        this.customerName = customerName;
    }
    
    // Getter và Setter cho formatted fields
    public String getFormattedAmount() {
        return formattedAmount;
    }
    
    public void setFormattedAmount(String formattedAmount) {
        this.formattedAmount = formattedAmount;
    }
    
    public String getFormattedCreatedAt() {
        return formattedCreatedAt;
    }
    
    public void setFormattedCreatedAt(String formattedCreatedAt) {
        this.formattedCreatedAt = formattedCreatedAt;
    }
    
    // Method để format amount sử dụng hàm từ Validate class
    public String getFormattedAmountVND() {
        if (amount != null) {
            return Validate.formatCostPriceToVND(amount.doubleValue());
        }
        return "0 ₫";
    }
    
    // Method để format date sử dụng hàm từ Validate class
    public String getFormattedDate() {
        return Validate.getFormattedDate(createdAt);
    }
    
    // Các getter và setter cho các field gốc
    public int getCashFlowID() {
        return cashFlowID;
    }

    public void setCashFlowID(int cashFlowID) {
        this.cashFlowID = cashFlowID;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public int getRelatedOrderID() {
        return relatedOrderID;
    }

    public void setRelatedOrderID(int relatedOrderID) {
        this.relatedOrderID = relatedOrderID;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
}
