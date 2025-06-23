/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Dell
 */
public class UserDTO {
    private int userID;
    private String fullName;
    private String phone;
    private int isActive;
    private String roleName;
    private String branchName;
    private String warehouseName;

    public UserDTO() {
    }

    public UserDTO(int userID, String fullName, String phone, int isActive, String roleName, String branchName, String warehouseName) {
        this.userID = userID;
        this.fullName = fullName;
        this.phone = phone;
        this.isActive = isActive;
        this.roleName = roleName;
        this.branchName = branchName;
        this.warehouseName = warehouseName;
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
    
    
}
