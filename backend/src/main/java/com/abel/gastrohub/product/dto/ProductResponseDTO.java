package com.abel.gastrohub.product.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Setter
@Getter
public class ProductResponseDTO {
    private Integer id;
    private String name;
    private BigDecimal price;
    private Boolean available;
    private Boolean isKitchen;
    private Integer categoryId;
    private List<IngredientResponseDTO> ingredients;
    private List<String> attributes;

    @Setter
    @Getter
    public static class IngredientResponseDTO {
        private Integer ingredientId;
        private String ingredientName;
        private BigDecimal quantity;
    }
}