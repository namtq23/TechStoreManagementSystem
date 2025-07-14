package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import util.Validate;

public class StockMovementsRequest {
    private int movementID;
    private Integer fromSupplierID;
    private Integer fromBranchID;
    private Integer fromWarehouseID;
    private Integer toBranchID;
    private Integer toWarehouseID;
    private String movementType; // import, export.
    private int createdBy;
    private LocalDateTime createdAt;
    private String note;
    private String fromSupplierName;
    private String createdByName;
    private BigDecimal totalAmount;
    private String responseStatus; //pending-processing-completed-cancelled
    private String fromBranchName;



    // Tự động format
    private String formattedDate;
    private String formattedTotalAmount;

    // Constructors
    public StockMovementsRequest() {}

    public StockMovementsRequest(int movementID, Integer fromSupplierID, Integer fromBranchID, Integer fromWarehouseID,
                                 Integer toBranchID, Integer toWarehouseID, String movementType, int createdBy,
                                 LocalDateTime createdAt, String note, String fromSupplierName, String createdByName) {
        this.movementID = movementID;
        this.fromSupplierID = fromSupplierID;
        this.fromBranchID = fromBranchID;
        this.fromWarehouseID = fromWarehouseID;
        this.toBranchID = toBranchID;
        this.toWarehouseID = toWarehouseID;
        this.movementType = movementType;
        this.createdBy = createdBy;
        this.setCreatedAt(createdAt); // auto format
        this.note = note;
        this.fromSupplierName = fromSupplierName;
        this.createdByName = createdByName;
    }

    public StockMovementsRequest(int movementID, Integer fromSupplierID, Integer toWarehouseID,
                                 String movementType, int createdBy, LocalDateTime createdAt, String note) {
        this.movementID = movementID;
        this.fromSupplierID = fromSupplierID;
        this.toWarehouseID = toWarehouseID;
        this.movementType = movementType;
        this.createdBy = createdBy;
        this.setCreatedAt(createdAt); // auto format
        this.note = note;
    }

    public StockMovementsRequest(int movementID, Integer fromSupplierID, Integer fromBranchID, Integer fromWarehouseID,
                                 Integer toBranchID, Integer toWarehouseID, String movementType,
                                 int createdBy, LocalDateTime createdAt, String note) {
        this.movementID = movementID;
        this.fromSupplierID = fromSupplierID;
        this.fromBranchID = fromBranchID;
        this.fromWarehouseID = fromWarehouseID;
        this.toBranchID = toBranchID;
        this.toWarehouseID = toWarehouseID;
        this.movementType = movementType;
        this.createdBy = createdBy;
        this.setCreatedAt(createdAt); // auto format
        this.note = note;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
        this.formattedDate = Validate.getFormattedDate(createdAt);
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getFromSupplierName() {
        return fromSupplierName;
    }

    public void setFromSupplierName(String fromSupplierName) {
        this.fromSupplierName = fromSupplierName;
    }

    public String getCreatedByName() {
        return createdByName;
    }

    public void setCreatedByName(String createdByName) {
        this.createdByName = createdByName;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
        this.formattedTotalAmount = Validate.formatCurrency(totalAmount);
    }

    public String getFormattedDate() {
        return formattedDate;
    }

    public String getFormattedTotalAmount() {
        return formattedTotalAmount;
    }
    public String getResponseStatus() {
    return responseStatus;
}

public void setResponseStatus(String responseStatus) {
    this.responseStatus = responseStatus;
}

    @Override
    public String toString() {
        return "StockMovementsRequest{" +
                "movementID=" + movementID +
                ", fromSupplierID=" + fromSupplierID +
                ", fromBranchID=" + fromBranchID +
                ", fromWarehouseID=" + fromWarehouseID +
                ", toBranchID=" + toBranchID +
                ", toWarehouseID=" + toWarehouseID +
                ", movementType='" + movementType + '\'' +
                ", createdBy=" + createdBy +
                ", createdAt=" + createdAt +
                ", note='" + note + '\'' +
                '}';
    }

    public String getFromBranchName() {
        return fromBranchName;
    }

    public void setFromBranchName(String fromBranchName) {
        this.fromBranchName = fromBranchName;
    }

    

   
}
