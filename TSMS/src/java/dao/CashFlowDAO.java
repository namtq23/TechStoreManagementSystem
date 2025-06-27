/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.lang.*;
import java.util.*;
import java.io.*;
import java.math.BigDecimal;
import java.sql.Timestamp;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import model.CashFlow;
import model.CashFlowReportDTO;
import model.ProductDTO;
import model.ProductSaleDTO;
import model.User;
import util.DBUtil;
import util.Validate;

/**
 *
 * @author Trieu Quang Nam
 */
public class CashFlowDAO {
//TRang tổng quan

//Truy vấn tổng doanh thu (income) trong bảng CashFlows của ngày hôm nay. 
    public BigDecimal getTodayIncome(String dbName) throws SQLException {
        String sql = """
        SELECT ISNULL(SUM(Amount), 0) AS TotalIncome
        FROM CashFlows
        WHERE FlowType = 'income'
        AND CONVERT(DATE, CreatedAt) = CONVERT(DATE, GETDATE());
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("TotalIncome");
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi lấy tổng thu nhập hôm nay: " + e.getMessage());
        }

        return BigDecimal.ZERO;
    }

//Đếm số hóa đơn tổng trong ngày của tất cả các tri nhánh
    public int getTodayInvoiceCount(String dbName) throws SQLException {
        String sql = """
        SELECT COUNT(*) AS InvoiceCount
        FROM CashFlows
        WHERE CONVERT(DATE, CreatedAt) = CONVERT(DATE, GETDATE());
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("InvoiceCount");
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi đếm số hóa đơn hôm nay: " + e.getMessage());
        }

        return 0;
    }

//Lấy ra thông tin thanh toán của ngày hôm qua
    public BigDecimal getYesterdayIncome(String dbName) throws SQLException {
        String sql = """
        SELECT ISNULL(SUM(Amount), 0) AS TotalIncome
        FROM CashFlows
        WHERE FlowType = 'income'
        AND CAST(CreatedAt AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getBigDecimal("TotalIncome");
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi lấy tổng thu nhập hôm qua: " + e.getMessage());
        }
        return BigDecimal.ZERO;
    }

//Lấy ra thông tin thanh toán của ngày này tháng trước
    public BigDecimal getSameDayLastMonthIncome(String dbName) throws SQLException {
        String sql = """
        SELECT ISNULL(SUM(Amount), 0) AS TotalIncome
        FROM CashFlows
        WHERE FlowType = 'income'
        AND CONVERT(DATE, CreatedAt) = CONVERT(DATE, DATEADD(MONTH, -1, GETDATE()));
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getBigDecimal("TotalIncome");
            }
        } catch (Exception e) {
            System.out.println("Lỗi khi lấy dữ liệu cùng kỳ tháng trước: " + e.getMessage());
        }

        return BigDecimal.ZERO;
    }

    //Lấy tổng thu nhập của ngày giống hôm nay trong tháng trước
    public BigDecimal getSameDayLastMonthIncome(String dbName, LocalDate sameDayLastMonth) throws SQLException {
        String sql = """
        SELECT ISNULL(SUM(Amount), 0) AS TotalIncome
        FROM CashFlows
        WHERE FlowType = 'income'
        AND CONVERT(DATE, CreatedAt) = ?;
    """;

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Gán giá trị ngày cần truy vấn vào câu SQL
            stmt.setDate(1, java.sql.Date.valueOf(sameDayLastMonth));

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("TotalIncome");
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi khi truy vấn tổng thu nhập ngày cùng kỳ tháng trước: " + e.getMessage());
            throw e;
        }

        return BigDecimal.ZERO;
    }

    //Lấy ra doanh thu theo tháng trước
    public Map<String, Object> getPreviousMonthRevenueByDay(String dbName) throws SQLException {

        // Sử dụng DATEADD(month, -1, GETDATE()) để lấy ngày của tháng trước
        String sql = """
        SELECT 
            DAY(CreatedAt) as Day,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = YEAR(DATEADD(month, -1, GETDATE()))
        AND MONTH(CreatedAt) = MONTH(DATEADD(month, -1, GETDATE()))
        GROUP BY DAY(CreatedAt)
        ORDER BY DAY(CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> daylist = new ArrayList<>();
        List<BigDecimal> dailyRevenueList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            Map<Integer, BigDecimal> dailyRevenue = new HashMap<>();

            while (rs.next()) {
                int day = rs.getInt("Day");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                dailyRevenue.put(day, revenue);
            }

            //  Lấy số ngày của tháng trước trong Java 
            LocalDate previousMonthDate = LocalDate.now().minusMonths(1);
            int daysInPreviousMonth = previousMonthDate.lengthOfMonth();

            for (int day = 1; day <= daysInPreviousMonth; day++) {
                daylist.add(String.valueOf(day));
                BigDecimal dayRevenue = dailyRevenue.getOrDefault(day, BigDecimal.ZERO);
                dailyRevenueList.add(dayRevenue);
            }

            // Cập nhật tiêu đề biểu đồ cho rõ ràng
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("'Tháng' M/yyyy");
            String chartTitle = "Doanh thu theo ngày - " + previousMonthDate.format(formatter);
            result.put("chartTitle", chartTitle);

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu tháng trước theo ngày: " + e.getMessage());
            throw e;
        }

        result.put("labels", daylist); // Danh sách các ngày trong tháng trước (trục X)
        result.put("data", dailyRevenueList); // Dữ liệu doanh thu tương ứng (trục Y)

        return result;
    }

    //Lấy ra doanh thu theo tháng hiện tại
    public Map<String, Object> getMonthlyRevenueByDay(String dbName) throws SQLException {
        String sql = """
        SELECT 
            DAY(CreatedAt) as Day,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = YEAR(GETDATE())
        AND MONTH(CreatedAt) = MONTH(GETDATE())
        GROUP BY DAY(CreatedAt)
        ORDER BY DAY(CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> daylist = new ArrayList<>();
        List<BigDecimal> dailyRevenueList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            // Tạo map để lưu dữ liệu theo ngày
            Map<Integer, BigDecimal> dailyRevenue = new HashMap<>();

            while (rs.next()) {
                int day = rs.getInt("Day");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                dailyRevenue.put(day, revenue);

            }

            LocalDate now = LocalDate.now();
            int daysInMonth = now.lengthOfMonth();

            for (int day = 1; day <= daysInMonth; day++) {
                daylist.add(String.valueOf(day));
                BigDecimal dayRevenue = dailyRevenue.getOrDefault(day, BigDecimal.ZERO);
                dailyRevenueList.add(dayRevenue);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu theo ngày: " + e.getMessage());
            throw e;
        }
        //danh sách các ngày (dùng làm nhãn trục X trong biểu đồ)
        result.put("labels", daylist);
        //dữ liệu doanh thu theo từng ngày (trục Y biểu đồ)
        result.put("data", dailyRevenueList);

        result.put("chartTitle", "Doanh thu theo ngày trong tháng");

        return result;

    }

    // Lấy ra doanh thu theo tháng và năm cụ thể
    public Map<String, Object> getMonthlyRevenueByDay(String dbName, int year, int month) throws SQLException {
        String sql = """
        SELECT 
            DAY(CreatedAt) as Day,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = ?
        AND MONTH(CreatedAt) = ?
        GROUP BY DAY(CreatedAt)
        ORDER BY DAY(CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> daylist = new ArrayList<>();
        List<BigDecimal> dailyRevenueList = new ArrayList<>();

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, year);
            stmt.setInt(2, month);

            try (ResultSet rs = stmt.executeQuery()) {
                // Tạo map để lưu dữ liệu theo ngày
                Map<Integer, BigDecimal> dailyRevenue = new HashMap<>();

                while (rs.next()) {
                    int day = rs.getInt("Day");
                    BigDecimal revenue = rs.getBigDecimal("Revenue");
                    dailyRevenue.put(day, revenue);
                }

                // Tính số ngày trong tháng cụ thể
                LocalDate specificDate = LocalDate.of(year, month, 1);
                int daysInMonth = specificDate.lengthOfMonth();

                for (int day = 1; day <= daysInMonth; day++) {
                    daylist.add(String.valueOf(day));
                    BigDecimal dayRevenue = dailyRevenue.getOrDefault(day, BigDecimal.ZERO);
                    dailyRevenueList.add(dayRevenue);
                }
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu theo ngày: " + e.getMessage());
            throw e;
        }

        // Danh sách các ngày (dùng làm nhãn trục X trong biểu đồ)
        result.put("labels", daylist);
        // Dữ liệu doanh thu theo từng ngày (trục Y biểu đồ)
        result.put("data", dailyRevenueList);
        result.put("chartTitle", String.format("Doanh thu theo ngày tháng %d/%d", month, year));
        return result;
    }

    //Hàm lấy ra doang thu theo giờ với tháng năm cụ thể
    public Map<String, Object> getMonthlyRevenueByHour(String dbName, int year, int month) throws SQLException {
        String sql = """
        SELECT 
            DATEPART(HOUR, CreatedAt) as Hour,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = ?
        AND MONTH(CreatedAt) = ?
        GROUP BY DATEPART(HOUR, CreatedAt)
        ORDER BY DATEPART(HOUR, CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, year);
            stmt.setInt(2, month);

            try (ResultSet rs = stmt.executeQuery()) {
                // Tạo map để lưu dữ liệu theo giờ
                Map<Integer, BigDecimal> hourlyRevenue = new HashMap<>();

                while (rs.next()) {
                    int hour = rs.getInt("Hour");
                    BigDecimal revenue = rs.getBigDecimal("Revenue");
                    hourlyRevenue.put(hour, revenue);
                }

                // Tạo dữ liệu cho tất cả 24 giờ (0-23)
                for (int hour = 0; hour < 24; hour++) {
                    labels.add(String.format("%02d:00", hour)); // Format: 00:00, 01:00, ...
                    BigDecimal hourRevenue = hourlyRevenue.getOrDefault(hour, BigDecimal.ZERO);
                    data.add(hourRevenue);
                }
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu theo giờ trong tháng: " + e.getMessage());
            throw e;
        }

        result.put("labels", labels);
        result.put("data", data);
        result.put("chartTitle", String.format("Doanh thu theo giờ tháng %d/%d", month, year));
        return result;
    }

    //Hàm lấy ra doang thu theo giờ với tháng năm hiện tại
    public Map<String, Object> getMonthlyRevenueByHour(String dbName) throws SQLException {
        String sql = """
        SELECT 
            DATEPART(HOUR, CreatedAt) as Hour,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = YEAR(GETDATE())
        AND MONTH(CreatedAt) = MONTH(GETDATE())
        GROUP BY DATEPART(HOUR, CreatedAt)
        ORDER BY DATEPART(HOUR, CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            // Tạo map để lưu dữ liệu theo giờ
            Map<Integer, BigDecimal> hourlyRevenue = new HashMap<>();

            while (rs.next()) {
                int hour = rs.getInt("Hour");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                hourlyRevenue.put(hour, revenue);
            }

            // Tạo dữ liệu cho tất cả 24 giờ (0-23)
            for (int hour = 0; hour < 24; hour++) {
                labels.add(String.format("%02d:00", hour)); // Format: 00:00, 01:00, ...
                BigDecimal hourRevenue = hourlyRevenue.getOrDefault(hour, BigDecimal.ZERO);
                data.add(hourRevenue);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu theo giờ trong tháng: " + e.getMessage());
            throw e;
        }

        result.put("labels", labels);
        result.put("data", data);
        result.put("chartTitle", "Doanh thu theo giờ trong tháng");
        return result;
    }

    // Hàm lấy ra doanh thu theo giờ của tháng trước.     
    public Map<String, Object> getPreviousMonthRevenueByHour(String dbName) throws SQLException {

        // Sử dụng DATEADD(month, -1, GETDATE()) để lọc theo tháng trước
        String sql = """
        SELECT 
            DATEPART(HOUR, CreatedAt) as Hour,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = YEAR(DATEADD(month, -1, GETDATE()))
        AND MONTH(CreatedAt) = MONTH(DATEADD(month, -1, GETDATE()))
        GROUP BY DATEPART(HOUR, CreatedAt)
        ORDER BY DATEPART(HOUR, CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            // Tạo map để lưu dữ liệu theo giờ
            Map<Integer, BigDecimal> hourlyRevenue = new HashMap<>();

            while (rs.next()) {
                int hour = rs.getInt("Hour");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                hourlyRevenue.put(hour, revenue);
            }

            // Dữ liệu sẽ được điền vào từ kết quả SQL ở trên.
            for (int hour = 0; hour < 24; hour++) {
                labels.add(String.format("%02d:00", hour)); // Format: 00:00, 01:00, ...
                BigDecimal hourRevenue = hourlyRevenue.getOrDefault(hour, BigDecimal.ZERO);
                data.add(hourRevenue);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu tháng trước theo giờ: " + e.getMessage());
            throw e;
        }

        // Cập nhật tiêu đề biểu đồ cho rõ ràng
        LocalDate previousMonthDate = LocalDate.now().minusMonths(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("'Tháng' M/yyyy");
        String chartTitle = "Doanh thu theo giờ - " + previousMonthDate.format(formatter);

        result.put("labels", labels);
        result.put("data", data);
        result.put("chartTitle", chartTitle);

        return result;
    }

    //Hàm lấy ra doang thu theo thứ với tháng năm hiện tại
    public Map<String, Object> getMonthlyRevenueByWeekday(String dbName) throws SQLException {
        String sql = """
        SELECT 
                    DATEPART(WEEKDAY, CreatedAt) as WeekDay,
                    ISNULL(SUM(Amount), 0) as Revenue
                FROM CashFlows
                WHERE FlowType = 'income'
                AND YEAR(CreatedAt) = YEAR(GETDATE())
                AND MONTH(CreatedAt) = MONTH(GETDATE())
                GROUP BY DATEPART(WEEKDAY, CreatedAt)
                ORDER BY DATEPART(WEEKDAY, CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        // Tên các thứ trong tuần (SQL Server: 1=Chủ nhật, 2=Thứ 2, ...)
        String[] weekDayNames = {"Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            Map<Integer, BigDecimal> weekdayRevenue = new HashMap<>();

            while (rs.next()) {
                int weekday = rs.getInt("WeekDay");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                weekdayRevenue.put(weekday, revenue);

            }

            // Tạo dữ liệu cho 7 ngày trong tuần
            for (int i = 1; i <= 7; i++) {
                labels.add(weekDayNames[i - 1]);
                BigDecimal dayRevenue = weekdayRevenue.getOrDefault(i, BigDecimal.ZERO);
                data.add(dayRevenue);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu theo thứ: " + e.getMessage());
            throw e;
        }

        result.put("labels", labels);
        result.put("data", data);
        result.put("chartTitle", "Doanh thu theo thứ trong tháng");

        return result;
    }

    //Hàm lấy ra doang thu theo thứ với tháng năm cụ thể
    public Map<String, Object> getMonthlyRevenueByWeekday(String dbName, int year, int month) throws SQLException {
        String sql = """
        SELECT 
            DATEPART(WEEKDAY, CreatedAt) as WeekDay,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = ?
        AND MONTH(CreatedAt) = ?
        GROUP BY DATEPART(WEEKDAY, CreatedAt)
        ORDER BY DATEPART(WEEKDAY, CreatedAt)
    """;

        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        // Tên các thứ trong tuần (SQL Server: 1=Chủ nhật, 2=Thứ 2, ...)
        String[] weekDayNames = {"Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, year);
            stmt.setInt(2, month);

            try (ResultSet rs = stmt.executeQuery()) {
                Map<Integer, BigDecimal> weekdayRevenue = new HashMap<>();

                while (rs.next()) {
                    int weekday = rs.getInt("WeekDay");
                    BigDecimal revenue = rs.getBigDecimal("Revenue");
                    weekdayRevenue.put(weekday, revenue);
                }

                // Tạo dữ liệu cho 7 ngày trong tuần
                for (int i = 1; i <= 7; i++) {
                    labels.add(weekDayNames[i - 1]);
                    BigDecimal dayRevenue = weekdayRevenue.getOrDefault(i, BigDecimal.ZERO);
                    data.add(dayRevenue);
                }
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu theo thứ trong tháng: " + e.getMessage());
            throw e;
        }

        result.put("labels", labels);
        result.put("data", data);
        result.put("chartTitle", String.format("Doanh thu theo thứ tháng %d/%d", month, year));
        return result;
    }

    // Hàm lấy ra doanh thu theo thứ của tháng trước.
    public Map<String, Object> getPreviousMonthRevenueByWeekday(String dbName) throws SQLException {
        // --- THAY ĐỔI 1: Cập nhật câu lệnh SQL ---
        // Sử dụng DATEADD(month, -1, GETDATE()) để lọc theo tháng trước
        String sql = """
        SELECT 
            DATEPART(WEEKDAY, CreatedAt) as WeekDay,
            ISNULL(SUM(Amount), 0) as Revenue
        FROM CashFlows
        WHERE FlowType = 'income'
        AND YEAR(CreatedAt) = YEAR(DATEADD(month, -1, GETDATE()))
        AND MONTH(CreatedAt) = MONTH(DATEADD(month, -1, GETDATE()))
        GROUP BY DATEPART(WEEKDAY, CreatedAt)
        ORDER BY DATEPART(WEEKDAY, CreatedAt)
    """; // [1]

        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> data = new ArrayList<>();

        // Tên các thứ trong tuần (SQL Server: 1=Chủ nhật, 2=Thứ 2, ...)
        // Lưu ý: Thứ tự này phụ thuộc vào cấu hình @@DATEFIRST trên SQL Server của bạn.
        // Mặc định (US English) là 7, tức Chủ nhật là ngày đầu tuần (giá trị 1).
        String[] weekDayNames = {"Chủ nhật", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            Map<Integer, BigDecimal> weekdayRevenue = new HashMap<>();

            while (rs.next()) {
                int weekday = rs.getInt("WeekDay");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                weekdayRevenue.put(weekday, revenue);
            }

            // Phần logic này không cần thay đổi, vì luôn có 7 ngày trong một tuần.
            for (int i = 1; i <= 7; i++) {
                labels.add(weekDayNames[i - 1]);
                BigDecimal dayRevenue = weekdayRevenue.getOrDefault(i, BigDecimal.ZERO);
                data.add(dayRevenue);
            }

        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy doanh thu tháng trước theo thứ: " + e.getMessage());
            throw e;
        }

        // --- THAY ĐỔI 2: Cập nhật tiêu đề biểu đồ cho rõ ràng ---
        LocalDate previousMonthDate = LocalDate.now().minusMonths(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("'Tháng' M/yyyy");
        String chartTitle = "Doanh thu theo thứ - " + previousMonthDate.format(formatter); // [1]

        result.put("labels", labels);
        result.put("data", data);
        result.put("chartTitle", chartTitle);

        return result;
    }
// Hàm lấy ra top 5 sản phẩm bán theo số lượng tháng này

    public List<ProductSaleDTO> getTop5ProductSalesThisMonthByQuantity(String dbName) throws SQLException {
        String sql = """
        SELECT TOP 5
            p.ProductName,
            p.ProductID,    
            SUM(od.Quantity) AS TotalQuantity
        FROM CashFlows cf
        JOIN Orders o ON cf.RelatedOrderID = o.OrderID
        JOIN OrderDetails od ON o.OrderID = od.OrderID
        JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID 
        JOIN Products p ON pd.ProductID = p.ProductID  
        WHERE cf.FlowType = 'income'
          AND YEAR(cf.CreatedAt) = YEAR(GETDATE())
          AND MONTH(cf.CreatedAt) = MONTH(GETDATE())
        GROUP BY p.ProductName, p.ProductID  
        ORDER BY TotalQuantity DESC
    """;

        List<ProductSaleDTO> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String productName = rs.getString("ProductName");
                int productId = rs.getInt("ProductID");
                int totalQuantity = rs.getInt("TotalQuantity");
                result.add(new ProductSaleDTO(productName, productId, totalQuantity));
            }
        }
        return result;
    }

// Hàm lấy ra top 5 sản phẩm bán theo số lượng tháng trước
    public List<ProductSaleDTO> getTop5ProductSalesLastMonthByQuantity(String dbName) throws SQLException {
        String sql = """
    SELECT TOP 5
        p.ProductName,
        p.ProductID,    
        SUM(od.Quantity) AS TotalQuantity
    FROM CashFlows cf
    JOIN Orders o ON cf.RelatedOrderID = o.OrderID
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID  
    JOIN Products p ON pd.ProductID = p.ProductID  
    WHERE cf.FlowType = 'income'
      AND YEAR(cf.CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))
      AND MONTH(cf.CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE()))
    GROUP BY p.ProductName, p.ProductID  
    ORDER BY TotalQuantity DESC
""";

        List<ProductSaleDTO> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String productName = rs.getString("ProductName");
                int productId = rs.getInt("ProductID");
                int totalQuantity = rs.getInt("TotalQuantity");
                result.add(new ProductSaleDTO(productName, productId, totalQuantity));
            }
        }
        return result;
    }

    //Hàm lấy ra top 5 sản phẩm bán theo doanh thu chạy tháng này
    public List<ProductSaleDTO> getTop5ProductSalesThisMonthByRevenue(String dbName) throws SQLException {
        String sql = """
        SELECT TOP 5
            p.ProductName,
            p.ProductID,     
            SUM(od.Quantity) AS TotalQuantity,
            SUM(od.Quantity * p.RetailPrice) AS Revenue
        FROM CashFlows cf
        JOIN Orders o ON cf.RelatedOrderID = o.OrderID
        JOIN OrderDetails od ON o.OrderID = od.OrderID
        JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID 
        JOIN Products p ON pd.ProductID = p.ProductID  
        WHERE cf.FlowType = 'income'
          AND YEAR(cf.CreatedAt) = YEAR(GETDATE())
          AND MONTH(cf.CreatedAt) = MONTH(GETDATE())
        GROUP BY p.ProductName, p.ProductID  
        ORDER BY Revenue DESC
    """;

        List<ProductSaleDTO> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String productName = rs.getString("ProductName");
                int productId = rs.getInt("ProductID");
                int totalQuantity = rs.getInt("TotalQuantity");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                result.add(new ProductSaleDTO(productName, productId, totalQuantity, revenue));
            }
        }
        return result;
    }

    //Hàm lấy ra top 5 sản phẩm bán theo doanh thu chạy tháng trước
    public List<ProductSaleDTO> getTop5ProductSalesLastMonthByRevenue(String dbName) throws SQLException {
        String sql = """
            SELECT TOP 5
                p.ProductName,
                p.ProductID,     
                SUM(od.Quantity) AS TotalQuantity,
                SUM(od.Quantity * p.RetailPrice) AS Revenue
            FROM CashFlows cf
            JOIN Orders o ON cf.RelatedOrderID = o.OrderID
            JOIN OrderDetails od ON o.OrderID = od.OrderID
            JOIN ProductDetails pd ON od.ProductDetailID = pd.ProductDetailID  
            JOIN Products p ON pd.ProductID = p.ProductID  
            WHERE cf.FlowType = 'income'
              AND YEAR(cf.CreatedAt) = YEAR(DATEADD(MONTH, -1, GETDATE()))
              AND MONTH(cf.CreatedAt) = MONTH(DATEADD(MONTH, -1, GETDATE()))
            GROUP BY p.ProductName, p.ProductID 
            ORDER BY Revenue DESC
        """;

        List<ProductSaleDTO> result = new ArrayList<>();
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String productName = rs.getString("ProductName");
                int productId = rs.getInt("ProductID");
                int totalQuantity = rs.getInt("TotalQuantity");
                BigDecimal revenue = rs.getBigDecimal("Revenue");
                result.add(new ProductSaleDTO(productName, productId, totalQuantity, revenue));
            }
        }
        return result;
    }

    //Trang báo cáo doang thu
    //Lấy ra sản phẩm doang thu thuần
    public List<CashFlowReportDTO> getIncomeCashFlowReports(String dbName) throws SQLException {
        String sql = """
    SELECT 
        cf.CashFlowID,
        cf.Amount,
        cf.PaymentMethod,
        cf.RelatedOrderID,
        cf.CreatedAt,
        cf.Description,
        b.BranchName,
        u.FullName AS CreatedByName,
        c.CustomerID,
        c.FullName AS CustomerName
    FROM CashFlows cf
    LEFT JOIN Branches b ON cf.BranchID = b.BranchID
    LEFT JOIN Users u ON cf.CreatedBy = CAST(u.UserID AS NVARCHAR)
    LEFT JOIN Orders o ON cf.RelatedOrderID = o.OrderID
    LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE cf.FlowType = 'income'
    ORDER BY cf.CreatedAt DESC
    """;

        List<CashFlowReportDTO> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                CashFlowReportDTO dto = new CashFlowReportDTO();

                // Set dữ liệu gốc
                dto.setCashFlowID(rs.getInt("CashFlowID"));
                BigDecimal amount = rs.getBigDecimal("Amount");
                dto.setAmount(amount);
                dto.setPaymentMethod(rs.getString("PaymentMethod"));
                dto.setRelatedOrderID(rs.getInt("RelatedOrderID"));

                Timestamp ts = rs.getTimestamp("CreatedAt");
                LocalDateTime createdAt = ts != null ? ts.toLocalDateTime() : null;
                dto.setCreatedAt(createdAt);

                dto.setDescription(rs.getString("Description"));
                dto.setBranchName(rs.getString("BranchName"));
                dto.setCreatedByName(rs.getString("CreatedByName"));

                // Xử lý CustomerID có thể null
                int customerID = rs.getInt("CustomerID");
                if (rs.wasNull()) {
                    dto.setCustomerID(0);
                } else {
                    dto.setCustomerID(customerID);
                }

                dto.setCustomerName(rs.getString("CustomerName"));

                // **QUAN TRỌNG: Format dữ liệu sẵn cho frontend**
                if (amount != null) {
                    dto.setFormattedAmount(Validate.formatCostPriceToVND(amount.doubleValue()));
                } else {
                    dto.setFormattedAmount("0 ₫");
                }

                if (createdAt != null) {
                    dto.setFormattedCreatedAt(Validate.getFormattedDate(createdAt));
                } else {
                    dto.setFormattedCreatedAt("-");
                }

                list.add(dto);
            }
        }
        return list;
    }

//Hàm lấy dữ liệu với phân trang
    public List<CashFlowReportDTO> getIncomeCashFlowReports(String dbName, int offset, int recordsPerPage,
            String dateFrom, String dateTo, String branchId, String employeeId, String paymentMethod) throws SQLException {
        StringBuilder sql = new StringBuilder("""
    SELECT 
        cf.CashFlowID,
        cf.Amount,
        cf.PaymentMethod,
        cf.RelatedOrderID,
        cf.CreatedAt,
        cf.Description,
        b.BranchName,
        cf.CreatedBy AS CreatedByName,
        c.CustomerID,
        c.FullName AS CustomerName
    FROM CashFlows cf
    LEFT JOIN Branches b ON cf.BranchID = b.BranchID
    LEFT JOIN Orders o ON cf.RelatedOrderID = o.OrderID
    LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE cf.FlowType = 'INCOME'
    """);

        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt >= ?");
            params.add(dateFrom + " 00:00:00");
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt <= ?");
            params.add(dateTo + " 23:59:59");
        }

        if (branchId != null && !branchId.trim().isEmpty()) {
            sql.append(" AND cf.BranchID = ?");
            params.add(Integer.parseInt(branchId));
        }
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append(" AND cf.PaymentMethod = ?");
            params.add(paymentMethod.trim());
        }

        // SỬA LẠI: Chuyển đổi employeeId thành tên nhân viên
        if (employeeId != null && !employeeId.trim().isEmpty()) {
            try {
                int userIdFilter = Integer.parseInt(employeeId);
                // Lấy tên nhân viên từ UserID
                User user = UserDAO.getUserById(userIdFilter, dbName);
                if (user != null) {
                    sql.append(" AND cf.CreatedBy = ?");
                    params.add(user.getFullName());
                }
            } catch (NumberFormatException e) {
                // Nếu employeeId không phải số, tìm theo tên
                sql.append(" AND cf.CreatedBy LIKE ?");
                params.add("%" + employeeId + "%");
            }
        }

        sql.append(" ORDER BY cf.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(recordsPerPage);

        List<CashFlowReportDTO> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CashFlowReportDTO dto = new CashFlowReportDTO();

                    dto.setCashFlowID(rs.getInt("CashFlowID"));
                    BigDecimal amount = rs.getBigDecimal("Amount");
                    dto.setAmount(amount);
                    dto.setPaymentMethod(rs.getString("PaymentMethod"));

                    Object orderIdObj = rs.getObject("RelatedOrderID");
                    if (orderIdObj != null) {
                        dto.setRelatedOrderID(rs.getInt("RelatedOrderID"));
                    } else {
                        dto.setRelatedOrderID(0);
                    }

                    Timestamp ts = rs.getTimestamp("CreatedAt");
                    LocalDateTime createdAt = ts != null ? ts.toLocalDateTime() : null;
                    dto.setCreatedAt(createdAt);

                    dto.setDescription(rs.getString("Description"));
                    dto.setBranchName(rs.getString("BranchName"));
                    dto.setCreatedByName(rs.getString("CreatedByName"));

                    Object customerIdObj = rs.getObject("CustomerID");
                    if (customerIdObj != null) {
                        dto.setCustomerID(rs.getInt("CustomerID"));
                    } else {
                        dto.setCustomerID(0);
                    }

                    dto.setCustomerName(rs.getString("CustomerName"));

                    // Format dữ liệu
                    if (amount != null) {
                        dto.setFormattedAmount(Validate.formatCostPriceToVND(amount.doubleValue()));
                    } else {
                        dto.setFormattedAmount("0 ₫");
                    }

                    if (createdAt != null) {
                        dto.setFormattedCreatedAt(Validate.getFormattedDate(createdAt));
                    } else {
                        dto.setFormattedCreatedAt("-");
                    }

                    list.add(dto);
                }
            }
        }
        return list;
    }

//Hàm đếm tổng số bản ghi
    public int getTotalIncomeCashFlowCount(String dbName, String dateFrom, String dateTo, String branchId, String employeeId, String paymentMethod) throws SQLException {
        StringBuilder sql = new StringBuilder("""
    SELECT COUNT(*) as total
    FROM CashFlows cf
    LEFT JOIN Branches b ON cf.BranchID = b.BranchID
    LEFT JOIN Orders o ON cf.RelatedOrderID = o.OrderID
    LEFT JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE cf.FlowType = 'INCOME'
    """);

        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt >= ?");
            params.add(dateFrom + " 00:00:00");
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt <= ?");
            params.add(dateTo + " 23:59:59");
        }

        if (branchId != null && !branchId.trim().isEmpty()) {
            sql.append(" AND cf.BranchID = ?");
            params.add(Integer.parseInt(branchId));
        }
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append(" AND cf.PaymentMethod = ?");
            params.add(paymentMethod.trim());
        }

        // SỬA LẠI: Chuyển đổi employeeId thành tên nhân viên
        if (employeeId != null && !employeeId.trim().isEmpty()) {
            try {
                int userIdFilter = Integer.parseInt(employeeId);
                // Lấy tên nhân viên từ UserID
                User user = UserDAO.getUserById(userIdFilter, dbName);
                if (user != null) {
                    sql.append(" AND cf.CreatedBy = ?");
                    params.add(user.getFullName());
                }
            } catch (NumberFormatException e) {
                // Nếu employeeId không phải số, tìm theo tên
                sql.append(" AND cf.CreatedBy LIKE ?");
                params.add("%" + employeeId + "%");
            }
        }

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }
    // Thêm vào CashFlowDAO.java

    public List<CashFlowReportDTO> getOutcomeCashFlowReports(String dbName, int offset, int recordsPerPage,
            String dateFrom, String dateTo, String branchId, String employeeId, String paymentMethod) throws SQLException {
        StringBuilder sql = new StringBuilder("""
    SELECT 
        cf.CashFlowID,
        cf.Amount,
        cf.PaymentMethod,
        cf.RelatedOrderID,
        cf.CreatedAt,
        cf.Description,
        cf.Category,
        b.BranchName,
        cf.CreatedBy AS CreatedByName
    FROM CashFlows cf
    LEFT JOIN Branches b ON cf.BranchID = b.BranchID
    WHERE cf.FlowType = 'OUTCOME'
    """);

        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt >= ?");
            params.add(dateFrom + " 00:00:00");
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt <= ?");
            params.add(dateTo + " 23:59:59");
        }

        if (branchId != null && !branchId.trim().isEmpty()) {
            sql.append(" AND cf.BranchID = ?");
            params.add(Integer.parseInt(branchId));
        }
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append(" AND cf.PaymentMethod = ?");
            params.add(paymentMethod.trim());
        }

        if (employeeId != null && !employeeId.trim().isEmpty()) {
            try {
                int userIdFilter = Integer.parseInt(employeeId);
                User user = UserDAO.getUserById(userIdFilter, dbName);
                if (user != null) {
                    sql.append(" AND cf.CreatedBy = ?");
                    params.add(user.getFullName());
                }
            } catch (NumberFormatException e) {
                sql.append(" AND cf.CreatedBy LIKE ?");
                params.add("%" + employeeId + "%");
            }
        }

        sql.append(" ORDER BY cf.CreatedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(recordsPerPage);

        List<CashFlowReportDTO> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CashFlowReportDTO dto = new CashFlowReportDTO();

                    dto.setCashFlowID(rs.getInt("CashFlowID"));
                    BigDecimal amount = rs.getBigDecimal("Amount");
                    dto.setAmount(amount);
                    dto.setPaymentMethod(rs.getString("PaymentMethod"));
                    dto.setRelatedOrderID(0);

                    Timestamp ts = rs.getTimestamp("CreatedAt");
                    LocalDateTime createdAt = ts != null ? ts.toLocalDateTime() : null;
                    dto.setCreatedAt(createdAt);

                    dto.setDescription(rs.getString("Description"));
                    dto.setCategory(rs.getString("Category")); // THÊM LẠI CATEGORY
                    dto.setBranchName(rs.getString("BranchName"));
                    dto.setCreatedByName(rs.getString("CreatedByName"));

                    dto.setCustomerID(0);
                    dto.setCustomerName(null);

                    // Format dữ liệu
                    if (amount != null) {
                        dto.setFormattedAmount(Validate.formatCostPriceToVND(amount.doubleValue()));
                    } else {
                        dto.setFormattedAmount("0 ₫");
                    }

                    if (createdAt != null) {
                        dto.setFormattedCreatedAt(Validate.getFormattedDate(createdAt));
                    } else {
                        dto.setFormattedCreatedAt("-");
                    }

                    list.add(dto);
                }
            }
        }
        return list;
    }

    public int getTotalOutcomeCashFlowCount(String dbName, String dateFrom, String dateTo, String branchId, String employeeId, String paymentMethod) throws SQLException {
        StringBuilder sql = new StringBuilder("""
    SELECT COUNT(*) as total
    FROM CashFlows cf
    LEFT JOIN Branches b ON cf.BranchID = b.BranchID
    WHERE cf.FlowType = 'OUTCOME'
    """);

        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt >= ?");
            params.add(dateFrom + " 00:00:00");
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt <= ?");
            params.add(dateTo + " 23:59:59");
        }

        if (branchId != null && !branchId.trim().isEmpty()) {
            sql.append(" AND cf.BranchID = ?");
            params.add(Integer.parseInt(branchId));
        }
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append(" AND cf.PaymentMethod = ?");
            params.add(paymentMethod.trim());
        }

        if (employeeId != null && !employeeId.trim().isEmpty()) {
            try {
                int userIdFilter = Integer.parseInt(employeeId);
                User user = UserDAO.getUserById(userIdFilter, dbName);
                if (user != null) {
                    sql.append(" AND cf.CreatedBy = ?");
                    params.add(user.getFullName());
                }
            } catch (NumberFormatException e) {
                sql.append(" AND cf.CreatedBy LIKE ?");
                params.add("%" + employeeId + "%");
            }
        }

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        }
        return 0;
    }

// Thêm method này vào CashFlowDAO
    public BigDecimal getTotalOutcomeAmount(String dbName, String dateFrom, String dateTo, String branchId, String employeeId, String paymentMethod) throws SQLException {
        StringBuilder sql = new StringBuilder("""
    SELECT COALESCE(SUM(cf.Amount), 0) as totalAmount
    FROM CashFlows cf
    LEFT JOIN Branches b ON cf.BranchID = b.BranchID
    WHERE cf.FlowType = 'OUTCOME'
    """);

        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt >= ?");
            params.add(dateFrom + " 00:00:00");
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt <= ?");
            params.add(dateTo + " 23:59:59");
        }

        if (branchId != null && !branchId.trim().isEmpty()) {
            sql.append(" AND cf.BranchID = ?");
            params.add(Integer.parseInt(branchId));
        }
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append(" AND cf.PaymentMethod = ?");
            params.add(paymentMethod.trim());
        }

        if (employeeId != null && !employeeId.trim().isEmpty()) {
            try {
                int userIdFilter = Integer.parseInt(employeeId);
                User user = UserDAO.getUserById(userIdFilter, dbName);
                if (user != null) {
                    sql.append(" AND cf.CreatedBy = ?");
                    params.add(user.getFullName());
                }
            } catch (NumberFormatException e) {
                sql.append(" AND cf.CreatedBy LIKE ?");
                params.add("%" + employeeId + "%");
            }
        }

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("totalAmount");
                }
            }
        }
        return BigDecimal.ZERO;
    }

    //Phuong: Add order detail to cashflow
    public static boolean insertCashFlow(
            String dbName,
            String flowType,
            double amount,
            String category,
            String description,
            String paymentMethod,
            Integer relatedOrderID,
            Integer branchID,
            String createdBy) throws SQLException {

        String sql = "INSERT INTO dbo.CashFlows (FlowType, Amount, Category, Description, PaymentMethod, RelatedOrderID, BranchID, CreatedBy) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, flowType);
            stmt.setDouble(2, amount);
            stmt.setString(3, category);
            stmt.setString(4, description != null ? description : "");
            stmt.setString(5, paymentMethod != null ? paymentMethod : "");
            stmt.setObject(6, relatedOrderID, java.sql.Types.INTEGER); // NULL nếu relatedOrderID là null
            stmt.setObject(7, branchID, java.sql.Types.INTEGER); // NULL nếu branchID là null
            stmt.setString(8, createdBy != null ? createdBy : "");

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new SQLException("Error inserting cash flow: " + e.getMessage(), e);
        }
    }

    public BigDecimal getTotalIncomeAmount(String dbName, String dateFrom, String dateTo, String branchId, String employeeId, String paymentMethod) throws SQLException {
        StringBuilder sql = new StringBuilder("""
        SELECT COALESCE(SUM(cf.Amount), 0) as totalAmount
        FROM CashFlows cf
        LEFT JOIN Branches b ON cf.BranchID = b.BranchID
        WHERE cf.FlowType = 'INCOME'
    """);

        List<Object> params = new ArrayList<>();

        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt >= ?");
            params.add(dateFrom + " 00:00:00");
        }

        if (dateTo != null && !dateTo.trim().isEmpty()) {
            sql.append(" AND cf.CreatedAt <= ?");
            params.add(dateTo + " 23:59:59");
        }

        if (branchId != null && !branchId.trim().isEmpty()) {
            sql.append(" AND cf.BranchID = ?");
            params.add(Integer.parseInt(branchId));
        }
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            sql.append(" AND cf.PaymentMethod = ?");
            params.add(paymentMethod.trim());
        }

        if (employeeId != null && !employeeId.trim().isEmpty()) {
            try {
                int userIdFilter = Integer.parseInt(employeeId);
                User user = UserDAO.getUserById(userIdFilter, dbName);
                if (user != null) {
                    sql.append(" AND cf.CreatedBy = ?");
                    params.add(user.getFullName());
                }
            } catch (NumberFormatException e) {
                sql.append(" AND cf.CreatedBy LIKE ?");
                params.add("%" + employeeId + "%");
            }
        }

        try (Connection conn = DBUtil.getConnectionTo(dbName); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("totalAmount");
                }
            }
        }
        return BigDecimal.ZERO;
    }
    
    
    //Lấy ra tất cả các phương thức thanh toán
    public List<String> getAllPaymentMethods(String dbName) throws SQLException {
    List<String> methods = new ArrayList<>();
    String sql = "SELECT DISTINCT PaymentMethod FROM CashFlows WHERE PaymentMethod IS NOT NULL ORDER BY PaymentMethod";
    try (Connection conn = DBUtil.getConnectionTo(dbName);
         PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
            methods.add(rs.getString("PaymentMethod"));
        }
    }
    return methods;
}


}
