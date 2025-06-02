/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class User {

    private int userID;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String branchId;
    private String warehouseId;
    private int roleId;
    private int isActive;

    // Constructors
    public User() {
    }

    public User(int userID, String password, String fullName, String email, String phone, String branchId, String warehouseId, int roleId, int isActive) {
        this.userID = userID;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.branchId = branchId;
        this.warehouseId = warehouseId;
        this.roleId = roleId;
        this.isActive = isActive;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
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

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getBranchId() {
        return branchId;
    }

    public void setBranchId(String branchId) {
        this.branchId = branchId;
    }

    public String getWarehouseId() {
        return warehouseId;
    }

    public void setWarehouseId(String warehouseId) {
        this.warehouseId = warehouseId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getIsActive() {
        return isActive;
    }

    public void setIsActive(int isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "User{" + "userID=" + userID + ", password=" + password + ", fullName=" + fullName + ", email=" + email + ", phone=" + phone + ", branchId=" + branchId + ", warehouseId=" + warehouseId + ", roleId=" + roleId + ", isActive=" + isActive + '}';
    }

    

}
