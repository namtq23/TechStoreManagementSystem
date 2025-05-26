/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class User {
    
    private int accountId;
    private int role;
    private String fullName;
    private String email;
    private String password;

    // Constructors
    public User() {
    }

    public User(int accountId, int role, String fullName, String email, String password) {
        this.accountId = accountId;
        this.role = role;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "User{" + "accountId=" + accountId + ", role=" + role + ", fullName=" + fullName + ", email=" + email + ", password=" + password + '}';
    }

    
    
    

}
