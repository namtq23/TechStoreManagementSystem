/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class BMProductFilter {

    private String[] categories;
    private String inventoryStatus;
    private String searchKeyword;

    public BMProductFilter() {
    }

    public BMProductFilter(String[] categories, String inventoryStatus, String searchKeyword) {
        this.categories = categories;
        this.inventoryStatus = inventoryStatus;
        this.searchKeyword = searchKeyword;
    }

    // Getters and Setters
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
        return inventoryStatus != null && !inventoryStatus.equals("all");
    }

    public boolean hasSearchKeyword() {
        return searchKeyword != null && !searchKeyword.trim().isEmpty();
    }
}
