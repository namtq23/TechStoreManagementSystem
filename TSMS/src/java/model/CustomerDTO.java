/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Kawaii
 */


import java.util.Date;

public class CustomerDTO extends Customer {
    private int branchID;
    private double grandTotal;
    

    public CustomerDTO() {
        super();
    }

    public CustomerDTO(int customerId, String fullName, String phoneNumber, String email, String address, Boolean gender, Date dateOfBirth, Date createdAt, Date updatedAt, int branchID  ,double grandTotal) {
        super(customerId, fullName, phoneNumber, email, address, gender, dateOfBirth, createdAt, updatedAt);
        this.grandTotal = grandTotal;
        this.branchID = branchID;
    }

    public double getGrandTotal() {
        return grandTotal;
    }

    public void setGrandTotal(double grandTotal) {
        this.grandTotal = grandTotal;
    }

    public int getBranchID() {
        return branchID;
    }

    public void setBranchID(int branchID) {
        this.branchID = branchID;
    }

    @Override
    public String toString() {
        return super.toString() + ", CustomerDTO{" + "grandTotal=" + grandTotal + ", branchID=" + branchID + '}';
    }
}

