/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Dell
 */
public class OrdersDTO extends Orders {

    private int orderDetailID;
    private int productDetailID;
    private int quantity;
    private String branchName;
    private String customerName;
    private String createdByName;
    private String productName;
    private String customerPhone;
    private String customerEmail;
    private String customerAddress;
    private Boolean customerGender;
    private Date customerDOB;
    
    private String createdByEmail;
    private String createdByPhone;
    private Boolean createdByGender;
    private String createdByAddress;
    private String createdByAvaUrl;
    private String roleName;
    
    private int productID;
    private double costPrice;
    private double VAT;
    private Boolean productIsActive;
    private String imageURL;
    private String productDescription;
    private String productCode;
    private String warrantyPeriod;
    private String serialNumber;

    public OrdersDTO(int orderDetailID, int productDetailID, int quantity, int orderID, int branchID, int createdBy, String orderStatus, int customerID, String paymentMethod, String notes, double grandTotal, double customerPay, double change) {
        super(orderID, branchID, createdBy, orderStatus, customerID, paymentMethod, notes, grandTotal, customerPay, change);
        this.orderDetailID = orderDetailID;
        this.productDetailID = productDetailID;
        this.quantity = quantity;
    }

    public OrdersDTO(int orderDetailID, int productDetailID, int quantity, int orderID, int branchID, int createdBy, String orderStatus, Date createdAt, int customerID, String paymentMethod, String notes, double grandTotal, double customerPay, double change) {
        super(orderID, branchID, createdBy, orderStatus, createdAt, customerID, paymentMethod, notes, grandTotal, customerPay, change);
        this.orderDetailID = orderDetailID;
        this.productDetailID = productDetailID;
        this.quantity = quantity;
    }

    public OrdersDTO(int orderDetailID, int productDetailID, int quantity, String branchName, String customerName, String createdByName, String productName, int orderID, int branchID, int createdBy, String orderStatus, Date createdAt, int customerID, String paymentMethod, String notes, double grandTotal, double customerPay, double change) {
        super(orderID, branchID, createdBy, orderStatus, createdAt, customerID, paymentMethod, notes, grandTotal, customerPay, change);
        this.orderDetailID = orderDetailID;
        this.productDetailID = productDetailID;
        this.quantity = quantity;
        this.branchName = branchName;
        this.customerName = customerName;
        this.createdByName = createdByName;
        this.productName = productName;
    }
    public String getCustomerPhone() { return customerPhone; }
    public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }
    
    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }
    
    public String getCustomerAddress() { return customerAddress; }
    public void setCustomerAddress(String customerAddress) { this.customerAddress = customerAddress; }
    
    public Boolean getCustomerGender() { return customerGender; }
    public void setCustomerGender(Boolean customerGender) { this.customerGender = customerGender; }
    
    public Date getCustomerDOB() { return customerDOB; }
    public void setCustomerDOB(Date customerDOB) { this.customerDOB = customerDOB; }
    
    public String getCreatedByEmail() { return createdByEmail; }
    public void setCreatedByEmail(String createdByEmail) { this.createdByEmail = createdByEmail; }
    
    public String getCreatedByPhone() { return createdByPhone; }
    public void setCreatedByPhone(String createdByPhone) { this.createdByPhone = createdByPhone; }
    
    public Boolean getCreatedByGender() { return createdByGender; }
    public void setCreatedByGender(Boolean createdByGender) { this.createdByGender = createdByGender; }
    
    public String getCreatedByAddress() { return createdByAddress; }
    public void setCreatedByAddress(String createdByAddress) { this.createdByAddress = createdByAddress; }
    
    public String getCreatedByAvaUrl() { return createdByAvaUrl; }
    public void setCreatedByAvaUrl(String createdByAvaUrl) { this.createdByAvaUrl = createdByAvaUrl; }
    
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
    
    public int getProductID() { return productID; }
    public void setProductID(int productID) { this.productID = productID; }
    
    public double getCostPrice() { return costPrice; }
    public void setCostPrice(double costPrice) { this.costPrice = costPrice; }
    
    public double getVAT() { return VAT; }
    public void setVAT(double VAT) { this.VAT = VAT; }
    
    public Boolean getProductIsActive() { return productIsActive; }
    public void setProductIsActive(Boolean productIsActive) { this.productIsActive = productIsActive; }
    
    public String getImageURL() { return imageURL; }
    public void setImageURL(String imageURL) { this.imageURL = imageURL; }
    
    public String getProductDescription() { return productDescription; }
    public void setProductDescription(String productDescription) { this.productDescription = productDescription; }
    
    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }
    
    public String getWarrantyPeriod() { return warrantyPeriod; }
    public void setWarrantyPeriod(String warrantyPeriod) { this.warrantyPeriod = warrantyPeriod; }
    
    public String getSerialNumber() { return serialNumber; }
    public void setSerialNumber(String serialNumber) { this.serialNumber = serialNumber; }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(int orderDetailID) {
        this.orderDetailID = orderDetailID;
    }

    public int getProductDetailID() {
        return productDetailID;
    }

    public void setProductDetailID(int productDetailID) {
        this.productDetailID = productDetailID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    
    
}
