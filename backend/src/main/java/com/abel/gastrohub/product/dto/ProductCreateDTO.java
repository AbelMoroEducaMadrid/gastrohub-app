package com.abel.gastrohub.product.dto;

import java.math.BigDecimal;
import java.util.List;

public class ProductCreateDTO {
    private String name;
    private Integer categoryId;
    private Boolean available;
    private Boolean isKitchen;
    private List<IngredientDTO> ingredients;

    public static class IngredientDTO {
        private Integer ingredientId;
        private BigDecimal quantity;

        public Integer getIngredientId() { return ingredientId; }
        public void setIngredientId(Integer ingredientId) { this.ingredientId = ingredientId; }
        public BigDecimal getQuantity() { return quantity; }
        public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Integer getCategoryId() { return categoryId; }
    public void setCategoryId(Integer categoryId) { this.categoryId = categoryId; }
    public Boolean getAvailable() { return available; }
    public void setAvailable(Boolean available) { this.available = available; }
    public Boolean getIsKitchen() { return isKitchen; }
    public void setIsKitchen(Boolean isKitchen) { this.isKitchen = isKitchen; }
    public List<IngredientDTO> getIngredients() { return ingredients; }
    public void setIngredients(List<IngredientDTO> ingredients) { this.ingredients = ingredients; }
}