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
public class UserDTO extends User{
    private String shopName;
    private int isActive;
    private Date createAt;

    public UserDTO() {
    }

    public UserDTO(String shopName, int isActive, Date createAt) {
        this.shopName = shopName;
        this.isActive = isActive;
        this.createAt = createAt;
    }

    public UserDTO(String shopName, int isActive, Date createAt, int accountId, int role, String fullName, String email, String password) {
        super(accountId, role, fullName, email, password);
        this.shopName = shopName;
        this.isActive = isActive;
        this.createAt = createAt;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    @Override
    public String toString() {
        return "UserDTO{" + "shopName=" + shopName + ", isActive=" + isActive + ", createAt=" + createAt + '}';
    }
    
    
}
