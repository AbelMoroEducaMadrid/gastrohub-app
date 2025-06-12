package com.abel.gastrohub.product.dto;

import java.math.BigDecimal;
import java.util.List;

public class ProductResponseDTO {
    private Integer id;
    private String name;
    private BigDecimal totalCost;
    private Boolean available;
    private Boolean isKitchen;
    private Integer categoryId;
    private List<IngredientResponseDTO> ingredients;

    public static class IngredientResponseDTO {
        private Integer ingredientId;
        private String ingredientName;
        private BigDecimal quantity;

        public Integer getIngredientId() { return ingredientId; }
        public void setIngredientId(Integer ingredientId) { this.ingredientId = ingredientId; }
        public String getIngredientName() { return ingredientName; }
        public void setIngredientName(String ingredientName) { this.ingredientName = ingredientName; }
        public BigDecimal getQuantity() { return quantity; }
        public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public BigDecimal getTotalCost() { return totalCost; }
    public void setTotalCost(BigDecimal totalCost) { this.totalCost = totalCost; }
    public Boolean getAvailable() { return available; }
    public void setAvailable(Boolean available) { this.available = available; }
    public Boolean getIsKitchen() { return isKitchen; }
    public void setIsKitchen(Boolean isKitchen) { this.isKitchen = isKitchen; }
    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }
    public List<IngredientResponseDTO> getIngredients() { return ingredients; }
    public void setIngredients(List<IngredientResponseDTO> ingredients) { this.ingredients = ingredients; }
}