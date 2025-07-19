/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.lang.*;
import java.util.*;
import java.io.*;

/**
 *
 * @author Trieu Quang Nam
 */
public class ProductDetailSerialNumber {

    private int productDetailID;
    private String serialNumber;
    private String status;
    private Integer orderID;       // có thể null
    private Integer branchID;      // có thể null
    private Integer warehouseID;   // có thể null
    private String error;// dùng để hiển thị lỗi nếu có
    private int movementDetailID;
    private String movementHistory;

    // Getter và Setter
    public String getMovementHistory() {
        return movementHistory;
    }

    public void setMovementHistory(String movementHistory) {
        this.movementHistory = movementHistory;
    }

    public ProductDetailSerialNumber() {
    }

    public ProductDetailSerialNumber(int productDetailID, String serialNumber, String status, Integer orderID, Integer branchID, Integer warehouseID) {
        this.productDetailID = productDetailID;
        this.serialNumber = serialNumber;
        this.status = status;
        this.orderID = orderID;
        this.branchID = branchID;
        this.warehouseID = warehouseID;
    }

    public int getProductDetailID() {
        return productDetailID;
    }

    public void setProductDetailID(int productDetailID) {
        this.productDetailID = productDetailID;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getOrderID() {
        return orderID;
    }

    public void setOrderID(Integer orderID) {
        this.orderID = orderID;
    }

    public Integer getBranchID() {
        return branchID;
    }

    public void setBranchID(Integer branchID) {
        this.branchID = branchID;
    }

    public Integer getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(Integer warehouseID) {
        this.warehouseID = warehouseID;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public int getMovementDetailID() {
        return movementDetailID;
    }

    public void setMovementDetailID(int movementDetailID) {
        this.movementDetailID = movementDetailID;
    }

    @Override
    public String toString() {
        return "ProductDetailSerialNumber{"
                + "productDetailID=" + productDetailID
                + ", serialNumber='" + serialNumber + '\''
                + ", status='" + status + '\''
                + ", orderID=" + orderID
                + ", branchID=" + branchID
                + ", warehouseID=" + warehouseID
                + ", error='" + error + '\''
                + '}';
    }
}
