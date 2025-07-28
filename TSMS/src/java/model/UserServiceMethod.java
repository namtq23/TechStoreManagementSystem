/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
import java.util.Date;

public class UserServiceMethod {

    private int ownerId;
    private boolean isTrial; 
    private Date trialEndDate;
    private Date subscriptionEnd;

    public UserServiceMethod() {
    }

    public UserServiceMethod(int ownerId, boolean isTrial, Date trialEndDate, Date subscriptionEnd) {
        this.ownerId = ownerId;
        this.isTrial = isTrial;
        this.trialEndDate = trialEndDate;
        this.subscriptionEnd = subscriptionEnd;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public boolean isTrial() {
        return isTrial;
    }

    public void setTrial(boolean isTrial) {
        this.isTrial = isTrial;
    }

    public Date getTrialEndDate() {
        return trialEndDate;
    }

    public void setTrialEndDate(Date trialEndDate) {
        this.trialEndDate = trialEndDate;
    }

    public Date getSubscriptionEnd() {
        return subscriptionEnd;
    }

    public void setSubscriptionEnd(Date subscriptionEnd) {
        this.subscriptionEnd = subscriptionEnd;
    }
}
