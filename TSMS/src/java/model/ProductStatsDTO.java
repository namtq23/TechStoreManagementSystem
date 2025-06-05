package model;

import java.math.BigDecimal;


public class ProductStatsDTO {
    private int totalProducts;
    private int inStockProducts;
    private int outOfStockProducts;
    private int lowStockProducts;
    private int totalQuantity;
    private BigDecimal totalValue;
    
    // Constructor
    public ProductStatsDTO() {}
    
    public ProductStatsDTO(int totalProducts, int inStockProducts, int outOfStockProducts,
                          int lowStockProducts, int totalQuantity, BigDecimal totalValue) {
        this.totalProducts = totalProducts;
        this.inStockProducts = inStockProducts;
        this.outOfStockProducts = outOfStockProducts;
        this.lowStockProducts = lowStockProducts;
        this.totalQuantity = totalQuantity;
        this.totalValue = totalValue != null ? totalValue : BigDecimal.ZERO;
    }
    
    // Getters and Setters
    public int getTotalProducts() { return totalProducts; }
    public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
    
    public int getInStockProducts() { return inStockProducts; }
    public void setInStockProducts(int inStockProducts) { this.inStockProducts = inStockProducts; }
    
    public int getOutOfStockProducts() { return outOfStockProducts; }
    public void setOutOfStockProducts(int outOfStockProducts) { this.outOfStockProducts = outOfStockProducts; }
    
    public int getLowStockProducts() { return lowStockProducts; }
    public void setLowStockProducts(int lowStockProducts) { this.lowStockProducts = lowStockProducts; }
    
    public int getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity) { this.totalQuantity = totalQuantity; }
    
    public BigDecimal getTotalValue() { return totalValue; }
    public void setTotalValue(BigDecimal totalValue) { this.totalValue = totalValue; }
    
    @Override
    public String toString() {
        return "ProductStatsDTO{" +
                "totalProducts=" + totalProducts +
                ", inStockProducts=" + inStockProducts +
                ", outOfStockProducts=" + outOfStockProducts +
                ", lowStockProducts=" + lowStockProducts +
                ", totalQuantity=" + totalQuantity +
                ", totalValue=" + totalValue +
                '}';
    }
}
