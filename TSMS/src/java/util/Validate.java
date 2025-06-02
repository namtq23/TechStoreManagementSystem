/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

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

    public static String shopNameConverter(String input) {
        // Kiểm tra chuỗi rỗng hoặc null
        if (input == null || input.trim().isEmpty()) {
            return "DTB_";
        }

        // Loại bỏ dấu tiếng Việt và chuyển thành chữ thường
        String normalized = java.text.Normalizer.normalize(input, java.text.Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase();

        // Tách chuỗi thành mảng các từ
        String[] words = normalized.split("\\s+");

        // Chuyển đổi mỗi từ: viết hoa chữ cái đầu
        StringBuilder result = new StringBuilder("DTB_");
        for (String word : words) {
            if (!word.isEmpty()) {
                result.append(Character.toUpperCase(word.charAt(0)))
                        .append(word.substring(1));
            }
        }

        return result.toString();
    }

    public static String formatDateTime(Date date) {
        if (date == null) {
            return "Chưa cập nhật";
        }
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        return sdf.format(date);
    }

    public static String formatCostPriceToVND(String costPriceStr) {
        if (costPriceStr == null || costPriceStr.equalsIgnoreCase("NULL")) {
            return "NULL";
        }

        try {
            Double costPrice = Double.valueOf(costPriceStr);

            NumberFormat vndFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedAmount = vndFormat.format(costPrice).replace("₫", "VND");

            return formattedAmount;
        } catch (NumberFormatException e) {
            return "NULL";
        }
    }

    public static void main(String[] args) {
        // Test hàm với đầu vào mới
        String input = "hanh tinh xanh";
        System.out.println("Input: " + input + " -> Output: " + shopNameConverter(input));
    }

}
