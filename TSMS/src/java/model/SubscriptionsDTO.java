/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class SubscriptionsDTO extends Subscriptions{
    private String totalUsers;

    public SubscriptionsDTO(String totalUsers, int methodId, String subscriptionName, String subscriptionPrice) {
        super(methodId, subscriptionName, subscriptionPrice);
        this.totalUsers = totalUsers;
    }

    public String getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(String totalUsers) {
        this.totalUsers = totalUsers;
    }

    @Override
    public String toString() {
        return "SubscriptionsDTO{" + "totalUsers=" + totalUsers + '}';
    }
    
    
}
