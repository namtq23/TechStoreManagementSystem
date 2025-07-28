/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model;

 import java.lang.*;
 import java.util.*;
 import java.io.*;
import java.math.BigDecimal;
/**
 *
 * @author Trieu Quang Nam
 */


public class ProductSaleDTO {
    private String productName;
    private int productId;
    private int totalQuantity;
    private BigDecimal revenue; 

    public ProductSaleDTO(String productName, int productId, int totalQuantity, BigDecimal revenue) {
        this.productName = productName;
        this.productId = productId;
        this.totalQuantity = totalQuantity;
        this.revenue = revenue;
    }

    public ProductSaleDTO(String productName, int productId, int totalQuantity) {
        this.productName = productName;
        this.productId = productId;
        this.totalQuantity = totalQuantity;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public void setRevenue(BigDecimal revenue) {
        this.revenue = revenue;
    }

    
 
}

