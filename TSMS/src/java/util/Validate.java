/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author admin
 */


public class Validate {

    public static boolean isValidName(String name) {
        // Kiểm tra null hoặc chuỗi rỗng sau khi loại bỏ khoảng trắng
        if (name == null || name.trim().isEmpty()) {
            System.out.println("Tên không được để trống!");
            return false;
        }

        // Xóa khoảng trắng đầu và cuối
        name = name.trim();

        // Kiểm tra độ dài (2-50 ký tự)
        if (name.length() < 2 || name.length() > 50) {
            System.out.println("Tên phải từ 2 đến 50 ký tự!");
            return false;
        }

        // Regex: Chỉ cho phép chữ cái, dấu cách và các dấu hợp lệ (', -, .)
        String namePattern = "^[A-Za-zÀ-Ỹà-ỹ\\s'-]+$";
        if (!name.matches(namePattern)) {
            System.out.println("Tên chỉ được chứa chữ cái, dấu cách, dấu gạch ngang (-), dấu nháy đơn (')!");
            return false;
        }

        return true; // Hợp lệ
    }

    public static boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}$";
        return email != null && email.matches(emailRegex);
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 8;
    }

}
