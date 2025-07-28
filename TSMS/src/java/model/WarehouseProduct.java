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
public class WarehouseProduct {
private int warehouseID;
    private int productDetailID;
    private int quantity;

    public WarehouseProduct(int warehouseID, int productDetailID, int quantity) {
        this.warehouseID = warehouseID;
        this.productDetailID = productDetailID;
        this.quantity = quantity;
    }

    public WarehouseProduct() {
    }

    public int getWarehouseID() {
        return warehouseID;
    }

    public void setWarehouseID(int warehouseID) {
        this.warehouseID = warehouseID;
    }

    public int getProductDetailID() {
        return productDetailID;
    }

    public void setProductDetailID(int productDetailID) {
        this.productDetailID = productDetailID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
}
