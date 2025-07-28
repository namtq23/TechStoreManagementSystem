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
public class User {

    private int userID;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String branchId;
    private String warehouseId;
    private String gender;
    private String avaUrl;
    private int roleId;
    private int isActive;
    private String address;
    private Date dob;
    private String identificationID;

    // Constructors
    public User() {
    }

    public User(int userID, String password, String fullName, String email, String phone, String branchId, String warehouseId, String gender, String avaUrl, int roleId, int isActive, String address, Date dob, String identificationID) {
        this.userID = userID;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.branchId = branchId;
        this.warehouseId = warehouseId;
        this.gender = gender;
        this.avaUrl = avaUrl;
        this.roleId = roleId;
        this.isActive = isActive;
        this.address = address;
        this.dob = dob;
        this.identificationID = identificationID;
    }

    public String getIdentificationID() {
        return identificationID;
    }

    public void setIdentificationID(String identificationID) {
        this.identificationID = identificationID;
    }
    
    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAvaUrl() {
        return avaUrl;
    }

    public void setAvaUrl(String avaUrl) {
        this.avaUrl = avaUrl;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
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
        return "User{" + "userID=" + userID + ", password=" + password + ", fullName=" + fullName + ", email=" + email + ", phone=" + phone + ", branchId=" + branchId + ", warehouseId=" + warehouseId + ", gender=" + gender + ", avaUrl=" + avaUrl + ", roleId=" + roleId + ", isActive=" + isActive + ", address=" + address + ", dob=" + dob + ", identificationID=" + identificationID + '}';
    }

}
