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
public class ShopOwnerDTO extends ShopOwner{
    private Date trial;
    private String status;
    private String subscription;
    private Date subscriptionStart;
    private Date subscriptionEnd;

    public ShopOwnerDTO(Date trial, String status, String subscription, Date subscriptionStart, Date subscriptionEnd, int ownerId, String password, String fullName, String shopName, String databaseName, String email, String identificationID, String gender, String address, String phone, int isActive, Date createdAt) {
        super(ownerId, password, fullName, shopName, databaseName, email, identificationID, gender, address, phone, isActive, createdAt);
        this.trial = trial;
        this.status = status;
        this.subscription = subscription;
        this.subscriptionStart = subscriptionStart;
        this.subscriptionEnd = subscriptionEnd;
    }

    

    public Date getTrial() {
        return trial;
    }

    public void setTrial(Date trial) {
        this.trial = trial;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSubscription() {
        return subscription;
    }

    public void setSubscription(String subscription) {
        this.subscription = subscription;
    }

    public Date getSubscriptionStart() {
        return subscriptionStart;
    }

    public void setSubscriptionStart(Date subscriptionStart) {
        this.subscriptionStart = subscriptionStart;
    }

    public Date getSubscriptionEnd() {
        return subscriptionEnd;
    }

    public void setSubscriptionEnd(Date subscriptionEnd) {
        this.subscriptionEnd = subscriptionEnd;
    }

    @Override
    public String toString() {
        return "ShopOwnerDTO{" + super.getFullName() +"trial=" + trial + ", status=" + status + ", subscription=" + subscription + ", subscriptionStart=" + subscriptionStart + ", subscriptionEnd=" + subscriptionEnd + '}';
    }

    
    
    
    
}
