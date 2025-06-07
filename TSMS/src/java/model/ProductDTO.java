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
public class ProductDTO extends Product {

    private int productDetailId;
    private int quantity;
    private String description;
    private String serialNum;
    private String warrantyPeriod;
    private String promoName;
    private double discountPercent;
    private Date startDate;
    private Date endDate;


    public ProductDTO(int productDetailId, int quantity, String description, String serialNum, String warrantyPeriod, String promoName, double discountPercent, Date startDate, Date endDate, int productId, String productName, String brand, String category, String supplier, String costPrice, String retailPrice, String imgUrl, String isActive) {
        super(productId, productName, brand, category, supplier, costPrice, retailPrice, imgUrl, isActive);
        this.productDetailId = productDetailId;
        this.quantity = quantity;
        this.description = description;
        this.serialNum = serialNum;
        this.warrantyPeriod = warrantyPeriod;
        this.promoName = promoName;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public ProductDTO(int productDetailId, int quantity, String description, String serialNum, String warrantyPeriod, String promoName, double discountPercent, Date startDate, Date endDate, int productId, String productName, String brand, String category, String supplier, String costPrice, String retailPrice, String imgUrl, Date CreatedAt, String isActive) {
        super(productId, productName, brand, category, supplier, costPrice, retailPrice, imgUrl, CreatedAt, isActive);
        this.productDetailId = productDetailId;
        this.quantity = quantity;
        this.description = description;
        this.serialNum = serialNum;
        this.warrantyPeriod = warrantyPeriod;
        this.promoName = promoName;
        this.discountPercent = discountPercent;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public int getProductDetailId() {
        return productDetailId;
    }

    public void setProductDetailId(int productDetailId) {
        this.productDetailId = productDetailId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSerialNum() {
        return serialNum;
    }

    public void setSerialNum(String serialNum) {
        this.serialNum = serialNum;
    }

    public String getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(String warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }

    public String getPromoName() {
        return promoName;
    }

    public void setPromoName(String promoName) {
        this.promoName = promoName;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    @Override
    public String toString() {
        return "ProductDTO{" + "productDetailId=" + productDetailId + ", quantity=" + quantity + ", description=" + description + ", serialNum=" + serialNum + ", warrantyPeriod=" + warrantyPeriod + ", promoName=" + promoName + ", discountPercent=" + discountPercent + ", startDate=" + startDate + ", endDate=" + endDate + '}';
    }

    
}
