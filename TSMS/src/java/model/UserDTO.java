/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author Dell
 */
public class UserDTO {
    private int userID;
    private String fullName;
    private String phone;
    private String email;
    private int gender;
    private String avaUrl;
    private String address;
    private int isActive;
    private String roleName;
    private String branchName;
    private String warehouseName;
    private Date DOB;

    public UserDTO() {
    }

    public UserDTO(int userID, String fullName, String phone, String email, int gender, String avaUrl, String address, int isActive, String roleName, String branchName, String warehouseName) {
        this.userID = userID;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.gender = gender;
        this.avaUrl = avaUrl;
        this.address = address;
        this.isActive = isActive;
        this.roleName = roleName;
        this.branchName = branchName;
        this.warehouseName = warehouseName;
    }
    public UserDTO(int userID, String fullName, String phone, String email, int gender, String avaUrl, String address, int isActive, String roleName, String branchName, String warehouseName, Date DOB) {
        this.userID = userID;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.gender = gender;
        this.avaUrl = avaUrl;
        this.address = address;
        this.isActive = isActive;
        this.roleName = roleName;
        this.branchName = branchName;
        this.warehouseName = warehouseName;
        this.DOB = DOB;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public String getAvaUrl() {
        return avaUrl;
    }

    public void setAvaUrl(String avaUrl) {
        this.avaUrl = avaUrl;
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

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public Date getDOB() {
        return DOB;
    }

    public void setDOB(Date DOB) {
        this.DOB = DOB;
    }
}
