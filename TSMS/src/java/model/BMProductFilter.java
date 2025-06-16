package model;

public class BMProductFilter {

    private String[] categories;
    private String inventoryStatus;
    private String searchKeyword;
    private Double minPrice;
    private Double maxPrice;
    private String status; // "active", "inactive", "all"

    public BMProductFilter() {
    }

    public BMProductFilter(String[] categories, String inventoryStatus, String searchKeyword,
            Double minPrice, Double maxPrice, String status) {
        this.categories = categories;
        this.inventoryStatus = inventoryStatus;
        this.searchKeyword = searchKeyword;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.status = status;
    }

    // --- Getters and Setters ---
    public String[] getCategories() {
        return categories;
    }

    public void setCategories(String[] categories) {
        this.categories = categories;
    }

    public String getInventoryStatus() {
        return inventoryStatus;
    }

    public void setInventoryStatus(String inventoryStatus) {
        this.inventoryStatus = inventoryStatus;
    }

    public String getSearchKeyword() {
        return searchKeyword;
    }

    public void setSearchKeyword(String searchKeyword) {
        this.searchKeyword = searchKeyword;
    }

    public Double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Double minPrice) {
        this.minPrice = minPrice;
    }

    public Double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(Double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // --- Helper Methods ---
    public boolean hasCategories() {
        return categories != null && categories.length > 0 && !isAllCategoriesSelected();
    }

    public boolean isAllCategoriesSelected() {
        if (categories == null || categories.length == 0) {
            return false;
        }
        for (String category : categories) {
            if ("all".equals(category)) {
                return true;
            }
        }
        return false;
    }

    public boolean hasInventoryFilter() {
        return inventoryStatus != null && !inventoryStatus.equalsIgnoreCase("all");
    }

    public boolean hasSearchKeyword() {
        return searchKeyword != null && !searchKeyword.trim().isEmpty();
    }

    public boolean hasStatusFilter() {
        return status != null && !status.equalsIgnoreCase("all");
    }

    public boolean hasMinPrice() {
        return minPrice != null;
    }

    public boolean hasMaxPrice() {
        return maxPrice != null;
    }
}
