package model;

import java.util.Date;


public class Customer {

    private int customerId;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String address;
    private Boolean gender; 
    private Date dateOfBirth;
    private Date createdAt;
    private Date updatedAt;
    private Integer branchId;
    private double grandTotal;
public Integer getBranchId() { return branchId; }
public void setBranchId(Integer branchId) { this.branchId = branchId; }


public Customer(int customerId, String fullName, String phoneNumber, String email,
                String address, Boolean gender, Date dateOfBirth,
                Date createdAt, Date updatedAt, Integer branchId, double grandTotal) {
    this.customerId = customerId;
    this.fullName = fullName;
    this.phoneNumber = phoneNumber;
    this.email = email;
    this.address = address;
    this.gender = gender;
    this.dateOfBirth = dateOfBirth;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
    this.branchId = branchId;
    this.grandTotal = grandTotal;
}


    // Getters and Setters
    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(Date dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    public double getGrandTotal() {
    return grandTotal;
    }

    
    @Override

public String toString() {
    return "Customer{" +
            "customerId=" + customerId +
            ", fullName='" + fullName + '\'' +
            ", phoneNumber='" + phoneNumber + '\'' +
            ", email='" + email + '\'' +
            ", address='" + address + '\'' +
            ", gender=" + gender +
            ", dateOfBirth=" + dateOfBirth +
            ", createdAt=" + createdAt +
            ", updatedAt=" + updatedAt +
            ", branchId=" + branchId +
            ", grandTotal=" + grandTotal +
            '}';
}

}
