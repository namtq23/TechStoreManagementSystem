/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.Normalizer;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Pattern;

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

    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches("0\\d{9}");
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

    public static String toInputDate(Date date) {
        if (date == null) {
            return "";
        }
        return new java.text.SimpleDateFormat("yyyy-MM-dd").format(date);
    }

    public static String formatCostPriceToVND(String costPriceStr) {
        if (costPriceStr == null || costPriceStr.equalsIgnoreCase("NULL")) {
            return "NULL";
        }

        try {
            Double costPrice = Double.valueOf(costPriceStr);

            NumberFormat vndFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            String formattedAmount = vndFormat.format(costPrice).replace("₫", "₫");

            return formattedAmount;
        } catch (NumberFormatException e) {
            return "NULL";
        }
    }

    public static String formatCurrency(BigDecimal amount) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        DecimalFormat formatter = new DecimalFormat("#,###", symbols);
        return formatter.format(amount);  // trả về chuỗi như "5.000.000"
    }

    public static String formatDoubleCurrency(Double amount) {
        DecimalFormatSymbols symbols = new DecimalFormatSymbols(new Locale("vi", "VN"));
        symbols.setGroupingSeparator('.');
        DecimalFormat formatter = new DecimalFormat("#,###", symbols);
        return formatter.format(amount);  // trả về chuỗi như "5.000.000"
    }

    public static double calculatePercentageChange(BigDecimal today, BigDecimal yesterday) {
        if (yesterday.compareTo(BigDecimal.ZERO) == 0) {
            if (today.compareTo(BigDecimal.ZERO) == 0) {
                return 0.0;
            } else {
                return 100.0;
            }
        }
        return today.subtract(yesterday)
                .divide(yesterday, 2, RoundingMode.HALF_UP)
                .multiply(BigDecimal.valueOf(100))
                .doubleValue();
    }

    public static LocalDate getSameDayPreviousMonthSafe(int monthsAgo) {
        LocalDate today = LocalDate.now();
        // Lùi lại 'monthsAgo' tháng
        LocalDate previousMonth = today.minusMonths(monthsAgo);

        // Xử lý nếu ngày hiện tại không tồn tại trong tháng trước (vd: 31 → 30 hoặc 28/29)
        int lastDayOfMonth = previousMonth.lengthOfMonth();
        int day = Math.min(today.getDayOfMonth(), lastDayOfMonth);

        return LocalDate.of(previousMonth.getYear(), previousMonth.getMonth(), day);
    }

    //Format cost theo VND
    public static String formatCostPriceToVND(double costPrice) {
        try {
            NumberFormat vndFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
            return vndFormat.format(costPrice);
        } catch (Exception e) {
            return "0";
        }
    }
    // Method để format date

    public static String getFormattedDate(LocalDateTime createdAt) {
        if (createdAt != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
            return createdAt.format(formatter);
        }
        return "-";
    }

    public static double safeParseDouble(String input) throws NumberFormatException {
        if (input == null || input.trim().isEmpty()) {
            return 0.0;
        }

        input = input.replaceAll("[^\\d]", "");

        return Double.parseDouble(input);
    }

    public static String normalizeSearch(String input) {
        if (input == null) {
            return null;
        }

        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);

        String noDiacritics = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");

        noDiacritics = noDiacritics.replaceAll("đ", "d").replaceAll("Đ", "D");

        String lowerCased = noDiacritics.toLowerCase();

        String cleaned = lowerCased.replaceAll("\\s+", " ").trim();

        return cleaned;
    }

    public static String standardizeName(String name) {
        String standardizedName = "";
        standardizedName = name.trim();
        return standardizedName;
    }

    public static void main(String[] args) {
        // Test hàm với đầu vào mới
        String input = "hanh tinh xanh";
        System.out.println("Input: " + input + " -> Output: " + shopNameConverter(input));

        System.out.println(safeParseDouble("1.250.000"));

        System.out.println(standardizeName("       an       d     "));

        System.out.println(normalizeSearch("Máy"));
    }

}
