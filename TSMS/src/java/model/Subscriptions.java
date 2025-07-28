/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class Subscriptions {
    private int methodId;
    private String subscriptionName;
    private String subscriptionPrice;

    public Subscriptions(int methodId, String subscriptionName, String subscriptionPrice) {
        this.methodId = methodId;
        this.subscriptionName = subscriptionName;
        this.subscriptionPrice = subscriptionPrice;
    }

    public int getMethodId() {
        return methodId;
    }

    public void setMethodId(int methodId) {
        this.methodId = methodId;
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

    @Override
    public String toString() {
        return "Subcriptions{" + "methodId=" + methodId + ", subscriptionName=" + subscriptionName + ", subscriptionPrice=" + subscriptionPrice + '}';
    }
    
    
    
}
