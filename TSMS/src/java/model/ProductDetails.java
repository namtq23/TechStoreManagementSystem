/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model;

/**
 *
 * @author phungpdhe189026
 */
import java.sql.Timestamp;

public class ProductDetails {
    private int productDetailID;
    private String description;
    private String serialNumber;
    private String warrantyPeriod;
    private Timestamp detailCreatedAt;
    private Timestamp updatedAt;

    // Constructor
    public ProductDetails(int productDetailID, String description, String serialNumber,
                         String warrantyPeriod, Timestamp detailCreatedAt, Timestamp updatedAt) {
        this.productDetailID = productDetailID;
        this.description = description;
        this.serialNumber = serialNumber;
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

    public String getSerialNumber() {
        return serialNumber;
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

    // Setter
    public void setProductDetailID(int productDetailID) {
        this.productDetailID = productDetailID;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
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

    // toString()
    @Override
    public String toString() {
        return "ProductDetail{" +
                "productDetailID=" + productDetailID +
                ", description='" + description + '\'' +
                ", serialNumber='" + serialNumber + '\'' +
                ", warrantyPeriod='" + warrantyPeriod + '\'' +
                ", detailCreatedAt=" + detailCreatedAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
