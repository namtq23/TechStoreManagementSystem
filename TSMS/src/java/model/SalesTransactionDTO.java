package model;

import java.math.BigDecimal;
import java.util.Date;

/*
  DTO cho giao dịch bán hàng - Kết hợp dữ liệu từ Orders, Customers, Products

 */
public class SalesTransactionDTO {
    private int orderId;
    private String transactionId;
    private String customerName;
    private String customerPhone;
    private String productNames;
    private BigDecimal totalAmount;
    private Date transactionDate;
    private String orderStatus;
    private String paymentMethod;
    private String notes;
    private String statusDisplayText;    // Trạng thái hiển thị tiếng Việt
    private String formattedAmount;      // Số tiền đã format
    
    // Constructor
    public SalesTransactionDTO() {}
    
    public SalesTransactionDTO(int orderId, String customerName, String customerPhone,
                              String productNames, BigDecimal totalAmount, Date transactionDate,
                              String orderStatus, String paymentMethod) {
        this.orderId = orderId;
        this.transactionId = "GD" + String.format("%03d", orderId);
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.productNames = productNames;
        this.totalAmount = totalAmount != null ? totalAmount : BigDecimal.ZERO;
        this.transactionDate = transactionDate;
        this.orderStatus = orderStatus;
        this.paymentMethod = paymentMethod;

        generateStatusDisplayText();
        generateFormattedAmount();
    }

    // Getters and Setters
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) {
        this.orderId = orderId;
        this.transactionId = "GD" + String.format("%03d", orderId);
    }
    
    public String getTransactionId() { return transactionId; }
    
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    
    public String getProductNames() { return productNames; }
    public void setProductNames(String productNames) { this.productNames = productNames; }
    
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
        generateFormattedAmount();
    }
    
    public Date getTransactionDate() { return transactionDate; }
    public void setTransactionDate(Date transactionDate) { this.transactionDate = transactionDate; }
    
    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
        generateStatusDisplayText();
    }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public String getStatusDisplayText() { return statusDisplayText; }

    public String getFormattedAmount() { return formattedAmount; }

    /**
     * Chuyển đổi trạng thái sang tiếng Việt
     */
    private void generateStatusDisplayText() {
        if (this.orderStatus == null) {
            this.statusDisplayText = "Không xác định";
            return;
        }

        switch (this.orderStatus.toLowerCase()) {
            case "completed":
                this.statusDisplayText = "Hoàn thành";
                break;
            case "processing":
                this.statusDisplayText = "Đang xử lý";
                break;
            case "pending":
                this.statusDisplayText = "Chờ xử lý";
                break;
            case "cancelled":
                this.statusDisplayText = "Đã hủy";
                break;
            default:
                this.statusDisplayText = this.orderStatus;
        }
    }

    /**
     * Format số tiền
     */
    private void generateFormattedAmount() {
        if (this.totalAmount != null) {
            this.formattedAmount = String.format("%,.0f ₫", this.totalAmount.doubleValue());
        } else {
            this.formattedAmount = "0 ₫";
        }
    }

    @Override
    public String toString() {
        return "SalesTransactionDTO{" +
                "orderId=" + orderId +
                ", transactionId='" + transactionId + '\'' +
                ", customerName='" + customerName + '\'' +
                ", customerPhone='" + customerPhone + '\'' +
                ", productNames='" + productNames + '\'' +
                ", totalAmount=" + totalAmount +
                ", transactionDate=" + transactionDate +
                ", orderStatus='" + orderStatus + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", notes='" + notes + '\'' +
                ", statusDisplayText='" + statusDisplayText + '\'' +
                ", formattedAmount='" + formattedAmount + '\'' +
                '}';
    }
}
