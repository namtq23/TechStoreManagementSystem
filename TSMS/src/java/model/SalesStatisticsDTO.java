package model;

import java.math.BigDecimal;

/**
 * DTO cho thống kê bán hàng - KHÔNG có entity tương ứng
 * vì không có bảng SalesStatistics trong database
 */
public class SalesStatisticsDTO {
    private int salespersonId;
    private String salespersonName;
    private BigDecimal currentMonthSales;
    private BigDecimal salesTarget;
    private int ordersCount;
    private int customersServed;
    private double performancePercentage;
    
    // Constructor
    public SalesStatisticsDTO() {}
    
    public SalesStatisticsDTO(int salespersonId, String salespersonName, 
                             BigDecimal currentMonthSales, BigDecimal salesTarget,
                             int ordersCount, int customersServed) {
        this.salespersonId = salespersonId;
        this.salespersonName = salespersonName;
        this.currentMonthSales = currentMonthSales != null ? currentMonthSales : BigDecimal.ZERO;
        this.salesTarget = salesTarget != null ? salesTarget : BigDecimal.ZERO;
        this.ordersCount = ordersCount;
        this.customersServed = customersServed;
        
        // Tính toán tự động
        if (this.salesTarget.compareTo(BigDecimal.ZERO) > 0) {
            this.performancePercentage = this.currentMonthSales
                .divide(this.salesTarget, 4, BigDecimal.ROUND_HALF_UP)
                .multiply(BigDecimal.valueOf(100))
                .doubleValue();
        } else {
            this.performancePercentage = 0.0;
        }
    }

    // Getters and Setters
    public int getSalespersonId() { return salespersonId; }
    public void setSalespersonId(int salespersonId) { this.salespersonId = salespersonId; }
    
    public String getSalespersonName() { return salespersonName; }
    public void setSalespersonName(String salespersonName) { this.salespersonName = salespersonName; }
    
    public BigDecimal getCurrentMonthSales() { return currentMonthSales; }
    public void setCurrentMonthSales(BigDecimal currentMonthSales) { this.currentMonthSales = currentMonthSales; }
    
    public BigDecimal getSalesTarget() { return salesTarget; }
    public void setSalesTarget(BigDecimal salesTarget) { this.salesTarget = salesTarget; }
    
    public int getOrdersCount() { return ordersCount; }
    public void setOrdersCount(int ordersCount) { this.ordersCount = ordersCount; }
    
    public int getCustomersServed() { return customersServed; }
    public void setCustomersServed(int customersServed) { this.customersServed = customersServed; }
    
    public double getPerformancePercentage() { return performancePercentage; }
    public void setPerformancePercentage(double performancePercentage) { this.performancePercentage = performancePercentage; }
}
