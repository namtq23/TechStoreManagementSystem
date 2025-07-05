/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class Warehouse {

    private int wareHouseId;
    private String wareHouseName;
    private String wareHouseAddress;
    private String phone;
    private int isActive;

    public Warehouse(int wareHouseId, String wareHouseName, String wareHouseAddress, String phone, int isActive) {
        this.wareHouseId = wareHouseId;
        this.wareHouseName = wareHouseName;
        this.wareHouseAddress = wareHouseAddress;
        this.phone = phone;
        this.isActive = isActive;
    }

    public Warehouse() {
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

    public int getWareHouseId() {
        return wareHouseId;
    }

    public void setWareHouseId(int wareHouseId) {
        this.wareHouseId = wareHouseId;
    }

    public String getWareHouseName() {
        return wareHouseName;
    }

    public void setWareHouseName(String wareHouseName) {
        this.wareHouseName = wareHouseName;
    }

    public String getWareHouseAddress() {
        return wareHouseAddress;
    }

    public void setWareHouseAddress(String wareHouseAddress) {
        this.wareHouseAddress = wareHouseAddress;
    }

    @Override
    public String toString() {
        return "Warehouse{" + "wareHouseId=" + wareHouseId + ", wareHouseName=" + wareHouseName + ", wareHouseAddress=" + wareHouseAddress + ", phone=" + phone + ", isActive=" + isActive + '}';
    }

}
