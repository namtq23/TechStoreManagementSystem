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
public class OrdersDTO extends Orders{
    private int orderDetailID;
    private int productDetailID;
    private int quantity;
    private String branchName;
    private String customerName;
    private String createdByName;
    private String productName;

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
    public OrdersDTO(int orderDetailID, int productDetailID, int quantity, int orderID, int branchID, int createdBy, 
                     String orderStatus, Date createdAt, int customerID, String paymentMethod, String notes, 
                     double grandTotal, double customerPay, double change, String branchName, String customerName, 
                     String createdByName) {
        super(orderID, branchID, createdBy, orderStatus, createdAt, customerID, paymentMethod, notes, grandTotal, customerPay, change);
        this.orderDetailID = orderDetailID;
        this.productDetailID = productDetailID;
        this.quantity = quantity;
        this.branchName = branchName;
        this.customerName = customerName;
        this.createdByName = createdByName;
    }
    public String getBranchName() { return branchName; }
    public void setBranchName(String branchName) { this.branchName = branchName; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
    public String getProductName() { return productName; }
public void setProductName(String productName) { this.productName = productName; }

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
