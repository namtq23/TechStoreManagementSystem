/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class SubscriptionLog {
    private int ownerId;
    private int methodId;
    private String subsMonth;
    private String status;

    public SubscriptionLog(int ownerId, int methodId, String subsMonth, String status) {
        this.ownerId = ownerId;
        this.methodId = methodId;
        this.subsMonth = subsMonth;
        this.status = status;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public int getMethodId() {
        return methodId;
    }

    public void setMethodId(int methodId) {
        this.methodId = methodId;
    }

    public String getSubsMonth() {
        return subsMonth;
    }

    public void setSubsMonth(String subsMonth) {
        this.subsMonth = subsMonth;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "SubscriptionLog{" + "ownerId=" + ownerId + ", methodId=" + methodId + ", subsMonth=" + subsMonth + ", status=" + status + '}';
    }
    
    
} 
