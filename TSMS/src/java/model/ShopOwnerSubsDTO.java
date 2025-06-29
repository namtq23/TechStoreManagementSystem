/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author admin
 */
public class ShopOwnerSubsDTO extends ShopOwner{
    private int methodId;
    private String subscriptionMonth;
    private Timestamp logCreatedAt;

    public ShopOwnerSubsDTO(int methodId, String subscriptionMonth, Timestamp logCreatedAt, int ownerId, String password, String fullName, String fullNameUnsigned, String shopName, String databaseName, String email, String identificationID, String gender, String address, String phone, int isActive) {
        super(ownerId, password, fullName, fullNameUnsigned, shopName, databaseName, email, identificationID, gender, address, phone, isActive);
        this.methodId = methodId;
        this.subscriptionMonth = subscriptionMonth;
        this.logCreatedAt = logCreatedAt;
    }

    public int getMethodId() {
        return methodId;
    }

    public void setMethodId(int methodId) {
        this.methodId = methodId;
    }

    public String getSubscriptionMonth() {
        return subscriptionMonth;
    }

    public void setSubscriptionMonth(String subscriptionMonth) {
        this.subscriptionMonth = subscriptionMonth;
    }

    public Timestamp getLogCreatedAt() {
        return logCreatedAt;
    }

    public void setLogCreatedAt(Timestamp logCreatedAt) {
        this.logCreatedAt = logCreatedAt;
    }

    @Override
    public String toString() {
        return "ShopOwnerSubsDTO{" + "methodId=" + methodId + ", subscriptionMonth=" + subscriptionMonth + ", logCreatedAt=" + logCreatedAt + '}';
    }

    
    
            
}
