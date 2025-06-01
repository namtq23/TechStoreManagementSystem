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
    private String identificationID;
    private String gender;      
    private String address;
    private int isActive;

    public ShopOwner() {
    }

    public ShopOwner(int ownerId, String password, String fullName, String shopName, String databaseName, String email, String identificationID, String gender, String address, int isActive) {
        this.ownerId = ownerId;
        this.password = password;
        this.fullName = fullName;
        this.shopName = shopName;
        this.databaseName = databaseName;
        this.email = email;
        this.identificationID = identificationID;
        this.gender = gender;
        this.address = address;
        this.isActive = isActive;
    }

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

    public String getIdentificationID() {
        return identificationID;
    }

    public void setIdentificationID(String identificationID) {
        this.identificationID = identificationID;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "ShopOwner{" + "ownerId=" + ownerId + ", password=" + password + ", fullName=" + fullName + ", shopName=" + shopName + ", databaseName=" + databaseName + ", email=" + email + ", identificationID=" + identificationID + ", gender=" + gender + ", address=" + address + ", isActive=" + isActive + '}';
    }

    


    
}
