/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
import java.sql.Timestamp;

public class SubscriptionLogDTO {

    private int logId;
    private int ownerId;
    private String ownerName;          
    private String subscriptionName;   
    private String subscriptionPrice;  
    private String status;
    private Timestamp createdAt;
    private int minutesAgo;

    public SubscriptionLogDTO(int logId, int ownerId, String ownerName, String subscriptionName, String subscriptionPrice, String status, Timestamp createdAt, int minutesAgo) {
        this.logId = logId;
        this.ownerId = ownerId;
        this.ownerName = ownerName;
        this.subscriptionName = subscriptionName;
        this.subscriptionPrice = subscriptionPrice;
        this.status = status;
        this.createdAt = createdAt;
        this.minutesAgo = minutesAgo;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getSubscriptionName() {
        return subscriptionName;
    }

    public void setSubscriptionName(String subscriptionName) {
        this.subscriptionName = subscriptionName;
    }

    public String getSubscriptionPrice() {
        return subscriptionPrice;
    }

    public void setSubscriptionPrice(String subscriptionPrice) {
        this.subscriptionPrice = subscriptionPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public int getMinutesAgo() {
        return minutesAgo;
    }

    public void setMinutesAgo(int minutesAgo) {
        this.minutesAgo = minutesAgo;
    }

    @Override
    public String toString() {
        return "SubscriptionLogDTO{" + "logId=" + logId + ", ownerId=" + ownerId + ", ownerName=" + ownerName + ", subscriptionName=" + subscriptionName + ", subscriptionPrice=" + subscriptionPrice + ", status=" + status + ", createdAt=" + createdAt + ", minutesAgo=" + minutesAgo + '}';
    }

    
}
