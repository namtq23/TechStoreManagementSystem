package model;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author admin
 */

public class ShopOwner {
    private int ownerId;
    private String password;
    private String fullName;
    private String shopName;
    private String databaseName;
    private String email;


    // Constructors
    public ShopOwner() {}

    public ShopOwner(int ownerId, String password, String fullName,
                     String shopName, String databaseName, String email) {
        this.ownerId = ownerId;
        this.password = password;
        this.fullName = fullName;
        this.shopName = shopName;
        this.databaseName = databaseName;
        this.email = email;
    }

    // Getters and Setters
    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getDatabaseName() {
        return databaseName;
    }

    public void setDatabaseName(String databaseName) {
        this.databaseName = databaseName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    @Override
    public String toString() {
        return "ShopOwner{" +
                "ownerId=" + ownerId +
                ", password='" + password + '\'' +
                ", fullName='" + fullName + '\'' +
                ", shopName='" + shopName + '\'' +
                ", databaseName='" + databaseName + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
