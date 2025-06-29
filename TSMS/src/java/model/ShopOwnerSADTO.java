/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class ShopOwnerSADTO {

    private double revenueThisMonth;
    private double revenueLastMonth;
    private Double revenueGrowthPercent;

    private int totalUsersThisMonth;
    private int newUsersLastMonth;
    private Double userGrowthPercent;

    private int activeSubscribersThisMonth;
    private int activeSubscribersLastMonth;
    private Double activeSubscribersGrowthPercent;

    public ShopOwnerSADTO(
            double revenueThisMonth, double revenueLastMonth, Double revenueGrowthPercent,
            int totalUsersThisMonth, int newUsersLastMonth, Double userGrowthPercent,
            int activeSubscribersThisMonth, int activeSubscribersLastMonth, Double activeSubscribersGrowthPercent
    ) {
        this.revenueThisMonth = revenueThisMonth;
        this.revenueLastMonth = revenueLastMonth;
        this.revenueGrowthPercent = revenueGrowthPercent;
        this.totalUsersThisMonth = totalUsersThisMonth;
        this.newUsersLastMonth = newUsersLastMonth;
        this.userGrowthPercent = userGrowthPercent;
        this.activeSubscribersThisMonth = activeSubscribersThisMonth;
        this.activeSubscribersLastMonth = activeSubscribersLastMonth;
        this.activeSubscribersGrowthPercent = activeSubscribersGrowthPercent;
    }

    public double getRevenueThisMonth() {
        return revenueThisMonth;
    }

    public void setRevenueThisMonth(double revenueThisMonth) {
        this.revenueThisMonth = revenueThisMonth;
    }

    public double getRevenueLastMonth() {
        return revenueLastMonth;
    }

    public void setRevenueLastMonth(double revenueLastMonth) {
        this.revenueLastMonth = revenueLastMonth;
    }

    public Double getRevenueGrowthPercent() {
        return revenueGrowthPercent;
    }

    public void setRevenueGrowthPercent(Double revenueGrowthPercent) {
        this.revenueGrowthPercent = revenueGrowthPercent;
    }

    public int getTotalUsersThisMonth() {
        return totalUsersThisMonth;
    }

    public void setTotalUsersThisMonth(int totalUsersThisMonth) {
        this.totalUsersThisMonth = totalUsersThisMonth;
    }

    public int getNewUsersLastMonth() {
        return newUsersLastMonth;
    }

    public void setNewUsersLastMonth(int newUsersLastMonth) {
        this.newUsersLastMonth = newUsersLastMonth;
    }

    public Double getUserGrowthPercent() {
        return userGrowthPercent;
    }

    public void setUserGrowthPercent(Double userGrowthPercent) {
        this.userGrowthPercent = userGrowthPercent;
    }

    public int getActiveSubscribersThisMonth() {
        return activeSubscribersThisMonth;
    }

    public void setActiveSubscribersThisMonth(int activeSubscribersThisMonth) {
        this.activeSubscribersThisMonth = activeSubscribersThisMonth;
    }

    public int getActiveSubscribersLastMonth() {
        return activeSubscribersLastMonth;
    }

    public void setActiveSubscribersLastMonth(int activeSubscribersLastMonth) {
        this.activeSubscribersLastMonth = activeSubscribersLastMonth;
    }

    public Double getActiveSubscribersGrowthPercent() {
        return activeSubscribersGrowthPercent;
    }

    public void setActiveSubscribersGrowthPercent(Double activeSubscribersGrowthPercent) {
        this.activeSubscribersGrowthPercent = activeSubscribersGrowthPercent;
    }

    @Override
    public String toString() {
        return "SubscriptionDashboardStats{" + "revenueThisMonth=" + revenueThisMonth + ", revenueLastMonth=" + revenueLastMonth + ", revenueGrowthPercent=" + revenueGrowthPercent + ", totalUsersThisMonth=" + totalUsersThisMonth + ", newUsersLastMonth=" + newUsersLastMonth + ", userGrowthPercent=" + userGrowthPercent + ", activeSubscribersThisMonth=" + activeSubscribersThisMonth + ", activeSubscribersLastMonth=" + activeSubscribersLastMonth + ", activeSubscribersGrowthPercent=" + activeSubscribersGrowthPercent + '}';
    }

}
