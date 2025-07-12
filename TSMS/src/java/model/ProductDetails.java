/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model;

/**
 *
 * @author phungpdhe189026
 */
import java.math.BigDecimal;
import java.sql.Timestamp;

public class ProductDetails {
    private int productDetailID;
    private String description;
    private String productCode;
    private String warrantyPeriod;
    private Timestamp detailCreatedAt;
    private Timestamp updatedAt;
    private String productNameUnsigned;  
    private int quantity;  

 
    // Constructor
    public ProductDetails(int productDetailID, String description, String productCode,
                         String warrantyPeriod, Timestamp detailCreatedAt, Timestamp updatedAt) {
        this.productDetailID = productDetailID;
        this.description = description;
        this.productCode = productCode;

        this.warrantyPeriod = warrantyPeriod;
        this.detailCreatedAt = detailCreatedAt;
        this.updatedAt = updatedAt;
    }

    // Getter
    public int getProductDetailID() {
        return productDetailID;
    }

    public String getDescription() {
        return description;
    }

    public String getProductCode() {
        return productCode;
    }

    public String getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public Timestamp getDetailCreatedAt() {
        return detailCreatedAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public String getProductNameUnsigned() {
        return productNameUnsigned;
    }
    
    public int getQuantity() {
        return quantity;
    }

    

    // Setter
    public void setProductDetailID(int productDetailID) {
        this.productDetailID = productDetailID;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setProductCode(String productCode) {
        this.productCode = productCode;
    }

    public void setWarrantyPeriod(String warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }

    public void setDetailCreatedAt(Timestamp detailCreatedAt) {
        this.detailCreatedAt = detailCreatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public void setProductNameUnsigned(String productNameUnsigned) {
        this.productNameUnsigned = productNameUnsigned;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
   
    // toString()
    @Override
    public String toString() {
        return "ProductDetail{" +
                "productDetailID=" + productDetailID +
                ", description='" + description + '\'' +
                ", productCode='" + productCode + '\'' +
                ", warrantyPeriod='" + warrantyPeriod + '\'' +
                ", detailCreatedAt=" + detailCreatedAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
    public ProductDetails() {
}

}


