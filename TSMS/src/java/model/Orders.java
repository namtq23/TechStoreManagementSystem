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
public class Orders {
    private int orderID;
    private int branchID;
    private int createdBy;
    private String orderStatus;
    private Date createdAt;
    private int customerID;
    private String paymentMethod;
    private String notes;
    private double grandTotal;
    private double customerPay;
    private double change;

    public Orders() {
    }

    public Orders(int orderID, int branchID, int createdBy, String orderStatus, int customerID, String paymentMethod, String notes, double grandTotal, double customerPay, double change) {
        this.orderID = orderID;
        this.branchID = branchID;
        this.createdBy = createdBy;
        this.orderStatus = orderStatus;
        this.customerID = customerID;
        this.paymentMethod = paymentMethod;
        this.notes = notes;
        this.grandTotal = grandTotal;
        this.customerPay = customerPay;
        this.change = change;
    }

    public Orders(int orderID, int branchID, int createdBy, String orderStatus, Date createdAt, int customerID, String paymentMethod, String notes, double grandTotal, double customerPay, double change) {
        this.orderID = orderID;
        this.branchID = branchID;
        this.createdBy = createdBy;
        this.orderStatus = orderStatus;
        this.createdAt = createdAt;
        this.customerID = customerID;
        this.paymentMethod = paymentMethod;
        this.notes = notes;
        this.grandTotal = grandTotal;
        this.customerPay = customerPay;
        this.change = change;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getBranchID() {
        return branchID;
    }

    public void setBranchID(int branchID) {
        this.branchID = branchID;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public double getGrandTotal() {
        return grandTotal;
    }

    public void setGrandTotal(double grandTotal) {
        this.grandTotal = grandTotal;
    }

    public double getCustomerPay() {
        return customerPay;
    }

    public void setCustomerPay(double customerPay) {
        this.customerPay = customerPay;
    }

    public double getChange() {
        return change;
    }

    public void setChange(double change) {
        this.change = change;
    }
   
    
}
