/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author phungpdhe189026
 */
import java.util.ArrayList;
import java.util.List;

public class StockMovement {

    private int movementID;
    private Integer fromSupplierID;
    private Integer fromBranchID;
    private Integer fromWarehouseID;
    private Integer toBranchID;
    private Integer toWarehouseID;
    private String movementType;
    private int createdBy;
    private Timestamp createdAt;
    private String note;

    // Gộp danh sách chi tiết yêu cầu nhập
    private List<StockMovementDetail> details;

    public StockMovement() {
        this.details = new ArrayList<>();
    }

    // Getters & Setters
    public int getMovementID() {
        return movementID;
    }

    public void setMovementID(int movementID) {
        this.movementID = movementID;
    }

    public Integer getFromSupplierID() {
        return fromSupplierID;
    }

    public void setFromSupplierID(Integer fromSupplierID) {
        this.fromSupplierID = fromSupplierID;
    }

    public Integer getFromBranchID() {
        return fromBranchID;
    }

    public void setFromBranchID(Integer fromBranchID) {
        this.fromBranchID = fromBranchID;
    }

    public Integer getFromWarehouseID() {
        return fromWarehouseID;
    }

    public void setFromWarehouseID(Integer fromWarehouseID) {
        this.fromWarehouseID = fromWarehouseID;
    }

    public Integer getToBranchID() {
        return toBranchID;
    }

    public void setToBranchID(Integer toBranchID) {
        this.toBranchID = toBranchID;
    }

    public Integer getToWarehouseID() {
        return toWarehouseID;
    }

    public void setToWarehouseID(Integer toWarehouseID) {
        this.toWarehouseID = toWarehouseID;
    }

    public String getMovementType() {
        return movementType;
    }

    public void setMovementType(String movementType) {
        this.movementType = movementType;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<StockMovementDetail> getDetails() {
        return details;
    }

    public void setDetails(List<StockMovementDetail> details) {
        this.details = details;
    }

    public void addDetail(StockMovementDetail detail) {
        if (details == null) {
            details = new ArrayList<>();
        }
        details.add(detail);
    }

    // Inner class đại diện chi tiết yêu cầu nhập
    public static class StockMovementDetail {

        private int productDetailID;
        private int quantity;

        public StockMovementDetail() {
        }

        public StockMovementDetail(int productDetailID, int quantity) {
            this.productDetailID = productDetailID;
            this.quantity = quantity;
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
}
