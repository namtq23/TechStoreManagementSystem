/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class Branch {

    private int branchId;
    private String branchName;
    private String address;
    private String phone;
    private int isActive;

    public Branch(int branchId, String branchName, String address, String phone, int isActive) {
        this.branchId = branchId;
        this.branchName = branchName;
        this.address = address;
        this.phone = phone;
        this.isActive = isActive;
    }

    public Branch() {
    }

    public int getBranchId() {
        return branchId;
    }

    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }

    public String getBranchName() {
        return branchName;
    }

    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    @Override
    public String toString() {
        return "Branch{" + "branchId=" + branchId + ", branchName=" + branchName + ", address=" + address + ", phone=" + phone + ", isActive=" + isActive + '}';
    }

}
