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
public class Product {

    private int productId;
    private String productName;
    private String brand;
    private String category;
    private String supplier;
    private String costPrice;
    private String retailPrice;
    private String imgUrl;
    private Date CreatedAt;
    private String isActive;

    public Product() {
    }
    

    public Product(int productId, String productName, String brand, String category, String supplier, String costPrice, String retailPrice, String imgUrl, String isActive) {
        this.productId = productId;
        this.productName = productName;
        this.brand = brand;
        this.category = category;
        this.supplier = supplier;
        this.costPrice = costPrice;
        this.retailPrice = retailPrice;
        this.imgUrl = imgUrl;
        this.isActive = isActive;
    }

    public Product(int productId, String productName, String brand, String category, String supplier, String costPrice, String retailPrice, String imgUrl, Date CreatedAt, String isActive) {
        this.productId = productId;
        this.productName = productName;
        this.brand = brand;
        this.category = category;
        this.supplier = supplier;
        this.costPrice = costPrice;
        this.retailPrice = retailPrice;
        this.imgUrl = imgUrl;
        this.CreatedAt = CreatedAt;
        this.isActive = isActive;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getSupplier() {
        return supplier;
    }

    public void setSupplier(String supplier) {
        this.supplier = supplier;
    }

    public String getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(String costPrice) {
        this.costPrice = costPrice;
    }

    public String getRetailPrice() {
        return retailPrice;
    }

    public void setRetailPrice(String retailPrice) {
        this.retailPrice = retailPrice;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public Date getCreatedAt() {
        return CreatedAt;
    }

    public void setCreatedAt(Date CreatedAt) {
        this.CreatedAt = CreatedAt;
    }

    public String getIsActive() {
        return isActive;
    }

    public void setIsActive(String isActive) {
        this.isActive = isActive;
    }

    @Override
    public String toString() {
        return "Product{" + "productId=" + productId + ", productName=" + productName + ", brand=" + brand + ", category=" + category + ", supplier=" + supplier + ", costPrice=" + costPrice + ", retailPrice=" + retailPrice + ", imgUrl=" + imgUrl + ", CreatedAt=" + CreatedAt + ", isActive=" + isActive + '}';
    }

}
