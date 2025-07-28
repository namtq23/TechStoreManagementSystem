/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class CashFlow {
    private int cashFlowID;
    private String flowType;
    private BigDecimal amount;
    private String category;
    private String description;
    private String paymentMethod;
    private Integer relatedOrderID; // Có thể null
    private Integer branchID;       // Có thể null
    private String createdBy;
    private LocalDateTime createdAt;

    // Constructors
    public CashFlow() {}

    public CashFlow(int cashFlowID, String flowType, BigDecimal amount, String category,
                    String description, String paymentMethod, Integer relatedOrderID,
                    Integer branchID, String createdBy, LocalDateTime createdAt) {
        this.cashFlowID = cashFlowID;
        this.flowType = flowType;
        this.amount = amount;
        this.category = category;
        this.description = description;
        this.paymentMethod = paymentMethod;
        this.relatedOrderID = relatedOrderID;
        this.branchID = branchID;
        this.createdBy = createdBy;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getCashFlowID() {
        return cashFlowID;
    }

    public void setCashFlowID(int cashFlowID) {
        this.cashFlowID = cashFlowID;
    }

    public String getFlowType() {
        return flowType;
    }

    public void setFlowType(String flowType) {
        this.flowType = flowType;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Integer getRelatedOrderID() {
        return relatedOrderID;
    }

    public void setRelatedOrderID(Integer relatedOrderID) {
        this.relatedOrderID = relatedOrderID;
    }

    public Integer getBranchID() {
        return branchID;
    }

    public void setBranchID(Integer branchID) {
        this.branchID = branchID;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

