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
    private BigDecimal revenue; // Thêm trường doanh thu

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

    // Getters và setters
    public String getProductName() { return productName; }
    public int getProductId() { return productId; }
    public int getTotalQuantity() { return totalQuantity; }
    public BigDecimal getRevenue() { return revenue; }
}

