/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import util.Validate;

/**
 *
 * @author admin
 */
public class ProductDetailDTO {

    private int productDetailID;
    private int productID;
    private String productName;
    private String fullName;
    private String productCode;
    private String description;
    private String warrantyPeriod;
    private int brandID;
    private int categoryID;
    private int supplierID;
    private double costPrice;
    private double retailPrice;
    private double vat;
    private String imageURL;
    private boolean isActive;
    private String productNameUnsigned;
    private java.sql.Timestamp productCreatedAt;
    private java.sql.Timestamp detailCreatedAt;
    private java.sql.Timestamp updatedAt;
    private int quantity;
    private String formattedCostPrice;

    public ProductDetailDTO() {
    }

  
public String getFormattedCostPrice() {
    if (formattedCostPrice == null || formattedCostPrice.isEmpty()) {
        formattedCostPrice = Validate.formatCostPriceToVND(this.costPrice);
    }
    return formattedCostPrice;
}


    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Getters, setters & constructors
    public ProductDetailDTO(int productDetailID, int productID, String productName, String fullName,
            String productCode, String description, String warrantyPeriod,
            int brandID, int categoryID, int supplierID,
            double costPrice, double retailPrice, double vat,
            String imageURL, boolean isActive, String productNameUnsigned,
            java.sql.Timestamp productCreatedAt,
            java.sql.Timestamp detailCreatedAt,
            java.sql.Timestamp updatedAt) {
        this.productDetailID = productDetailID;
        this.productID = productID;
        this.productName = productName;
        this.fullName = fullName;
        this.productCode = productCode;
        this.description = description;
        this.warrantyPeriod = warrantyPeriod;
        this.brandID = brandID;
        this.categoryID = categoryID;
        this.supplierID = supplierID;
        this.costPrice = costPrice;
        this.retailPrice = retailPrice;
        this.vat = vat;
        this.imageURL = imageURL;
        this.isActive = isActive;
        this.productNameUnsigned = productNameUnsigned;
        this.productCreatedAt = productCreatedAt;
        this.detailCreatedAt = detailCreatedAt;
        this.updatedAt = updatedAt;
    }

    public int getProductDetailID() {
        return productDetailID;
    }

    public void setProductDetailID(int productDetailID) {
        this.productDetailID = productDetailID;
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

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getProductCode() {
        return productCode;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(String warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }

    public int getBrandID() {
        return brandID;
    }

    public void setBrandID(int brandID) {
        this.brandID = brandID;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getSupplierID() {
        return supplierID;
    }

    public void setSupplierID(int supplierID) {
        this.supplierID = supplierID;
    }

    public double getCostPrice() {
        return costPrice;
    }

    public void setCostPrice(double costPrice) {
        this.costPrice = costPrice;
    }

    public double getRetailPrice() {
        return retailPrice;
    }

    public void setRetailPrice(double retailPrice) {
        this.retailPrice = retailPrice;
    }

    public double getVat() {
        return vat;
    }

    public void setVat(double vat) {
        this.vat = vat;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getProductNameUnsigned() {
        return productNameUnsigned;
    }

    public void setProductNameUnsigned(String productNameUnsigned) {
        this.productNameUnsigned = productNameUnsigned;
    }

    public Timestamp getProductCreatedAt() {
        return productCreatedAt;
    }

    public void setProductCreatedAt(Timestamp productCreatedAt) {
        this.productCreatedAt = productCreatedAt;
    }

    public Timestamp getDetailCreatedAt() {
        return detailCreatedAt;
    }

    public void setDetailCreatedAt(Timestamp detailCreatedAt) {
        this.detailCreatedAt = detailCreatedAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {
        return "ProductDetailDTO{" + "productDetailID=" + productDetailID + ", productID=" + productID + ", productName=" + productName + ", fullName=" + fullName + ", productCode=" + productCode + ", description=" + description + ", warrantyPeriod=" + warrantyPeriod + ", brandID=" + brandID + ", categoryID=" + categoryID + ", supplierID=" + supplierID + ", costPrice=" + costPrice + ", retailPrice=" + retailPrice + ", vat=" + vat + ", imageURL=" + imageURL + ", isActive=" + isActive + ", productNameUnsigned=" + productNameUnsigned + ", productCreatedAt=" + productCreatedAt + ", detailCreatedAt=" + detailCreatedAt + ", updatedAt=" + updatedAt + '}';
    }

}
