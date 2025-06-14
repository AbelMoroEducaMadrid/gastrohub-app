package com.abel.gastrohub.product.dto;

import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.List;

@Setter
@Getter
public class ProductCreateDTO {
    private String name;
    private String description;
    private String imageBase64;
    private Integer categoryId;
    private Boolean available;
    private Boolean isKitchen;
    private BigDecimal price;
    private List<IngredientDTO> ingredients;

    @Setter
    @Getter
    public static class IngredientDTO {
        private Integer ingredientId;
        private BigDecimal quantity;

    }

}