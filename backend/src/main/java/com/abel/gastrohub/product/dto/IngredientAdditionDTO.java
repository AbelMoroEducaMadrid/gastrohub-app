package com.abel.gastrohub.product.dto;

import java.math.BigDecimal;

public class IngredientAdditionDTO {
    private Integer ingredientId;
    private BigDecimal quantity;

    public Integer getIngredientId() { return ingredientId; }
    public void setIngredientId(Integer ingredientId) { this.ingredientId = ingredientId; }
    public BigDecimal getQuantity() { return quantity; }
    public void setQuantity(BigDecimal quantity) { this.quantity = quantity; }
}