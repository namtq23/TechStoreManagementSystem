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
public class StockMovementDetail {

    private int detailID;
    private int requestID;
    private int productID;
    private String productName;
    private String productCode;
    private int quantity;
    private String unit;
    private String note;
    private int scanned;         // ✅ Subquery đếm tạm thời

private int productDetailID;

public int getProductDetailID() {
    return productDetailID;
}

public void setProductDetailID(int productDetailID) {
    this.productDetailID = productDetailID;
}

    private int quantityScanned; // ✅ Dữ liệu từ bảng

      private List<ProductDetailSerialNumber> serials; // Thêm dòng này


    public StockMovementDetail() {
    }
public StockMovementDetail(int productDetailID, int quantity) {
    this.detailID = productDetailID; // nếu bạn dùng detailID là ProductDetailID
    this.quantity = quantity;
}

    public StockMovementDetail(int detailID, int requestID, int productID, String productName, String productCode,
            int quantity, String unit, String note) {
        this.detailID = detailID;
        this.requestID = requestID;
        this.productID = productID;
        this.productName = productName;
        this.productCode = productCode;
        this.quantity = quantity;
        this.unit = unit;
        this.note = note;
    }

    public int getDetailID() {
        return detailID;
    }

    public void setDetailID(int detailID) {
        this.detailID = detailID;
    }

    public int getRequestID() {
        return requestID;
    }

    public void setRequestID(int requestID) {
        this.requestID = requestID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
  public int getScanned() {
        return scanned;
    }

    public void setScanned(int scanned) {
        this.scanned = scanned;
    }
        public List<ProductDetailSerialNumber> getSerials() {
        return serials;
    }

    public void setSerials(List<ProductDetailSerialNumber> serials) {
        this.serials = serials;
    }

        public int getQuantityScanned() {
        return quantityScanned;
    }

    public void setQuantityScanned(int quantityScanned) {
        this.quantityScanned = quantityScanned;
    }
    
    @Override
    public String toString() {
        return "StockMovementDetail{" + "detailID=" + detailID + ", requestID=" + requestID + ", productID=" + productID + ", productName=" + productName + ", productCode=" + productCode + ", quantity=" + quantity + ", unit=" + unit + ", note=" + note + '}';
    }

}
