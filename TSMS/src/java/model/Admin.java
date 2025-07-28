/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class Admin {

    private int adminId;
    private String password;
    private String fullName;
    private String userName;

    public Admin(int adminId, String fullName, String userName, String password) {
        this.adminId = adminId;
        this.password = password;
        this.fullName = fullName;
        this.userName = userName;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Override
    public String toString() {
        return "Admin{" + "adminId=" + adminId + ", password=" + password + ", fullName=" + fullName + ", userName=" + userName + '}';
    }

}
