/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author admin
 */
public class Order {

    private int orderId;
    private int branchId;
    private int createdBy;
    private String orderStatus;
    private Date createdAt;
    private int customerId;
    private String paymentMethod;
    private String note;
    private double grandTotal;
    private double customerPay;
    private double change;

    public Order(int orderId, int branchId, int createdBy, String orderStatus, Date createdAt, int customerId, String paymentMethod, String note, double grandTotal, double customerPay, double change) {
        this.orderId = orderId;
        this.branchId = branchId;
        this.createdBy = createdBy;
        this.orderStatus = orderStatus;
        this.createdAt = createdAt;
        this.customerId = customerId;
        this.paymentMethod = paymentMethod;
        this.note = note;
        this.grandTotal = grandTotal;
        this.customerPay = customerPay;
        this.change = change;
    }

    public Order(int orderId, int branchId, int createdBy, String orderStatus, int customerId, String paymentMethod, String note, double grandTotal, double customerPay, double change) {
        this.orderId = orderId;
        this.branchId = branchId;
        this.createdBy = createdBy;
        this.orderStatus = orderStatus;
        this.customerId = customerId;
        this.paymentMethod = paymentMethod;
        this.note = note;
        this.grandTotal = grandTotal;
        this.customerPay = customerPay;
        this.change = change;
    }

    public Order() {
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getBranchId() {
        return branchId;
    }

    public void setBranchId(int branchId) {
        this.branchId = branchId;
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

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
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

    @Override
    public String toString() {
        return "Order{" + "orderId=" + orderId + ", branchId=" + branchId + ", createdBy=" + createdBy + ", orderStatus=" + orderStatus + ", createdAt=" + createdAt + ", customerId=" + customerId + ", paymentMethod=" + paymentMethod + ", note=" + note + ", grandTotal=" + grandTotal + ", customerPay=" + customerPay + ", change=" + change + '}';
    }

}
